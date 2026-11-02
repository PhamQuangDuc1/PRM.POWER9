import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/services/auth_service.dart';
import 'package:power9_office_routine/services/notification_service.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/notification_viewmodel.dart';
import 'package:power9_office_routine/viewmodels/observability_providers.dart';
import 'package:power9_office_routine/viewmodels/profile_viewmodel.dart';

import 'notification_flow_test.dart' show LocalNotificationsFake;
import 'observability_test.dart' show RecordingTelemetry;

class FailedSignOut implements AuthService {
  @override
  Stream<AppUser?> watchSession() => Stream.value(const AppUser(uid: 'alice'));
  @override
  Future<void> signInWithGoogle() async {}
  @override
  Future<void> signOut() async => throw StateError('sign-out failed');
}

class BindingNotifications extends LocalNotificationsFake {
  bool disabled = false;
  String? restored;
  @override
  Future<void> disable() async {
    disabled = true;
  }

  @override
  Future<NotificationStatus> restore(String uid) async {
    restored = uid;
    return const NotificationStatus(enabled: true);
  }
}

void main() {
  test(
    'failed sign-out restores notifications for the still active account',
    () async {
      final notifications = BindingNotifications();
      final container = ProviderContainer(
        overrides: [
          authServiceProvider.overrideWithValue(FailedSignOut()),
          notificationServiceProvider.overrideWithValue(notifications),
          telemetryProvider.overrideWithValue(RecordingTelemetry()),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await notifications.dispose();
      });
      container.listen(sessionProvider, (_, _) {});
      await container.read(sessionProvider.future);
      container.listen(profileViewModelProvider, (_, _) {});
      await container.read(profileViewModelProvider.notifier).signOut();
      expect(notifications.disabled, isTrue);
      expect(notifications.restored, 'alice');
      expect(container.read(profileViewModelProvider).hasError, isTrue);
      expect(container.read(sessionProvider).asData!.value!.uid, 'alice');
    },
  );
}
