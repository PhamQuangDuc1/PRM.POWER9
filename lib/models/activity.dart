class Activity {
  const Activity({
    required this.id,
    required this.title,
    required this.groupId,
    required this.groupName,
    required this.minutes,
    required this.purpose,
    required this.steps,
    required this.note,
    required this.rank,
  });
  final String id;
  final String title;
  final String groupId;
  final String groupName;
  final int minutes;
  final String purpose;
  final List<String> steps;
  final String note;
  final int rank;

  factory Activity.fromMap(String id, Map<String, dynamic> data) => Activity(
    id: id,
    title: data['title'] as String,
    groupId: data['groupId'] as String,
    groupName: data['groupName'] as String,
    minutes: data['minutes'] as int,
    purpose: data['purpose'] as String,
    steps: List<String>.from(data['steps'] as List),
    note: data['note'] as String,
    rank: data['rank'] as int,
  );
}
