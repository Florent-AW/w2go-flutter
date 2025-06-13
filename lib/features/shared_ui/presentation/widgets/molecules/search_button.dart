// lib/features/shared_ui/presentation/widgets/molecules/search_button.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';


/// Bouton de recherche stylisé affichant une icône et un texte
class SearchButton extends StatelessWidget {
  /// Texte à afficher dans le bouton
  final String text;

  /// Fonction appelée lors du tap sur le bouton
  final VoidCallback onTap;

  /// Couleur du fond du bouton
  final Color backgroundColor;

  /// Couleur du texte et de l'icône
  final Color textColor;

  const SearchButton({
    Key? key,
    this.text = 'Trouvez des activités',
    required this.onTap,
    this.backgroundColor = Colors.white,
    this.textColor = AppColors.neutral800,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: AppDimensions.buttonHeightM,
        padding: EdgeInsets.only(
          left: AppDimensions.spacingS, // ou spacingXs
          right: AppDimensions.spacingM,
        ),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(50), // 100% arrondi (pilule)
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center, // Centrer horizontalement
          crossAxisAlignment: CrossAxisAlignment.center, // Centrer verticalement
          children: [
            Icon(
              LucideIcons.search,
              size: 18,
              color: textColor,
            ),
            SizedBox(width: AppDimensions.spacingXxs),
            Text(
              text,
              style: AppTypography
                  .buttonS(isDark: Theme.of(context).brightness == Brightness.dark)
                  .copyWith(color: textColor),
              overflow: TextOverflow.ellipsis, // Gérer le débordement du texte
              maxLines: 1,                     // Limiter à une ligne
            ),
          ],

        ),
      ),
    );
  }
}