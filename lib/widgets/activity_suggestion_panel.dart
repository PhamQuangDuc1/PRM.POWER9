import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:power9_core/power9_core.dart';

import '../models/activity.dart';
import '../screens/activity_detail_screen.dart';
import '../services/activity_suggestion_service.dart';
import '../services/telemetry_service.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../viewmodels/observability_providers.dart';

class ActivitySuggestionPanel extends ConsumerStatefulWidget {
  const ActivitySuggestionPanel({super.key});

  @override
  ConsumerState<ActivitySuggestionPanel> createState() =>
      _ActivitySuggestionPanelState();
}

class _ActivitySuggestionPanelState
    extends ConsumerState<ActivitySuggestionPanel> {
  String? _group;
  int _minutes = 5;
  bool _loading = false;
  String? _message;
  List<String> _ids = const [];

  List<Activity> _eligible(List<Activity> catalog, int limit) => catalog
      .where(
        (item) =>
            (_group == null || item.groupId == _group) &&
            item.minutes <= _minutes &&
            item.minutes <= limit,
      )
      .toList();

  void _clear() {
    _ids = const [];
    _message = null;
  }

  Future<void> _suggest(List<Activity> candidates) async {
    if (_loading) return;
    final config = ref.read(appConfigProvider).value;
    if (!config.aiEnabled || candidates.isEmpty) return;
    final telemetry = ref.read(telemetryProvider);
    setState(() {
      _clear();
      _loading = true;
    });
    unawaited(telemetry.event(AppEvent.aiRequest));
    try {
      final suggestions = await const ActivitySuggestionService()
          .suggest(config, candidates.take(30).toList())
          .timeout(const Duration(seconds: 20));
      if (!mounted) return;
      if (suggestions.isEmpty) {
        throw const FormatException('No eligible activities');
      }
      setState(() => _ids = suggestions.map((item) => item.id).toList());
    } catch (_) {
      unawaited(telemetry.event(AppEvent.aiError));
      if (mounted) {
        setState(
          () => _message = 'Tạm thời chưa có gợi ý AI. Bạn vẫn có thể tìm và lọc hoạt động bên dưới.',
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final config = ref.watch(appConfigProvider).value;
    final catalog =
        ref.watch(activitiesProvider).asData?.value ?? const <Activity>[];
    final candidates = _eligible(catalog, config.discoverMaxMinutes);
    final eligibleById = {for (final item in candidates) item.id: item};
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(P9Space.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: P9Space.md,
          children: [
            Text(
              'Gợi ý hoạt động bằng AI',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Text(
              'Chọn nhóm và thời gian bạn có. Bạn có thể đổi lựa chọn hoặc bỏ qua gợi ý.',
            ),
            DropdownButtonFormField<String>(
              initialValue: _group ?? '',
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Nhóm hoạt động'),
              items: [
                const DropdownMenuItem(value: '', child: Text('Tất cả nhóm')),
                for (final group in activityGroups.entries)
                  DropdownMenuItem(value: group.key, child: Text(group.value)),
              ],
              onChanged: _loading
                  ? null
                  : (value) => setState(() {
                      _group = value == '' ? null : value;
                      _clear();
                    }),
            ),
            Wrap(
              spacing: P9Space.sm,
              children: [
                for (final minutes in [3, 5, 10])
                  ChoiceChip(
                    label: Text('$minutes phút'),
                    selected: minutes == _minutes,
                    onSelected: _loading
                        ? null
                        : (_) => setState(() {
                            _minutes = minutes;
                            _clear();
                          }),
                  ),
              ],
            ),
            FilledButton(
              onPressed: _loading || candidates.isEmpty
                  ? null
                  : () => _suggest(candidates),
              child: Text(_loading ? 'Đang tìm gợi ý…' : 'Gợi ý bằng Gemini'),
            ),
            if (catalog.isNotEmpty && candidates.isEmpty)
              const Text(
                'Không có hoạt động phù hợp. Hãy đổi nhóm hoặc chọn thêm thời gian.',
              ),
            if (_message case final message?) Text(message),
            for (final id in _ids)
              if (eligibleById[id] case final activity?)
                OutlinedButton(
                  onPressed: () {
                    unawaited(
                      ref
                          .read(telemetryProvider)
                          .event(AppEvent.aiResultAccepted),
                    );
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) =>
                            ActivityDetailScreen(activity: activity),
                      ),
                    );
                  },
                  child: Text('${activity.title} · ${activity.minutes} phút'),
                ),
            if (_ids.isNotEmpty)
              TextButton(
                onPressed: () => setState(_clear),
                child: const Text('Bỏ gợi ý'),
              ),
          ],
        ),
      ),
    );
  }
}
