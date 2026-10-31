import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/app_user.dart';
import '../theme/p9_theme.dart';
import '../viewmodels/activity_providers.dart';
import '../widgets/p9_activity_card.dart';
import '../widgets/p9_async_content.dart';
import '../widgets/p9_logo.dart';
import 'today_screen.dart';
import 'profile_screen.dart';
import 'activity_detail_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key, required this.user});
  final AppUser user;
  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;
  @override
  Widget build(BuildContext context) => Scaffold(
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
          onPressed: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => ProfileScreen(user: widget.user),
            ),
          ),
        ),
      ],
    ),
    body: SafeArea(
      child: IndexedStack(
        index: _index,
        children: const [
          TodayScreen(),
          _GroupScreen(groupId: 'eat'),
          _GroupScreen(groupId: 'stress'),
          _GroupScreen(groupId: 'social'),
        ],
      ),
    ),
    bottomNavigationBar: NavigationBar(
      height: P9Size.navigationHeight,
      selectedIndex: _index,
      onDestinationSelected: (index) => setState(() => _index = index),
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
  );
}

class _GroupScreen extends ConsumerWidget {
  const _GroupScreen({required this.groupId});
  final String groupId;
  @override
  Widget build(BuildContext context, WidgetRef ref) => P9AsyncContent(
    value: ref.watch(groupActivitiesProvider(groupId)),
    retry: () => ref.invalidate(activitiesProvider),
    builder: (activities) => activities.isEmpty
        ? const P9Empty(message: 'Chưa có hoạt động trong nhóm này.')
        : ListView(
            padding: const EdgeInsets.all(P9Space.lg),
            children: [
              for (final activity in activities)
                P9ActivityCard(
                  activity: activity,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => ActivityDetailScreen(activity: activity),
                    ),
                  ),
                ),
            ],
          ),
  );
}
