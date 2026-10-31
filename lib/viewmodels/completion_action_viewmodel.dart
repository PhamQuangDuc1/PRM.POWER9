import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/completion.dart';
import '../models/schedule.dart';
import 'app_providers.dart';
import 'completion_providers.dart';

typedef CompletionKey = ({String activityId, String dateKey});
final completionActionProvider = NotifierProvider.autoDispose
    .family<CompletionActionViewModel, AsyncValue<void>, CompletionKey>(
      CompletionActionViewModel.new,
    );

class CompletionActionViewModel extends Notifier<AsyncValue<void>> {
  CompletionActionViewModel(this.key);
  final CompletionKey key;
  int _generation = 0;
  @override
  AsyncValue<void> build() {
    ref.watch(sessionProvider.select((session) => session.asData?.value?.uid));
    _generation++;
    return const AsyncData(null);
  }

  Future<bool> record(
    Activity activity, {
    CompletionSource source = CompletionSource.checkin,
    int? durationSeconds,
  }) => _run(
    (uid) => ref
        .read(completionServiceProvider)
        .record(
          uid: uid,
          activity: activity,
          dateKey: key.dateKey,
          source: source,
          durationSeconds: durationSeconds,
        ),
  );
  Future<bool> undo() => _run(
    (uid) => ref
        .read(completionServiceProvider)
        .delete(uid, scheduleId(key.activityId, key.dateKey)),
  );

  Future<bool> _run(Future<void> Function(String uid) action) async {
    if (state.isLoading) return false;
    final user = ref.read(sessionProvider).asData?.value;
    if (user == null) return false;
    state = const AsyncLoading();
    final generation = _generation;
    try {
      await action(user.uid);
      if (!ref.mounted || generation != _generation) return false;
      state = const AsyncData(null);
      return true;
    } catch (error, stack) {
      if (ref.mounted && generation == _generation) {
        state = AsyncError(error, stack);
      }
      return false;
    }
  }
}
