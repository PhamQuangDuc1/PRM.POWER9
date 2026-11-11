import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:power9_core/p9_theme.dart';
import 'package:power9_core/power9_core.dart';

import 'admin_service.dart';
import 'admin_workspace.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const emulator = bool.fromEnvironment('POWER9_USE_EMULATORS');
  const projectId = String.fromEnvironment(
    'POWER9_FIREBASE_PROJECT_ID',
    defaultValue: 'power9-office-se180724',
  );
  const apiKey = String.fromEnvironment('POWER9_FIREBASE_WEB_API_KEY');
  const appId = String.fromEnvironment('POWER9_FIREBASE_WEB_APP_ID');
  const appCheckKey = String.fromEnvironment('POWER9_WEB_APP_CHECK_SITE_KEY');
  const measurementId = String.fromEnvironment(
    'POWER9_FIREBASE_WEB_MEASUREMENT_ID',
  );
  const senderId = String.fromEnvironment(
    'POWER9_FIREBASE_MESSAGING_SENDER_ID',
  );
  if (!emulator && [apiKey, appId, senderId].any((value) => value.isEmpty)) {
    runApp(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: Text('Thiếu cấu hình Firebase Web. Xem web/README.md.'),
          ),
        ),
      ),
    );
    return;
  }
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: emulator ? 'demo-api-key' : apiKey,
      appId: emulator ? '1:123456789:web:0000000000000000' : appId,
      messagingSenderId: emulator ? '123456789' : senderId,
      measurementId: measurementId.isEmpty ? null : measurementId,
      projectId: emulator ? 'demo-power9' : projectId,
      authDomain: emulator
          ? 'demo-power9.firebaseapp.com'
          : '$projectId.firebaseapp.com',
    ),
  );
  if (!emulator && appCheckKey.isNotEmpty) {
    await FirebaseAppCheck.instance.activate(
      providerWeb: ReCaptchaEnterpriseProvider(appCheckKey),
    );
  }
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  if (emulator) {
    await auth.useAuthEmulator('127.0.0.1', 9099);
    db.useFirestoreEmulator('127.0.0.1', 8080);
  }
  runApp(
    MaterialApp(
      title: 'Power9 Admin',
      debugShowCheckedModeBanner: false,
      theme: P9Theme.light,
      home: AdminScreen(
        service: AdminService(
          auth,
          db,
          emulator ? null : FirebaseAnalytics.instance,
        ),
        announcementEnabled: emulator
            ? Future.value(true)
            : _loadAnnouncementAvailability(),
      ),
    ),
  );
}

Future<bool> _loadAnnouncementAvailability() async {
  try {
    final config = FirebaseRemoteConfig.instance;
    await config.setDefaults({'admin_announcements_enabled': true});
    await config.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: const Duration(seconds: 5),
        minimumFetchInterval: const Duration(hours: 1),
      ),
    );
    await config.fetchAndActivate();
    return config.getBool('admin_announcements_enabled');
  } catch (_) {
    return true;
  }
}

class AdminScreen extends StatefulWidget {
  const AdminScreen({
    super.key,
    required this.service,
    required this.announcementEnabled,
  });
  final AdminService service;
  final Future<bool> announcementEnabled;

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late final _session = widget.service.session;
  bool _signingIn = false;

