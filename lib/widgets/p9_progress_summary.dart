import 'package:flutter/material.dart';

import '../models/today_overview.dart';
import '../theme/p9_theme.dart';

class P9ProgressSummary extends StatelessWidget {
  const P9ProgressSummary({super.key, required this.overview});
  final TodayOverview overview;
  @override
  Widget build(BuildContext context) => Card(
    color: P9Colors.card,
    elevation: 0,
    child: Padding(
      padding: const EdgeInsets.all(P9Space.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            overview.total == 0
                ? 'Bắt đầu từ một việc nhỏ'
                : '${overview.done}/${overview.total} hoạt động đã hoàn thành',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: P9Space.md),
          LinearProgressIndicator(
            value: overview.fraction,
            semanticsLabel:
                'Tiến độ: ${overview.done} trên ${overview.total} hoạt động đã chọn',
          ),
          const SizedBox(height: P9Space.md),
          const Text(
            'Tiến độ riêng tư của bạn. Không cần hoàn thành cả 9 nhóm mỗi ngày.',
          ),
        ],
      ),
    ),
  );
}
