import '../models/activity.dart';
import '../models/schedule.dart';

abstract interface class ScheduleService {
  Stream<List<Schedule>> watchDay(String uid, String dateKey);
  Future<void> save({
    required String uid,
    required Activity activity,
    required String dateKey,
    required int? minuteOfDay,
    required bool reminderEnabled,
  });
  Future<void> delete(String uid, String id);
}
