import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app/core/constants/breakpoints.dart';
import 'package:app/features/auth/presentation/widgets/account_menu.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  static const _titles = ['Projects', 'Clients', 'Pricing'];

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width >= Breakpoints.wide;
    final index = navigationShell.currentIndex;

    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[index]),
        actions: const [AccountMenu()],
      ),
      body: wide
          ? Row(
              children: [
                NavigationRail(
                  selectedIndex: index,
                  onDestinationSelected: (i) {
                    navigationShell.goBranch(
                      i,
                      initialLocation: i == navigationShell.currentIndex,
                    );
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: const [
                    NavigationRailDestination(
                      icon: Icon(Icons.handyman_outlined),
                      selectedIcon: Icon(Icons.handyman),
                      label: Text('Projects'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.people_outline),
                      selectedIcon: Icon(Icons.people),
                      label: Text('Clients'),
                    ),
                    NavigationRailDestination(
                      icon: Icon(Icons.attach_money_outlined),
                      selectedIcon: Icon(Icons.attach_money),
                      label: Text('Pricing'),
                    ),
                  ],
                ),
                const VerticalDivider(width: 1),
                Expanded(child: navigationShell),
              ],
            )
          : navigationShell,
      bottomNavigationBar: wide
          ? null
          : NavigationBar(
              selectedIndex: index,
              onDestinationSelected: (i) {
                navigationShell.goBranch(
                  i,
                  initialLocation: i == navigationShell.currentIndex,
                );
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.handyman_outlined),
                  selectedIcon: Icon(Icons.handyman),
                  label: 'Projects',
                ),
                NavigationDestination(
                  icon: Icon(Icons.people_outline),
                  selectedIcon: Icon(Icons.people),
                  label: 'Clients',
                ),
                NavigationDestination(
                  icon: Icon(Icons.attach_money_outlined),
                  selectedIcon: Icon(Icons.attach_money),
                  label: 'Pricing',
                ),
              ],
            ),
    );
  }
}
