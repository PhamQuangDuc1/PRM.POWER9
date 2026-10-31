import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/p9_theme.dart';
import '../viewmodels/login_viewmodel.dart';
import '../widgets/p9_button.dart';
import '../widgets/p9_logo.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginViewModelProvider);
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            padding: const EdgeInsets.all(P9Space.xl),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight > P9Space.xl * 2
                    ? constraints.maxHeight - P9Space.xl * 2
                    : 0,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: P9Size.contentMaxWidth,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Center(child: P9Logo()),
                      const SizedBox(height: P9Space.xl),
                      Text(
                        'Power9 Office Routine',
                        style: text.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: P9Space.md),
                      Text(
                        'Thói quen nhỏ cho ngày làm việc cân bằng.',
                        style: text.bodyLarge,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: P9Space.xxl),
                      Container(
                        padding: const EdgeInsets.all(P9Space.xl),
                        decoration: BoxDecoration(
                          color: P9Colors.card,
                          borderRadius: BorderRadius.circular(
                            P9Size.cardRadius,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('Chào bạn', style: text.titleLarge),
                            const SizedBox(height: P9Space.sm),
                            Text(
                              'Đăng nhập để lưu lịch hoạt động và xem lại tiến độ của riêng bạn.',
                              style: text.bodyLarge,
                            ),
                            const SizedBox(height: P9Space.xl),
                            P9Button(
                              label: 'Đăng nhập với Google',
                              icon: Icons.login_rounded,
                              loading: state.loading,
                              onPressed: () => ref
                                  .read(loginViewModelProvider.notifier)
                                  .signIn(),
                            ),
                            if (state.error case final error?) ...[
                              const SizedBox(height: P9Space.lg),
                              Semantics(
                                liveRegion: true,
                                child: Text(
                                  error,
                                  style: text.bodyMedium?.copyWith(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: P9Space.xl),
                      Text(
                        'Tự chọn hoạt động phù hợp với bạn.\nKhông cần hoàn thành cả 9 nhóm mỗi ngày.',
                        style: text.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
