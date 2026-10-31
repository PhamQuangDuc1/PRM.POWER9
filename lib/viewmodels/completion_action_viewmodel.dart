import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/completion.dart';
import '../models/schedule.dart';
import 'app_providers.dart';
import 'completion_providers.dart';
import 'observability_providers.dart';
import '../services/telemetry_service.dart';

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
    event: AppEvent.activityCompleted,
    parameters: {...activityEventParameters(activity), 'source': source.name},
  );
  Future<bool> undo() => _run(
    (uid) => ref
        .read(completionServiceProvider)
        .delete(uid, scheduleId(key.activityId, key.dateKey)),
    event: AppEvent.completionUndone,
    parameters: {'activity_id': key.activityId},
  );

  Future<bool> _run(
    Future<void> Function(String uid) action, {
    required AppEvent event,
    required Map<String, Object> parameters,
  }) async {
    if (state.isLoading) return false;
    final user = ref.read(sessionProvider).asData?.value;
    if (user == null) return false;
    state = const AsyncLoading();
    final generation = _generation;
    try {
      await action(user.uid);
      if (!ref.mounted || generation != _generation) return false;
      state = const AsyncData(null);
      await ref.read(telemetryProvider).event(event, parameters);
      return true;
    } catch (error, stack) {
      if (ref.mounted && generation == _generation) {
        final telemetry = ref.read(telemetryProvider);
        state = AsyncError(error, stack);
        await telemetry.report(error, stack, operation: 'completion_write');
      }
      return false;
    }
  }
}
