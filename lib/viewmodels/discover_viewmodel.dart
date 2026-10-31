import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/activity.dart';
import 'activity_providers.dart';

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
  @override
  DiscoverFilter build() => const DiscoverFilter();
  void search(String query) =>
      state = DiscoverFilter(query: query, maxMinutes: state.maxMinutes);
  void filter(int? minutes) =>
      state = DiscoverFilter(query: state.query, maxMinutes: minutes);
  void reset() => state = const DiscoverFilter();
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
      return ref
          .watch(activitiesProvider)
          .whenData((items) => filterActivities(items, filter));
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
