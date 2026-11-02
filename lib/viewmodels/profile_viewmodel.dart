import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_providers.dart';
import 'observability_providers.dart';
import '../services/telemetry_service.dart';
import 'notification_viewmodel.dart';

final profileViewModelProvider =
    NotifierProvider.autoDispose<ProfileViewModel, AsyncValue<void>>(
      ProfileViewModel.new,
    );

class ProfileViewModel extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);

  Future<void> signOut() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    final telemetry = ref.read(telemetryProvider);
    final uid = ref.read(sessionProvider).asData?.value?.uid;
    final notifications = ref.read(notificationServiceProvider);
    try {
      try {
        await notifications.disable();
      } catch (_) {
        /* Do not trap a user in a signed-in session. */
      }
      await ref.read(authServiceProvider).signOut();
      await telemetry.event(AppEvent.logout);
      await telemetry.identify(null);
      if (ref.mounted) state = const AsyncData(null);
    } catch (error, stack) {
      // Failed sign-out leaves the same session active. Restore its messaging
      // binding rather than silently disabling notifications until app restart.
      if (ref.mounted &&
          uid != null &&
          ref.read(sessionProvider).asData?.value?.uid == uid) {
        try {
          await notifications.restore(uid);
        } catch (_) {
          // Keep the sign-out error; messaging can be retried independently.
        }
      }
      if (ref.mounted) state = AsyncError(error, stack);
    }
  }
}
