import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/app.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/models/completion.dart';
import 'package:power9_office_routine/models/schedule.dart';
import 'package:power9_office_routine/services/telemetry_service.dart';
import 'package:power9_office_routine/viewmodels/activity_providers.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/completion_providers.dart';
import 'package:power9_office_routine/viewmodels/observability_providers.dart';
import 'package:power9_office_routine/viewmodels/schedule_delete_viewmodel.dart';

import 'auth_gate_test.dart'
    show EmptyActivityService, EmptyScheduleService, EmptyCompletionService;
import 'observability_test.dart' show RecordingTelemetry;
import 'schedule_viewmodel_test.dart' show activity;

const day = '2026-11-02';
const key = (activityId: 'move-walk', dateKey: day);
const schedule = Schedule(
  id: 'move-walk_2026-11-02',
  activityId: 'move-walk',
  title: 'Đi bộ giữa giờ',
  groupId: 'move',
  dateKey: day,
  minuteOfDay: 600,
  reminderEnabled: false,
);

class DeletableSchedules extends EmptyScheduleService {
  final changes = StreamController<List<Schedule>>.broadcast(sync: true);
  final calls = <(String, String)>[];
  List<Schedule> items = [schedule];
  int failuresRemaining = 0;
  Completer<void>? gate;

  @override
  Stream<List<Schedule>> watchDay(String uid, String dateKey) =>
      Stream.multi((out) {
        final subscription = changes.stream.listen(out.add);
        out.add(List.of(items));
        out.onCancel = subscription.cancel;
      });

  @override
  Future<void> delete(String uid, String id) async {
    calls.add((uid, id));
    if (gate != null) await gate!.future;
    if (failuresRemaining > 0) {
      failuresRemaining--;
      throw StateError('offline');
    }
    items = items.where((item) => item.id != id).toList();
    changes.add(List.of(items));
  }
}

class RetainedCompletions extends EmptyCompletionService {
  int deletes = 0;
  @override
  Stream<List<Completion>> watchDay(String uid, String dateKey) =>
      Stream.value([
        Completion(
          id: schedule.id,
          activityId: schedule.activityId,
          title: schedule.title,
          groupId: schedule.groupId,
          dateKey: day,
          source: CompletionSource.timer,
          durationSeconds: 45,
        ),
      ]);
  @override
  Future<void> delete(String uid, String id) async {
    deletes++;
  }
}

class BrokenTelemetry extends RecordingTelemetry {
  @override
  Future<void> event(
    AppEvent event, [
    Map<String, Object> parameters = const {},
  ]) async => throw StateError('telemetry unavailable');
}

Future<ProviderContainer> controller(
  DeletableSchedules service,
  RecordingTelemetry telemetry, {
  Stream<AppUser?>? session,
}) async {
  final container = ProviderContainer(
    overrides: [
      sessionProvider.overrideWith(
        (ref) => session ?? Stream.value(const AppUser(uid: 'alice')),
      ),
      scheduleServiceProvider.overrideWithValue(service),
      telemetryProvider.overrideWithValue(telemetry),
    ],
  );
  container.listen(sessionProvider, (_, _) {});
  await container.read(sessionProvider.future);
  container.listen(scheduleDeleteProvider(key), (_, _) {});
  return container;
}

