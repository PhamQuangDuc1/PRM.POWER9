import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/models/office_notification.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/notification_viewmodel.dart';

import 'notification_flow_test.dart' show LocalNotificationsFake;

class DelayedInbox extends LocalNotificationsFake {
  final pending = <Completer<List<OfficeNotification>>>[];
  @override
  Future<List<OfficeNotification>> load(String uid) {
    final result = Completer<List<OfficeNotification>>();
    pending.add(result);
    return result.future;
  }
}

void main() {
  test('late inbox refresh cannot replace a newer read state', () async {
    final service = DelayedInbox();
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
    service.pending.first.complete([]);
    await Future<void>.delayed(Duration.zero);
    final vm = container.read(notificationControllerProvider('alice').notifier);
    final old = vm.refresh();
    final latest = vm.refresh();
    final item = OfficeNotification(
      id: 'message',
      ownerUid: 'alice',
      title: 'Power9',
      body: 'Test',
      target: 'today',
      dateKey: '2026-11-01',
      receivedAt: DateTime(2026, 11, 1),
    );
    service.pending.last.complete([item.asRead()]);
    await latest;
    service.pending[service.pending.length - 2].complete([item]);
    await old;
    expect(container.read(notificationControllerProvider('alice')).unread, 0);
    expect(
      container.read(notificationControllerProvider('alice')).items.single.read,
      isTrue,
    );
  });
}
