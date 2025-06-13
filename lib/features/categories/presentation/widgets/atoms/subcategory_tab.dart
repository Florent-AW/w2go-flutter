// lib/features/categories/presentation/widgets/atoms/subcategory_tab.dart
import 'package:flutter/material.dart';
import '../../../../../core/domain/models/shared/subcategory_model.dart';
import '../../../../../core/common/constants/subcategory_icons.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_colors.dart';

class SubcategoryTab extends StatelessWidget {
  final Subcategory subcategory;
  final bool isSelected;
  final Color categoryColor;
  final double height;

  const SubcategoryTab({
    Key? key,
    required this.subcategory,
    required this.isSelected,
    required this.categoryColor,
    this.height = 64.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String label = subcategory.name;
    final IconData icon = SubcategoryIcons.getIcon(
        subcategory.icon ?? subcategory.name);

    // ✅ Couleurs selon l'état
    final backgroundColor = isSelected
        ? categoryColor
        : AppColors.neutral100;
    final textColor = isSelected
        ? Colors.white
        : categoryColor;
    final iconColor = isSelected
        ? Colors.white
        : categoryColor;

// ✅ Logique de saut de ligne intelligente
    final words = label.split(' ');
    final displayLabel = words.length == 1
        ? label  // 1 mot : pas de break
        : words.length == 2
        ? '${words[0]}\n${words[1]}'  // 2 mots : break après le 1er
        : '${words[0]} ${words[1]}\n${words.sublist(2).join(' ')}';  // 3+ mots : break après le 2ème

    return IntrinsicWidth(  // ✅ S'adapte au contenu
      child: Container(
        height: height - 8,
        constraints: BoxConstraints(
          minWidth: 140,   // ✅ Seulement largeur minimale
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: AppDimensions.spacingXxs,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppDimensions.radiusS),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,  // ✅ Taille minimale
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ✅ Icône à gauche
            Icon(
              icon,
              size: AppDimensions.iconSizeM,
              color: iconColor,
            ),

            SizedBox(width: AppDimensions.spacingXs),

            // ✅ Titre sans contrainte de largeur
            Text(
              displayLabel,
              style: AppTypography.body().copyWith(
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w600,
                color: textColor,
                height: 1.2,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.start,
            ),
          ],
        ),
      ),
    );
  }
}