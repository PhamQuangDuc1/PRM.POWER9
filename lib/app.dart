import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/login_screen.dart';
import 'screens/home_shell.dart';
import 'theme/p9_theme.dart';
import 'viewmodels/app_providers.dart';
import 'widgets/p9_status_screen.dart';

class Power9App extends StatelessWidget {
  const Power9App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Power9 Office Routine',
    debugShowCheckedModeBanner: false,
    locale: const Locale('vi'),
    supportedLocales: const [Locale('vi')],
    localizationsDelegates: GlobalMaterialLocalizations.delegates,
    theme: P9Theme.light,
    home: const _BootstrapGate(),
  );
}

class _BootstrapGate extends ConsumerWidget {
  const _BootstrapGate();
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(bootstrapProvider)
      .when(
        loading: () => const P9StatusScreen(message: 'Đang mở Power9…'),
        error: (_, _) => P9StatusScreen(
          message: 'Chưa thể mở ứng dụng. Vui lòng thử lại.',
          retry: () => ref.invalidate(bootstrapProvider),
        ),
        data: (_) => const _AuthGate(),
      );
}

class _AuthGate extends ConsumerWidget {
  const _AuthGate();
  @override
  Widget build(BuildContext context, WidgetRef ref) => ref
      .watch(sessionProvider)
      .when(
        loading: () =>
            const P9StatusScreen(message: 'Đang kiểm tra đăng nhập…'),
        error: (_, _) => P9StatusScreen(
          message: 'Chưa thể kiểm tra đăng nhập. Vui lòng thử lại.',
          retry: () => ref.invalidate(sessionProvider),
        ),
        data: (user) => user == null
            ? const LoginScreen()
            : Navigator(
                key: ValueKey(user.uid),
                onGenerateRoute: (_) => MaterialPageRoute<void>(
                  builder: (_) => HomeShell(user: user),
                ),
              ),
      );
}
