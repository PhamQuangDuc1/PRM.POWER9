import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/services/auth_service.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/login_viewmodel.dart';

class PendingAuthService implements AuthService {
  @override
  Stream<AppUser?> watchSession() => Stream.value(null);
  @override
  Future<void> signOut() async {}
  final completer = Completer<void>();
  int calls = 0;

  @override
  Future<void> signInWithGoogle() {
    calls++;
    return completer.future;
  }
}

void main() {
  test(
    'Repeated taps do not start multiple sign-in requests; error permits retry',
    () async {
      final service = PendingAuthService();
      final container = ProviderContainer(
        overrides: [authServiceProvider.overrideWithValue(service)],
      );
      addTearDown(container.dispose);
      final vm = container.read(loginViewModelProvider.notifier);
      final first = vm.signIn();
      await vm.signIn();
      expect(service.calls, 1);
      expect(container.read(loginViewModelProvider).loading, isTrue);
      service.completer.completeError(const AuthFailure('Đã hủy đăng nhập.'));
      await first;
      expect(container.read(loginViewModelProvider).loading, isFalse);
      expect(container.read(loginViewModelProvider).error, isNotNull);
      await vm.signIn();
      expect(service.calls, 2);
      expect(container.read(loginViewModelProvider).loading, isFalse);
    },
  );

  test(
    'A pending request may finish after its container is disposed',
    () async {
      final service = PendingAuthService();
      final container = ProviderContainer(
        overrides: [authServiceProvider.overrideWithValue(service)],
      );
      final pending = container.read(loginViewModelProvider.notifier).signIn();
      container.dispose();
      service.completer.completeError(const AuthFailure('Đã hủy đăng nhập.'));
      await expectLater(pending, completes);
    },
  );
}
