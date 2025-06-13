// lib/features/shared_ui/presentation/widgets/molecules/filter_chip.dart

import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/theme/app_interactions.dart';

/// Types de puces disponibles
enum FilterChipType {
  standard,       // Puce standard
  choice,         // Puce de choix (une seule sélectionnable à la fois)
  action,         // Puce d'action (déclenche une action)
  category,       // Puce de catégorie (avec couleur personnalisée)
}

/// Puce de filtre réutilisable pour l'application
///
/// Composant moléculaire permettant à l'utilisateur de filtrer des contenus
/// ou de faire des sélections.
class AppFilterChip extends StatelessWidget {
  /// Libellé de la puce
  final String label;

  /// Si la puce est sélectionnée
  final bool selected;

  /// Type de puce
  final FilterChipType type;

  /// Fonction appelée quand la puce est pressée
  final VoidCallback? onPressed;

  /// Icône à afficher à gauche (optionnel)
  final IconData? icon;

  /// Couleur personnalisée de la puce
  final Color? color;

  /// Si la puce est désactivée
  final bool disabled;

  /// Si la puce doit avoir une ombre
  final bool hasShadow;

  /// Marges externes
  final EdgeInsets? margin;

  const AppFilterChip({
    Key? key,
    required this.label,
    this.selected = false,
    this.type = FilterChipType.standard,
    this.onPressed,
    this.icon,
    this.color,
    this.disabled = false,
    this.hasShadow = false,
    this.margin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    // Déterminer la couleur principale de la puce
    Color chipColor = color ?? colorScheme.primary;
    if (type == FilterChipType.category && color == null) {
      // Si c'est une puce de catégorie mais sans couleur spécifiée, utiliser la primaire
      chipColor = colorScheme.primary;
    }

    // Configurer les couleurs selon l'état
    Color backgroundColor;
    Color textColor;
    Color borderColor;

    if (disabled) {
      // Puce désactivée
      backgroundColor = isDark ? AppColors.neutral800 : AppColors.neutral200;
      textColor = isDark ? AppColors.neutral600 : AppColors.neutral500;
      borderColor = Colors.transparent;
    } else if (selected) {
      // Puce sélectionnée
      backgroundColor = chipColor;
      textColor = Colors.white;
      borderColor = Colors.transparent;
    } else {
      // Puce non sélectionnée
      backgroundColor = isDark ? AppColors.neutral800.withOpacity(0.5) : AppColors.neutral100;
      textColor = isDark ? AppColors.neutral200 : AppColors.neutral800;
      borderColor = isDark ? AppColors.neutral700 : AppColors.neutral300;
    }

    // Style du texte
    final TextStyle textStyle = context.label.copyWith(
      color: textColor,
      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
    );

    // Icône à afficher
    Widget? iconWidget;
    if (icon != null) {
      iconWidget = Icon(
        icon,
        size: 16,
        color: textColor,
      );
    }

    // Effets de décoration
    BoxDecoration decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: AppDimensions.borderRadiusXl,
      border: !selected
          ? Border.all(color: borderColor, width: 1)
          : null,
    );

    // Ajouter une ombre si demandé
    if (hasShadow && !disabled) {
      decoration = decoration.copyWith(
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withOpacity(0.2)
                : Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: Offset(0, 1),
            spreadRadius: 0,
          ),
        ],
      );
    }

    // Construire le contenu de la puce
    Widget chipContent = Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space3,
        vertical: AppDimensions.space2,
      ),
      decoration: decoration,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (iconWidget != null) ...[
            iconWidget,
            SizedBox(width: AppDimensions.space2),
          ],
          Text(
            label,
            style: textStyle,
          ),
        ],
      ),
    );

    // Appliquer les marges si spécifiées
    if (margin != null) {
      chipContent = Padding(
        padding: margin!,
        child: chipContent,
      );
    }

    // Rendre la puce interactive si elle n'est pas désactivée
    if (!disabled && onPressed != null) {
      return GestureDetector(
        onTap: onPressed,
        child: chipContent,
      );
    }

    return chipContent;
  }

  /// Crée une liste horizontale scrollable de puces de filtre
  static Widget horizontalList({
    required List<AppFilterChip> chips,
    EdgeInsets? padding,
    double spacing = 8.0,
    double height = 40.0,
    bool showScrollbar = true,
  }) {
    return Builder(
      builder: (context) {
        final ScrollController scrollController = ScrollController();

        return Container(
          height: height,
          child: showScrollbar
              ? Scrollbar(
            controller: scrollController,
            thumbVisibility: true,
            thickness: 4,
            radius: Radius.circular(8),
            child: _buildChipList(chips, scrollController, padding, spacing),
          )
              : _buildChipList(chips, scrollController, padding, spacing),
        );
      },
    );
  }

  static Widget _buildChipList(
      List<AppFilterChip> chips,
      ScrollController scrollController,
      EdgeInsets? padding,
      double spacing,
      ) {
    return ListView.separated(
      controller: scrollController,
      scrollDirection: Axis.horizontal,
      padding: padding ?? EdgeInsets.symmetric(
        horizontal: AppDimensions.space4,
        vertical: AppDimensions.space2,
      ),
      itemCount: chips.length,
      separatorBuilder: (context, index) => SizedBox(width: spacing),
      itemBuilder: (context, index) => chips[index],
    );
  }

  /// Crée une grille responsive de puces de filtre
  static Widget grid({
    required List<AppFilterChip> chips,
    EdgeInsets? padding,
    double spacing = 8.0,
    double runSpacing = 8.0,
  }) {
    return Padding(
      padding: padding ?? EdgeInsets.all(AppDimensions.space4),
      child: Wrap(
        spacing: spacing,
        runSpacing: runSpacing,
        children: chips,
      ),
    );
  }
}