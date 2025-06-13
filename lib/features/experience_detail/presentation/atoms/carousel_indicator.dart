// lib/features/experience_detail/presentation/atoms/carousel_indicator.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';

class CarouselIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final Color? textColor;
  final Color? backgroundColor;
  final EdgeInsets? padding;

  const CarouselIndicator({
    Key? key,
    required this.currentIndex,
    required this.itemCount,
    this.textColor,
    this.backgroundColor,
    this.padding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si une seule image ou moins, ne rien afficher
    if (itemCount <= 1) return const SizedBox.shrink();

    // Index lisible par l'utilisateur (commençant à 1)
    final int displayIndex = currentIndex + 1;

    return Container(
      padding: padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor ?? Colors.black.withOpacity(0.4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$displayIndex/$itemCount',
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}