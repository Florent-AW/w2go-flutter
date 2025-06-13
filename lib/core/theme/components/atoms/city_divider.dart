import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../app_dimensions.dart';

/// Variantes visuelles pour le séparateur
enum DividerStyle {
  /// Fine ligne discrète
  subtle,

  /// Séparateur standard
  standard,

  /// Séparateur avec padding horizontal
  inset
}

/// Séparateur atomique avec différentes variantes visuelles
class CityDivider extends StatelessWidget {
  /// Style visuel du séparateur
  final DividerStyle style;

  /// Constructeur standard
  const CityDivider({
    Key? key
  }) : style = DividerStyle.standard, super(key: key);

  /// Constructeur pour style discret
  const CityDivider.subtle({
    Key? key
  }) : style = DividerStyle.subtle, super(key: key);

  /// Constructeur pour style avec marge
  const CityDivider.inset({
    Key? key
  }) : style = DividerStyle.inset, super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Configuration selon le style
    double height;
    Color color;
    EdgeInsets margin;

    switch (style) {
      case DividerStyle.subtle:
        height = 0.5;
        color = isDark ? AppColors.neutral700.withOpacity(0.5) : AppColors.neutral300.withOpacity(0.5);
        margin = EdgeInsets.zero;
        break;
      case DividerStyle.standard:
        height = 1.0;
        color = isDark ? AppColors.neutral700 : AppColors.neutral300;
        margin = EdgeInsets.symmetric(vertical: AppDimensions.space2);
        break;
      case DividerStyle.inset:
        height = 1.0;
        color = isDark ? AppColors.neutral700 : AppColors.neutral300;
        margin = EdgeInsets.symmetric(
          horizontal: AppDimensions.space4,
          vertical: AppDimensions.space2,
        );
        break;
    }

    return Container(
      height: height,
      margin: margin,
      color: color,
    );
  }
}