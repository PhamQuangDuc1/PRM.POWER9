import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/models/activity.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/screens/activity_detail_screen.dart';
import 'package:power9_office_routine/screens/connection_screen.dart';
import 'package:power9_office_routine/screens/discover_screen.dart';
import 'package:power9_office_routine/screens/food_screen.dart';
import 'package:power9_office_routine/screens/home_shell.dart';
import 'package:power9_office_routine/screens/login_screen.dart';
import 'package:power9_office_routine/screens/notification_screen.dart';
import 'package:power9_office_routine/screens/profile_screen.dart';
import 'package:power9_office_routine/screens/progress_screen.dart';
import 'package:power9_office_routine/screens/recovery_screen.dart';
import 'package:power9_office_routine/screens/relax_screen.dart';
import 'package:power9_office_routine/screens/report_screen.dart';
import 'package:power9_office_routine/screens/schedule_screen.dart';
import 'package:power9_office_routine/screens/today_screen.dart';
import 'package:power9_office_routine/screens/workspace_screen.dart';
import 'package:power9_office_routine/theme/p9_theme.dart';
import 'package:power9_office_routine/viewmodels/activity_providers.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/completion_providers.dart';
import 'package:power9_office_routine/viewmodels/notification_viewmodel.dart';
import 'package:power9_office_routine/widgets/p9_activity_card.dart';

import 'auth_gate_test.dart'
    show EmptyActivityService, EmptyScheduleService, EmptyCompletionService;
import 'notification_flow_test.dart' show LocalNotificationsFake;

void main() {
  final catalog =
      (jsonDecode(File('firebase/catalog.json').readAsStringSync()) as List)
          .map(
            (row) => Activity.fromMap(
              row['id'] as String,
              Map<String, dynamic>.from(row as Map),
            ),
          )
          .toList();
  Activity activity(String id) => catalog.firstWhere((item) => item.id == id);
  for (final (size, textScale) in [
    (const Size(320, 568), 2.0),
    (const Size(360, 800), 1.5),
    (const Size(412, 800), 1.5),
    (const Size(667, 320), 2.0),
    (const Size(800, 1200), 2.0),
    (const Size(1200, 800), 1.0),
  ]) {
    final viewport = '${size.width.toInt()}×${size.height.toInt()} dp';
    testWidgets('main screens fit $viewport with $textScale text scaling', (
      tester,
    ) async {
      tester.view.physicalSize = size;
      tester.view.devicePixelRatio = 1;
      final semantics = tester.ensureSemantics();
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final notifications = LocalNotificationsFake();
      final container = ProviderContainer(
        overrides: [
          sessionProvider.overrideWith(
            (ref) => Stream.value(const AppUser(uid: 'layout-test')),
          ),
          currentDayProvider.overrideWith((ref) => Stream.value('2026-11-01')),
          activityServiceProvider.overrideWithValue(
            EmptyActivityService(catalog),
          ),
          scheduleServiceProvider.overrideWithValue(EmptyScheduleService()),
          completionServiceProvider.overrideWithValue(EmptyCompletionService()),
          notificationServiceProvider.overrideWithValue(notifications),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await notifications.dispose();
      });
      final screens = <Widget>[
        const LoginScreen(),
        const HomeShell(user: AppUser(uid: 'layout-test')),
        const TodayScreen(),
        const FoodScreen(),
        const RelaxScreen(),
        const ConnectionScreen(),
        const DiscoverScreen(),
        ActivityDetailScreen(activity: activity('move-walk')),
        ScheduleScreen(activity: activity('move-walk')),
        const ProgressScreen(initialDay: '2026-11-01'),
        const ReportScreen(day: '2026-11-01'),
        WorkspaceScreen(activity: activity('space-desk')),
        RecoveryScreen(activity: activity('sleep-prepare')),
        const ProfileScreen(
          user: AppUser(
            uid: 'layout-test',
            displayName: 'Tài khoản kiểm thử bố cục',
          ),
        ),
        const NotificationScreen(),
      ];
      try {
        for (final screen in screens) {
          await tester.pumpWidget(
            UncontrolledProviderScope(
              container: container,
              child: MaterialApp(
                key: UniqueKey(),
                theme: P9Theme.light,
                locale: const Locale('vi'),
                supportedLocales: const [Locale('vi')],
                localizationsDelegates: GlobalMaterialLocalizations.delegates,
                builder: (context, child) => MediaQuery(
                  data: MediaQuery.of(context)
                      .copyWith(textScaler: TextScaler.linear(textScale)),
                  child: child!,
                ),
                home: Scaffold(body: screen),
              ),
            ),
          );
          await tester.pumpAndSettle();
          final renderError = tester.takeException();
          expect(
            renderError,
            isNull,
            reason:
                '${screen.runtimeType} overflow or render error at $viewport / $textScale text'
                '${renderError is FlutterError ? renderError.diagnostics.map((d) => d.toStringDeep()).join() : ''}',
          );
          expect(find.byType(Scaffold), findsWidgets);
          if (screen is HomeShell) {
            final wide = size.width >= 600;
            expect(
              find.byType(NavigationRail),
              wide ? findsOneWidget : findsNothing,
            );
            expect(
              find.byType(NavigationBar),
              wide ? findsNothing : findsOneWidget,
            );
          }
          await expectLater(
            tester,
            meetsGuideline(androidTapTargetGuideline),
            reason: '${screen.runtimeType}: Android touch targets at $viewport',
          );
          await expectLater(
            tester,
            meetsGuideline(labeledTapTargetGuideline),
            reason:
                '${screen.runtimeType}: accessible control labels at $viewport',
          );
          if (screen is ScheduleScreen && size.height == 320) {
            for (final (label, pickerType) in [
              ('Ngày thực hiện', DatePickerDialog),
              ('Chọn giờ', TimePickerDialog),
            ]) {
              final control = find.text(label);
              await tester.dragUntilVisible(
                control.hitTestable(),
                find.byType(ListView),
                const Offset(0, -80),
              );
              await tester.tap(control);
              await tester.pumpAndSettle();
              final picker = find.byType(pickerType);
              expect(picker, findsOneWidget);
              expect(
                tester.takeException(),
                isNull,
                reason: '$pickerType at $viewport',
              );
              Navigator.of(tester.element(picker)).pop();
              await tester.pumpAndSettle();
            }
          }
          if (screen is DiscoverScreen && size.height == 320) {
            final title = activity('move-walk').title;
            await tester.enterText(find.byType(TextField), title);
            tester.view.viewInsets = const FakeViewPadding(bottom: 205);
            try {
              await tester.pumpAndSettle();
              final result = find.descendant(
                of: find.byType(P9ActivityCard),
                matching: find.text(title),
              );
              await tester.dragUntilVisible(
                result.hitTestable(),
                find.byType(ListView),
                const Offset(0, -32),
              );
              expect(tester.takeException(), isNull);
            } finally {
              tester.view.resetViewInsets();
            }
          }
        }
      } finally {
        semantics.dispose();
      }
    });
  }
}
