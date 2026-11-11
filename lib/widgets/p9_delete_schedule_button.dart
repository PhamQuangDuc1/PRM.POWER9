import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/schedule.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/schedule_delete_viewmodel.dart';

class P9DeleteScheduleButton extends ConsumerStatefulWidget {
  const P9DeleteScheduleButton({
    super.key,
    required this.schedule,
    required this.onDeleted,
  });
  final Schedule schedule;
  final VoidCallback onDeleted;

  @override
  ConsumerState<P9DeleteScheduleButton> createState() =>
      _P9DeleteScheduleButtonState();
}

class _P9DeleteScheduleButtonState
    extends ConsumerState<P9DeleteScheduleButton> {
  bool _confirming = false;

  Future<void> _confirmDelete() async {
    if (_confirming) return;
    setState(() => _confirming = true);
    final schedule = widget.schedule;
    final key = (activityId: schedule.activityId, dateKey: schedule.dateKey);
    try {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          scrollable: true,
          title: const Text('Xóa lịch hoạt động này?'),
          content: Text(
            'Xóa lịch “${schedule.title}” ngày ${schedule.dateKey}. '
            'Các bản ghi đã hoàn thành vẫn được giữ trong Tiến độ.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Giữ lịch'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Theme.of(dialogContext).colorScheme.error,
              ),
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Xóa lịch'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
      final success = await ref
          .read(scheduleDeleteProvider(key).notifier)
          .delete();
      if (!success || !mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xóa lịch. Lịch sử hoàn thành được giữ nguyên.'),
        ),
      );
      widget.onDeleted();
    } finally {
      if (mounted) setState(() => _confirming = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(
      scheduleDeleteProvider((
        activityId: widget.schedule.activityId,
        dateKey: widget.schedule.dateKey,
      )),
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextButton.icon(
          style: TextButton.styleFrom(
            foregroundColor: Theme.of(context).colorScheme.error,
            minimumSize: const Size.fromHeight(P9Size.minTarget),
          ),
          onPressed: state.isLoading || _confirming ? null : _confirmDelete,
          icon: const Icon(Icons.event_busy_outlined),
          label: Text(
            state.isLoading ? 'Đang xóa lịch…' : 'Xóa lịch hoạt động',
          ),
        ),
        if (state.hasError)
          Semantics(
            liveRegion: true,
            child: const Text(
              'Chưa xóa được lịch. Kiểm tra kết nối rồi thử lại. Lịch của bạn vẫn được giữ.',
            ),
          ),
      ],
    );
  }
}
