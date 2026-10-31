import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/models/activity.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/models/completion.dart';
import 'package:power9_office_routine/services/completion_service.dart';
import 'package:power9_office_routine/services/session_clock.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/completion_providers.dart';
import 'package:power9_office_routine/viewmodels/session_viewmodel.dart';

const activity = Activity(
  id: 'stress-break',
  title: 'Nghỉ sau họp',
  groupId: 'stress',
  groupName: 'Giảm căng thẳng',
  minutes: 3,
  purpose: '',
  steps: [],
  note: '',
  rank: 1,
);

class ManualClock implements SessionClock {
  int milliseconds = 0;
  bool running = false;
  void advance(int amount) {
    if (running) milliseconds += amount;
  }

  @override
  int get elapsedMilliseconds => milliseconds;
  @override
  void start() => running = true;
  @override
  void pause() => running = false;
  @override
  void reset() {
    running = false;
    milliseconds = 0;
  }
}

class RecordingService implements CompletionService {
  final durations = <int?>[];
  final days = <String>[];
  final sources = <CompletionSource>[];
  Completer<void>? pending;
  @override
  Stream<List<Completion>> watchDay(String uid, String day) => Stream.value([]);
  @override
  Future<void> delete(String uid, String id) async {}
  @override
  Future<void> record({
    required String uid,
    required Activity activity,
    required String dateKey,
    required CompletionSource source,
    int? durationSeconds,
  }) {
    durations.add(durationSeconds);
    days.add(dateKey);
    sources.add(source);
    return pending?.future ?? Future.value();
  }
}

Future<
  ({ProviderContainer container, ManualClock clock, RecordingService service})
>
setup() async {
  final clock = ManualClock();
  final service = RecordingService();
  final container = ProviderContainer(
    overrides: [
      sessionProvider.overrideWith(
        (ref) => Stream.value(const AppUser(uid: 'alice')),
      ),
      sessionClockFactoryProvider.overrideWithValue(() => clock),
      completionServiceProvider.overrideWithValue(service),
    ],
  );
  addTearDown(container.dispose);
  container.listen(sessionProvider, (_, _) {});
  await container.read(sessionProvider.future);
  container.listen(sessionViewModelProvider, (_, _) {});
  return (container: container, clock: clock, service: service);
}

void main() {
  test('an old save result cannot restore timer state after logout', () async {
    final auth = StreamController<AppUser?>();
    final clock = ManualClock();
    final service = RecordingService();
    final container = ProviderContainer(
      overrides: [
        sessionProvider.overrideWith((ref) => auth.stream),
        sessionClockFactoryProvider.overrideWithValue(() => clock),
        completionServiceProvider.overrideWithValue(service),
      ],
    );
    addTearDown(() async {
      container.dispose();
      await auth.close();
    });
    container.listen(sessionProvider, (_, _) {});
    auth.add(const AppUser(uid: 'alice'));
    await container.read(sessionProvider.future);
    container.listen(sessionViewModelProvider, (_, _) {});
    final vm = container.read(sessionViewModelProvider.notifier);
    vm.start(activity, '2026-10-31');
    clock.advance(45000);
    vm.finishEarly();
    service.pending = Completer<void>();
    final save = vm.record();
    auth.add(null);
    await Future<void>.delayed(Duration.zero);
    expect(container.read(sessionViewModelProvider).phase, SessionPhase.idle);
    service.pending!.complete();
    expect(await save, isFalse);
    expect(container.read(sessionViewModelProvider).saved, isFalse);
  });
  test(
    'elapsed clock survives background gaps and excludes paused time',
    () async {
      final s = await setup();
      final vm = s.container.read(sessionViewModelProvider.notifier);
      vm.start(activity, '2026-10-31');
      s.clock.advance(45000);
      vm.pause();
      expect(s.container.read(sessionViewModelProvider).elapsedSeconds, 45);
      s.clock.advance(120000);
      expect(s.container.read(sessionViewModelProvider).elapsedSeconds, 45);
      vm.resume();
      s.clock.advance(1000);
      vm.finishEarly();
      expect(s.container.read(sessionViewModelProvider).elapsedSeconds, 46);
      expect(await vm.record(), isTrue);
      expect(s.service.durations, [46]);
      expect(s.service.sources, [CompletionSource.timer]);
    },
  );
  test(
    'full countdown caps at target after a long suspended UI period',
    () async {
      final s = await setup();
      final vm = s.container.read(sessionViewModelProvider.notifier);
      vm.start(activity, '2026-10-31');
      s.clock.advance(500000);
      vm.refresh();
      final state = s.container.read(sessionViewModelProvider);
      expect(state.phase, SessionPhase.finished);
      expect(state.timerLabel, '00:00');
      expect(state.elapsedSeconds, 180);
      expect(s.clock.running, isFalse);
    },
  );
  test(
    'discarding an active or paused session never records completion',
    () async {
      final s = await setup();
      final vm = s.container.read(sessionViewModelProvider.notifier);
      vm.start(activity, '2026-10-31');
      s.clock.advance(45000);
      vm.pause();
      vm.discard();
      expect(
        s.container.read(sessionViewModelProvider).phase,
        SessionPhase.idle,
      );
      expect(s.service.durations, isEmpty);
      expect(s.clock.running, isFalse);
    },
  );
  test(
    'failed save keeps 45 measured seconds for retry and blocks duplicate taps',
    () async {
      final s = await setup();
      final vm = s.container.read(sessionViewModelProvider.notifier);
      vm.start(activity, '2026-10-31');
      s.clock.advance(45000);
      vm.finishEarly();
      s.service.pending = Completer<void>();
      final first = vm.record();
      expect(await vm.record(), isFalse);
      expect(s.service.durations, [45]);
      s.service.pending!.completeError(Exception('network unavailable'));
      expect(await first, isFalse);
      expect(s.container.read(sessionViewModelProvider).elapsedSeconds, 45);
      expect(s.container.read(sessionViewModelProvider).error, isNotNull);
      s.service.pending = null;
      expect(await vm.record(), isTrue);
      expect(s.service.durations, [45, 45]);
      expect(await vm.record(), isFalse);
    },
  );
  test('subsecond session cannot become a fake completion', () async {
    final s = await setup();
    final vm = s.container.read(sessionViewModelProvider.notifier);
    vm.start(activity, '2026-10-31');
    s.clock.advance(500);
    vm.finishEarly();
    expect(await vm.record(), isFalse);
    expect(s.service.durations, isEmpty);
  });
}
