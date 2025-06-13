// lib/core/theme/extensions/button_tokens.dart

import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_dimensions.dart';

/// Extension de thème pour les tokens de bouton
@immutable
class ButtonTokens extends ThemeExtension<ButtonTokens> {
  const ButtonTokens({
    required this.heights,
    required this.iconSizes,
    required this.backgroundColors,
    required this.contentColors,
    required this.outlineBorderSides,
  });

  final Map<ButtonSize, double> heights;
  final Map<ButtonSize, double> iconSizes;
  final Map<ButtonVariant, Color> backgroundColors;
  final Map<ButtonVariant, Color> contentColors;
  final Map<ButtonVariant, BorderSide> outlineBorderSides;

  /// Crée les tokens de bouton pour le thème clair
  static ButtonTokens light() {
    return ButtonTokens(
      heights: {
        ButtonSize.small: AppDimensions.buttonHeightS,
        ButtonSize.medium: AppDimensions.buttonHeightM,
        ButtonSize.large: AppDimensions.buttonHeightL,
      },
      iconSizes: {
        ButtonSize.small: 16,
        ButtonSize.medium: 20,
        ButtonSize.large: 24,
      },
      backgroundColors: {
        ButtonVariant.primary: AppColors.primary,
        ButtonVariant.secondary: AppColors.secondary,
        ButtonVariant.accent: AppColors.accent,
        ButtonVariant.error: AppColors.error,
        ButtonVariant.outline: Colors.transparent,
        ButtonVariant.text: Colors.transparent,
      },
      contentColors: {
        ButtonVariant.primary: AppColors.neutral50,
        ButtonVariant.secondary: AppColors.neutral50,
        ButtonVariant.accent: AppColors.neutral50,
        ButtonVariant.error: AppColors.neutral50,
        ButtonVariant.outline: AppColors.primary,
        ButtonVariant.text: AppColors.primary,
      },
      outlineBorderSides: {
        ButtonVariant.outline: BorderSide(color: AppColors.primary, width: 1.5),
        ButtonVariant.primary: BorderSide.none,
        ButtonVariant.secondary: BorderSide.none,
        ButtonVariant.accent: BorderSide.none,
        ButtonVariant.error: BorderSide.none,
        ButtonVariant.text: BorderSide.none,
      },
    );
  }

  /// Crée les tokens de bouton pour le thème sombre
  static ButtonTokens dark() {
    return ButtonTokens(
      heights: {
        ButtonSize.small: AppDimensions.buttonHeightS,
        ButtonSize.medium: AppDimensions.buttonHeightM,
        ButtonSize.large: AppDimensions.buttonHeightL,
      },
      iconSizes: {
        ButtonSize.small: 16,
        ButtonSize.medium: 20,
        ButtonSize.large: 24,
      },
      backgroundColors: {
        ButtonVariant.primary: AppColors.primary,
        ButtonVariant.secondary: AppColors.secondary,
        ButtonVariant.accent: AppColors.accent,
        ButtonVariant.error: AppColors.error,
        ButtonVariant.outline: Colors.transparent,
        ButtonVariant.text: Colors.transparent,
      },
      contentColors: {
        ButtonVariant.primary: AppColors.neutral50,
        ButtonVariant.secondary: AppColors.neutral50,
        ButtonVariant.accent: AppColors.neutral50,
        ButtonVariant.error: AppColors.neutral50,
        ButtonVariant.outline: AppColors.primary,
        ButtonVariant.text: AppColors.primary,
      },
      outlineBorderSides: {
        ButtonVariant.outline: BorderSide(color: AppColors.primary, width: 1.5),
        ButtonVariant.primary: BorderSide.none,
        ButtonVariant.secondary: BorderSide.none,
        ButtonVariant.accent: BorderSide.none,
        ButtonVariant.error: BorderSide.none,
        ButtonVariant.text: BorderSide.none,
      },
    );
  }

  /// Obtient les tokens pour un état désactivé
  ButtonTokens disabled(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return copyWith(
      backgroundColors: {
        ButtonVariant.primary: isDark ? AppColors.neutral700 : AppColors.neutral300,
        ButtonVariant.secondary: isDark ? AppColors.neutral700 : AppColors.neutral300,
        ButtonVariant.accent: isDark ? AppColors.neutral700 : AppColors.neutral300,
        ButtonVariant.error: isDark ? AppColors.neutral700 : AppColors.neutral300,
        ButtonVariant.outline: Colors.transparent,
        ButtonVariant.text: Colors.transparent,
      },
      contentColors: {
        ButtonVariant.primary: isDark ? AppColors.neutral500 : AppColors.neutral600,
        ButtonVariant.secondary: isDark ? AppColors.neutral500 : AppColors.neutral600,
        ButtonVariant.accent: isDark ? AppColors.neutral500 : AppColors.neutral600,
        ButtonVariant.error: isDark ? AppColors.neutral500 : AppColors.neutral600,
        ButtonVariant.outline: isDark ? AppColors.neutral500 : AppColors.neutral600,
        ButtonVariant.text: isDark ? AppColors.neutral500 : AppColors.neutral600,
      },
      outlineBorderSides: {
        ButtonVariant.outline: BorderSide(
          color: isDark ? AppColors.neutral700 : AppColors.neutral300,
          width: 1.5,
        ),
        ButtonVariant.primary: BorderSide.none,
        ButtonVariant.secondary: BorderSide.none,
        ButtonVariant.accent: BorderSide.none,
        ButtonVariant.error: BorderSide.none,
        ButtonVariant.text: BorderSide.none,
      },
    );
  }

  @override
  ButtonTokens copyWith({
    Map<ButtonSize, double>? heights,
    Map<ButtonSize, double>? iconSizes,
    Map<ButtonVariant, Color>? backgroundColors,
    Map<ButtonVariant, Color>? contentColors,
    Map<ButtonVariant, BorderSide>? outlineBorderSides,
  }) {
    return ButtonTokens(
      heights: heights ?? this.heights,
      iconSizes: iconSizes ?? this.iconSizes,
      backgroundColors: backgroundColors ?? this.backgroundColors,
      contentColors: contentColors ?? this.contentColors,
      outlineBorderSides: outlineBorderSides ?? this.outlineBorderSides,
    );
  }

  @override
  ButtonTokens lerp(ButtonTokens? other, double t) {
    if (other is! ButtonTokens) {
      return this;
    }
    return this;
  }
}

/// Tailles de bouton disponibles
enum ButtonSize {
  small,
  medium,
  large,
}

/// Variantes de boutons disponibles dans l'application
enum ButtonVariant {
  primary,     // Bouton principal (couleur primaire)
  secondary,   // Bouton secondaire (couleur secondaire)
  accent,      // Bouton accent (couleur accent)
  error,       // Bouton d'erreur/destruction
  outline,     // Bouton avec bordure uniquement
  text,        // Bouton texte sans fond
}