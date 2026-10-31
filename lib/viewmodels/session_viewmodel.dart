import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/completion.dart';
import '../services/session_clock.dart';
import 'app_providers.dart';
import 'completion_providers.dart';

enum SessionPhase { idle, running, paused, finished }

class SessionState {
  const SessionState({
    this.activity,
    this.dateKey,
    this.phase = SessionPhase.idle,
    this.elapsedMilliseconds = 0,
    this.saving = false,
    this.saved = false,
    this.error,
  });
  final Activity? activity;
  final String? dateKey;
  final SessionPhase phase;
  final int elapsedMilliseconds;
  final bool saving;
  final bool saved;
  final String? error;
  int get elapsedSeconds => elapsedMilliseconds ~/ 1000;
  int get goalMilliseconds => (activity?.minutes ?? 3) * 60000;
  int get remainingSeconds =>
      ((goalMilliseconds - elapsedMilliseconds).clamp(0, goalMilliseconds) +
          999) ~/
      1000;
  String get timerLabel =>
      '${(remainingSeconds ~/ 60).toString().padLeft(2, '0')}:${(remainingSeconds % 60).toString().padLeft(2, '0')}';
  bool get hasUnrecordedSession =>
      !saved &&
      (phase == SessionPhase.running ||
          phase == SessionPhase.paused ||
          (phase == SessionPhase.finished && elapsedMilliseconds > 0));
  SessionState copyWith({
    SessionPhase? phase,
    int? elapsedMilliseconds,
    bool? saving,
    bool? saved,
    String? error,
  }) => SessionState(
    activity: activity,
    dateKey: dateKey,
    phase: phase ?? this.phase,
    elapsedMilliseconds: elapsedMilliseconds ?? this.elapsedMilliseconds,
    saving: saving ?? this.saving,
    saved: saved ?? this.saved,
    error: error,
  );
}

final sessionClockFactoryProvider = Provider<SessionClock Function()>(
  (ref) => MonotonicSessionClock.new,
);
final sessionViewModelProvider =
    NotifierProvider.autoDispose<SessionViewModel, SessionState>(
      SessionViewModel.new,
    );

class SessionViewModel extends Notifier<SessionState> {
  late SessionClock _clock;
  Timer? _ticker;
  int _generation = 0;
  @override
  SessionState build() {
    ref.watch(sessionProvider.select((session) => session.asData?.value?.uid));
    _generation++;
    _clock = ref.read(sessionClockFactoryProvider)();
    ref.onDispose(() {
      _ticker?.cancel();
      _clock.reset();
    });
    return const SessionState();
  }

  void start(Activity activity, String day) {
    if (state.hasUnrecordedSession || state.saving) return;
    _ticker?.cancel();
    _clock.reset();
    _clock.start();
    state = SessionState(
      activity: activity,
      dateKey: day,
      phase: SessionPhase.running,
    );
    _startTicker();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(
      const Duration(milliseconds: 250),
      (_) => refresh(),
    );
  }

  void refresh() {
    if (state.phase != SessionPhase.running) return;
    final elapsed = _clock.elapsedMilliseconds.clamp(0, state.goalMilliseconds);
    if (elapsed >= state.goalMilliseconds) {
      _clock.pause();
      _ticker?.cancel();
      state = state.copyWith(
        phase: SessionPhase.finished,
        elapsedMilliseconds: elapsed,
      );
    } else {
      state = state.copyWith(elapsedMilliseconds: elapsed);
    }
  }

  void pause() {
    if (state.phase != SessionPhase.running) return;
    refresh();
    if (state.phase != SessionPhase.running) return;
    _clock.pause();
    _ticker?.cancel();
    state = state.copyWith(phase: SessionPhase.paused);
  }

  void resume() {
    if (state.phase != SessionPhase.paused) return;
    _clock.start();
    state = state.copyWith(phase: SessionPhase.running);
    _startTicker();
  }

  void finishEarly() {
    if (state.saving || state.phase == SessionPhase.idle) return;
    refresh();
    _clock.pause();
    _ticker?.cancel();
    state = state.copyWith(phase: SessionPhase.finished);
  }

  void discard() {
    if (state.saving) return;
    _ticker?.cancel();
    _clock.reset();
    state = const SessionState();
  }

  Future<bool> record() async {
    if (state.saving || state.saved || state.phase != SessionPhase.finished) {
      return false;
    }
    final user = ref.read(sessionProvider).asData?.value;
    final activity = state.activity;
    final day = state.dateKey;
    if (user == null ||
        activity == null ||
        day == null ||
        state.elapsedSeconds < 1) {
      state = state.copyWith(error: 'Phiên chưa đủ 1 giây để ghi nhận.');
      return false;
    }
    state = state.copyWith(saving: true);
    final generation = _generation;
    try {
      await ref
          .read(completionServiceProvider)
          .record(
            uid: user.uid,
            activity: activity,
            dateKey: day,
            source: CompletionSource.timer,
            durationSeconds: state.elapsedSeconds,
          );
      if (!ref.mounted || generation != _generation) return false;
      state = state.copyWith(saving: false, saved: true);
      return true;
    } catch (_) {
      if (ref.mounted && generation == _generation) {
        state = state.copyWith(
          saving: false,
          error: 'Chưa ghi nhận được phiên. Thời lượng vẫn được giữ, bạn có thể thử lại.',
        );
      }
      return false;
    }
  }
}
