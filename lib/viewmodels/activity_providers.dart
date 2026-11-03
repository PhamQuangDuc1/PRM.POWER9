import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/schedule.dart';
import '../services/activity_service.dart';
import '../services/schedule_service.dart';
import '../services/firestore_activity_service.dart';
import '../services/firestore_schedule_service.dart';
import '../services/firestore_client.dart';
import '../services/day_clock.dart';
import 'app_providers.dart';

final dayClockProvider = Provider((ref) => DayClock());
final currentDayProvider = StreamProvider.autoDispose<String>(
  (ref) => ref.watch(dayClockProvider).watchDay().distinct(),
);

final activityServiceProvider = Provider<ActivityService>(
  (ref) => FirestoreActivityService(createFirestoreClient()),
);
final scheduleServiceProvider = Provider<ScheduleService>(
  (ref) => FirestoreScheduleService(createFirestoreClient()),
);

final activitiesProvider = StreamProvider.autoDispose<List<Activity>>((ref) {
  final user = ref.watch(sessionProvider).asData?.value;
  if (user == null) return Stream.value(const []);
  return ref.watch(activityServiceProvider).watchActivities();
});

final groupActivitiesProvider = Provider.autoDispose
    .family<AsyncValue<List<Activity>>, String>(
      (ref, groupId) => ref
          .watch(activitiesProvider)
          .whenData(
            (items) => items.where((item) => item.groupId == groupId).toList(),
          ),
    );

final activityByIdProvider = Provider.autoDispose
    .family<AsyncValue<Activity?>, String>(
      (ref, id) => ref.watch(activitiesProvider).whenData((items) {
        for (final item in items) {
          if (item.id == id) return item;
        }
        return null;
      }),
    );

final daySchedulesProvider = StreamProvider.autoDispose
    .family<List<Schedule>, String>((ref, dateKey) {
      final user = ref.watch(sessionProvider).asData?.value;
      if (user == null) return Stream.value(const []);
      return ref.watch(scheduleServiceProvider).watchDay(user.uid, dateKey);
    });

final activityScheduleProvider = Provider.autoDispose
    .family<AsyncValue<Schedule?>, ({String activityId, String dateKey})>(
      (ref, key) =>
          ref.watch(daySchedulesProvider(key.dateKey)).whenData((schedules) {
            for (final schedule in schedules) {
              if (schedule.activityId == key.activityId) return schedule;
            }
            return null;
          }),
    );
