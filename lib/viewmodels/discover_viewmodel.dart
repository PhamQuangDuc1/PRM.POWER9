import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import 'activity_providers.dart';
import 'observability_providers.dart';
import '../services/telemetry_service.dart';

import 'dart:async';

class DiscoverFilter {
  const DiscoverFilter({this.query = '', this.maxMinutes});
  final String query;
  final int? maxMinutes;
}

final discoverFilterProvider =
    NotifierProvider.autoDispose<DiscoverViewModel, DiscoverFilter>(
      DiscoverViewModel.new,
    );

class DiscoverViewModel extends Notifier<DiscoverFilter> {
  Timer? _searchTimer;
  @override
  DiscoverFilter build() {
    ref.onDispose(() => _searchTimer?.cancel());
    return const DiscoverFilter();
  }

  void search(String query) {
    state = DiscoverFilter(query: query, maxMinutes: state.maxMinutes);
    _searchTimer?.cancel();
    _searchTimer = Timer(const Duration(milliseconds: 600), () {
      if (!ref.mounted) return;
      unawaited(
        ref.read(telemetryProvider).event(AppEvent.search, {
          'query_length': query.trim().length,
          'has_query': query.trim().isEmpty ? 0 : 1,
          'max_minutes': state.maxMinutes ?? 60,
        }),
      );
    });
  }

  void filter(int? minutes) =>
      state = DiscoverFilter(query: state.query, maxMinutes: minutes);
  void reset() {
    _searchTimer?.cancel();
    state = const DiscoverFilter();
  }
}

List<Activity> filterActivities(
  List<Activity> activities,
  DiscoverFilter filter,
) {
  final query = filter.query.trim().toLowerCase();
  return activities
      .where(
        (item) =>
            (filter.maxMinutes == null || item.minutes <= filter.maxMinutes!) &&
            (query.isEmpty ||
                '${item.title} ${item.groupName}'.toLowerCase().contains(
                  query,
                )),
      )
      .toList();
}

final discoverResultsProvider =
    Provider.autoDispose<AsyncValue<List<Activity>>>((ref) {
      final filter = ref.watch(discoverFilterProvider);
      final cap = ref.watch(
        appConfigProvider.select((state) => state.value.discoverMaxMinutes),
      );
      final effectiveFilter = DiscoverFilter(
        query: filter.query,
        maxMinutes: filter.maxMinutes == null || filter.maxMinutes! > cap
            ? cap
            : filter.maxMinutes,
      );
      return ref
          .watch(activitiesProvider)
          .whenData((items) => filterActivities(items, effectiveFilter));
    });

final discoverGroupsProvider =
    Provider.autoDispose<AsyncValue<Map<String, List<Activity>>>>(
      (ref) => ref.watch(discoverResultsProvider).whenData((items) {
        final groups = <String, List<Activity>>{};
        for (final item in items) {
          (groups[item.groupName] ??= []).add(item);
        }
        return groups;
      }),
    );
