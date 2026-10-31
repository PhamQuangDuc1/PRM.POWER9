import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../theme/p9_theme.dart';
import '../widgets/p9_button.dart';
import '../widgets/p9_async_content.dart';
import '../viewmodels/activity_providers.dart';
import 'schedule_screen.dart';

class RecoveryScreen extends ConsumerWidget {
  const RecoveryScreen({super.key, required this.activity});
  final Activity activity;
  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Ngủ & phục hồi')),
    body: ListView(
      padding: const EdgeInsets.all(P9Space.lg),
      children: [
        Text(activity.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: P9Space.lg),
        Text(activity.purpose),
        const SizedBox(height: P9Space.lg),
        for (final step in activity.steps)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(P9Space.lg),
              child: Text(step),
            ),
          ),
        const SizedBox(height: P9Space.lg),
        Text(activity.note),
        const SizedBox(height: P9Space.xl),
        P9AsyncContent(
          value: ref.watch(currentDayProvider),
          retry: () => ref.invalidate(currentDayProvider),
          builder: (day) => P9AsyncContent(
            value: ref.watch(
              activityScheduleProvider((activityId: activity.id, dateKey: day)),
            ),
            retry: () => ref.invalidate(daySchedulesProvider(day)),
            builder: (schedule) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (schedule != null) ...[
                  Text('Đã đặt lịch hôm nay · ${schedule.timeLabel}'),
                  const SizedBox(height: P9Space.md),
                ],
                P9Button(
                  label: schedule == null
                      ? 'Chọn giờ nghỉ tối'
                      : 'Đổi giờ nghỉ tối',
                  icon: Icons.schedule,
                  onPressed: () => Navigator.of(context).push(
                    ScheduleScreen.route(
                      activity,
                      schedule,
                      returnAfterSave: true,
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
