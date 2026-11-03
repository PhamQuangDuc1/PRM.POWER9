import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/session_viewmodel.dart';
import '../widgets/p9_leave_session_dialog.dart';
import '../widgets/p9_logo.dart';
import 'today_screen.dart';
import 'profile_screen.dart';
import 'connection_screen.dart';
import 'food_screen.dart';
import 'relax_screen.dart';
import 'notification_screen.dart';
import 'progress_screen.dart';
import '../viewmodels/notification_viewmodel.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key, required this.user});
  final AppUser user;
  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell>
    with WidgetsBindingObserver {
  int _index = 0;
  bool _handlingNotification = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ref
          .read(notificationControllerProvider(widget.user.uid).notifier)
          .refresh();
    }
  }

  Future<void> _openNotification() async {
    if (_handlingNotification || !mounted) return;
    final vm = ref.read(
      notificationControllerProvider(widget.user.uid).notifier,
    );
    final item = vm.consumeTap();
    if (item == null) return;
    _handlingNotification = true;
    try {
      if (!await _mayLeaveSession() || !mounted) return;
      await vm.markRead(item);
      if (!mounted) return;
      setState(() => _index = 0);
      if (!context.mounted) return;
      final navigator = Navigator.of(context);
      navigator.popUntil((route) => route.isFirst);
      if (item.target == 'progress') {
        navigator.push(
          MaterialPageRoute<void>(
            builder: (_) => ProgressScreen(initialDay: item.dateKey),
          ),
        );
      }
    } finally {
      _handlingNotification = false;
      if (mounted &&
          ref.read(notificationControllerProvider(widget.user.uid)).pending !=
              null) {
        _openNotification();
      }
    }
  }

  Future<bool> _mayLeaveSession() async {
    if (_index != 2) return true;
    final session = ref.read(sessionViewModelProvider);
    if (session.saving) return false;
    if (!session.hasUnrecordedSession) return true;
    final discard = await showLeaveSessionDialog(context);
    if (!mounted || !discard) return false;
    ref.read(sessionViewModelProvider.notifier).discard();
    return true;
  }

  Future<void> _changeIndex(int index) async {
    if (index == _index || !await _mayLeaveSession() || !mounted) return;
    setState(() => _index = index);
  }

  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(
      notificationControllerProvider(widget.user.uid),
    );
    ref.listen(notificationControllerProvider(widget.user.uid), (_, next) {
      if (next.pending != null) _openNotification();
    });
    return PopScope(
      canPop: _index == 0,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _changeIndex(0);
      },
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: P9Size.appBarHeight,
          leadingWidth: P9Size.appBarHeight,
          leading: const Padding(
            padding: EdgeInsets.all(P9Space.sm),
            child: P9Logo(size: P9Size.headerLogo),
          ),
          title: Text(
            'Power9 Office Routine',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            IconButton(
              tooltip: notifications.unread > 0
                  ? 'Thông báo, ${notifications.unread} chưa đọc'
                  : 'Thông báo',
              icon: Semantics(
                label: notifications.unread > 0
                    ? 'Thông báo, ${notifications.unread} chưa đọc'
                    : 'Thông báo',
                child: ExcludeSemantics(
                  child: Badge(
                    isLabelVisible: notifications.unread > 0,
                    label: Text('${notifications.unread}'),
                    child: const Icon(Icons.notifications_outlined),
                  ),
                ),
              ),
              onPressed: () async {
                if (!await _mayLeaveSession() || !mounted || !context.mounted) {
                  return;
                }
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => const NotificationScreen(),
                  ),
                );
              },
            ),
            IconButton(
              tooltip: 'Tài khoản',
              icon: const Icon(Icons.account_circle_outlined),
              onPressed: () async {
                if (!await _mayLeaveSession() || !mounted) return;
                if (!context.mounted) return;
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => ProfileScreen(user: widget.user),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: IndexedStack(
            index: _index,
            children: [
              const TodayScreen(),
              const FoodScreen(),
              RelaxScreen(onRecorded: () => setState(() => _index = 0)),
              const ConnectionScreen(),
            ],
          ),
        ),
        bottomNavigationBar: NavigationBar(
          height: P9Size.navigationHeight,
          selectedIndex: _index,
          onDestinationSelected: _changeIndex,
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.today_outlined),
              selectedIcon: Icon(Icons.today),
              label: 'Hôm nay',
            ),
            NavigationDestination(
              icon: Icon(Icons.restaurant_outlined),
              selectedIcon: Icon(Icons.restaurant),
              label: 'Ăn uống',
            ),
            NavigationDestination(
              icon: Icon(Icons.self_improvement),
              label: 'Thư giãn',
            ),
            NavigationDestination(
              icon: Icon(Icons.people_outline),
              selectedIcon: Icon(Icons.people),
              label: 'Kết nối',
            ),
          ],
        ),
      ),
    );
  }
}
