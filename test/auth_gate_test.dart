import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/app.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/models/activity.dart';
import 'package:power9_office_routine/models/schedule.dart';
import 'package:power9_office_routine/services/activity_service.dart';
import 'package:power9_office_routine/services/schedule_service.dart';
import 'package:power9_office_routine/services/completion_service.dart';
import 'package:power9_office_routine/models/completion.dart';
import 'package:power9_office_routine/viewmodels/completion_providers.dart';
import 'package:power9_office_routine/viewmodels/activity_providers.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/session_viewmodel.dart';

class EmptyActivityService implements ActivityService {
  EmptyActivityService([this.items = const []]);
  final List<Activity> items;
  @override
  Stream<List<Activity>> watchActivities() => Stream.value(items);
}

class EmptyScheduleService implements ScheduleService {
  @override
  Stream<List<Schedule>> watchDay(String uid, String dateKey) =>
      Stream.value([]);
  @override
  Future<void> save({
    required String uid,
    required Activity activity,
    required String dateKey,
    required int? minuteOfDay,
    required bool reminderEnabled,
  }) async {}
  @override
  Future<void> delete(String uid, String id) async {}
}

class EmptyCompletionService implements CompletionService {
  int recordCalls = 0;
  @override
  Stream<List<Completion>> watchDay(String uid, String day) => Stream.value([]);
  @override
  Future<void> record({
    required String uid,
    required Activity activity,
    required String dateKey,
    required CompletionSource source,
    int? durationSeconds,
  }) async {
    recordCalls++;
  }

  @override
  Future<void> delete(String uid, String id) async {}
}

void main() {
  testWidgets(
    'leaving a paused session preserves it on Stay and discards without recording',
    (tester) async {
      const rest = Activity(
        id: 'stress-break',
        title: 'Nghỉ sau họp',
        groupId: 'stress',
        groupName: 'Giảm căng thẳng',
        minutes: 3,
        purpose: 'Nghỉ ngắn',
        steps: [],
        note: 'Tự chọn',
        rank: 1,
      );
      final service = EmptyCompletionService();
      final container = ProviderContainer(
        overrides: [
          bootstrapProvider.overrideWith((ref) async {}),
          sessionProvider.overrideWith(
            (ref) => Stream.value(const AppUser(uid: 'alice')),
          ),
          currentDayProvider.overrideWith((ref) => Stream.value('2026-10-31')),
          activityServiceProvider.overrideWithValue(
            EmptyActivityService([rest]),
          ),
          scheduleServiceProvider.overrideWithValue(EmptyScheduleService()),
          completionServiceProvider.overrideWithValue(service),
        ],
      );
      addTearDown(container.dispose);
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: const Power9App(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Thư giãn'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Bắt đầu 3 phút'));
      await tester.tap(find.text('Bắt đầu 3 phút'));
      await tester.pump(const Duration(milliseconds: 300));
      await tester.ensureVisible(find.text('Tạm dừng'));
      await tester.tap(find.text('Tạm dừng'));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Hôm nay'),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('Rời phiên thư giãn?'), findsOneWidget);
      await tester.tap(find.text('Ở lại'));
      await tester.pumpAndSettle();
      expect(
        container.read(sessionViewModelProvider).phase,
        SessionPhase.paused,
      );
      expect(find.text('Tiếp tục'), findsOneWidget);
      await tester.tap(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text('Hôm nay'),
        ),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bỏ phiên'));
      await tester.pumpAndSettle();
      expect(container.read(sessionViewModelProvider).phase, SessionPhase.idle);
      expect(service.recordCalls, 0);
      await tester.pumpWidget(const SizedBox.shrink());
    },
  );
  testWidgets('sign-out removes pushed private routes as well as Home', (
    tester,
  ) async {
    final session = StreamController<AppUser?>();
    addTearDown(session.close);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bootstrapProvider.overrideWith((ref) async {}),
          sessionProvider.overrideWith((ref) => session.stream),
          activityServiceProvider.overrideWithValue(EmptyActivityService()),
          currentDayProvider.overrideWith((ref) => Stream.value('2026-10-31')),
          scheduleServiceProvider.overrideWithValue(EmptyScheduleService()),
          completionServiceProvider.overrideWithValue(EmptyCompletionService()),
        ],
        child: const Power9App(),
      ),
    );
    await tester.pump();
    session.add(const AppUser(uid: 'alice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Khám phá hoạt động'));
    await tester.pumpAndSettle();
    expect(find.text('Tìm hoạt động'), findsOneWidget);
    session.add(null);
    await tester.pumpAndSettle();
    expect(find.text('Đăng nhập với Google'), findsOneWidget);
    expect(find.text('Tìm hoạt động'), findsNothing);
    expect(find.text('Khám phá hoạt động'), findsNothing);
  });
  testWidgets('Signed-out sessions cannot see account details', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          bootstrapProvider.overrideWith((ref) async {}),
          sessionProvider.overrideWith((ref) => Stream<AppUser?>.value(null)),
        ],
        child: const Power9App(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Đăng nhập với Google'), findsOneWidget);
    expect(find.text('Đăng xuất'), findsNothing);
  });

  for (final width in [360.0, 412.0]) {
    testWidgets('Login remains usable at width $width with enlarged text', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 800);
      tester.view.devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            bootstrapProvider.overrideWith((ref) async {}),
            sessionProvider.overrideWith((ref) => Stream<AppUser?>.value(null)),
          ],
          child: const Power9App(),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Đăng nhập với Google'));
      expect(tester.takeException(), isNull);
      expect(find.text('Power9 Office Routine'), findsOneWidget);
    });
  }
}
