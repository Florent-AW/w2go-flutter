// lib/core/theme/components/atoms/city_list_item.dart

import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../app_dimensions.dart';
import '../../app_typography.dart';
import '../../../domain/models/shared/city_model.dart';

/// Type de visuel pour l'élément de ville
enum CityItemStyle {
  /// Style standard pour les listes normales
  standard,

  /// Style pour les éléments d'historique
  history,

  /// Style pour les suggestions
  suggestion
}

/// Élément atomique représentant une ville dans une liste
class CityListItem extends StatelessWidget {
  /// Modèle de données de la ville
  final City city;

  /// Si l'élément est actuellement sélectionné
  final bool isSelected;

  /// Callback appelé lors du tap
  final VoidCallback onTap;

  /// Style visuel de l'élément
  final CityItemStyle style;

  final String? secondaryText;
  final bool isGooglePlace;

  /// Constructeur principal avec style standard
  const CityListItem({
    Key? key,
    required this.city,
    required this.onTap,
    this.isSelected = false,
    this.secondaryText,
    this.isGooglePlace = false,
  }) : style = CityItemStyle.standard, super(key: key);

  /// Constructeur pour les éléments d'historique
  const CityListItem.history({
    Key? key,
    required this.city,
    required this.onTap,
    this.isSelected = false,
    this.secondaryText,
    this.isGooglePlace = false,
  }) : style = CityItemStyle.history, super(key: key);

  /// Constructeur pour les suggestions
  const CityListItem.suggestion({
    Key? key,
    required this.city,
    required this.onTap,
    this.isSelected = false,
    this.secondaryText,
    this.isGooglePlace = false,
  }) : style = CityItemStyle.suggestion, super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Supprimer toute la section de variation de style
    // Utiliser un style uniforme pour tous les types

    return Semantics(
      label: 'Ville: ${city.cityName}',
      selected: isSelected,
      button: true,
      child: InkWell(
        onTap: onTap,
        // Supprimer le Material avec background
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: AppDimensions.space3,
                horizontal: AppDimensions.space4,
              ),
              child: Row(
                children: [
                  // Pin marker pour tous les éléments
                  Icon(
                    Icons.location_on_outlined,
                    size: AppDimensions.iconSizeM,
                    color: AppColors.accent,
                  ),
                  SizedBox(width: AppDimensions.space3),

                  // Informations textuelles
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          city.cityName,
                          style: AppTypography.label(isDark: isDark).copyWith(
                            color: AppColors.primary,
                            fontWeight: isSelected ? FontWeight.w600 : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (secondaryText != null && secondaryText!.isNotEmpty)
                          Text(
                            secondaryText!,
                            style: AppTypography.caption(
                              isDark: isDark,
                              isSecondary: true,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                      ],
                    ),
                  ),

                  // Indicateur de sélection
                  if (isSelected)
                    Icon(
                      Icons.check,
                      color: AppColors.primary,
                      size: AppDimensions.iconSizeM,
                    ),
                ],
              ),
            ),

            // Trait de séparation discret
            Divider(
              height: 1,
              thickness: 0.5,
              color: isDark
                  ? AppColors.neutral700.withOpacity(0.5)
                  : AppColors.neutral300.withOpacity(0.5),
              indent: AppDimensions.space12,
              endIndent: AppDimensions.space4,
            ),
          ],
        ),
      ),
    );
  }
}