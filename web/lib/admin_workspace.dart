import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:power9_core/p9_theme.dart';
import 'package:power9_core/power9_core.dart';

import 'admin_service.dart';

typedef CatalogItem = QueryDocumentSnapshot<Map<String, dynamic>>;
const _fixedTabActivities = {'eat-lunch', 'stress-break'};

class AdminWorkspace extends StatefulWidget {
  const AdminWorkspace({
    super.key,
    required this.service,
    required this.uid,
    required this.review,
    required this.announcementEnabled,
  });
  final AdminService service;
  final String uid;
  final Widget review;
  final Future<bool> announcementEnabled;

  @override
  State<AdminWorkspace> createState() => _AdminWorkspaceState();
}

class _AdminWorkspaceState extends State<AdminWorkspace> {
  static const _sections = [
    (label: 'Tổng quan', icon: Icons.space_dashboard_outlined),
    (label: 'Danh mục', icon: Icons.view_list_outlined),
    (label: 'Duyệt đề xuất', icon: Icons.fact_check_outlined),
    (label: 'Thông báo', icon: Icons.campaign_outlined),
  ];
  late final _role = widget.service.watchAdmin(widget.uid);
  final _pageKey = GlobalKey();
  late var _metrics = widget.service.loadDashboard();
  int _selected = 0;

  void _select(int index) => setState(() {
    if (index == 0 && _selected != 0) {
      _metrics = widget.service.loadDashboard();
    }
    _selected = index;
  });

  void _refreshDashboard() => setState(() {
    _metrics = widget.service.loadDashboard();
  });

