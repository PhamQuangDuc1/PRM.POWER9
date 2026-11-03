import 'completion.dart';
import 'schedule.dart';

class TodayItem {
  const TodayItem({
    required this.activityId,
    required this.title,
    required this.groupId,
    this.schedule,
    this.completion,
  });
  final String activityId;
  final String title;
  final String groupId;
  final Schedule? schedule;
  final Completion? completion;
  bool get isDone => completion != null;
}

class TodayOverview {
  const TodayOverview(this.items);
  final List<TodayItem> items;
  List<TodayItem> get completed => items.where((item) => item.isDone).toList();
  List<TodayItem> get pending => items.where((item) => !item.isDone).toList();
  int get total => items.length;
  int get done => completed.length;
  double get fraction => total == 0 ? 0 : done / total;
}

TodayOverview buildOverview(
  List<Schedule> schedules,
  List<Completion> completions,
) {
  final records = {for (final record in completions) record.activityId: record};
  final items = <String, TodayItem>{};
  for (final schedule in schedules) {
    items[schedule.activityId] = TodayItem(
      activityId: schedule.activityId,
      title: schedule.title,
      groupId: schedule.groupId,
      schedule: schedule,
      completion: records[schedule.activityId],
    );
  }
  for (final record in completions) {
    items.putIfAbsent(
      record.activityId,
      () => TodayItem(
        activityId: record.activityId,
        title: record.title,
        groupId: record.groupId,
        completion: record,
      ),
    );
  }
  final sorted = items.values.toList()
    ..sort(
      (a, b) => (a.schedule?.minuteOfDay ?? 1440).compareTo(
        b.schedule?.minuteOfDay ?? 1440,
      ),
    );
  return TodayOverview(List.unmodifiable(sorted));
}
