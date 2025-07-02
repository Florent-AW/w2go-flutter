// lib/core/theme/components/organisms/app_header.dart

import 'package:flutter/material.dart';
import '../../app_dimensions.dart';
import '../../app_colors.dart';
import '../../../../features/shared_ui/presentation/widgets/molecules/location_selector.dart';
import '../../../../features/shared_ui/presentation/widgets/molecules/search_button.dart';

/// Organism : Header d'application réutilisable
class AppHeader extends StatelessWidget {
  final VoidCallback? onSearchTap;
  final bool showLocationIcon;
  final String searchText;
  final TextStyle? locationTextStyle;
  final Color? iconColor;
  final EdgeInsets? padding;
  final double? height;
  final Color? locationTextColor;

  const AppHeader({
    Key? key,
    this.onSearchTap,
    this.showLocationIcon = true,
    this.searchText = 'Trouver des activités',
    this.locationTextStyle,
    this.iconColor,
    this.padding,
    this.height,
    this.locationTextColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final defaultPadding = EdgeInsets.symmetric(
      horizontal: AppDimensions.spacingS,
      vertical: 8,
    );

    return Container(
      height: height ?? 70, // ✅ HAUTEUR STANDARDISÉE CategoryPage
      padding: padding ?? defaultPadding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Localisation à gauche
          LocationSelector(
            showIcon: showLocationIcon,
            textStyle: locationTextStyle,
            iconColor: iconColor ?? AppColors.accent,
            locationTextColor: locationTextColor,
          ),

          // Espace flexible
          const Spacer(),

          // Recherche à droite
          SearchButton(
            text: searchText,
            onTap: onSearchTap ?? () => print('Recherche tappée'),
          ),
        ],
      ),
    );
  }
}