// lib/features/home/presentation/pages/home_shell.dart

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import '../../../categories/presentation/pages/category_page.dart';
import '../../../city_page/presentation/pages/city_page.dart';
import '../../../shared_ui/presentation/widgets/organisms/generic_bottom_bar.dart';

class HomeShell extends StatefulWidget {
  /// Tab initial à afficher
  final BottomNavTab initialTab;

  const HomeShell({
    Key? key,
    this.initialTab = BottomNavTab.explorer,
  }) : super(key: key);

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  late BottomNavTab _currentTab;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  /// Retourne la page correspondant au tab
  Widget _getPageForTab(BottomNavTab tab) {
    switch (tab) {
      case BottomNavTab.explorer:
        return const CategoryPage();
      case BottomNavTab.visiter:
        return const CityPage();
      case BottomNavTab.favoris:
        return const Scaffold(
          body: Center(child: Text('🚧 Favoris - À implémenter')),
        );
      case BottomNavTab.profil:
        return const Scaffold(
          body: Center(child: Text('🚧 Profil - À implémenter')),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // ✅ PAS de AppBar ici - chaque page gère son header

      // ✅ Body qui commute avec transition subtile
      body: PageTransitionSwitcher(
        duration: const Duration(milliseconds: 200), // ✅ Très rapide
        transitionBuilder: (child, animation, secondaryAnimation) {
          return SharedAxisTransition(
            animation: animation,
            secondaryAnimation: secondaryAnimation,
            transitionType: SharedAxisTransitionType.horizontal,
            fillColor: Theme.of(context).colorScheme.background,
            child: child,
          );
        },
        child: KeyedSubtree(
          key: ValueKey(_currentTab), // ✅ Conserve l'état de chaque page
          child: _getPageForTab(_currentTab),
        ),
      ),

      // ✅ Bottom Bar fixe avec callback
      bottomNavigationBar: GenericBottomBar(
        selectedTab: _currentTab,
        onTabSelected: (tab) {
          if (tab != _currentTab) {
            setState(() {
              _currentTab = tab;
            });
          }
        },
      ),
    );
  }
}