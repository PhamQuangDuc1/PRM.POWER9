import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/models/completion.dart';
import 'package:power9_office_routine/models/schedule.dart';
import 'package:power9_office_routine/models/today_overview.dart';

void main() {
  const plan = Schedule(
    id: 'walk_day',
    activityId: 'walk',
    title: 'Đi bộ',
    groupId: 'move',
    dateKey: '2026-10-31',
    minuteOfDay: 600,
    reminderEnabled: false,
  );
  const checkin = Completion(
    id: 'walk_day',
    activityId: 'walk',
    title: 'Đi bộ',
    groupId: 'move',
    dateKey: '2026-10-31',
    source: CompletionSource.checkin,
    durationSeconds: null,
  );
  const timer = Completion(
    id: 'stress_day',
    activityId: 'stress',
    title: 'Nghỉ',
    groupId: 'stress',
    dateKey: '2026-10-31',
    source: CompletionSource.timer,
    durationSeconds: 45,
  );
  test(
    'unscheduled completion contributes once and progress cannot exceed total',
    () {
      final overview = buildOverview([plan], [checkin, timer]);
      expect(overview.done, 2);
      expect(overview.total, 2);
      expect(overview.fraction, 1);
      expect(timer.durationLabel, '45 giây');
      expect(checkin.durationLabel, 'Đã ghi nhận');
    },
  );
  test(
    'removing completion restores pending schedule instead of removing plan',
    () {
      final overview = buildOverview([plan], []);
      expect(overview.total, 1);
      expect(overview.done, 0);
      expect(overview.pending.single.schedule, plan);
    },
  );
  test(
    'no schedules and no records is an empty day without a nine-group quota',
    () {
      final overview = buildOverview([], []);
      expect(overview.total, 0);
      expect(overview.fraction, 0);
    },
  );
}
