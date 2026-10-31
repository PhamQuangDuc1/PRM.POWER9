import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../widgets/p9_activity_card.dart';
import '../widgets/p9_async_content.dart';
import 'activity_detail_screen.dart';

class ConnectionScreen extends ConsumerWidget {
  const ConnectionScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) => P9AsyncContent(
    value: ref.watch(groupActivitiesProvider('social')),
    retry: () => ref.invalidate(activitiesProvider),
    builder: (activities) => activities.isEmpty
        ? const P9Empty(message: 'Chưa có hoạt động kết nối.')
        : ListView(
            padding: const EdgeInsets.all(P9Space.lg),
            children: [
              Text('Kết nối', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: P9Space.md),
              const Text(
                'Một cuộc trò chuyện hoặc khoảng đi bộ ngắn, khi cả hai cùng muốn tham gia.',
              ),
              const SizedBox(height: P9Space.lg),
              for (final activity in activities)
                P9ActivityCard(
                  activity: activity,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ActivityDetailScreen(activity: activity),
                    ),
                  ),
                ),
              const SizedBox(height: P9Space.lg),
              const Text(
                'Hoàn toàn tự nguyện. Ứng dụng không tự gửi lời mời hoặc chia sẻ tiến độ của bạn.',
              ),
            ],
          ),
  );
}
