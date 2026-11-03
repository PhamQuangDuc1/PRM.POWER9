import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../viewmodels/completion_providers.dart';
import '../viewmodels/report_viewmodel.dart';
import '../widgets/p9_async_content.dart';
import '../widgets/p9_button.dart';
import '../viewmodels/observability_providers.dart';

class ReportScreen extends ConsumerWidget {
  const ReportScreen({super.key, required this.day});
  final String day;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(reportControllerProvider(day));
    final vm = ref.read(reportControllerProvider(day).notifier);
    final cloudEnabled = ref.watch(appConfigProvider).value.reportUploadEnabled;
    return Scaffold(
      appBar: AppBar(title: const Text('Báo cáo PDF')),
      body: P9AsyncContent(
        value: ref.watch(todayOverviewProvider(day)),
        retry: () {
          ref.invalidate(daySchedulesProvider(day));
          ref.invalidate(dayCompletionsProvider(day));
        },
        builder: (overview) => ListView(
          padding: const EdgeInsets.all(P9Space.lg),
          children: [
            Text('Ngày $day', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: P9Space.md),
            Text(
              'Đã thực hiện ${overview.done}/${overview.total} hoạt động đã chọn.',
            ),
            const SizedBox(height: P9Space.md),
            const Text(
              'PDF lấy dữ liệu tại lúc tạo. Tạo lại nếu bạn vừa thay đổi lịch hoặc ghi nhận.',
            ),
            const SizedBox(height: P9Space.lg),
            P9Button(
              label: state.report == null ? 'Tạo PDF' : 'Tạo lại PDF',
              loading: state.operation == 'generate',
              onPressed: state.busy ? null : vm.generate,
            ),
            if (state.report case final report?) ...[
              const SizedBox(height: P9Space.lg),
              Text(report.fileName),
              Text(
                '${(report.bytes.length / 1024).ceil()} KB · ${report.itemCount} hoạt động trong bản PDF',
              ),
              const SizedBox(height: P9Space.md),
              OutlinedButton.icon(
                icon: const Icon(Icons.picture_as_pdf_outlined),
                onPressed: state.busy ? null : () => vm.present(),
                label: const Text('Xem / lưu PDF'),
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.share_outlined),
                onPressed: state.busy ? null : () => vm.present(share: true),
                label: const Text('Chia sẻ PDF'),
              ),
              const SizedBox(height: P9Space.lg),
              P9Button(
                label: 'Lưu lên đám mây',
                icon: Icons.cloud_upload_outlined,
                loading: state.operation == 'upload',
                loadingLabel: 'Đang tải lên…',
                onPressed: state.busy || !cloudEnabled ? null : vm.upload,
              ),
              if (!cloudEnabled)
                const Padding(
                  padding: EdgeInsets.only(top: P9Space.md),
                  child: Text(
                    'Lưu đám mây chưa được kích hoạt. Bạn vẫn có thể xem, lưu hoặc chia sẻ PDF trên thiết bị.',
                  ),
                ),
            ],
            if (state.operation == 'upload') ...[
              const SizedBox(height: P9Space.md),
              LinearProgressIndicator(value: state.progress),
              Text(
                '${(state.progress * 100).round()}% dữ liệu đã tải; đang xác nhận lưu báo cáo.',
              ),
            ],
            if (state.error != null)
              Padding(
                padding: const EdgeInsets.only(top: P9Space.lg),
                child: Semantics(liveRegion: true, child: Text(state.error!)),
              ),
            if (state.uploaded case final uploaded?) ...[
              const SizedBox(height: P9Space.lg),
              const Text('Đã lưu báo cáo lên đám mây.'),
              const Text(
                'Ai có liên kết này có thể mở PDF. Chỉ chia sẻ với người bạn muốn.',
              ),
              SelectableText(uploaded.url),
            ],
          ],
        ),
      ),
    );
  }
}
