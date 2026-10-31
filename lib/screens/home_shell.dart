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

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key, required this.user});
  final AppUser user;
  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;
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
  Widget build(BuildContext context) => PopScope(
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
          style: Theme.of(context).textTheme.titleMedium,
        ),
        actions: [
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
