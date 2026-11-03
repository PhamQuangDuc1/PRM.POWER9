import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import '../models/schedule.dart';
import 'activity_providers.dart';
import 'app_providers.dart';
import 'observability_providers.dart';
import '../services/telemetry_service.dart';

class ScheduleDraft {
  const ScheduleDraft({
    required this.date,
    this.minuteOfDay,
    this.reminderEnabled = false,
    this.saving = false,
    this.error,
    this.saved = false,
  });
  final DateTime date;
  final int? minuteOfDay;
  final bool reminderEnabled;
  final bool saving;
  final String? error;
  final bool saved;
}

String? validateSchedule(ScheduleDraft draft) {
  final minute = draft.minuteOfDay;
  if (draft.reminderEnabled && minute == null) {
    return 'Chọn giờ khi bật nhắc hoạt động.';
  }
  if (minute != null && (minute < 0 || minute >= 1440)) {
    return 'Giờ đã chọn không hợp lệ.';
  }
  return null;
}

final scheduleDraftProvider =
    NotifierProvider.autoDispose<ScheduleViewModel, ScheduleDraft>(
      ScheduleViewModel.new,
    );

class ScheduleViewModel extends Notifier<ScheduleDraft> {
  ScheduleViewModel({this.existing});
  final Schedule? existing;
  @override
  ScheduleDraft build() => existing == null
      ? ScheduleDraft(date: DateTime.now())
      : ScheduleDraft(
          date: DateTime.parse(existing!.dateKey),
          minuteOfDay: existing!.minuteOfDay,
          reminderEnabled: existing!.reminderEnabled,
        );
  void edit({DateTime? date, int? minuteOfDay, bool? reminderEnabled}) {
    if (state.saving) return;
    state = ScheduleDraft(
      date: date ?? state.date,
      minuteOfDay: minuteOfDay ?? state.minuteOfDay,
      reminderEnabled: reminderEnabled ?? state.reminderEnabled,
    );
  }

  Future<bool> save(Activity activity) async {
    if (state.saving) return false;
    final draft = state;
    final validation = validateSchedule(draft);
    final user = ref.read(sessionProvider).asData?.value;
    if (validation != null || user == null) {
      state = ScheduleDraft(
        date: draft.date,
        minuteOfDay: draft.minuteOfDay,
        reminderEnabled: draft.reminderEnabled,
        error: validation ?? 'Phiên đăng nhập đã hết. Vui lòng đăng nhập lại.',
      );
      return false;
    }
    state = ScheduleDraft(
      date: draft.date,
      minuteOfDay: draft.minuteOfDay,
      reminderEnabled: draft.reminderEnabled,
      saving: true,
    );
    try {
      await ref
          .read(scheduleServiceProvider)
          .save(
            uid: user.uid,
            activity: activity,
            dateKey: dayKey(draft.date),
            minuteOfDay: draft.minuteOfDay,
            reminderEnabled: draft.reminderEnabled,
          );
      if (!ref.mounted) return false;
      await ref
          .read(telemetryProvider)
          .event(
            existing == null
                ? AppEvent.scheduleCreated
                : AppEvent.scheduleUpdated,
            activityEventParameters(activity),
          );
      if (!ref.mounted) return false;
      state = ScheduleDraft(
        date: draft.date,
        minuteOfDay: draft.minuteOfDay,
        reminderEnabled: draft.reminderEnabled,
        saved: true,
      );
      return true;
    } catch (error, stack) {
      if (!ref.mounted) return false;
      final telemetry = ref.read(telemetryProvider);
      state = ScheduleDraft(
        date: draft.date,
        minuteOfDay: draft.minuteOfDay,
        reminderEnabled: draft.reminderEnabled,
        error: 'Chưa lưu được lịch. Kiểm tra kết nối rồi thử lại. Nội dung bạn chọn vẫn được giữ.',
      );
      await telemetry.report(error, stack, operation: 'schedule_save');
      return false;
    }
  }
}
