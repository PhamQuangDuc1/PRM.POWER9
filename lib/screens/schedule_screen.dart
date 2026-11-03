import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/schedule.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/schedule_viewmodel.dart';
import '../widgets/p9_button.dart';

class ScheduleScreen extends ConsumerWidget {
  const ScheduleScreen({
    super.key,
    required this.activity,
    this.editing = false,
    this.returnAfterSave = false,
  });
  final Activity activity;
  final bool editing;
  final bool returnAfterSave;

  static Route<void> route(
    Activity activity,
    Schedule? existing, {
    bool returnAfterSave = false,
  }) => MaterialPageRoute<void>(
    builder: (_) => ProviderScope(
      overrides: [
        scheduleDraftProvider.overrideWith(
          () => ScheduleViewModel(existing: existing),
        ),
      ],
      child: ScheduleScreen(
        activity: activity,
        editing: existing != null,
        returnAfterSave: returnAfterSave,
      ),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(scheduleDraftProvider);
    final vm = ref.read(scheduleDraftProvider.notifier);
    final time = state.minuteOfDay;
    final timeLabel = time == null
        ? 'Chọn giờ'
        : '${(time ~/ 60).toString().padLeft(2, '0')}:${(time % 60).toString().padLeft(2, '0')}';
    return PopScope(
      canPop: !state.saving,
      child: Scaffold(
        appBar: AppBar(
          title: Text(editing ? 'Đổi lịch hoạt động' : 'Lịch hoạt động'),
        ),
        body: ListView(
          padding: const EdgeInsets.all(P9Space.lg),
          children: [
            Text(activity.title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: P9Space.sm),
            Text('${activity.groupName} · ${activity.minutes} phút'),
            const SizedBox(height: P9Space.xl),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_month_outlined),
              title: const Text('Ngày thực hiện'),
              subtitle: Text(dayKey(state.date)),
              trailing: editing ? null : const Icon(Icons.chevron_right),
              onTap: editing || state.saving
                  ? null
                  : () async {
                      final today = DateTime.now();
                      final selected = await showDatePicker(
                        context: context,
                        initialDate: state.date,
                        firstDate: DateTime(today.year, today.month, today.day),
                        lastDate: DateTime(
                          today.year + 1,
                          today.month,
                          today.day,
                        ),
                      );
                      if (selected != null && context.mounted) {
                        vm.edit(date: selected);
                      }
                    },
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Nhắc hoạt động'),
              subtitle: const Text('Giờ yên lặng: 18:00–08:00'),
              value: state.reminderEnabled,
              onChanged: state.saving
                  ? null
                  : (value) => vm.edit(reminderEnabled: value),
            ),
            OutlinedButton.icon(
              icon: const Icon(Icons.schedule),
              label: Text(timeLabel),
              onPressed: state.saving
                  ? null
                  : () async {
                      final selected = await showTimePicker(
                        context: context,
                        initialTime: time == null
                            ? TimeOfDay.now()
                            : TimeOfDay(hour: time ~/ 60, minute: time % 60),
                        builder: (context, child) => MediaQuery(
                          data: MediaQuery.of(context)
                              .copyWith(alwaysUse24HourFormat: true),
                          child: child!,
                        ),
                      );
                      if (selected != null && context.mounted) {
                        vm.edit(
                          minuteOfDay: selected.hour * 60 + selected.minute,
                        );
                      }
                    },
            ),
            const SizedBox(height: P9Space.md),
            Text(
              'Bạn vẫn có thể lưu lịch ngoài giờ yên lặng. Lưu lịch chưa phải là hoàn thành hoạt động.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: P9Space.xl),
            if (state.error case final error?) ...[
              Semantics(
                liveRegion: true,
                child: Text(
                  error,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
              const SizedBox(height: P9Space.lg),
            ],
            P9Button(
              label: state.error == null ? 'Lưu lịch' : 'Thử lưu lại',
              loading: state.saving,
              loadingLabel: 'Đang lưu lịch…',
              onPressed: () async {
                final success = await vm.save(activity);
                if (success && context.mounted) {
                  final messenger = ScaffoldMessenger.of(context);
                  if (returnAfterSave) {
                    Navigator.of(context).pop();
                  } else {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  }
                  messenger.showSnackBar(
                    const SnackBar(content: Text('Đã lưu lịch hoạt động.')),
                  );
                }
              },
            ),
            const SizedBox(height: P9Space.sm),
            TextButton(
              onPressed: state.saving
                  ? null
                  : () => Navigator.of(context).pop(),
              child: const Text('Hủy'),
            ),
          ],
        ),
      ),
    );
  }
}
