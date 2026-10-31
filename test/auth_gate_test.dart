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
import 'package:power9_office_routine/viewmodels/activity_providers.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';

class EmptyActivityService implements ActivityService {
  @override
  Stream<List<Activity>> watchActivities() => Stream.value([]);
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

void main() {
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
