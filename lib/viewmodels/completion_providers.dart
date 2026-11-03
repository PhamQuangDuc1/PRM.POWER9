import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/completion.dart';
import '../models/today_overview.dart';
import '../services/completion_service.dart';
import '../services/firestore_completion_service.dart';
import '../services/firestore_client.dart';
import 'activity_providers.dart';
import 'app_providers.dart';

final completionServiceProvider = Provider<CompletionService>(
  (ref) => FirestoreCompletionService(createFirestoreClient()),
);
final dayCompletionsProvider = StreamProvider.autoDispose
    .family<List<Completion>, String>((ref, day) {
      final user = ref.watch(sessionProvider).asData?.value;
      return user == null
          ? Stream.value([])
          : ref.watch(completionServiceProvider).watchDay(user.uid, day);
    });
final completionForActivityProvider = Provider.autoDispose
    .family<AsyncValue<Completion?>, ({String activityId, String dateKey})>(
      (ref, key) =>
          ref.watch(dayCompletionsProvider(key.dateKey)).whenData((records) {
            for (final record in records) {
              if (record.activityId == key.activityId) return record;
            }
            return null;
          }),
    );
final todayOverviewProvider = Provider.autoDispose
    .family<AsyncValue<TodayOverview>, String>((ref, day) {
      final schedules = ref.watch(daySchedulesProvider(day));
      final records = ref.watch(dayCompletionsProvider(day));
      if (schedules.hasError) {
        return AsyncError(schedules.error!, schedules.stackTrace!);
      }
      if (records.hasError) {
        return AsyncError(records.error!, records.stackTrace!);
      }
      final plans = schedules.asData?.value;
      final completions = records.asData?.value;
      if (plans == null || completions == null) return const AsyncLoading();
      return AsyncData(buildOverview(plans, completions));
    });
