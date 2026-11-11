import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/schedule.dart';
import '../theme/p9_theme.dart';
import '../widgets/p9_page_layout.dart';
import '../widgets/p9_button.dart';
import '../widgets/p9_scene.dart';
import '../viewmodels/activity_providers.dart';
import '../viewmodels/completion_providers.dart';
import '../widgets/p9_async_content.dart';
import '../widgets/p9_completion_button.dart';
import '../widgets/p9_delete_schedule_button.dart';
import '../viewmodels/schedule_delete_viewmodel.dart';
import 'workspace_screen.dart';
import 'recovery_screen.dart';
import 'progress_screen.dart';
import '../viewmodels/observability_providers.dart';
import 'schedule_screen.dart';

class ActivityDetailScreen extends ConsumerWidget {
  const ActivityDetailScreen({
    super.key,
    required this.activity,
    this.existing,
  });
  final Activity activity;
  final Schedule? existing;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(activityViewEventProvider(activity));
    if (existing == null &&
        (activity.id == 'space-desk' || activity.id == 'posture-check')) {
      return WorkspaceScreen(activity: activity);
    }
    if (existing == null && activity.id == 'sleep-prepare') {
      return RecoveryScreen(activity: activity);
    }
    return P9PageScaffold(
      appBar: AppBar(title: const Text('Chi tiết hoạt động')),
      body: ListView(
        padding: const EdgeInsets.all(P9Space.lg),
        children: [
          P9SceneBanner(asset: P9Scenes.forActivity(activity)),
          const SizedBox(height: P9Space.xl),
          Text(
            activity.groupName,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: P9Space.md),
          Text(
            activity.title,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
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
            P9InstructionStep(number: index + 1, text: step),
          const SizedBox(height: P9Space.lg),
          Text(activity.note, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: P9Space.xl),
          if (activity.groupId == 'social' &&
              ref.watch(appConfigProvider).value.connectionCheckinEnabled) ...[
            P9AsyncContent(
              value: ref.watch(currentDayProvider),
              retry: () => ref.invalidate(currentDayProvider),
              builder: (day) => P9AsyncContent(
                value: ref.watch(
                  completionForActivityProvider((
                    activityId: activity.id,
                    dateKey: day,
                  )),
                ),
                retry: () => ref.invalidate(dayCompletionsProvider(day)),
                builder: (record) => P9CompletionButton(
                  activity: activity,
                  day: day,
                  isDone: record != null,
                  onRecorded: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ProgressScreen(initialDay: day),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: P9Space.lg),
          ],
          if (existing == null)
            P9Button(
              label: 'Chọn lịch hoạt động',
              icon: Icons.event_outlined,
              onPressed: () =>
                  Navigator.of(context)
                      .push(ScheduleScreen.route(activity, null)),
            )
          else
            _ExistingScheduleActions(activity: activity, original: existing!),
        ],
      ),
    );
  }
}

class _ExistingScheduleActions extends ConsumerWidget {
  const _ExistingScheduleActions({
    required this.activity,
    required this.original,
  });
  final Activity activity;
  final Schedule original;

  @override
  Widget build(BuildContext context, WidgetRef ref) => P9AsyncContent(
    value: ref.watch(
      activityScheduleProvider((
        activityId: original.activityId,
        dateKey: original.dateKey,
      )),
    ),
    retry: () => ref.invalidate(daySchedulesProvider(original.dateKey)),
    builder: (schedule) {
      final deletion = ref.watch(
        scheduleDeleteProvider((
          activityId: original.activityId,
          dateKey: original.dateKey,
        )),
      );
      final deleting = deletion.isLoading || deletion.asData?.value == true;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (schedule != null) ...[
            Text('${schedule.dateKey} · ${schedule.timeLabel}'),
            const SizedBox(height: P9Space.md),
          ],
          P9Button(
            label: schedule == null ? 'Chọn lịch hoạt động' : 'Đổi lịch',
            icon: Icons.event_outlined,
            onPressed: deleting
                ? null
                : () =>
                      Navigator.of(context)
                          .push(ScheduleScreen.route(activity, schedule)),
          ),
          if (schedule != null || deleting) ...[
            const SizedBox(height: P9Space.sm),
            P9DeleteScheduleButton(
              schedule: schedule ?? original,
              onDeleted: () => Navigator.of(context).pop(),
            ),
          ],
        ],
      );
    },
  );
}
