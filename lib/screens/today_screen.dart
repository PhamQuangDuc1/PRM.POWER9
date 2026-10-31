import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../widgets/p9_async_content.dart';
import '../widgets/p9_button.dart';
import 'discover_screen.dart';
import 'activity_detail_screen.dart';

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
  Widget build(BuildContext context, WidgetRef ref) {
    final schedules = ref.watch(daySchedulesProvider(date));
    return P9AsyncContent(
      value: schedules,
      retry: () => ref.invalidate(daySchedulesProvider(date)),
      builder: (items) => ListView(
        padding: const EdgeInsets.all(P9Space.lg),
        children: [
          Text('Hôm nay', style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: P9Space.sm),
          Text(date),
          const SizedBox(height: P9Space.xl),
          Text(
            'Tự chọn một vài hoạt động phù hợp với ngày làm việc của bạn.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: P9Space.lg),
          P9Button(
            label: 'Khám phá hoạt động',
            icon: Icons.explore_outlined,
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const DiscoverScreen()),
            ),
          ),
          const SizedBox(height: P9Space.xl),
          Text(
            'Lịch hôm nay · ${items.length} hoạt động',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: P9Space.md),
          if (items.isEmpty)
            const P9Empty(
              message: 'Bạn chưa đặt hoạt động nào hôm nay. Hãy chọn một việc nhỏ để bắt đầu.',
            )
          else
            for (final schedule in items)
              Card(
                color: P9Colors.card,
                elevation: 0,
                child: ListTile(
                  contentPadding: const EdgeInsets.all(P9Space.lg),
                  title: Text(
                    schedule.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  subtitle: Text(schedule.timeLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    final activity = ref
                        .read(activityByIdProvider(schedule.activityId))
                        .asData
                        ?.value;
                    if (activity == null) {
                      ref.invalidate(activitiesProvider);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Đang tải chi tiết. Vui lòng thử lại.'),
                        ),
                      );
                      return;
                    }
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ActivityDetailScreen(
                          activity: activity,
                          existing: schedule,
                        ),
                      ),
                    );
                  },
                ),
              ),
        ],
      ),
    );
  }
}
