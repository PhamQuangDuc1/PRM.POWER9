import '../models/activity.dart';

abstract interface class ActivityService {
  Stream<List<Activity>> watchActivities();
}
