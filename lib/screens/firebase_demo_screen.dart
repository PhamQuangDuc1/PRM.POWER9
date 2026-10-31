import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/p9_theme.dart';
import '../viewmodels/observability_providers.dart';
import '../viewmodels/firebase_demo_viewmodel.dart';
import '../widgets/p9_button.dart';

class FirebaseDemoScreen extends ConsumerWidget {
  const FirebaseDemoScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!kDebugMode) return const SizedBox.shrink();
    final config = ref.watch(appConfigProvider);
    final crash = ref.watch(firebaseDemoProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Kiểm thử Firebase')),
      body: ListView(
        padding: const EdgeInsets.all(P9Space.lg),
        children: [
          Text('Remote Config', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: P9Space.md),
          Text('discover_max_minutes: ${config.value.discoverMaxMinutes}'),
          Text(
            'connection_checkin_enabled: ${config.value.connectionCheckinEnabled}',
          ),
          const SizedBox(height: P9Space.md),
          Text(
            config.fetchedAt == null
                ? 'Chưa xác nhận lần tải từ server; đang dùng mặc định hoặc cache.'
                : 'Lần tải thành công: ${config.fetchedAt!.toLocal()}',
          ),
          if (config.error != null) Text(config.error!),
          const SizedBox(height: P9Space.md),
          P9Button(
            label: 'Tải cấu hình mới',
            loading: config.loading,
            onPressed: () => ref.read(appConfigProvider.notifier).refresh(),
          ),
          const SizedBox(height: P9Space.xl),
          Text(
            'Analytics & Crashlytics',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: P9Space.md),
          const Text(
            'Sự kiện được gửi khi thao tác thật. Lỗi lưu được báo cáo sau khi đã xử lý; không gửi email, tên hoặc nội dung tìm kiếm.',
          ),
          const SizedBox(height: P9Space.md),
          const Text(
            'Cần kiểm tra DebugView và Crashlytics Console để xác nhận Firebase đã nhận dữ liệu.',
          ),
          const SizedBox(height: P9Space.lg),
          OutlinedButton.icon(
            icon: const Icon(Icons.bug_report_outlined),
            onPressed: crash.isLoading
                ? null
                : () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Tạo test crash?'),
                        content: const Text(
                          'Ứng dụng sẽ đóng để kiểm thử Crashlytics. Mở lại app sau đó để gửi báo cáo. Lịch đã lưu không bị xóa.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Hủy'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Tạo crash kiểm thử'),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      await ref.read(firebaseDemoProvider.notifier).crash();
                    }
                  },
            label: const Text('Test crash · chỉ bản debug'),
          ),
          if (crash.hasError)
            const Text('Chưa tạo được test crash. Vui lòng thử lại.'),
        ],
      ),
    );
  }
}