  @override
  Widget build(BuildContext context) => StreamBuilder<bool>(
    stream: _role,
    builder: (context, role) {
      if (role.hasError) {
        return const AdminNotice(
          icon: Icons.cloud_off_outlined,
          title: 'Chưa xác minh được quyền Admin.',
          message: 'Kiểm tra kết nối rồi tải lại trang.',
        );
      }
      if (!role.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      if (role.data != true) {
        return const AdminNotice(
          icon: Icons.lock_outline,
          title: 'Tài khoản này chưa có quyền Admin.',
          message: 'Đăng xuất rồi đăng nhập bằng tài khoản quản trị Power9.',
        );
      }
      return LayoutBuilder(
        builder: (context, constraints) {
          final page = KeyedSubtree(
            key: _pageKey,
            child: switch (_selected) {
              0 => _dashboard(context),
              1 => CatalogPanel(service: widget.service),
              2 => widget.review,
              _ => _announcement(),
            },
          );
          final shortWindow = constraints.maxHeight < 430;
          if (constraints.maxWidth >= 960) {
            return Row(
              children: [
                SizedBox(
                  width: 224,
                  child: Material(
                    color: P9Colors.card,
                    child: ListView(
                      padding: const EdgeInsets.all(P9Space.lg),
                      children: [
                        const Padding(
                          padding: EdgeInsets.fromLTRB(
                            P9Space.md,
                            P9Space.sm,
                            0,
                            P9Space.lg,
                          ),
                          child: Text(
                            'QUẢN TRỊ',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1,
                              color: P9Colors.secondaryText,
                            ),
                          ),
                        ),
                        for (final (index, section) in _sections.indexed)
                          Padding(
                            padding: const EdgeInsets.only(bottom: P9Space.sm),
                            child: ListTile(
                              minTileHeight: 48,
                              horizontalTitleGap: P9Space.md,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: P9Space.md,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  P9Size.controlRadius,
                                ),
                              ),
                              selected: _selected == index,
                              selectedColor: P9Colors.primaryStrong,
                              selectedTileColor: P9Colors.surfaceContainer,
                              leading: Icon(section.icon, size: 20),
                              title: Text(
                                section.label,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: _selected == index
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
                              onTap: () => _select(index),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const VerticalDivider(
                  width: 1,
                  color: P9Colors.surfaceContainer,
                ),
                Expanded(child: page),
              ],
            );
          }
          if (constraints.maxWidth >= 700 || shortWindow) {
            return Row(
              children: [
                NavigationRail(
                  backgroundColor: P9Colors.card,
                  selectedIndex: _selected,
                  onDestinationSelected: _select,
                  minWidth: 64,
                  scrollable: true,
                  labelType: NavigationRailLabelType.none,
                  destinations: [
                    for (final section in _sections)
                      NavigationRailDestination(
                        icon: Tooltip(
                          message: section.label,
                          child: Icon(section.icon),
                        ),
                        label: Text(section.label),
                      ),
                  ],
                ),
                const VerticalDivider(
                  width: 1,
                  color: P9Colors.surfaceContainer,
                ),
                Expanded(child: page),
              ],
            );
          }
          return Column(
            children: [
              Expanded(child: page),
              NavigationBar(
                height: 64,
                selectedIndex: _selected,
                onDestinationSelected: _select,
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                destinations: [
                  for (final section in _sections)
                    NavigationDestination(
                      icon: Icon(section.icon),
                      label: section.label,
                    ),
                ],
              ),
            ],
          );
        },
      );
    },
  );

  Widget _announcement() => FutureBuilder<bool>(
    future: widget.announcementEnabled,
    builder: (context, enabled) {
      if (!enabled.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      if (enabled.data == false) {
        return const AdminNotice(
          icon: Icons.notifications_off_outlined,
          title: 'Gửi thông báo đang tạm tắt.',
          message: 'Có thể bật lại form từ Remote Config.',
        );
      }
      return AnnouncementPanel(store: widget.service.announcements);
    },
  );

  Widget _dashboard(BuildContext context) => FutureBuilder(
    future: _metrics,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(
          child: CircularProgressIndicator(semanticsLabel: 'Đang tải thống kê'),
        );
      }
      if (snapshot.hasError) {
        return Center(
          child: TextButton(
            onPressed: _refreshDashboard,
            child: const Text('Chưa tải được thống kê. Thử lại'),
          ),
        );
      }
      final metrics = snapshot.requireData;
      final total = metrics.proposals.fold<int>(
        0,
        (totalSoFar, value) => totalSoFar + value,
      );
      const labels = ['Chờ duyệt', 'Đã duyệt', 'Từ chối'];
      return AdminPage(
        children: [
          AdminHeading(
            title: 'Tổng quan',
            description: 'Theo dõi danh mục và tình trạng xử lý đề xuất.',
            action: OutlinedButton.icon(
              onPressed: _refreshDashboard,
              icon: const Icon(Icons.refresh),
              label: const Text('Cập nhật số liệu'),
            ),
          ),
          const SizedBox(height: P9Space.lg),
          LayoutBuilder(
            builder: (context, layout) {
              final width = layout.maxWidth >= 630 * adminTextScale(context)
                  ? (layout.maxWidth - P9Space.lg * 2) / 3
                  : layout.maxWidth;
              return Wrap(
                spacing: P9Space.lg,
                children: [
                  for (final metric in [
                    (
                      label: 'Hoạt động đang hiển thị',
                      value: metrics.published,
                      icon: Icons.visibility_outlined,
                    ),
                    (
                      label: 'Hoạt động lưu trữ',
                      value: metrics.archived,
                      icon: Icons.archive_outlined,
                    ),
                    (
                      label: 'Đề xuất chờ duyệt',
                      value: metrics.proposals.first,
                      icon: Icons.pending_actions_outlined,
                    ),
                  ])
                    SizedBox(
                      width: width,
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(P9Space.lg),
                          child: Row(
                            children: [
                              AdminIcon(metric.icon),
                              const SizedBox(width: P9Space.md),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${metric.value}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineSmall,
                                    ),
                                    Text(metric.label),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
          const SizedBox(height: P9Space.md),
          Card(
            color: P9Colors.surfaceLow,
            child: Padding(
              padding: const EdgeInsets.all(P9Space.lg),
              child: AdminHeading(
                title: 'Hàng đợi duyệt',
                description: metrics.proposals.first == 0
                    ? 'Bạn đã xử lý hết đề xuất đang chờ.'
                    : 'Có ${metrics.proposals.first} đề xuất cần bạn xem xét.',
                action: OutlinedButton.icon(
                  onPressed: () => _select(2),
                  icon: const Icon(Icons.arrow_forward),
                  label: const Text('Mở hàng đợi'),
                ),
              ),
            ),
          ),
          const SizedBox(height: P9Space.md),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(P9Space.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Đề xuất theo trạng thái',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Text(
                    total == 0
                        ? 'Chưa có đề xuất để tổng hợp.'
                        : '$total đề xuất đã ghi nhận',
                  ),
                  for (final (index, count) in metrics.proposals.indexed) ...[
                    const SizedBox(height: P9Space.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(labels[index]),
                        Text(
                          '$count',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: P9Space.sm),
                    LinearProgressIndicator(
                      semanticsLabel: labels[index],
                      value: total == 0 ? 0 : count / total,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      );
    },
  );
}

class AdminFeed<T> extends StatelessWidget {
  const AdminFeed({super.key, required this.stream, required this.builder});
  final Stream<T> stream;
  final Widget Function(T data) builder;

  @override
  Widget build(BuildContext context) => StreamBuilder<T>(
    stream: stream,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Center(
          child: Text('Chưa tải được dữ liệu. Kiểm tra kết nối rồi tải lại.'),
        );
      }
      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }
      return builder(snapshot.data as T);
    },
  );
}

class AdminPage extends StatelessWidget {
  const AdminPage({super.key, required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Scrollbar(
          child: ListView(
            padding: EdgeInsets.all(
              constraints.maxWidth >= 960
                  ? P9Space.xxl
                  : constraints.maxWidth >= 600
                  ? P9Space.xl
                  : P9Space.lg,
            ),
            children: children,
          ),
        ),
      ),
    ),
  );
}

class AdminHeading extends StatelessWidget {
  const AdminHeading({
    super.key,
    required this.title,
    required this.description,
    this.action,
  });
  final String title;
  final String description;
  final Widget? action;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final heading = Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium
                ?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: P9Space.sm),
          Text(
            description,
            style: const TextStyle(color: P9Colors.secondaryText),
          ),
        ],
      );
      final control = action;
      if (control == null) return heading;
      if (constraints.maxWidth >= 620 * adminTextScale(context)) {
        return Row(
          children: [
            Expanded(child: heading),
            const SizedBox(width: P9Space.lg),
            control,
          ],
        );
      }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heading,
          const SizedBox(height: P9Space.lg),
          control,
        ],
      );
    },
  );
}

class AdminIcon extends StatelessWidget {
  const AdminIcon(this.icon, {super.key});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(P9Space.md),
    decoration: BoxDecoration(
      color: P9Colors.surfaceContainer,
      borderRadius: BorderRadius.circular(P9Size.controlRadius),
    ),
    child: Icon(icon, color: P9Colors.primaryStrong),
  );
}

class AdminNotice extends StatelessWidget {
  const AdminNotice({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
  });
  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 460),
        child: Card(
          margin: const EdgeInsets.all(P9Space.lg),
          child: Padding(
            padding: const EdgeInsets.all(P9Space.xl),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AdminIcon(icon),
                const SizedBox(height: P9Space.md),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: P9Space.sm),
                Text(message, textAlign: TextAlign.center),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

double adminTextScale(BuildContext context) =>
    MediaQuery.textScalerOf(context).scale(14) / 14;

EdgeInsets adminDialogInsets(BuildContext context) {
  final viewport = MediaQuery.sizeOf(context);
  return EdgeInsets.symmetric(
    horizontal: viewport.width < 480 ? P9Space.md : P9Space.xl,
    vertical: viewport.height < 520 ? P9Space.sm : P9Space.xl,
  );
}

class CatalogPanel extends StatefulWidget {
  const CatalogPanel({super.key, required this.service});
  final AdminService service;

  @override
  State<CatalogPanel> createState() => _CatalogPanelState();
}

class _CatalogPanelState extends State<CatalogPanel> {
  late final _catalog = widget.service.watchCatalog();
  String _filter = '';
  bool? _publishedFilter;
  bool _saving = false;

  Future<void> _save(Future<void> Function() action, String message) async {
    setState(() => _saving = true);
    try {
      await action();
    } catch (_) {
      message = 'Chưa lưu được thay đổi. Vui lòng thử lại.';
    } finally {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(message)));
      }
    }
  }

