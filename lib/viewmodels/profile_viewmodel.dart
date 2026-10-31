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
    try {
      try {
        await ref.read(notificationServiceProvider).disable();
      } catch (_) {
        /* Do not trap a user in a signed-in session. */
      }
      await ref.read(authServiceProvider).signOut();
      await telemetry.event(AppEvent.logout);
      await telemetry.identify(null);
      if (ref.mounted) state = const AsyncData(null);
    } catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
    }
  }
}