  Future<void> _signIn() async {
    setState(() => _signingIn = true);
    try {
      await widget.service.signIn();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Chưa đăng nhập được. Vui lòng thử lại.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _signingIn = false);
    }
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<String?>(
    stream: _session,
    builder: (context, snapshot) {
      final viewport = MediaQuery.sizeOf(context);
      final compactHeader = viewport.width < 380 * adminTextScale(context);
      return Scaffold(
        appBar: AppBar(
          toolbarHeight: viewport.height < 520 ? 48 : null,
          backgroundColor: P9Colors.card,
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/power9-logo-3d.png',
                width: compactHeader ? 28 : 36,
                height: compactHeader ? 28 : 36,
                excludeFromSemantics: true,
              ),
              const SizedBox(width: P9Space.md),
              const Flexible(
                child: Text('Power9 Admin', overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          actions: [
            if (snapshot.hasData && compactHeader)
              IconButton(
                tooltip: 'Đăng xuất',
                onPressed: widget.service.signOut,
                icon: const Icon(Icons.logout),
              )
            else if (snapshot.hasData)
              TextButton.icon(
                onPressed: widget.service.signOut,
                icon: const Icon(Icons.logout),
                label: const Text('Đăng xuất'),
              ),
            const SizedBox(width: P9Space.sm),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.only(
            bottom: const bool.fromEnvironment('POWER9_USE_EMULATORS')
                ? (viewport.width < 600 ? 52 : 24)
                : 0,
          ),
          child: switch (snapshot) {
            AsyncSnapshot(hasError: true) => const Center(
              child: Text('Không kiểm tra được phiên.'),
            ),
            AsyncSnapshot(connectionState: ConnectionState.waiting) =>
              const Center(child: CircularProgressIndicator()),
            AsyncSnapshot(data: final String uid) => AdminWorkspace(
              key: ValueKey(uid),
              service: widget.service,
              uid: uid,
              announcementEnabled: widget.announcementEnabled,
              review: ReviewQueue(service: widget.service, uid: uid),
            ),
            _ => _signInCard(context),
          },
        ),
      );
    },
  );

  Widget _signInCard(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(P9Space.lg),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(
              MediaQuery.sizeOf(context).width < 480 ? P9Space.lg : P9Space.xxl,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/power9-logo-3d.png',
                  width: 80,
                  height: 80,
                  excludeFromSemantics: true,
                ),
                const SizedBox(height: P9Space.lg),
                Text(
                  'Cổng quản trị Power9',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: P9Space.md),
                const Text(
                  'Quản lý hoạt động, xử lý đề xuất và gửi thông báo cho người dùng Power9.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: P9Space.xl),
                FilledButton(
                  onPressed: _signingIn ? null : _signIn,
                  child: Text(
                    _signingIn ? 'Đang đăng nhập…' : 'Đăng nhập với Google',
                  ),
                ),
                const SizedBox(height: P9Space.md),
                const Text(
                  'Dành cho tài khoản có quyền quản trị.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: P9Colors.secondaryText),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class ReviewQueue extends StatefulWidget {
  const ReviewQueue({super.key, required this.service, required this.uid});
  final AdminService service;
  final String uid;

  @override
  State<ReviewQueue> createState() => _ReviewQueueState();
}

class _ReviewQueueState extends State<ReviewQueue> {
  late final _pending = widget.service.proposals.watchPending();
  late final _decided = widget.service.proposals.watchDecided();
  bool _reviewing = false;
  bool _readyToPublishOnly = false;

  Future<void> _publish(ActivityProposal item) async {
    if (_reviewing) return;
    setState(() => _reviewing = true);
    try {
      await widget.service.proposals.publish(item);
      if (mounted) _feedback('Đã đưa hoạt động vào Khám phá.');
    } catch (_) {
      if (mounted) _feedback('Chưa xuất bản được. Vui lòng thử lại.');
    } finally {
      if (mounted) setState(() => _reviewing = false);
    }
  }

  Future<void> _review(ActivityProposal item, ProposalStatus status) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (_) => ReasonDialog(status: status),
    );
    if (!mounted || reason == null || _reviewing) return;
    setState(() => _reviewing = true);
    try {
      await widget.service.proposals.decide(
        id: item.id,
        reviewerUid: widget.uid,
        status: status,
        reason: reason,
      );
      if (mounted) _feedback('Đã lưu kết quả duyệt.');
    } catch (_) {
      if (mounted) {
        _feedback('Chưa lưu được. Kiểm tra mạng và trạng thái đề xuất.');
      }
    } finally {
      if (mounted) setState(() => _reviewing = false);
    }
  }

  void _feedback(String message) =>
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));

  @override
  Widget build(BuildContext context) => AdminPage(
    children: [
      const AdminHeading(
        title: 'Duyệt đề xuất',
        description: 'Xử lý đề xuất từ app. Xuất bản các mục đã duyệt để đưa vào Khám phá.',
      ),
      const SizedBox(height: P9Space.xl),
      Text('Hàng đợi duyệt', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: P9Space.md),
      AdminFeed(
        stream: _pending,
        builder: (items) => items.isEmpty
            ? const Card(
                child: ListTile(
                  contentPadding: EdgeInsets.all(P9Space.lg),
                  leading: AdminIcon(Icons.inbox_outlined),
                  title: Text('Không có đề xuất chờ duyệt.'),
                  subtitle: Text(
                    'Đề xuất mới từ Android sẽ xuất hiện tại đây.',
                  ),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final item in items)
                    _proposalCard(
                      item,
                      actions: [
                        OutlinedButton.icon(
                          onPressed: _reviewing
                              ? null
                              : () => _review(item, ProposalStatus.approved),
                          icon: const Icon(Icons.check),
                          label: const Text('Duyệt'),
                        ),
                        TextButton(
                          onPressed: _reviewing
                              ? null
                              : () => _review(item, ProposalStatus.rejected),
                          child: const Text('Từ chối'),
                        ),
                      ],
                    ),
                ],
              ),
      ),
      const SizedBox(height: P9Space.xl),
      Text('Lịch sử xử lý', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: P9Space.md),
      Wrap(
        spacing: P9Space.sm,
        runSpacing: P9Space.sm,
        children: [
          ChoiceChip(
            label: const Text('Tất cả kết quả'),
            selected: !_readyToPublishOnly,
            onSelected: (_) => setState(() => _readyToPublishOnly = false),
          ),
          ChoiceChip(
            label: const Text('Chờ xuất bản'),
            selected: _readyToPublishOnly,
            onSelected: (_) => setState(() => _readyToPublishOnly = true),
          ),
        ],
      ),
      const SizedBox(height: P9Space.md),
      AdminFeed(
        stream: _decided,
        builder: (items) {
          final visible = _readyToPublishOnly
              ? items.where(
                  (item) =>
                      item.status == ProposalStatus.approved &&
                      item.publishedActivityId == null,
                )
              : items;
          if (visible.isEmpty) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(P9Space.lg),
                child: Text(
                  _readyToPublishOnly
                      ? 'Không có đề xuất chờ xuất bản.'
                      : 'Chưa có đề xuất đã xử lý.',
                ),
              ),
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final item in visible)
                _proposalCard(
                  item,
                  actions: [
                    if (item.status == ProposalStatus.rejected)
                      const Chip(label: Text('Từ chối'))
                    else if (item.publishedActivityId != null)
                      const Chip(
                        label: Text('Đã xuất bản'),
                        avatar: Icon(Icons.check_circle_outline),
                      )
                    else ...[
                      const Chip(label: Text('Chờ xuất bản')),
                      OutlinedButton.icon(
                        onPressed: _reviewing ? null : () => _publish(item),
                        icon: const Icon(Icons.publish),
                        label: const Text('Xuất bản'),
                      ),
                    ],
                  ],
                ),
            ],
          );
        },
      ),
    ],
  );

  Widget _proposalCard(
    ActivityProposal item, {
    required List<Widget> actions,
  }) => Card(
    child: Padding(
      padding: const EdgeInsets.all(P9Space.lg),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final wide = constraints.maxWidth >= 660 * adminTextScale(context);
          final details = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(item.title, style: Theme.of(context).textTheme.titleLarge),
              Text(
                '${activityGroups[item.groupId] ?? item.groupId} · ${item.minutes} phút',
                style: const TextStyle(color: P9Colors.secondaryText),
              ),
              const SizedBox(height: P9Space.sm),
              Text(item.description),
              if (item.reason case final reason?) ...[
                const SizedBox(height: P9Space.sm),
                Text(
                  'Lý do: $reason',
                  style: const TextStyle(color: P9Colors.secondaryText),
                ),
              ],
            ],
          );
          final controls = Wrap(
            spacing: P9Space.sm,
            runSpacing: P9Space.sm,
            alignment: wide ? WrapAlignment.end : WrapAlignment.start,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: actions,
          );
          if (wide) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: details),
                const SizedBox(width: P9Space.xl),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: constraints.maxWidth * .4,
                  ),
                  child: controls,
                ),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              details,
              const SizedBox(height: P9Space.md),
              controls,
            ],
          );
        },
      ),
    ),
  );
}

class ReasonDialog extends StatefulWidget {
  const ReasonDialog({super.key, required this.status});
  final ProposalStatus status;

  @override
  State<ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<ReasonDialog> {
  final _form = GlobalKey<FormState>();
  String _reason = '';

  @override
  Widget build(BuildContext context) => AlertDialog(
    insetPadding: adminDialogInsets(context),
    actionsOverflowButtonSpacing: P9Space.sm,
    title: Text(
      widget.status == ProposalStatus.approved
          ? 'Duyệt đề xuất'
          : 'Từ chối đề xuất',
    ),
    scrollable: true,
    content: Form(
      key: _form,
      child: TextFormField(
        autofocus: true,
        maxLines: 3,
        maxLength: 500,
        decoration: const InputDecoration(labelText: 'Lý do'),
        onChanged: (value) => _reason = value.trim(),
        validator: (_) => _reason.length < 3 ? 'Nhập ít nhất 3 ký tự.' : null,
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Hủy'),
      ),
      TextButton(
        onPressed: () {
          if (_form.currentState!.validate()) Navigator.pop(context, _reason);
        },
        child: const Text('Lưu kết quả'),
      ),
    ],
  );
}
