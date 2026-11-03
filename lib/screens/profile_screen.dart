import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/profile_viewmodel.dart';
import '../widgets/p9_logo.dart';
import 'firebase_demo_screen.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key, required this.user});
  final AppUser user;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(profileViewModelProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(P9Space.lg),
          children: [
            const Center(child: P9Logo()),
            const SizedBox(height: P9Space.xl),
            Text(
              user.displayName ?? 'Tài khoản Google',
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (user.email case final email?) ...[
              const SizedBox(height: P9Space.sm),
              Text(email, textAlign: TextAlign.center),
            ],
            const SizedBox(height: P9Space.xxl),
            if (kDebugMode) ...[
              OutlinedButton.icon(
                icon: const Icon(Icons.science_outlined),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const FirebaseDemoScreen(),
                  ),
                ),
                label: const Text('Kiểm thử Firebase'),
              ),
              const SizedBox(height: P9Space.lg),
            ],
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                minimumSize: const Size.fromHeight(P9Size.buttonHeight),
              ),
              onPressed: state.isLoading
                  ? null
                  : () => ref.read(profileViewModelProvider.notifier).signOut(),
              icon: const Icon(Icons.logout_rounded),
              label: Text(state.isLoading ? 'Đang đăng xuất…' : 'Đăng xuất'),
            ),
            if (state.hasError) ...[
              const SizedBox(height: P9Space.lg),
              Semantics(
                liveRegion: true,
                child: const Text('Chưa thể đăng xuất. Vui lòng thử lại.'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
