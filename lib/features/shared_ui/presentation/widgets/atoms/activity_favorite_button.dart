// lib/features/shared_ui/presentation/widgets/atoms/activity_favorite_button.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';

class ActivityFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onPressed;

  const ActivityFavoriteButton({
    Key? key,
    required this.isFavorite,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(8),
        child: isFavorite
        // Cœur plein quand favori
            ? Icon(
          Icons.favorite,
          size: 26,
          color: AppColors.accent,
        )
        // Cœur vide avec bordure blanche et intérieur transparent sombre
            : Stack(
          alignment: Alignment.center,
          children: [
            // Cœur noir transparent (intérieur)
            Icon(
              Icons.favorite,
              size: 26,
              color: Colors.black.withOpacity(0.2),
            ),
            // Contour blanc (bordure)
            Icon(
              Icons.favorite_border,
              size: 28,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}