  Future<void> _edit([CatalogItem? item]) async {
    final data = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => ActivityEditor(item: item?.data()),
    );
    if (mounted && data != null && !_saving) {
      await _save(
        () => widget.service.saveActivity(item?.id, data),
        'Đã lưu hoạt động.',
      );
    }
  }

  @override
  Widget build(BuildContext context) => AdminFeed(
    stream: _catalog,
    builder: (catalog) {
      final items =
          catalog
              .where(
                (item) =>
                    (_publishedFilter == null ||
                        item.data()['published'] == _publishedFilter) &&
                    (item.data()['title'] as String).toLowerCase().contains(
                      _filter,
                    ),
              )
              .toList()
            ..sort(
              (a, b) => (a.data()['title'] as String).compareTo(
                b.data()['title'] as String,
              ),
            );
      return AdminPage(
        children: [
          AdminHeading(
            title: 'Quản lý danh mục',
            description:
                '${catalog.length} hoạt động. Các mục đang hiển thị xuất hiện trong Khám phá trên app.',
            action: FilledButton.icon(
              style: FilledButton.styleFrom(
                minimumSize: const Size(48, P9Size.buttonHeight),
              ),
              onPressed: _saving ? null : _edit,
              icon: const Icon(Icons.add),
              label: const Text('Tạo hoạt động'),
            ),
          ),
          const SizedBox(height: P9Space.md),
          TextField(
            decoration: const InputDecoration(
              labelText: 'Tìm theo tên hoạt động',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: (value) =>
                setState(() => _filter = value.trim().toLowerCase()),
          ),
          const SizedBox(height: P9Space.md),
          Wrap(
            spacing: P9Space.sm,
            runSpacing: P9Space.sm,
            children: [
              for (final (label, status) in <(String, bool?)>[
                ('Tất cả', null),
                ('Đang hiển thị', true),
                ('Đã lưu trữ', false),
              ])
                ChoiceChip(
                  label: Text(label),
                  selected: _publishedFilter == status,
                  onSelected: (_) => setState(() => _publishedFilter = status),
                ),
            ],
          ),
          const SizedBox(height: P9Space.md),
          if (items.isNotEmpty) Text('${items.length} kết quả'),
          const SizedBox(height: P9Space.sm),
          if (items.isEmpty)
            AdminNotice(
              icon: Icons.search_off,
              title: catalog.isEmpty
                  ? 'Danh mục đang trống.'
                  : 'Không tìm thấy hoạt động.',
              message: catalog.isEmpty
                  ? 'Tạo hoạt động đầu tiên để đưa vào Khám phá.'
                  : 'Thử đổi từ khóa hoặc bộ lọc trạng thái.',
            )
          else
            LayoutBuilder(
              builder: (context, layout) =>
                  layout.maxWidth >= 750 * adminTextScale(context)
                  ? _table(context, items)
                  : Column(
                      children: [
                        for (final item in items) _compactRow(context, item),
                      ],
                    ),
            ),
        ],
      );
    },
  );

  Widget _table(BuildContext context, List<CatalogItem> items) => Card(
    clipBehavior: Clip.antiAlias,
    child: Table(
      columnWidths: const {
        0: FlexColumnWidth(2.6),
        1: FlexColumnWidth(1.45),
        2: FlexColumnWidth(1.15),
        3: FlexColumnWidth(1.5),
        4: FlexColumnWidth(2.3),
      },
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      border: const TableBorder(
        horizontalInside: BorderSide(color: P9Colors.surfaceContainer),
      ),
      children: [
        TableRow(
          decoration: const BoxDecoration(color: P9Colors.surfaceLow),
          children: [
            for (final (label, alignment) in const [
              ('Hoạt động', Alignment.centerLeft),
              ('Nhóm thói quen', Alignment.centerLeft),
              ('Thời lượng', Alignment.centerRight),
              ('Trạng thái', Alignment.centerLeft),
              ('Thao tác', Alignment.centerRight),
            ])
              _cell(
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
                alignment: alignment,
              ),
          ],
        ),
        for (final item in items)
          TableRow(
            children: [
              _cell(
                Text(
                  item.data()['title'] as String,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              _cell(Text(item.data()['groupName'] as String)),
              _cell(
                Text('${item.data()['minutes']} phút'),
                alignment: Alignment.centerRight,
              ),
              _cell(_status(item)),
              _cell(_actions(item), alignment: Alignment.centerRight),
            ],
          ),
      ],
    ),
  );

  Widget _cell(Widget child, {Alignment alignment = Alignment.centerLeft}) =>
      Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: P9Space.md,
          vertical: P9Space.sm,
        ),
        child: Align(alignment: alignment, child: child),
      );

  Widget _compactRow(BuildContext context, CatalogItem item) => Card(
    child: Padding(
      padding: const EdgeInsets.all(P9Space.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.data()['title'] as String,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          Wrap(
            spacing: P9Space.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Text(
                '${item.data()['groupName']} · ${item.data()['minutes']} phút',
              ),
              _status(item),
            ],
          ),
          _actions(item),
        ],
      ),
    ),
  );

  Widget _status(CatalogItem item) {
    final published = item.data()['published'] == true;
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: published
          ? P9Colors.surfaceContainer
          : P9Colors.surfaceLow,
      side: BorderSide.none,
      label: Text(published ? 'Đang hiển thị' : 'Đã lưu trữ'),
    );
  }

  Widget _actions(CatalogItem item) {
    final published = item.data()['published'] == true;
    return Wrap(
      alignment: WrapAlignment.end,
      children: [
        TextButton(
          onPressed: _saving ? null : () => _edit(item),
          child: const Text('Sửa'),
        ),
        if (_fixedTabActivities.contains(item.id))
          const Tooltip(
            message: 'Hoạt động này được mở từ một tab chính của app.',
            child: TextButton(onPressed: null, child: Text('Mục cố định')),
          )
        else
          TextButton(
            onPressed: _saving
                ? null
                : () => _save(
                    () => widget.service.setPublished(item.id, !published),
                    published
                        ? 'Đã lưu trữ hoạt động.'
                        : 'Đã khôi phục hoạt động.',
                  ),
            child: Text(published ? 'Lưu trữ' : 'Khôi phục'),
          ),
      ],
    );
  }
}

