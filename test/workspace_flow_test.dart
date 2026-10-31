import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:power9_office_routine/models/activity.dart';
import 'package:power9_office_routine/models/app_user.dart';
import 'package:power9_office_routine/models/completion.dart';
import 'package:power9_office_routine/models/schedule.dart';
import 'package:power9_office_routine/screens/activity_detail_screen.dart';
import 'package:power9_office_routine/services/completion_service.dart';
import 'package:power9_office_routine/theme/p9_theme.dart';
import 'package:power9_office_routine/viewmodels/activity_providers.dart';
import 'package:power9_office_routine/viewmodels/app_providers.dart';
import 'package:power9_office_routine/viewmodels/completion_providers.dart';

import 'auth_gate_test.dart' show EmptyScheduleService;

const desk = Activity(
  id: 'space-desk',
  title: 'Sắp xếp góc làm việc',
  groupId: 'space',
  groupName: 'Không gian',
  minutes: 5,
  purpose: 'Kiểm tra nơi làm việc',
  steps: ['Màn hình', 'Vật dụng', 'Lối đi'],
  note: 'Tự kiểm tra',
  rank: 6,
);

class RetryCompletionService implements CompletionService {
  int calls = 0;
  final sources = <CompletionSource>[];
  @override
  Stream<List<Completion>> watchDay(String uid, String dateKey) =>
      Stream.value([]);
  @override
  Future<void> record({
    required String uid,
    required Activity activity,
    required String dateKey,
    required CompletionSource source,
    int? durationSeconds,
  }) async {
    calls++;
    sources.add(source);
    if (calls == 1) throw Exception('offline');
  }

  @override
  Future<void> delete(String uid, String id) async {}
}

void main() {
  testWidgets(
    'checklist requires all items and preserves selections after failed save for retry',
    (tester) async {
      final service = RetryCompletionService();
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sessionProvider.overrideWith(
              (ref) => Stream.value(const AppUser(uid: 'alice')),
            ),
            currentDayProvider.overrideWith(
              (ref) => Stream.value('2026-11-01'),
            ),
            completionServiceProvider.overrideWithValue(service),
            scheduleServiceProvider.overrideWithValue(EmptyScheduleService()),
          ],
          child: MaterialApp(
            theme: P9Theme.light,
            home: const ActivityDetailScreen(activity: desk),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await tester.ensureVisible(find.text('Đã thực hiện'));
      await tester.tap(find.text('Đã thực hiện'));
      await tester.pumpAndSettle();
      expect(service.calls, 0);
      for (final label in desk.steps) {
        await tester.ensureVisible(find.text(label));
        await tester.tap(find.text(label));
        await tester.pump();
      }
      await tester.ensureVisible(find.text('Đã thực hiện'));
      await tester.tap(find.text('Đã thực hiện'));
      await tester.pumpAndSettle();
      expect(service.calls, 1);
      expect(find.text('Đã kiểm tra 3/3 mục'), findsOneWidget);
      expect(
        find.text('Chưa lưu được thay đổi. Bạn có thể thử lại.'),
        findsOneWidget,
      );
      await tester.ensureVisible(find.text('Thử lưu lại'));
      await tester.tap(find.text('Thử lưu lại'));
      await tester.pumpAndSettle();
      expect(service.calls, 2);
      expect(service.sources, everyElement(CompletionSource.checklist));
      expect(find.text('Tiến độ'), findsOneWidget);
    },
  );

  testWidgets('sleep scheduling cancel returns to recovery screen', (
    tester,
  ) async {
    const sleep = Activity(
      id: 'sleep-prepare',
      title: 'Chuẩn bị nghỉ tối',
      groupId: 'sleep',
      groupName: 'Ngủ & phục hồi',
      minutes: 5,
      purpose: 'Nghỉ tối',
      steps: ['Kết thúc công việc'],
      note: 'Không đo giấc ngủ',
      rank: 4,
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          currentDayProvider.overrideWith((ref) => Stream.value('2026-11-01')),
          daySchedulesProvider('2026-11-01').overrideWith(
            (ref) => Stream.value([
              const Schedule(
                id: 'sleep-prepare_2026-11-01',
                activityId: 'sleep-prepare',
                title: 'Chuẩn bị nghỉ tối',
                groupId: 'sleep',
                dateKey: '2026-11-01',
                minuteOfDay: 1290,
                reminderEnabled: false,
              ),
            ]),
          ),
        ],
        child: MaterialApp(
          theme: P9Theme.light,
          home: const ActivityDetailScreen(activity: sleep),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Đã đặt lịch hôm nay · 21:30'), findsOneWidget);
    await tester.ensureVisible(find.text('Đổi giờ nghỉ tối'));
    await tester.tap(find.text('Đổi giờ nghỉ tối'));
    await tester.pumpAndSettle();
    expect(find.text('21:30'), findsOneWidget);
    await tester.ensureVisible(find.text('Hủy'));
    await tester.tap(find.text('Hủy'));
    await tester.pumpAndSettle();
    expect(find.text('Ngủ & phục hồi'), findsOneWidget);
    expect(find.text('Đổi giờ nghỉ tối'), findsOneWidget);
  });
}
