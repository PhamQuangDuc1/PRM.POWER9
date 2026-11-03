import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/p9_theme.dart';

class P9AsyncContent<T> extends StatelessWidget {
  const P9AsyncContent({
    super.key,
    required this.value,
    required this.builder,
    required this.retry,
  });
  final AsyncValue<T> value;
  final Widget Function(T) builder;
  final VoidCallback retry;
  @override
  Widget build(BuildContext context) => value.when(
    skipLoadingOnRefresh: false,
    loading: () => const Center(child: CircularProgressIndicator()),
    error: (_, _) => P9Empty(
      message: 'Chưa tải được dữ liệu. Kiểm tra kết nối rồi thử lại.',
      icon: Icons.cloud_off_outlined,
      actionLabel: 'Thử lại',
      action: retry,
    ),
    data: builder,
  );
}

class P9Empty extends StatelessWidget {
  const P9Empty({
    super.key,
    required this.message,
    this.icon = Icons.event_note_outlined,
    this.actionLabel,
    this.action,
  });
  final String message;
  final IconData icon;
  final String? actionLabel;
  final VoidCallback? action;
  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(P9Space.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: P9Size.minTarget, color: P9Colors.primary),
          const SizedBox(height: P9Space.lg),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          if (action != null) ...[
            const SizedBox(height: P9Space.lg),
            OutlinedButton(
              onPressed: action,
              child: Text(actionLabel ?? 'Thử lại'),
            ),
          ],
        ],
      ),
    ),
  );
}