class ActivityEditor extends StatefulWidget {
  const ActivityEditor({super.key, required this.item});
  final Map<String, dynamic>? item;

  @override
  State<ActivityEditor> createState() => _ActivityEditorState();
}

class _ActivityEditorState extends State<ActivityEditor> {
  final _form = GlobalKey<FormState>();
  late final _title = TextEditingController(
    text: widget.item?['title'] as String?,
  );
  late final _minutes = TextEditingController(
    text: (widget.item?['minutes'] ?? 5).toString(),
  );
  late final _purpose = TextEditingController(
    text: widget.item?['purpose'] as String?,
  );
  late final _steps = TextEditingController(
    text: (widget.item?['steps'] as List?)?.join('\n'),
  );
  late final _note = TextEditingController(
    text: widget.item?['note'] as String?,
  );
  late String _group =
      widget.item?['groupId'] as String? ?? activityGroups.keys.first;

  List<String> get _stepList => _steps.text
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .toList();

  @override
  void dispose() {
    for (final controller in [_title, _minutes, _purpose, _steps, _note]) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_form.currentState!.validate()) return;
    Navigator.pop(context, <String, dynamic>{
      'title': _title.text.trim(),
      'groupId': _group,
      'groupName': widget.item?['groupId'] == _group
          ? widget.item!['groupName']
          : activityGroups[_group],
      'minutes': int.parse(_minutes.text.trim()),
      'purpose': _purpose.text.trim(),
      'steps': _stepList,
      'note': _note.text.trim(),
      if (widget.item == null) ...{'rank': 1000, 'published': true},
    });
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    insetPadding: adminDialogInsets(context),
    actionsOverflowButtonSpacing: P9Space.sm,
    title: Text(widget.item == null ? 'Tạo hoạt động' : 'Sửa hoạt động'),
    scrollable: true,
    content: SizedBox(
      width: 460,
      child: Form(
        key: _form,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: P9Space.lg,
          children: [
            adminField(_title, 'Tên hoạt động', min: 3, max: 120),
            DropdownButtonFormField<String>(
              isExpanded: true,
              initialValue: _group,
              decoration: const InputDecoration(labelText: 'Nhóm thói quen'),
              items: [
                for (final group in activityGroups.entries)
                  DropdownMenuItem(value: group.key, child: Text(group.value)),
              ],
              onChanged: (value) => setState(() => _group = value!),
            ),
            TextFormField(
              controller: _minutes,
              decoration: const InputDecoration(labelText: 'Thời lượng (phút)'),
              keyboardType: TextInputType.number,
              validator: (value) {
                final minutes = int.tryParse(value?.trim() ?? '');
                return minutes == null || minutes < 1 || minutes > 60
                    ? 'Nhập số nguyên từ 1 đến 60.'
                    : null;
              },
            ),
            adminField(_purpose, 'Mô tả', min: 5, max: 1000, lines: 2),
            TextFormField(
              controller: _steps,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: 'Hướng dẫn',
                helperText: 'Mỗi dòng một bước. Tối đa 5 bước.',
                helperMaxLines: 2,
                alignLabelWithHint: true,
              ),
              validator: (_) =>
                  _stepList.length > 5 ||
                      _stepList.any((step) => step.runes.length > 1000)
                  ? 'Tối đa 5 bước, mỗi bước tối đa 1.000 ký tự.'
                  : null,
            ),
            adminField(_note, 'Ghi chú', max: 500, lines: 2),
          ],
        ),
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Hủy'),
      ),
      FilledButton(
        style: FilledButton.styleFrom(
          minimumSize: const Size(104, P9Size.buttonHeight),
        ),
        onPressed: _submit,
        child: const Text('Lưu'),
      ),
    ],
  );
}

