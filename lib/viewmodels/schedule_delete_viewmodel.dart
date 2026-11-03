import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/schedule.dart';
import '../services/telemetry_service.dart';
import 'activity_providers.dart';
import 'app_providers.dart';
import 'observability_providers.dart';

typedef ScheduleKey = ({String activityId, String dateKey});

final scheduleDeleteProvider = NotifierProvider.autoDispose
    .family<ScheduleDeleteViewModel, AsyncValue<bool>, ScheduleKey>(
      ScheduleDeleteViewModel.new,
    );

class ScheduleDeleteViewModel extends Notifier<AsyncValue<bool>> {
  ScheduleDeleteViewModel(this.key);
  final ScheduleKey key;
  int _generation = 0;

  @override
  AsyncValue<bool> build() {
    ref.watch(sessionProvider.select((value) => value.asData?.value?.uid));
    _generation++;
    return const AsyncData(false);
  }

  bool _current(String uid, int generation) =>
      ref.mounted &&
      generation == _generation &&
      ref.read(sessionProvider).asData?.value?.uid == uid;

  Future<bool> delete() async {
    if (state.isLoading) return false;
    final uid = ref.read(sessionProvider).asData?.value?.uid;
    if (uid == null) return false;
    final generation = _generation;
    final service = ref.read(scheduleServiceProvider);
    final telemetry = ref.read(telemetryProvider);
    state = const AsyncLoading();
    try {
      // A schedule is independent of its completion: preserve measured history.
      await service.delete(uid, scheduleId(key.activityId, key.dateKey));
      if (!_current(uid, generation)) return false;
    } catch (error, stack) {
      if (!_current(uid, generation)) return false;
      state = AsyncError(error, stack);
      try {
        await telemetry.report(error, stack, operation: 'schedule_delete');
      } catch (_) {
        // Reporting must not hide the retryable action error.
      }
      return false;
    }
    try {
      await telemetry.event(AppEvent.scheduleDeleted, {
        'activity_id': key.activityId,
      });
    } catch (_) {
      // A confirmed delete is not rolled back by a telemetry failure.
    }
    if (!_current(uid, generation)) return false;
    state = const AsyncData(true);
    return true;
  }
}
