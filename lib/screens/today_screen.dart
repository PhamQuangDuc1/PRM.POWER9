import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/today_overview.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../viewmodels/completion_providers.dart';
import '../widgets/p9_async_content.dart';
import '../widgets/p9_button.dart';
import '../widgets/p9_progress_summary.dart';
import '../widgets/p9_completion_button.dart';
import 'discover_screen.dart';
import 'activity_detail_screen.dart';
import 'progress_screen.dart';

class TodayScreen extends ConsumerWidget {
  const TodayScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => P9AsyncContent(
    value: ref.watch(currentDayProvider),
    retry: () => ref.invalidate(currentDayProvider),
    builder: (date) => _TodayBody(date: date),
  );
}

class _TodayBody extends ConsumerWidget {
  const _TodayBody({required this.date});
  final String date;
  @override
  Widget build(BuildContext context, WidgetRef ref) => P9AsyncContent(
    value: ref.watch(todayOverviewProvider(date)),
    retry: () {
      ref.invalidate(daySchedulesProvider(date));
      ref.invalidate(dayCompletionsProvider(date));
    },
    builder: (overview) => ListView(
      padding: const EdgeInsets.all(P9Space.lg),
      children: [
        Text('Hôm nay', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: P9Space.sm),
        Text(date),
        const SizedBox(height: P9Space.xl),
        P9ProgressSummary(overview: overview),
        const SizedBox(height: P9Space.lg),
        P9Button(
          label: 'Khám phá hoạt động',
          icon: Icons.explore_outlined,
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(builder: (_) => const DiscoverScreen()),
          ),
        ),
        const SizedBox(height: P9Space.sm),
        OutlinedButton.icon(
          icon: const Icon(Icons.insights_outlined),
          label: const Text('Xem tiến độ'),
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ProgressScreen(initialDay: date),
            ),
          ),
        ),
        const SizedBox(height: P9Space.xl),
        Text(
          'Hoạt động hôm nay · ${overview.total}',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: P9Space.md),
        if (overview.items.isEmpty)
          const P9Empty(
            message: 'Bạn chưa chọn hoạt động nào hôm nay. Hãy bắt đầu từ một việc nhỏ.',
          )
        else
          for (final item in overview.items) _TodayCard(item: item, day: date),
      ],
    ),
  );
}

class _TodayCard extends ConsumerWidget {
  const _TodayCard({required this.item, required this.day});
  final TodayItem item;
  final String day;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activity = ref
        .watch(activityByIdProvider(item.activityId))
        .asData
        ?.value;
    return Card(
      color: P9Colors.card,
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(P9Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                item.isDone ? Icons.check_circle : Icons.radio_button_unchecked,
                color: item.isDone ? P9Colors.primary : P9Colors.secondaryText,
              ),
              title: Text(
                item.title,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              subtitle: Text(
                '${item.schedule?.timeLabel ?? 'Thực hiện ngoài lịch'}${item.isDone ? '\n${item.completion!.durationLabel}' : ''}',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                if (activity == null) {
                  ref.invalidate(activitiesProvider);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Chưa tải được chi tiết. Vui lòng thử lại.',
                      ),
                    ),
                  );
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ActivityDetailScreen(
                      activity: activity,
                      existing: item.schedule,
                    ),
                  ),
                );
              },
            ),
            if (activity != null) ...[
              const SizedBox(height: P9Space.md),
              P9CompletionButton(
                activity: activity,
                day: day,
                isDone: item.isDone,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
