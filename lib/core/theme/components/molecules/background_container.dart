// lib/core/theme/components/molecules/background_container.dart
import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../app_dimensions.dart';

/// Variantes du fond d'écran
enum BackgroundVariant {
  primary,   // Couleur primaire (bleu)
  secondary, // Couleur secondaire (vert)
  neutral,   // Fond neutre
  light,     // Version claire
}

/// Conteneur avec arrière-plan stylisé réutilisable dans toute l'application
class BackgroundContainer extends StatelessWidget {
  /// Le contenu à afficher
  final Widget child;

  /// Variante du fond d'écran
  final BackgroundVariant variant;

  /// Padding à appliquer au contenu
  final EdgeInsetsGeometry? padding;

  /// Widgets décoratifs à superposer (optionnel)
  final List<Widget>? decorations;

  const BackgroundContainer({
    Key? key,
    required this.child,
    this.variant = BackgroundVariant.primary,
    this.padding,
    this.decorations,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: _getBackgroundColor(),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Éléments décoratifs si fournis
          if (decorations != null) ...decorations!,

          // Contenu principal
          SafeArea(
            child: Padding(
              padding: padding ?? AppDimensions.paddingM,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  /// Retourne la couleur de fond selon la variante
  Color _getBackgroundColor() {
    switch (variant) {
      case BackgroundVariant.primary:
        return AppColors.primary;
      case BackgroundVariant.secondary:
        return AppColors.secondary;
      case BackgroundVariant.neutral:
        return AppColors.neutral900;
      case BackgroundVariant.light:
        return AppColors.background;
    }
  }
}