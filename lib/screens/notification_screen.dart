import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:power9_core/power9_core.dart';

import '../services/firestore_client.dart';
import '../theme/p9_theme.dart';
import '../widgets/p9_page_layout.dart';
import '../viewmodels/app_providers.dart';
import '../viewmodels/notification_viewmodel.dart';
import '../widgets/p9_button.dart';

final _announcementsProvider = StreamProvider.autoDispose(
  (ref) => AnnouncementStore(createFirestoreClient()).watchLatest(),
);

class NotificationScreen extends ConsumerWidget {
  const NotificationScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final uid = ref.watch(sessionProvider).asData?.value?.uid;
    if (uid == null) return const SizedBox.shrink();
    final state = ref.watch(notificationControllerProvider(uid));
    final vm = ref.read(notificationControllerProvider(uid).notifier);
    return P9PageScaffold(
      appBar: AppBar(title: const Text('Thông báo')),
      body: RefreshIndicator(
        onRefresh: vm.refresh,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(P9Space.lg),
          children: [
            if (const bool.fromEnvironment('POWER9_ASSIGNMENT')) ...[
              Text(
                'Thông báo từ Admin',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: P9Space.md),
              ...ref
                  .watch(_announcementsProvider)
                  .when(
                    loading: () => const [
                      Center(child: CircularProgressIndicator()),
                    ],
                    error: (_, _) => [
                      TextButton(
                        onPressed: () => ref.invalidate(_announcementsProvider),
                        child: const Text('Chưa tải được thông báo. Thử lại'),
                      ),
                    ],
                    data: (items) => [
                      if (items.isEmpty)
                        const Text('Chưa có thông báo từ Admin.'),
                      for (final item in items)
                        Card(
                          child: ListTile(
                            title: Text(item.title),
                            subtitle: Text(item.body),
                          ),
                        ),
                    ],
                  ),
              const SizedBox(height: P9Space.xl),
            ],
            Text(
              state.status.enabled
                  ? 'Đã bật thông báo Power9'
                  : 'Nhận thông báo từ Power9',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: P9Space.md),
            const Text(
              'Thông báo được gửi từ hệ thống Power9. Giờ đã lưu trong lịch chưa tự tạo thông báo nhắc giờ.',
            ),
            const SizedBox(height: P9Space.md),
            P9Button(
              label: state.status.enabled
                  ? 'Kiểm tra kết nối thông báo'
                  : 'Bật thông báo',
              loading: state.loading,
              onPressed: vm.enable,
            ),
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: P9Space.md),
                child: Text(state.error!),
              ),
            const SizedBox(height: P9Space.xl),
            Text(
              'Lịch sử thông báo · ${state.unread} chưa đọc',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: P9Space.md),
            if (state.items.isEmpty)
              const Padding(
                padding: EdgeInsets.all(P9Space.lg),
                child: Text('Chưa có thông báo cho tài khoản này.'),
              ),
            for (final item in state.items)
              Card(
                child: ListTile(
                  contentPadding: const EdgeInsets.all(P9Space.lg),
                  leading: Icon(
                    item.read
                        ? Icons.notifications_none
                        : Icons.notifications_active,
                  ),
                  title: Text(item.title),
                  subtitle: Text('${item.body}\n${item.receivedAt.toLocal()}'),
                  onTap: () => vm.open(item),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
