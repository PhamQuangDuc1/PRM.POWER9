import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../viewmodels/completion_providers.dart';
import '../viewmodels/session_viewmodel.dart';
import '../widgets/p9_async_content.dart';
import '../widgets/p9_button.dart';
import 'progress_screen.dart';

class RelaxScreen extends ConsumerStatefulWidget {
  const RelaxScreen({super.key, this.onRecorded});
  final VoidCallback? onRecorded;
  @override
  ConsumerState<RelaxScreen> createState() => _RelaxScreenState();
}

class _RelaxScreenState extends ConsumerState<RelaxScreen>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref.read(sessionViewModelProvider.notifier).refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(sessionViewModelProvider);
    return P9AsyncContent(
      value: ref.watch(activityByIdProvider('stress-break')),
      retry: () => ref.invalidate(activitiesProvider),
      builder: (activity) => activity == null
          ? const P9Empty(message: 'Chưa có hoạt động thư giãn.')
          : P9AsyncContent(
              value: ref.watch(currentDayProvider),
              retry: () => ref.invalidate(currentDayProvider),
              builder: (day) => _SessionBody(
                activity: activity,
                day: day,
                onRecorded: widget.onRecorded,
              ),
            ),
    );
  }
}

class _SessionBody extends ConsumerWidget {
  const _SessionBody({
    required this.activity,
    required this.day,
    this.onRecorded,
  });
  final Activity activity;
  final String day;
  final VoidCallback? onRecorded;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sessionViewModelProvider);
    final vm = ref.read(sessionViewModelProvider.notifier);
    final recorded = ref.watch(
      completionForActivityProvider((activityId: activity.id, dateKey: day)),
    );
    final timerLabel = state.saved
        ? '${activity.minutes.toString().padLeft(2, '0')}:00'
        : state.timerLabel;
    void history({String? targetDay}) => Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ProgressScreen(initialDay: targetDay ?? day),
      ),
    );
    return ListView(
      padding: const EdgeInsets.all(P9Space.lg),
      children: [
        Text('Thư giãn', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: P9Space.sm),
        Text(activity.title, style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: P9Space.md),
        Text(activity.purpose, style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: P9Space.xl),
        for (final (index, step) in activity.steps.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: P9Space.md),
            child: Text('${index + 1}. $step'),
          ),
        const SizedBox(height: P9Space.xl),
        Semantics(
          label: 'Thời gian còn lại',
          value: timerLabel,
          child: Text(
            timerLabel,
            style: Theme.of(context).textTheme.displayMedium,
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: P9Space.md),
        Text(switch (state.phase) {
          SessionPhase.idle => 'Sẵn sàng khi bạn muốn bắt đầu.',
          SessionPhase.running => 'Đang thực hiện',
          SessionPhase.paused => 'Đã tạm dừng',
          SessionPhase.finished =>
            state.saved
                ? 'Phiên trước đã kết thúc.'
                : 'Phiên đã kết thúc. Thời gian thực tế: ${state.elapsedSeconds} giây.',
        }, textAlign: TextAlign.center),
        const SizedBox(height: P9Space.xl),
        if (state.phase == SessionPhase.idle || state.saved) ...[
          P9AsyncContent(
            value: recorded,
            retry: () => ref.invalidate(dayCompletionsProvider(day)),
            builder: (record) => record != null
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text('Bạn đã ghi nhận hoạt động này hôm nay.'),
                      const SizedBox(height: P9Space.md),
                      P9Button(label: 'Xem tiến độ', onPressed: history),
                    ],
                  )
                : P9Button(
                    label: 'Bắt đầu ${activity.minutes} phút',
                    icon: Icons.play_arrow_rounded,
                    onPressed: () => vm.start(activity, day),
                  ),
          ),
        ] else if (state.phase == SessionPhase.running) ...[
          P9Button(label: 'Tạm dừng', icon: Icons.pause, onPressed: vm.pause),
          const SizedBox(height: P9Space.sm),
          OutlinedButton(
            onPressed: vm.finishEarly,
            child: const Text('Kết thúc sớm'),
          ),
        ] else if (state.phase == SessionPhase.paused) ...[
          P9Button(
            label: 'Tiếp tục',
            icon: Icons.play_arrow_rounded,
            onPressed: vm.resume,
          ),
          const SizedBox(height: P9Space.sm),
          OutlinedButton(
            onPressed: vm.finishEarly,
            child: const Text('Kết thúc sớm'),
          ),
        ] else ...[
          P9Button(
            label: 'Ghi nhận phiên',
            icon: Icons.check_circle_outline,
            loading: state.saving,
            loadingLabel: 'Đang ghi nhận…',
            onPressed: state.elapsedSeconds < 1
                ? null
                : () async {
                    if (await vm.record() && context.mounted) {
                      onRecorded?.call();
                      history(targetDay: state.dateKey);
                    }
                  },
          ),
          TextButton(
            onPressed: state.saving ? null : vm.discard,
            child: const Text('Bỏ phiên chưa ghi nhận'),
          ),
        ],
        if (state.error case final error?) ...[
          const SizedBox(height: P9Space.md),
          Semantics(
            liveRegion: true,
            child: Text(
              error,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        ],
        const SizedBox(height: P9Space.xl),
        Text(activity.note),
        const SizedBox(height: P9Space.md),
        const Text(
          'Timer tiếp tục khi bạn chuyển sang ứng dụng khác. Hãy bấm Tạm dừng nếu muốn dừng tính thời gian.',
        ),
      ],
    );
  }
}
