// lib/features/experience_detail/presentation/organisms/experience_top_bar.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/components/atoms/circle_back_button.dart';
import '../../../../core/theme/components/atoms/circle_favorite_button.dart';
import '../molecules/category_return_button.dart';

/// Organism : Top bar sticky de la page de détail d'expérience
/// Layout symétrique : [Retour] [-- Catégorie --] [Favori]
class ExperienceTopBar extends StatelessWidget {
  final String categoryName;
  final VoidCallback onBack;
  final VoidCallback onCategoryTap;
  final bool isFavorite;
  final VoidCallback? onFavoritePressed;
  final bool visible;
  final bool showBackground;

  const ExperienceTopBar({
    Key? key,
    required this.categoryName,
    required this.onBack,
    required this.onCategoryTap,
    required this.isFavorite,
    this.onFavoritePressed,
    required this.visible,
    required this.showBackground,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: visible ? 1.0 : 0.0,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: showBackground
              ? (Theme.of(context).brightness == Brightness.dark
              ? AppColors.primary  // ✅ Bleu foncé en mode sombre
              : Colors.white)      // ✅ Blanc en mode normal
              : Colors.transparent,   // ✅ Transparent quand masqué
          boxShadow: showBackground ? [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null, // ✅ Ombre seulement avec background
        ),
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: AppDimensions.spacingXxs,
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              // ✅ ATOM : Bouton retour (toujours visible)
              CircleBackButton(
                onPressed: onBack,
                backgroundColor: Colors.white,
                iconColor: AppColors.primary,
                size: 36,
                iconSize: 20,
                padding: EdgeInsets.zero,
              ),

              // ✅ MOLECULE : Bouton catégorie (conditionnel)
              Expanded(
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: showBackground ? 1.0 : 0.0, // ✅ Fade in/out
                  child: showBackground
                      ? Center(
                    child: CategoryReturnButton(
                      categoryName: categoryName,
                      onPressed: onCategoryTap,
                    ),
                  )
                      : const SizedBox.shrink(), // ✅ Pas d'espace si caché
                ),
              ),

              // ✅ ATOM : Bouton favori (toujours visible)
              CircleFavoriteButton(
                isFavorite: isFavorite,
                onPressed: onFavoritePressed,
                backgroundColor: Colors.white,
                iconColor: AppColors.primary,
                size: 36,
                iconSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}