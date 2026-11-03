import '../models/office_notification.dart';

class NotificationStatus {
  const NotificationStatus({this.enabled = false, this.token});
  final bool enabled;
  final String? token;
}

abstract interface class NotificationService {
  String? get currentToken;
  Stream<void> get changes;
  Stream<OfficeNotification> get taps;
  Future<NotificationStatus> restore(String uid);
  Future<NotificationStatus> enable(String uid);
  Future<void> disable();
  Future<List<OfficeNotification>> load(String uid);
  Future<void> markRead(OfficeNotification item);
  Future<void> dispose();
}
