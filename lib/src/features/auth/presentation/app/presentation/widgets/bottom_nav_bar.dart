import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:cinequizz/src/core/extensions/_extensions.dart';
import 'package:cinequizz/src/core/theme/_theme.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    final navigationBarItems = mainNavigationBarItems(
      series: 'Series',
      discover: 'Discover',
      leaderBoard: 'Leader Board',
      profile: 'Profile',
    );

    return BottomNavigationBar(
      backgroundColor: AppColors.background,
      iconSize: AppSize.xlg,
      currentIndex: navigationShell.currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: context.theme.colorScheme.primary,
      onTap: (index) {
        switch (index) {
          case 0:
            navigationShell.goBranch(
              index,
              initialLocation: index == navigationShell.currentIndex,
            );
          case 1:
            navigationShell.goBranch(index);
          case 2:
            navigationShell.goBranch(index);
          case 3:
            navigationShell.goBranch(index);
        }
      },
      items: navigationBarItems
          .map(
            (item) => BottomNavigationBarItem(
              icon: item.child ?? Icon(item.icon, size: 20),
              label: item.label,
              tooltip: item.tooltip,
            ),
          )
          .toList(),
    );
  }
}

List<NavBarItem> mainNavigationBarItems({
  required String series,
  required String discover,
  required String leaderBoard,
  required String profile,
}) =>
    [
      NavBarItem(icon: LucideIcons.tv, label: series),
      NavBarItem(icon: LucideIcons.search, label: discover),
      NavBarItem(icon: LucideIcons.trophy, label: leaderBoard),
      NavBarItem(icon: LucideIcons.user, label: profile),
    ];

class NavBarItem {
  NavBarItem({
    this.icon,
    this.label,
    this.child,
  });

  final String? label;
  final Widget? child;
  final IconData? icon;

  String? get tooltip => label;
}