void main() {
  test('delete waits for acknowledgement, blocks duplicate taps, then logs success', () async {
    final service = DeletableSchedules()..gate = Completer<void>();
    final telemetry = RecordingTelemetry();
    final c = await controller(service, telemetry);
    addTearDown(() async {
      c.dispose();
      await service.changes.close();
    });
    final vm = c.read(scheduleDeleteProvider(key).notifier);
    final pending = vm.delete();
    expect(await vm.delete(), isFalse);
    expect(service.calls, [('alice', schedule.id)]);
    expect(service.items, hasLength(1));
    expect(c.read(scheduleDeleteProvider(key)).isLoading, isTrue);
    expect(telemetry.events, isEmpty);
    service.gate!.complete();
    expect(await pending, isTrue);
    expect(service.items, isEmpty);
    expect(c.read(scheduleDeleteProvider(key)).asData!.value, isTrue);
    expect(telemetry.events, [AppEvent.scheduleDeleted]);
  });

  test('failed delete retains the schedule and retry can succeed', () async {
    final service = DeletableSchedules()..failuresRemaining = 1;
    final telemetry = RecordingTelemetry();
    final c = await controller(service, telemetry);
    addTearDown(() async {
      c.dispose();
      await service.changes.close();
    });
    final vm = c.read(scheduleDeleteProvider(key).notifier);
    expect(await vm.delete(), isFalse);
    expect(service.items, hasLength(1));
    expect(c.read(scheduleDeleteProvider(key)).hasError, isTrue);
    expect(telemetry.events, isEmpty);
    expect(telemetry.failures, ['schedule_delete']);
    expect(await vm.delete(), isTrue);
    expect(service.items, isEmpty);
  });

  test('pending delete cannot report success into another account', () async {
    final session = StreamController<AppUser?>();
    final service = DeletableSchedules()..gate = Completer<void>();
    final telemetry = RecordingTelemetry();
    final preparing = controller(service, telemetry, session: session.stream);
    await Future<void>.delayed(Duration.zero);
    session.add(const AppUser(uid: 'alice'));
    final c = await preparing;
    addTearDown(() async {
      c.dispose();
      await session.close();
      await service.changes.close();
    });
    final pending = c.read(scheduleDeleteProvider(key).notifier).delete();
    session.add(const AppUser(uid: 'bob'));
    await Future<void>.delayed(Duration.zero);
    service.gate!.complete();
    expect(await pending, isFalse);
    expect(service.calls.single.$1, 'alice');
    expect(telemetry.events, isEmpty);
    expect(c.read(scheduleDeleteProvider(key)).asData!.value, isFalse);
  });

  test(
    'telemetry failure cannot turn a confirmed delete into failure',
    () async {
      final service = DeletableSchedules();
      final c = await controller(service, BrokenTelemetry());
      addTearDown(() async {
        c.dispose();
        await service.changes.close();
      });
      expect(
        await c.read(scheduleDeleteProvider(key).notifier).delete(),
        isTrue,
      );
      expect(c.read(scheduleDeleteProvider(key)).hasError, isFalse);
    },
  );

  testWidgets(
    'cancel, failure and retry from detail preserve completion history',
    (tester) async {
      final service = DeletableSchedules()..failuresRemaining = 1;
      final completions = RetainedCompletions();
      final telemetry = RecordingTelemetry();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bootstrapProvider.overrideWith((ref) async {}),
            sessionProvider.overrideWith(
              (ref) => Stream.value(const AppUser(uid: 'alice')),
            ),
            currentDayProvider.overrideWith((ref) => Stream.value(day)),
            activityServiceProvider.overrideWithValue(
              EmptyActivityService([activity]),
            ),
            scheduleServiceProvider.overrideWithValue(service),
            completionServiceProvider.overrideWithValue(completions),
            telemetryProvider.overrideWithValue(telemetry),
          ],
          child: const Power9App(),
        ),
      );
      await tester.pumpAndSettle();
      final tile = find.ancestor(
        of: find.text(activity.title),
        matching: find.byType(ListTile),
      );
      await tester.ensureVisible(tile);
      await tester.pumpAndSettle();
      await tester.tap(tile);
      await tester.pumpAndSettle();
      Future<void> openDelete() async {
        await tester.ensureVisible(find.text('Xóa lịch hoạt động'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Xóa lịch hoạt động'));
        await tester.pumpAndSettle();
        expect(find.text('Xóa lịch hoạt động này?'), findsOneWidget);
      }

      await openDelete();
      await tester.tap(find.text('Giữ lịch'));
      await tester.pumpAndSettle();
      expect(service.calls, isEmpty);
      await openDelete();
      await tester.tap(find.text('Xóa lịch'));
      await tester.pumpAndSettle();
      expect(find.textContaining('Chưa xóa được lịch.'), findsOneWidget);
      expect(service.items, hasLength(1));
      await openDelete();
      await tester.tap(find.text('Xóa lịch'));
      await tester.pumpAndSettle();
      expect(service.items, isEmpty);
      expect(completions.deletes, 0);
      expect(find.text('Chi tiết hoạt động'), findsNothing);
      expect(find.text('Khám phá hoạt động'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await service.changes.close();
    },
  );
}
