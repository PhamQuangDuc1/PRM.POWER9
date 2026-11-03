enum CompletionSource { checkin, timer, checklist }

class Completion {
  const Completion({
    required this.id,
    required this.activityId,
    required this.title,
    required this.groupId,
    required this.dateKey,
    required this.source,
    required this.durationSeconds,
    this.createdAt,
  });
  final String id;
  final String activityId;
  final String title;
  final String groupId;
  final String dateKey;
  final CompletionSource source;
  final int? durationSeconds;
  final DateTime? createdAt;

  String get durationLabel {
    final seconds = durationSeconds;
    if (seconds == null) return 'Đã ghi nhận';
    if (seconds < 60) return '$seconds giây';
    final remainder = seconds % 60;
    return remainder == 0
        ? '${seconds ~/ 60} phút'
        : '${seconds ~/ 60} phút $remainder giây';
  }

  factory Completion.fromMap(
    String id,
    Map<String, dynamic> data, {
    DateTime? createdAt,
  }) => Completion(
    id: id,
    activityId: data['activityId'] as String,
    title: data['title'] as String,
    groupId: data['groupId'] as String,
    dateKey: data['dateKey'] as String,
    source: CompletionSource.values.byName(data['source'] as String),
    durationSeconds: data['durationSeconds'] as int?,
    createdAt: createdAt,
  );
}
