// lib/core/theme/components/molecules/city_selector.dart

import 'package:flutter/material.dart';
import '../../app_typography.dart';
import '../../app_dimensions.dart';
import '../atoms/selection_button.dart';

/// Composant de sélection réutilisable pour les villes
class CitySelector extends StatelessWidget {
  /// Texte à afficher (ville sélectionnée ou instruction)
  final String displayText;

  /// Si une valeur est sélectionnée
  final bool hasValue;

  /// Callback appelé quand l'utilisateur appuie sur le sélecteur
  final VoidCallback onTap;

  /// Icône à afficher à gauche (optionnel)
  final IconData? leadingIcon;

  /// Titre à afficher au-dessus du sélecteur (optionnel)
  final String? title;

  const CitySelector({
    Key? key,
    required this.displayText,
    required this.onTap,
    this.hasValue = false,
    this.leadingIcon,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Titre si présent
        if (title != null) ...[
          Text(
            title!,
            style: AppTypography.subtitle(
              isDark: Theme.of(context).brightness == Brightness.dark,
            ),
          ),
          SizedBox(height: AppDimensions.space2),
        ],

        // Bouton de sélection
        SelectionButton(
          text: displayText,
          onTap: onTap,
          isSelected: hasValue,
          leadingIcon: leadingIcon,
        ),
      ],
    );
  }
}