import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/models/office_notification.dart';
import 'package:power9_office_routine/services/firebase_notification_service.dart';
import 'package:power9_office_routine/services/notification_service.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/notification_viewmodel.dart';

class LocalNotificationsFake implements NotificationService {
  final changed = StreamController<void>.broadcast();
  final tapped = StreamController<OfficeNotification>.broadcast();
  final items = <OfficeNotification>[];
  @override
  String? get currentToken => 'test-fid';
  @override
  Stream<void> get changes => changed.stream;
  @override
  Stream<OfficeNotification> get taps => tapped.stream;
  @override
  Future<NotificationStatus> restore(String uid) async =>
      const NotificationStatus();
  @override
  Future<NotificationStatus> enable(String uid) async =>
      const NotificationStatus(enabled: true, token: 'test-fid');
  @override
  Future<void> disable() async {}
  @override
  Future<List<OfficeNotification>> load(String uid) async =>
      items.where((item) => item.ownerUid == uid).toList();
  @override
  Future<void> markRead(OfficeNotification item) async {
    final index = items.indexWhere((value) => value.id == item.id);
    if (index >= 0) items[index] = item.asRead();
  }

  @override
  Future<void> dispose() async {
    await changed.close();
    await tapped.close();
  }
}

void main() {
  test('public Console notification binds to current owner; data payload still requires explicit recipient', () {
    final item = notificationFromMessage(
      const RemoteMessage(messageId: 'console-public'),
      publicRecipient: 'alice',
    );
    expect(item!.ownerUid, 'alice');
    expect(item.target, 'today');
    expect(
      notificationFromMessage(
        const RemoteMessage(data: {'target': 'progress'}),
        publicRecipient: 'alice',
      ),
      isNull,
    );
    expect(notificationFromMessage(const RemoteMessage()), isNull);
  });
  test('payload requires recipient and validates target/date rather than arbitrary routes', () {
    expect(
      notificationFromMessage(
        const RemoteMessage(data: {'target': 'progress'}),
      ),
      isNull,
    );
    final item = notificationFromMessage(
      const RemoteMessage(
        messageId: 'test',
        data: {
          'recipient_uid': 'alice',
          'target': 'https://example.invalid',
          'date_key': '9999-99-99',
        },
      ),
    )!;
    expect(item.target, 'today');
    expect(item.dateKey, notificationDay(null, DateTime.now()));
    expect(notificationDay('2026-02-30', DateTime(2026, 11, 1)), '2026-11-01');
  });
  test(
    'foreign account taps ignored; own notification can be marked read',
    () async {
      final service = LocalNotificationsFake();
      final now = DateTime(2026, 11, 1);
      OfficeNotification item(String owner) => OfficeNotification(
        id: owner,
        ownerUid: owner,
        title: 'Power9',
        body: 'Test only',
        target: 'progress',
        dateKey: '2026-11-01',
        receivedAt: now,
      );
      service.items.addAll([item('alice'), item('bob')]);
      final container = ProviderContainer(
        overrides: [
          sessionProvider.overrideWith(
            (ref) => Stream.value(const AppUser(uid: 'alice')),
          ),
          notificationServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await service.dispose();
      });
      container.listen(sessionProvider, (_, _) {});
      await container.read(sessionProvider.future);
      container.listen(notificationControllerProvider('alice'), (_, _) {});
      await Future<void>.delayed(Duration.zero);
      final vm = container.read(
        notificationControllerProvider('alice').notifier,
      );
      await vm.refresh();
      expect(
        container.read(notificationControllerProvider('alice')).items.length,
        1,
      );
      vm.open(item('bob'));
      expect(
        container.read(notificationControllerProvider('alice')).pending,
        isNull,
      );
      vm.open(item('alice'));
      expect(vm.consumeTap()!.ownerUid, 'alice');
      await vm.markRead(item('alice'));
      expect(container.read(notificationControllerProvider('alice')).unread, 0);
    },
  );
}
