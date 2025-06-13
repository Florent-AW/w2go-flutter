// lib/features/categories/presentation/widgets/atoms/category_tab.dart
// Garder ce composant intact comme atom

import 'package:flutter/material.dart';
import 'package:travel_in_perigord_app/core/theme/app_dimensions.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/common/constants/subcategory_icons.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../constants/ui_constants.dart';

class CategoryTab extends StatelessWidget {
  final CategoryViewModel category;
  final bool isActive;
  final VoidCallback onTap;

  const CategoryTab({
    Key? key,
    required this.category,
    required this.isActive,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Obtenir les couleurs du thème
    final theme = Theme.of(context);
    final primaryColor = isActive
        ? AppColors.getCategoryColor(category.name, isDark: Theme.of(context).brightness == Brightness.dark)
        : Colors.white;

    // Couleur de fond selon le statut et Material 3
    final backgroundColor = isActive
        ? theme.colorScheme.surface
        : Colors.transparent;

    // Couleur du splash (primary avec opacité 12%)
    final splashColor = theme.colorScheme.primary.withOpacity(0.12);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(CategoryUIConstants.tabRadius),
        topRight: Radius.circular(CategoryUIConstants.tabRadius),
      ),
      elevation: isActive ? 1 : 0,
      child: InkWell(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(CategoryUIConstants.tabRadius),
          topRight: Radius.circular(CategoryUIConstants.tabRadius),
        ),
        splashColor: splashColor,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.only(
            left: AppDimensions.space5,
            right: AppDimensions.space5,
            top: AppDimensions.spacingXs,
            bottom: AppDimensions.spacingXxs,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icône
              Icon(
                SubcategoryIcons.getIcon(category.icon ?? category.name),
                size: AppDimensions.iconSizeS,
                color: primaryColor,
              ),
              SizedBox(height: 2),
              // Utilisation de TextTheme pour le texte (labelMedium)
              Text(
                category.name,
                style: isActive
                    ? theme.textTheme.labelMedium?.copyWith(
                  color: primaryColor,
                  fontWeight: FontWeight.bold,
                )
                    : theme.textTheme.labelMedium?.copyWith(
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}