import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/models/activity.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/models/schedule.dart';
import 'package:power9_office_routine/services/schedule_service.dart';
import 'package:power9_office_routine/viewmodels/activity_providers.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/schedule_viewmodel.dart';

const activity = Activity(
  id: 'move-walk',
  title: 'Đi bộ giữa giờ',
  groupId: 'move',
  groupName: 'Vận động',
  minutes: 3,
  purpose: 'Nghỉ ngắn',
  steps: ['A', 'B', 'C'],
  note: 'Tự chọn',
  rank: 1,
);

class PendingScheduleService implements ScheduleService {
  final pending = Completer<void>();
  int calls = 0;
  @override
  Stream<List<Schedule>> watchDay(String uid, String dateKey) =>
      Stream.value([]);
  @override
  Future<void> delete(String uid, String id) async {}
  @override
  Future<void> save({
    required String uid,
    required Activity activity,
    required String dateKey,
    required int? minuteOfDay,
    required bool reminderEnabled,
  }) {
    calls++;
    return pending.future;
  }
}

void main() {
  test('reminder requires time, but optional reminder may omit it', () {
    final date = DateTime(2026, 10, 31);
    expect(
      validateSchedule(ScheduleDraft(date: date, reminderEnabled: true)),
      isNotNull,
    );
    expect(validateSchedule(ScheduleDraft(date: date)), isNull);
    expect(
      validateSchedule(ScheduleDraft(date: date, minuteOfDay: 1440)),
      isNotNull,
    );
  });
  test(
    'save failure retains draft, blocks repeated save and permits retry',
    () async {
      final service = PendingScheduleService();
      final container = ProviderContainer(
        overrides: [
          sessionProvider.overrideWith(
            (ref) => Stream.value(const AppUser(uid: 'alice')),
          ),
          scheduleServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);
      container.listen(sessionProvider, (_, _) {});
      await container.read(sessionProvider.future);
      container.listen(scheduleDraftProvider, (_, _) {});
      final vm = container.read(scheduleDraftProvider.notifier);
      vm.edit(
        date: DateTime(2026, 11, 1),
        minuteOfDay: 600,
        reminderEnabled: true,
      );
      final first = vm.save(activity);
      expect(await vm.save(activity), isFalse);
      expect(service.calls, 1);
      service.pending.completeError(Exception('offline'));
      expect(await first, isFalse);
      final state = container.read(scheduleDraftProvider);
      expect(state.minuteOfDay, 600);
      expect(state.date, DateTime(2026, 11, 1));
      expect(state.reminderEnabled, isTrue);
      expect(state.error, isNotNull);
      expect(state.saved, isFalse);
      await vm.save(activity);
      expect(service.calls, 2);
    },
  );
  test('editing initializes the existing day and time', () {
    const original = Schedule(
      id: 'move-walk_2026-10-31',
      activityId: 'move-walk',
      title: 'Đi bộ giữa giờ',
      groupId: 'move',
      dateKey: '2026-10-31',
      minuteOfDay: 1050,
      reminderEnabled: true,
    );
    final container = ProviderContainer(
      overrides: [
        scheduleDraftProvider.overrideWith(
          () => ScheduleViewModel(existing: original),
        ),
      ],
    );
    addTearDown(container.dispose);
    final state = container.read(scheduleDraftProvider);
    expect(dayKey(state.date), '2026-10-31');
    expect(state.minuteOfDay, 1050);
    expect(scheduleId(original.activityId, original.dateKey), original.id);
  });
}
