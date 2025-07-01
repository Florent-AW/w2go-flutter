// lib/core/theme/components/atoms/circle_favorite_button.dart

import 'package:flutter/material.dart';
import '../../app_colors.dart';

/// Atom : Bouton favori circulaire avec fond blanc
/// Style identique à CircleBackButton pour cohérence UI
class CircleFavoriteButton extends StatelessWidget {
  final bool isFavorite;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;

  const CircleFavoriteButton({
    Key? key,
    required this.isFavorite,
    this.onPressed,
    this.backgroundColor = Colors.white,
    this.iconColor = AppColors.primary,
    this.size = 38.0,
    this.iconSize = 20.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(size / 2),
          onTap: onPressed,
          child: Center(
            child: isFavorite
            // ✅ Cœur plein (favori)
                ? Icon(
              Icons.favorite,
              size: iconSize,
              color: AppColors.accent,
            )
            // ✅ Cœur vide (non favori)
                : Icon(
              Icons.favorite_border,
              size: iconSize,
              color: iconColor,
            ),
          ),
        ),
      ),
    );
  }
}