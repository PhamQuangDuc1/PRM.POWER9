import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/completion.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../viewmodels/checklist_viewmodel.dart';
import '../viewmodels/completion_action_viewmodel.dart';
import '../viewmodels/completion_providers.dart';
import '../widgets/p9_async_content.dart';
import '../widgets/p9_completion_button.dart';
import 'progress_screen.dart';

class WorkspaceScreen extends ConsumerWidget {
  const WorkspaceScreen({super.key, required this.activity});
  final Activity activity;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
    appBar: AppBar(title: const Text('Góc làm việc')),
    body: P9AsyncContent(
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
        builder: (record) {
          final checked = ref.watch(checklistProvider(activity.id));
          final saving = ref
              .watch(
                completionActionProvider((
                  activityId: activity.id,
                  dateKey: day,
                )),
              )
              .isLoading;
          final ready =
              activity.steps.isNotEmpty &&
              checked.length == activity.steps.length;
          return ListView(
            padding: const EdgeInsets.all(P9Space.lg),
            children: [
              Text(
                activity.groupName,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: P9Space.md),
              Text(
                activity.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: P9Space.lg),
              Text(activity.purpose),
              const SizedBox(height: P9Space.lg),
              for (final (index, step) in activity.steps.indexed)
                Card(
                  child: CheckboxListTile(
                    title: Text(step),
                    value: record != null || checked.contains(index),
                    onChanged: record != null || saving
                        ? null
                        : (value) => ref
                              .read(checklistProvider(activity.id).notifier)
                              .toggle(
                                index,
                                value ?? false,
                                activity.steps.length,
                              ),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                ),
              const SizedBox(height: P9Space.lg),
              Text(
                record != null
                    ? 'Đã ghi nhận kiểm tra.'
                    : 'Đã kiểm tra ${checked.length}/${activity.steps.length} mục',
              ),
              const SizedBox(height: P9Space.md),
              P9CompletionButton(
                activity: activity,
                day: day,
                isDone: record != null,
                source: CompletionSource.checklist,
                enabled: record != null || ready,
                onRecorded: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ProgressScreen(initialDay: day),
                  ),
                ),
              ),
              const SizedBox(height: P9Space.lg),
              Text(activity.note),
            ],
          );
        },
      ),
    ),
  );
}
