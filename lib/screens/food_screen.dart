import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../viewmodels/completion_providers.dart';
import '../widgets/p9_async_content.dart';
import '../widgets/p9_completion_button.dart';
import 'progress_screen.dart';

class FoodScreen extends ConsumerWidget {
  const FoodScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => P9AsyncContent(
    value: ref.watch(activityByIdProvider('eat-lunch')),
    retry: () => ref.invalidate(activitiesProvider),
    builder: (activity) => activity == null
        ? const P9Empty(message: 'Chưa có hoạt động ăn uống.')
        : P9AsyncContent(
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
              builder: (record) => ListView(
                padding: const EdgeInsets.all(P9Space.lg),
                children: [
                  Text(
                    'Ăn uống',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: P9Space.lg),
                  Text(
                    activity.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: P9Space.md),
                  Text(activity.purpose),
                  const SizedBox(height: P9Space.xl),
                  for (final (index, step) in activity.steps.indexed)
                    Padding(
                      padding: const EdgeInsets.only(bottom: P9Space.lg),
                      child: Text('${index + 1}. $step'),
                    ),
                  const SizedBox(height: P9Space.lg),
                  P9CompletionButton(
                    activity: activity,
                    day: day,
                    isDone: record != null,
                    onRecorded: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ProgressScreen(initialDay: day),
                      ),
                    ),
                  ),
                  const SizedBox(height: P9Space.md),
                  OutlinedButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => ProgressScreen(initialDay: day),
                      ),
                    ),
                    child: const Text('Xem tiến độ'),
                  ),
                  const SizedBox(height: P9Space.xl),
                  Text(activity.note),
                ],
              ),
            ),
          ),
  );
}
