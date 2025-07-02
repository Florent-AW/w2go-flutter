// lib/features/shared_ui/presentation/widgets/organisms/generic_bottom_bar.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/components/molecules/bottom_bar_wrapper.dart';
import '../molecules/navigation_buttons_row.dart';

export '../molecules/navigation_buttons_row.dart' show BottomNavTab;

/// Bottom bar générique avec navigation 4 tabs
/// Gère automatiquement la navigation entre les pages principales
class GenericBottomBar extends StatelessWidget {
  final BottomNavTab selectedTab;
  final bool isLoading;
  final EdgeInsets? customPadding;

  const GenericBottomBar({
    Key? key,
    this.selectedTab = BottomNavTab.explorer,
    this.isLoading = false,
    this.customPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomBarWrapper(
      content: NavigationButtonsRow(
        selectedTab: selectedTab,
        onTabSelected: (tab) => _handleNavigation(context, tab),
      ),
      isLoading: isLoading,
      customPadding: customPadding,
    );
  }

  /// Navigation centralisée - Gère tous les cas de navigation
  void _handleNavigation(BuildContext context, BottomNavTab tab) {
    // Ne pas naviguer si on est déjà sur la bonne page
    if (tab == selectedTab) return;

    switch (tab) {
      case BottomNavTab.explorer:
        Navigator.of(context).pushReplacementNamed('/category');
        break;

      case BottomNavTab.favoris:
      // TODO: Navigation vers favoris quand la page sera créée
        print('🚧 Navigation vers favoris - À implémenter');
        break;

      case BottomNavTab.visiter:
        Navigator.of(context).pushReplacementNamed('/city');
        break;

      case BottomNavTab.profil:
      // TODO: Navigation vers profil quand la page sera créée
        print('🚧 Navigation vers profil - À implémenter');
        break;
    }
  }
}