import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'observability_providers.dart';

final firebaseDemoProvider =
    NotifierProvider.autoDispose<FirebaseDemoViewModel, AsyncValue<void>>(
      FirebaseDemoViewModel.new,
    );

class FirebaseDemoViewModel extends Notifier<AsyncValue<void>> {
  @override
  AsyncValue<void> build() => const AsyncData(null);
  Future<void> crash() async {
    if (state.isLoading) return;
    state = const AsyncLoading();
    try {
      await ref.read(telemetryProvider).testCrash();
      if (ref.mounted) state = const AsyncData(null);
    } catch (error, stack) {
      if (ref.mounted) state = AsyncError(error, stack);
    }
  }
}
