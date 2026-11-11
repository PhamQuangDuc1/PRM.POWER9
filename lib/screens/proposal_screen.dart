import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:power9_core/power9_core.dart';

import '../theme/p9_theme.dart';
import '../viewmodels/app_providers.dart';
import '../viewmodels/proposal_viewmodel.dart';
import '../widgets/p9_async_content.dart';
import '../widgets/p9_button.dart';
import '../widgets/p9_page_layout.dart';

class ProposalScreen extends ConsumerStatefulWidget {
  const ProposalScreen({super.key});

  @override
  ConsumerState<ProposalScreen> createState() => _ProposalScreenState();
}

class _ProposalScreenState extends ConsumerState<ProposalScreen> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _minutes = TextEditingController();
  final _description = TextEditingController();
  String _group = activityGroups.keys.first;

  @override
  void dispose() {
    _title.dispose();
    _minutes.dispose();
    _description.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uid = ref.watch(sessionProvider).asData?.value?.uid;
    final submission = ref.watch(proposalSubmissionProvider);
    return P9PageScaffold(
      appBar: AppBar(title: const Text('Đề xuất hoạt động')),
      body: uid == null
          ? const P9Empty(message: 'Đăng nhập để gửi đề xuất.')
          : ListView(
              padding: const EdgeInsets.all(P9Space.lg),
              children: [
                const Text(
                  'Bạn có thể nhập tiếng Việt có dấu. Hoạt động sẽ xuất hiện '
                  'trong Khám phá khi Admin duyệt và xuất bản.',
                ),
                const SizedBox(height: P9Space.lg),
                Form(
                  key: _form,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _title,
                        hintLocales: const [Locale('vi', 'VN')],
                        textCapitalization: TextCapitalization.sentences,
                        enabled: !submission.isLoading,
                        maxLength: 120,
                        decoration: const InputDecoration(
                          labelText: 'Tên hoạt động',
                        ),
                        validator: (value) => (value?.trim().length ?? 0) < 3
                            ? 'Nhập tên có ít nhất 3 ký tự.'
                            : null,
                      ),
                      DropdownButtonFormField<String>(
                        initialValue: _group,
                        decoration: const InputDecoration(
                          labelText: 'Nhóm thói quen',
                        ),
                        items: [
                          for (final group in activityGroups.entries)
                            DropdownMenuItem(
                              value: group.key,
                              child: Text(group.value),
                            ),
                        ],
                        onChanged: submission.isLoading
                            ? null
                            : (value) => setState(() => _group = value!),
                      ),
                      const SizedBox(height: P9Space.md),
                      TextFormField(
                        controller: _minutes,
                        enabled: !submission.isLoading,
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Thời lượng (phút)',
                        ),
                        validator: (value) {
                          final minutes = int.tryParse(value?.trim() ?? '');
                          return minutes == null || minutes < 1 || minutes > 60
                              ? 'Nhập số phút từ 1 đến 60.'
                              : null;
                        },
                      ),
                      const SizedBox(height: P9Space.md),
                      TextFormField(
                        controller: _description,
                        hintLocales: const [Locale('vi', 'VN')],
                        textCapitalization: TextCapitalization.sentences,
                        enabled: !submission.isLoading,
                        maxLines: 3,
                        maxLength: 1000,
                        decoration: const InputDecoration(
                          labelText: 'Mô tả ngắn',
                        ),
                        validator: (value) => (value?.trim().length ?? 0) < 5
                            ? 'Nhập mô tả có ít nhất 5 ký tự.'
                            : null,
                      ),
                      if (submission.hasError)
                        Semantics(
                          liveRegion: true,
                          child: const Text(
                            'Chưa gửi được đề xuất. Kiểm tra kết nối rồi thử lại.',
                          ),
                        ),
                      const SizedBox(height: P9Space.md),
                      P9Button(
                        label: 'Gửi đề xuất',
                        loading: submission.isLoading,
                        onPressed: () async {
                          if (!_form.currentState!.validate()) return;
                          final sent = await ref
                              .read(proposalSubmissionProvider.notifier)
                              .submit(
                                _title.text,
                                _group,
                                int.parse(_minutes.text.trim()),
                                _description.text,
                              );
                          if (!context.mounted || !sent) return;
                          _title.clear();
                          _minutes.clear();
                          _description.clear();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Đã gửi đề xuất để Admin duyệt.'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: P9Space.xl),
                Text(
                  'Đề xuất của tôi',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                P9AsyncContent(
                  value: ref.watch(myProposalsProvider(uid)),
                  retry: () => ref.invalidate(myProposalsProvider(uid)),
                  builder: (items) => items.isEmpty
                      ? const P9Empty(message: 'Bạn chưa gửi đề xuất nào.')
                      : Column(
                          children: [
                            for (final item in items)
                              ListTile(
                                title: Text(item.title),
                                subtitle: Text(
                                  [
                                    switch (item.status) {
                                      ProposalStatus.pending => 'Chờ duyệt',
                                      ProposalStatus.approved =>
                                        item.publishedActivityId == null
                                            ? 'Đã duyệt · Chờ xuất bản'
                                            : 'Đã xuất bản',
                                      ProposalStatus.rejected => 'Từ chối',
                                    },
                                    ?item.reason,
                                  ].join('\n'),
                                ),
                              ),
                          ],
                        ),
                ),
              ],
            ),
    );
  }
}
