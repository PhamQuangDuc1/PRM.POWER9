import 'package:flutter/material.dart';

import '../models/activity.dart';
import '../models/schedule.dart';
import '../theme/p9_theme.dart';
import '../widgets/p9_button.dart';
import 'schedule_screen.dart';

class ActivityDetailScreen extends StatelessWidget {
  const ActivityDetailScreen({
    super.key,
    required this.activity,
    this.existing,
  });
  final Activity activity;
  final Schedule? existing;
  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: const Text('Chi tiết hoạt động')),
    body: ListView(
      padding: const EdgeInsets.all(P9Space.lg),
      children: [
        Text(activity.groupName, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: P9Space.md),
        Text(activity.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: P9Space.sm),
        Text(
          '${activity.minutes} phút',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: P9Space.xl),
        Text(activity.purpose, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: P9Space.xl),
        Text('Cách thực hiện', style: Theme.of(context).textTheme.titleLarge),
        for (final (index, step) in activity.steps.indexed)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: P9Space.md),
            child: Text(
              '${index + 1}. $step',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
        const SizedBox(height: P9Space.lg),
        Text(activity.note, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: P9Space.xl),
        P9Button(
          label: existing == null ? 'Chọn lịch hoạt động' : 'Đổi lịch',
          icon: Icons.event_outlined,
          onPressed: () =>
              Navigator.of(context)
                  .push(ScheduleScreen.route(activity, existing)),
        ),
      ],
    ),
  );
}
