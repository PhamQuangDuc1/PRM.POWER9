import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../services/auth_service.dart';
import 'app_providers.dart';

final loginViewModelProvider = NotifierProvider<LoginViewModel, LoginState>(
  LoginViewModel.new,
);

class LoginState {
  const LoginState({this.loading = false, this.error});
  final bool loading;
  final String? error;
}

class LoginViewModel extends Notifier<LoginState> {
  @override
  LoginState build() => const LoginState();

  Future<void> signIn() async {
    if (state.loading) return;
    state = const LoginState(loading: true);
    try {
      await ref.read(authServiceProvider).signInWithGoogle();
      if (!ref.mounted) return;
      state = const LoginState();
    } on AuthFailure catch (error) {
      if (!ref.mounted) return;
      state = LoginState(error: error.message);
    } catch (_) {
      if (!ref.mounted) return;
      state = const LoginState(
        error: 'Chưa thể đăng nhập. Kiểm tra kết nối mạng rồi thử lại.',
      );
    }
  }
}
