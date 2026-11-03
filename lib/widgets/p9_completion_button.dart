import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/completion.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/completion_action_viewmodel.dart';
import 'p9_button.dart';

class P9CompletionButton extends ConsumerWidget {
  const P9CompletionButton({
    super.key,
    required this.activity,
    required this.day,
    required this.isDone,
    this.source = CompletionSource.checkin,
    this.enabled = true,
    this.onRecorded,
  });
  final Activity activity;
  final String day;
  final bool isDone;
  final CompletionSource source;
  final bool enabled;
  final VoidCallback? onRecorded;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (activityId: activity.id, dateKey: day);
    final state = ref.watch(completionActionProvider(key));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        P9Button(
          label: state.hasError
              ? 'Thử lưu lại'
              : isDone
              ? 'Hoàn tác'
              : 'Đã thực hiện',
          icon: isDone ? Icons.undo : Icons.check_circle_outline,
          loading: state.isLoading,
          loadingLabel: 'Đang lưu…',
          onPressed: !enabled
              ? null
              : () async {
                  final action = ref.read(
                    completionActionProvider(key).notifier,
                  );
                  final success = isDone
                      ? await action.undo()
                      : await action.record(activity, source: source);
                  if (!context.mounted || !success) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isDone
                            ? 'Đã hoàn tác ghi nhận.'
                            : 'Đã ghi nhận hoạt động.',
                      ),
                    ),
                  );
                  if (!isDone) onRecorded?.call();
                },
        ),
        if (state.hasError) ...[
          const SizedBox(height: P9Space.sm),
          Semantics(
            liveRegion: true,
            child: Text(
              'Chưa lưu được thay đổi. Bạn có thể thử lại.',
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
      ],
    );
  }
}
