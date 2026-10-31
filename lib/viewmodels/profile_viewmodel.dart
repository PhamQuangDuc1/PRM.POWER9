import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_providers.dart';

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
    try {
      await ref.read(authServiceProvider).signOut();
      if (ref.mounted) state = const AsyncData(null);
    } catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
    }
  }
}
