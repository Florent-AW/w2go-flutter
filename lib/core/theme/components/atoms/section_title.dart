import 'package:flutter/material.dart';
import '../../app_typography.dart';
import '../../app_dimensions.dart';
import '../../app_colors.dart';

/// Styles visuels pour les titres de section
enum SectionTitleStyle {
  /// Titre principal
  primary,

  /// Titre secondaire (plus petit)
  secondary
}

/// Composant atomique pour les titres de section
class SectionTitle extends StatelessWidget {
  /// Texte du titre
  final String text;

  /// Style visuel
  final SectionTitleStyle style;

  /// Action optionnelle (ex: "Voir tout")
  final Widget? action;

  /// Espacement en bas du titre
  final double bottomSpacing;

  /// Constructeur principal avec style primaire
  const SectionTitle({
    Key? key,
    required this.text,
    this.action,
    this.bottomSpacing = 12.0,
  }) : style = SectionTitleStyle.primary, super(key: key);

  /// Constructeur pour le style secondaire
  const SectionTitle.secondary({
    Key? key,
    required this.text,
    this.action,
    this.bottomSpacing = 8.0,
  }) : style = SectionTitleStyle.secondary, super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomSpacing),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Titre avec style adapté
          Expanded(
            child: Text(
              text,
              style: style == SectionTitleStyle.primary
                  ? AppTypography.subtitle(isDark: isDark)
                  : AppTypography.titleXs(
                isDark: isDark,
              ).copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Action optionnelle
          if (action != null) action!,
        ],
      ),
    );
  }
}