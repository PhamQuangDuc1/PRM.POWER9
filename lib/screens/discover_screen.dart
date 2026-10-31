import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../viewmodels/discover_viewmodel.dart';
import '../widgets/p9_activity_card.dart';
import '../widgets/p9_async_content.dart';
import 'activity_detail_screen.dart';
import '../viewmodels/observability_providers.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});
  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final _search = TextEditingController();
  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(discoverFilterProvider);
    final groups = ref.watch(discoverGroupsProvider);
    void reset() {
      _search.clear();
      ref.read(discoverFilterProvider.notifier).reset();
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Khám phá')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(P9Space.lg),
            child: TextField(
              controller: _search,
              onChanged: ref.read(discoverFilterProvider.notifier).search,
              textInputAction: TextInputAction.search,
              decoration: InputDecoration(
                labelText: 'Tìm hoạt động',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  onPressed: reset,
                  tooltip: 'Xóa tìm kiếm và bộ lọc',
                  icon: const Icon(Icons.close),
                ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: P9Space.lg),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                spacing: P9Space.sm,
                children: [
                  for (final option in <int?>[null, 5, 10])
                    ChoiceChip(
                      label: Text(option == null ? 'Tất cả' : '≤ $option phút'),
                      selected: filter.maxMinutes == option,
                      onSelected: (_) => ref
                          .read(discoverFilterProvider.notifier)
                          .filter(option),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: P9Space.sm),
          Expanded(
            child: P9AsyncContent(
              value: groups,
              retry: () => ref.invalidate(activitiesProvider),
              builder: (data) => data.isEmpty
                  ? P9Empty(
                      message: 'Không tìm thấy hoạt động phù hợp.',
                      icon: Icons.search_off,
                      actionLabel: 'Xóa bộ lọc',
                      action: reset,
                    )
                  : ListView(
                      padding: const EdgeInsets.all(P9Space.lg),
                      children: [
                        Text(
                          'Chọn hoạt động phù hợp với bạn',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: P9Space.lg),
                        if (ref
                                .watch(appConfigProvider)
                                .value
                                .discoverMaxMinutes <
                            60) ...[
                          Text(
                            'Danh mục hiện giới hạn hoạt động tối đa ${ref.watch(appConfigProvider).value.discoverMaxMinutes} phút.',
                          ),
                          const SizedBox(height: P9Space.md),
                        ],
                        for (final group in data.entries)
                          ExpansionTile(
                            key: PageStorageKey(group.key),
                            initiallyExpanded: true,
                            tilePadding: const EdgeInsets.symmetric(
                              horizontal: P9Space.sm,
                            ),
                            title: Text(
                              group.key,
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            children: [
                              for (final activity in group.value)
                                P9ActivityCard(
                                  activity: activity,
                                  onTap: () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                      builder: (_) => ActivityDetailScreen(
                                        activity: activity,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                      ],
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