TextFormField adminField(
  TextEditingController controller,
  String label, {
  int min = 0,
  required int max,
  int lines = 1,
}) => TextFormField(
  controller: controller,
  decoration: InputDecoration(labelText: label, alignLabelWithHint: lines > 1),
  maxLength: max,
  maxLines: lines,
  validator: (value) => (value?.trim().runes.length ?? 0) < min
      ? 'Nhập ít nhất $min ký tự.'
      : null,
);

class AnnouncementPanel extends StatefulWidget {
  const AnnouncementPanel({super.key, required this.store});
  final AnnouncementStore store;

  @override
  State<AnnouncementPanel> createState() => _AnnouncementPanelState();
}

class _AnnouncementPanelState extends State<AnnouncementPanel> {
  final _form = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _body = TextEditingController();
  late final _messages = widget.store.watchLatest();
  bool _sending = false;

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_sending || !_form.currentState!.validate()) return;
    final title = _title.text.trim();
    final body = _body.text.trim();
    setState(() => _sending = true);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        insetPadding: adminDialogInsets(context),
        actionsOverflowButtonSpacing: P9Space.sm,
        scrollable: true,
        title: const Text('Gửi cho tất cả người dùng?'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Tin sẽ xuất hiện trong mục Thông báo trên app.'),
            const SizedBox(height: P9Space.lg),
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: P9Space.sm),
            Text(body),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Quay lại sửa'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              minimumSize: const Size(48, P9Size.buttonHeight),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xác nhận gửi'),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (confirmed != true) {
      setState(() => _sending = false);
      return;
    }
    String message;
    try {
      await widget.store.send(title, body);
      if (!mounted) return;
      _title.clear();
      _body.clear();
      message = 'Đã gửi thông báo vào inbox.';
    } catch (_) {
      message = 'Chưa gửi được thông báo. Vui lòng thử lại.';
    }
    if (!mounted) return;
    setState(() => _sending = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) => AdminPage(
    children: [
      const AdminHeading(
        title: 'Thông báo',
        description:
            'Gửi tin vào inbox của tất cả người dùng Power9 đã đăng nhập.',
      ),
      const SizedBox(height: P9Space.lg),
      Card(
        child: Padding(
          padding: const EdgeInsets.all(P9Space.lg),
          child: Form(
            key: _form,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: P9Space.md,
              children: [
                Text(
                  'Soạn thông báo',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: P9Space.md),
                adminField(_title, 'Tiêu đề', min: 3, max: 120),
                adminField(_body, 'Nội dung', min: 3, max: 1000, lines: 4),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(48, P9Size.buttonHeight),
                  ),
                  onPressed: _sending ? null : _send,
                  icon: const Icon(Icons.preview_outlined),
                  label: Text(_sending ? 'Đang xử lý…' : 'Xem trước và gửi'),
                ),
              ],
            ),
          ),
        ),
      ),
      const SizedBox(height: P9Space.xl),
      Text('Thông báo đã gửi', style: Theme.of(context).textTheme.titleLarge),
      AdminFeed(
        stream: _messages,
        builder: (messages) => messages.isEmpty
            ? const Text('Chưa gửi thông báo nào.')
            : Column(
                children: [
                  for (final item in messages)
                    Card(
                      child: ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.body),
                      ),
                    ),
                ],
              ),
      ),
    ],
  );
}
