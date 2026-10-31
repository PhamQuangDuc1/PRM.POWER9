import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'dart:async';

import '../models/app_config.dart';
import '../models/activity.dart';
import '../services/telemetry_service.dart';
import '../services/firebase_telemetry_service.dart';
import '../services/app_config_service.dart';
import '../services/firebase_app_config_service.dart';

final telemetryProvider = Provider<TelemetryService>(
  (ref) => FirebaseTelemetryService(),
);
final appConfigServiceProvider = Provider<AppConfigService>(
  (ref) => FirebaseAppConfigService(),
);

class ConfigState {
  const ConfigState({
    this.value = const AppConfig(),
    this.loading = false,
    this.error,
    this.fetchedAt,
  });
  final AppConfig value;
  final bool loading;
  final String? error;
  final DateTime? fetchedAt;
}

final appConfigProvider = NotifierProvider<AppConfigViewModel, ConfigState>(
  AppConfigViewModel.new,
);

class AppConfigViewModel extends Notifier<ConfigState> {
  @override
  ConfigState build() => const ConfigState();
  Future<void> refresh() async {
    if (state.loading) return;
    final previous = state;
    state = ConfigState(
      value: previous.value,
      loading: true,
      fetchedAt: previous.fetchedAt,
    );
    var fallback = previous.value;
    try {
      final service = ref.read(appConfigServiceProvider);
      if (previous.fetchedAt == null) fallback = await service.cached();
      final value = await service.fetch();
      if (!ref.mounted) return;
      state = ConfigState(value: value, fetchedAt: DateTime.now());
      await ref.read(telemetryProvider).event(AppEvent.configRefreshed);
    } catch (error, stack) {
      if (!ref.mounted) return;
      state = ConfigState(
        value: fallback,
        fetchedAt: previous.fetchedAt,
        error: 'Chưa lấy được cấu hình mới. Đang giữ cấu hình hiện có.',
      );
      await ref
          .read(telemetryProvider)
          .report(error, stack, operation: 'remote_config_fetch');
    }
  }
}

Map<String, Object> activityEventParameters(Activity activity) => {
  'activity_id': activity.id,
  'group_id': activity.groupId,
};

final activityViewEventProvider = Provider.autoDispose.family<void, Activity>((
  ref,
  activity,
) {
  unawaited(
    ref
        .read(telemetryProvider)
        .event(AppEvent.viewActivity, activityEventParameters(activity)),
  );
});
