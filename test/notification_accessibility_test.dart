import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/models/office_notification.dart';
import 'package:power9_office_routine/screens/home_shell.dart';
import 'package:power9_office_routine/theme/p9_theme.dart';
import 'package:power9_office_routine/viewmodels/activity_providers.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/completion_providers.dart';
import 'package:power9_office_routine/viewmodels/notification_viewmodel.dart';

import 'auth_gate_test.dart'
    show EmptyActivityService, EmptyScheduleService, EmptyCompletionService;
import 'notification_flow_test.dart' show LocalNotificationsFake;

void main() {
  testWidgets('unread badge retains a usable notification action label', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    try {
      final notifications = LocalNotificationsFake();
      for (final id in ['first', 'second']) {
        notifications.items.add(
          OfficeNotification(
            id: id,
            ownerUid: 'accessibility-test',
            title: 'Test notification',
            body: 'Public test content',
            target: 'today',
            dateKey: '2026-11-03',
            receivedAt: DateTime(2026, 11, 3),
          ),
        );
      }
      final container = ProviderContainer(
        overrides: [
          sessionProvider.overrideWith(
            (ref) => Stream.value(const AppUser(uid: 'accessibility-test')),
          ),
          currentDayProvider.overrideWith((ref) => Stream.value('2026-11-03')),
          activityServiceProvider.overrideWithValue(EmptyActivityService()),
          scheduleServiceProvider.overrideWithValue(EmptyScheduleService()),
          completionServiceProvider.overrideWithValue(EmptyCompletionService()),
          notificationServiceProvider.overrideWithValue(notifications),
        ],
      );
      addTearDown(() async {
        container.dispose();
        await notifications.dispose();
      });
      final session = container.listen(sessionProvider, (_, _) {});
      addTearDown(session.close);
      await tester.pump();
      expect(
        container.read(sessionProvider).asData?.value?.uid,
        'accessibility-test',
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(
          container: container,
          child: MaterialApp(
            locale: const Locale('vi'),
            localizationsDelegates: GlobalMaterialLocalizations.delegates,
            supportedLocales: const [Locale('vi')],
            theme: P9Theme.light,
            home: const HomeShell(user: AppUser(uid: 'accessibility-test')),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        container
            .read(notificationControllerProvider('accessibility-test'))
            .unread,
        2,
      );
      expect(find.bySemanticsLabel('Thông báo, 2 chưa đọc'), findsOneWidget);
      notifications.items.clear();
      notifications.changed.add(null);
      await tester.pumpAndSettle();
      expect(find.bySemanticsLabel('Thông báo'), findsOneWidget);
      expect(find.bySemanticsLabel('Thông báo, 2 chưa đọc'), findsNothing);
      await tester.tap(find.byTooltip('Thông báo'));
      await tester.pumpAndSettle();
      expect(find.text('Chưa có thông báo cho tài khoản này.'), findsOneWidget);
    } finally {
      semantics.dispose();
    }
  });
}
