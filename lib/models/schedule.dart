class Schedule {
  const Schedule({
    required this.id,
    required this.activityId,
    required this.title,
    required this.groupId,
    required this.dateKey,
    required this.minuteOfDay,
    required this.reminderEnabled,
  });
  final String id;
  final String activityId;
  final String title;
  final String groupId;
  final String dateKey;
  final int? minuteOfDay;
  final bool reminderEnabled;

  String get timeLabel {
    final minute = minuteOfDay;
    if (minute == null) return 'Chưa chọn giờ';
    return '${(minute ~/ 60).toString().padLeft(2, '0')}:${(minute % 60).toString().padLeft(2, '0')}';
  }

  factory Schedule.fromMap(String id, Map<String, dynamic> data) => Schedule(
    id: id,
    activityId: data['activityId'] as String,
    title: data['title'] as String,
    groupId: data['groupId'] as String,
    dateKey: data['dateKey'] as String,
    minuteOfDay: data['minuteOfDay'] as int?,
    reminderEnabled: data['reminderEnabled'] as bool,
  );
}

String dayKey(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

String scheduleId(String activityId, String dateKey) =>
    '${activityId}_$dateKey';
