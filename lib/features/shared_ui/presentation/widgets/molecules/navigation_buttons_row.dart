// lib/features/shared_ui/presentation/widgets/molecules/navigation_buttons_row.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/components/atoms/action_button.dart';

enum BottomNavTab { explorer, favoris, visiter, profil }

/// Molecule contenant les 4 boutons de navigation principale
class NavigationButtonsRow extends StatelessWidget {
  final BottomNavTab selectedTab;
  final Function(BottomNavTab) onTabSelected;

  const NavigationButtonsRow({
    Key? key,
    this.selectedTab = BottomNavTab.explorer,
    required this.onTabSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // ✅ Barre d'indicateurs au-dessus
        Row(
          children: [
            Expanded(child: _buildIndicator(BottomNavTab.explorer)),
            SizedBox(width: AppDimensions.spacingS),

            Expanded(child: _buildIndicator(BottomNavTab.favoris)),
            SizedBox(width: AppDimensions.spacingS),

            Expanded(child: _buildIndicator(BottomNavTab.visiter)),
            SizedBox(width: AppDimensions.spacingS),

            Expanded(child: _buildIndicator(BottomNavTab.profil)),
          ],
        ),

        SizedBox(height: AppDimensions.spacingXxxs),

        // ✅ Boutons en dessous (couleur normale)
        Row(
          children: [
            Expanded(child: _buildNavItem(BottomNavTab.explorer, LucideIcons.compass, 'Explorer')),
            SizedBox(width: AppDimensions.spacingS),

            Expanded(child: _buildNavItem(BottomNavTab.favoris, LucideIcons.heart, 'Favoris')),
            SizedBox(width: AppDimensions.spacingS),

            Expanded(child: _buildNavItem(BottomNavTab.visiter, LucideIcons.mapPin, 'Visiter')),
            SizedBox(width: AppDimensions.spacingS),

            Expanded(child: _buildNavItem(BottomNavTab.profil, LucideIcons.user, 'Profil')),
          ],
        ),
      ],
    );
  }

  // ✅ Ajouter cette méthode
  Widget _buildIndicator(BottomNavTab tab) {
    final isSelected = selectedTab == tab;

    return Container(
      height: 3,
      color: isSelected ? AppColors.accent : Colors.transparent,
    );
  }

  Widget _buildNavItem(BottomNavTab tab, IconData icon, String label) {
    final isSelected = selectedTab == tab;

    return Opacity(
      opacity: isSelected ? 1.0 : 0.7,
      child: ActionButton(
        icon: icon,
        label: label,
        onPressed: () => onTabSelected(tab),
      ),
    );
  }
}