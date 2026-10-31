import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:power9_office_routine/models/app_config.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/models/activity.dart';
import 'package:power9_office_routine/services/app_config_service.dart';
import 'package:power9_office_routine/services/firebase_telemetry_service.dart';
import 'package:power9_office_routine/services/telemetry_service.dart';
import 'package:power9_office_routine/viewmodels/activity_providers.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/discover_viewmodel.dart';
import 'package:power9_office_routine/viewmodels/observability_providers.dart';
import 'package:power9_office_routine/viewmodels/schedule_viewmodel.dart';

import 'auth_gate_test.dart' show EmptyScheduleService;
import 'workspace_flow_test.dart' show desk;

class RecordingTelemetry extends TelemetryService {
  final events = <AppEvent>[];
  final parameters = <Map<String, Object>>[];
  final failures = <String>[];
  @override
  Future<void> initialize() async {}
  @override
  Future<void> identify(String? uid) async {}
  @override
  Future<void> event(
    AppEvent event, [
    Map<String, Object> parameters = const {},
  ]) async {
    events.add(event);
    this.parameters.add(parameters);
  }

  @override
  Future<void> report(
    Object error,
    StackTrace stack, {
    required String operation,
    bool fatal = false,
  }) async {
    failures.add(operation);
  }

  @override
  Future<void> testCrash() async {}
}

class ChangingConfig extends AppConfigService {
  bool fail = false;
  @override
  Future<AppConfig> cached() async =>
      const AppConfig(discoverMaxMinutes: 10, connectionCheckinEnabled: false);
  @override
  Future<AppConfig> fetch() async {
    if (fail) throw Exception('offline');
    return const AppConfig(
      discoverMaxMinutes: 5,
      connectionCheckinEnabled: false,
    );
  }
}

class FailingScheduleService extends EmptyScheduleService {
  bool fail = true;
  @override
  Future<void> save({
    required String uid,
    required Activity activity,
    required String dateKey,
    required int? minuteOfDay,
    required bool reminderEnabled,
  }) async {
    if (fail) throw Exception('offline');
  }
}

void main() {
  test('remote config changes real discover results and keeps last good values on failure', () async {
    final service = ChangingConfig();
    final telemetry = RecordingTelemetry();
    const longActivity = Activity(
      id: 'balance-review',
      title: 'Tổng kết',
      groupId: 'balance',
      groupName: 'Cân bằng',
      minutes: 10,
      purpose: '',
      steps: [],
      note: '',
      rank: 9,
    );
    final container = ProviderContainer(
      overrides: [
        appConfigServiceProvider.overrideWithValue(service),
        telemetryProvider.overrideWithValue(telemetry),
        activitiesProvider.overrideWith(
          (ref) => Stream.value([desk, longActivity]),
        ),
      ],
    );
    addTearDown(container.dispose);
    final sub = container.listen(discoverResultsProvider, (_, _) {});
    addTearDown(sub.close);
    await container.read(activitiesProvider.future);
    expect(container.read(discoverResultsProvider).asData!.value.length, 2);
    await container.read(appConfigProvider.notifier).refresh();
    expect(
      container
          .read(discoverResultsProvider)
          .asData!
          .value
          .map((item) => item.id),
      ['space-desk'],
    );
    expect(
      container.read(appConfigProvider).value.connectionCheckinEnabled,
      false,
    );
    service.fail = true;
    await container.read(appConfigProvider.notifier).refresh();
    expect(container.read(appConfigProvider).value.discoverMaxMinutes, 5);
    expect(container.read(appConfigProvider).error, isNotNull);
    expect(telemetry.failures, ['remote_config_fetch']);
  });

  test('first fetch offline uses activated cache rather than replacing with defaults', () async {
    final service = ChangingConfig()..fail = true;
    final container = ProviderContainer(
      overrides: [appConfigServiceProvider.overrideWithValue(service)],
    );
    addTearDown(container.dispose);
    await container.read(appConfigProvider.notifier).refresh();
    expect(container.read(appConfigProvider).value.discoverMaxMinutes, 10);
    expect(
      container.read(appConfigProvider).value.connectionCheckinEnabled,
      false,
    );
    expect(container.read(appConfigProvider).fetchedAt, isNull);
  });

  test('invalid remote duration fails open to safe default', () {
    expect(AppConfig.fromValues(0, true).discoverMaxMinutes, 60);
    expect(AppConfig.fromValues(9999, true).discoverMaxMinutes, 60);
  });

  test(
    'save failure is reported and does not emit a success event; retry does',
    () async {
      final telemetry = RecordingTelemetry();
      final service = FailingScheduleService();
      final container = ProviderContainer(
        overrides: [
          telemetryProvider.overrideWithValue(telemetry),
          scheduleServiceProvider.overrideWithValue(service),
          sessionProvider.overrideWith(
            (ref) => Stream.value(const AppUser(uid: 'alice')),
          ),
        ],
      );
      addTearDown(container.dispose);
      final sub = container.listen(scheduleDraftProvider, (_, _) {});
      addTearDown(sub.close);
      final sessionSub = container.listen(sessionProvider, (_, _) {});
      addTearDown(sessionSub.close);
      await container.read(sessionProvider.future);
      final vm = container.read(scheduleDraftProvider.notifier);
      vm.edit(minuteOfDay: 1290);
      expect(await vm.save(desk), false);
      expect(telemetry.events, isEmpty);
      expect(telemetry.failures, ['schedule_save']);
      expect(container.read(scheduleDraftProvider).minuteOfDay, 1290);
      service.fail = false;
      expect(await vm.save(desk), true);
      expect(telemetry.events, [AppEvent.scheduleCreated]);
    },
  );

  testWidgets('search event debounces and excludes free-text query', (
    tester,
  ) async {
    final telemetry = RecordingTelemetry();
    final container = ProviderContainer(
      overrides: [telemetryProvider.overrideWithValue(telemetry)],
    );
    addTearDown(container.dispose);
    final sub = container.listen(discoverFilterProvider, (_, _) {});
    addTearDown(sub.close);
    final vm = container.read(discoverFilterProvider.notifier);
    vm.search('personal@example.com');
    vm.search('private content');
    await tester.pump(const Duration(milliseconds: 650));
    expect(telemetry.events, [AppEvent.search]);
    expect(telemetry.parameters.single.keys, isNot(contains('query')));
    expect(
      telemetry.parameters.single.values,
      isNot(contains('private content')),
    );
    expect(telemetry.parameters.single['query_length'], 15);
  });

  test('telemetry whitelist drops names, email and raw queries', () {
    expect(
      safeEventParameters({
        'email': 'personal@example.com',
        'query': 'private',
        'display_name': 'Private Name',
        'activity_id': 'space-desk',
        'query_length': 7,
      }),
      {'activity_id': 'space-desk', 'query_length': 7},
    );
  });
}
