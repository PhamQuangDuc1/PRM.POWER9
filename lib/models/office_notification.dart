import 'schedule.dart';

String notificationDay(String? input, DateTime now) {
  final parsed = input == null ? null : DateTime.tryParse(input);
  return parsed != null &&
          dayKey(parsed) == input &&
          parsed.year >= now.year - 5 &&
          parsed.year <= now.year + 1
      ? input!
      : dayKey(now);
}

class OfficeNotification {
  const OfficeNotification({
    required this.id,
    required this.ownerUid,
    required this.title,
    required this.body,
    required this.target,
    required this.dateKey,
    required this.receivedAt,
    this.read = false,
  });
  final String id, ownerUid, title, body, target, dateKey;
  final DateTime receivedAt;
  final bool read;
  OfficeNotification asRead() => OfficeNotification(
    id: id,
    ownerUid: ownerUid,
    title: title,
    body: body,
    target: target,
    dateKey: dateKey,
    receivedAt: receivedAt,
    read: true,
  );
  Map<String, dynamic> toMap() => {
    'id': id,
    'ownerUid': ownerUid,
    'title': title,
    'body': body,
    'target': target,
    'dateKey': dateKey,
    'receivedAt': receivedAt.toIso8601String(),
    'read': read,
  };
  factory OfficeNotification.fromMap(Map<String, dynamic> data) =>
      OfficeNotification(
        id: data['id'] as String,
        ownerUid: data['ownerUid'] as String,
        title: data['title'] as String,
        body: data['body'] as String,
        target: data['target'] == 'progress' ? 'progress' : 'today',
        dateKey: notificationDay(data['dateKey'] as String?, DateTime.now()),
        receivedAt: DateTime.parse(data['receivedAt'] as String),
        read: data['read'] == true,
      );
}
