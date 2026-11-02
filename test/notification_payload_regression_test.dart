import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/services/firebase_notification_service.dart';
import 'package:power9_office_routine/models/office_notification.dart';

void main() {
  test(
    'malformed notification date types fall back without breaking delivery',
    () {
      for (final value in [12, true, <String>[], <String, String>{}]) {
        final item = notificationFromMessage(
          RemoteMessage(
            messageId: 'malformed-date',
            data: {
              'recipient_uid': 'alice',
              'date_key': value,
              'target': 'progress',
            },
          ),
        );
        expect(item, isNotNull);
        expect(item!.dateKey, notificationDay(null, DateTime.now()));
        expect(item.target, 'progress');
      }
    },
  );
}
