// lib/features/experience_detail/presentation/atoms/carousel_indicator.dart

import 'package:flutter/material.dart';

class CarouselIndicator extends StatelessWidget {
  final int currentIndex;
  final int itemCount;
  final Color? activeColor;
  final Color? inactiveColor;
  final double dotSize;
  final double spacing;

  const CarouselIndicator({
    Key? key,
    required this.currentIndex,
    required this.itemCount,
    this.activeColor,
    this.inactiveColor,
    this.dotSize = 8,
    this.spacing = 4,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Si une seule image ou moins, ne rien afficher
    if (itemCount <= 1) return const SizedBox.shrink();

    // Index lisible par l'utilisateur (commençant à 1)
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final Color active = activeColor ?? Colors.white;
    final Color inactive = inactiveColor ??
        (isDark ? Colors.white38 : Colors.black26);
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(itemCount, (index) {
      final bool isActive = index == currentIndex;
      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: spacing),
        width: dotSize,
        height: dotSize,
        decoration: BoxDecoration(
          color: isActive ? active : inactive,
          shape: BoxShape.circle,
        ),
      );
    }),
    );
  }
}