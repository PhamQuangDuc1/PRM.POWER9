import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/schedule.dart';
import '../models/today_overview.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../viewmodels/completion_providers.dart';
import '../viewmodels/completion_action_viewmodel.dart';
import '../widgets/p9_async_content.dart';
import '../widgets/p9_progress_summary.dart';
import 'discover_screen.dart';

class ProgressScreen extends ConsumerStatefulWidget {
  const ProgressScreen({super.key, required this.initialDay});
  final String initialDay;
  @override
  ConsumerState<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends ConsumerState<ProgressScreen> {
  late String _day;
  @override
  void initState() {
    super.initState();
    _day = widget.initialDay;
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Tiến độ')),
    body: Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(P9Space.lg),
          child: OutlinedButton.icon(
            icon: const Icon(Icons.calendar_month_outlined),
            label: Text(_day),
            onPressed: () async {
              final now = DateTime.now();
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.parse(_day),
                firstDate: DateTime(now.year - 5),
                lastDate: DateTime(now.year + 1, 12, 31),
              );
              if (date != null && mounted) setState(() => _day = dayKey(date));
            },
          ),
        ),
        Expanded(
          child: P9AsyncContent(
            value: ref.watch(todayOverviewProvider(_day)),
            retry: () {
              ref.invalidate(daySchedulesProvider(_day));
              ref.invalidate(dayCompletionsProvider(_day));
            },
            builder: (overview) => ListView(
              padding: const EdgeInsets.all(P9Space.lg),
              children: [
                P9ProgressSummary(overview: overview),
                const SizedBox(height: P9Space.xl),
                Text(
                  'Đã hoàn thành',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: P9Space.md),
                if (overview.completed.isEmpty)
                  const P9Empty(
                    message: 'Chưa có bản ghi hoàn thành trong ngày này.',
                  )
                else
                  for (final item in overview.completed)
                    _CompletionCard(item: item, day: _day),
                if (overview.pending.isNotEmpty) ...[
                  const SizedBox(height: P9Space.xl),
                  Text(
                    'Chưa hoàn thành',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  for (final item in overview.pending)
                    ListTile(
                      title: Text(item.title),
                      subtitle: Text(
                        item.schedule?.timeLabel ?? 'Chưa chọn giờ',
                      ),
                      leading: const Icon(Icons.radio_button_unchecked),
                    ),
                ],
                const SizedBox(height: P9Space.xl),
                OutlinedButton.icon(
                  icon: const Icon(Icons.explore_outlined),
                  label: const Text('Khám phá hoạt động'),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const DiscoverScreen(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}

class _CompletionCard extends ConsumerWidget {
  const _CompletionCard({required this.item, required this.day});
  final TodayItem item;
  final String day;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final key = (activityId: item.activityId, dateKey: day);
    final action = ref.watch(completionActionProvider(key));
    return Card(
      color: P9Colors.card,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(P9Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.check_circle, color: P9Colors.primary),
                const SizedBox(width: P9Space.sm),
                Expanded(
                  child: Text(
                    item.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: P9Space.sm),
            Text(item.completion!.durationLabel),
            Wrap(
              spacing: P9Space.sm,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.undo),
                  label: const Text('Hoàn tác'),
                  onPressed: action.isLoading
                      ? null
                      : () => ref
                            .read(completionActionProvider(key).notifier)
                            .undo(),
                ),
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Xóa bản ghi'),
                  onPressed: action.isLoading
                      ? null
                      : () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder: (dialogContext) => AlertDialog(
                              title: const Text('Xóa bản ghi này?'),
                              content: Text(
                                'Xóa ghi nhận “${item.title}”. Lịch hoạt động vẫn được giữ.',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, false),
                                  child: const Text('Giữ lại'),
                                ),
                                FilledButton(
                                  onPressed: () =>
                                      Navigator.pop(dialogContext, true),
                                  child: const Text('Xóa'),
                                ),
                              ],
                            ),
                          );
                          if (confirm == true && context.mounted) {
                            await ref
                                .read(completionActionProvider(key).notifier)
                                .undo();
                          }
                        },
                ),
              ],
            ),
            if (action.hasError)
              Semantics(
                liveRegion: true,
                child: const Text('Chưa xóa được bản ghi. Bạn có thể thử lại.'),
              ),
          ],
        ),
      ),
    );
  }
}
