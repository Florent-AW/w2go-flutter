// lib/core/theme/components/atoms/search_bar_with_back.dart

import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../app_dimensions.dart';
import '../../app_typography.dart';

/// Barre de recherche avec bouton retour intégré pour une expérience fluide.
/// Suit les principes de Material 3 avec transitions fluides.
class SearchBarWithBack extends StatelessWidget {
  /// Contrôleur de texte pour gérer l'entrée
  final TextEditingController controller;

  /// Callback appelé quand l'utilisateur soumet la recherche
  final ValueChanged<String>? onSubmitted;

  /// Callback appelé à chaque changement de texte
  final ValueChanged<String>? onChanged;

  /// Callback pour le bouton retour
  final VoidCallback onBackPressed;

  /// Texte placeholder quand le champ est vide
  final String hintText;

  /// Paramètre d'accessibilité pour le bouton retour
  final String backButtonLabel;

  final FocusNode? focusNode;


  const SearchBarWithBack({
    Key? key,
    required this.controller,
    required this.onBackPressed,
    this.focusNode,
    this.onSubmitted,
    this.onChanged,
    this.hintText = 'Rechercher une ville...',
    this.backButtonLabel = 'Retour',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: AppDimensions.inputHeightM,
      decoration: BoxDecoration(
        color: isDark ? AppColors.neutral800 : AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
      ),
      child: Row(
        children: [
          // Bouton retour
          Semantics(
            label: backButtonLabel,
            button: true,
            child: Material(
              type: MaterialType.transparency,
              child: InkWell(
                borderRadius: BorderRadius.circular(AppDimensions.radiusCircular),
                onTap: onBackPressed,
                child: Padding(
                  padding: EdgeInsets.all(AppDimensions.space3),
                  child: Icon(
                    Icons.arrow_back,
                    color: isDark ? AppColors.neutral300 : AppColors.neutral700,
                    size: AppDimensions.iconSizeM,
                  ),
                ),
              ),
            ),
          ),

          // Ligne verticale de séparation subtile
          Container(
            height: AppDimensions.inputHeightM * 0.5,
            width: 1,
            color: isDark ? AppColors.neutral700 : AppColors.neutral300,
            margin: EdgeInsets.symmetric(horizontal: AppDimensions.space2),
          ),

          // Champ de recherche
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              textInputAction: TextInputAction.search,
              style: AppTypography.body(isDark: isDark),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTypography.body(
                  isDark: isDark,
                  isSecondary: true,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none, // Pas de bordure au focus
                enabledBorder: InputBorder.none, // Pas de bordure à l'état normal
                contentPadding: EdgeInsets.symmetric(
                  vertical: AppDimensions.space2,
                ),
                isDense: true,
              ),
              onSubmitted: onSubmitted,
              onChanged: onChanged,
            )
          ),

          // Bouton effacer si du texte est présent
          ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller,
            builder: (context, value, child) {
              if (value.text.isNotEmpty) {
                return GestureDetector(
                  onTap: () {
                    controller.clear();
                    if (onChanged != null) onChanged!('');
                  },
                  child: Padding(
                    padding: EdgeInsets.all(AppDimensions.space3),
                    child: Icon(
                      Icons.close,
                      color: isDark ? AppColors.neutral300 : AppColors.neutral700,
                      size: AppDimensions.iconSizeS,
                    ),
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ],
      ),
    );
  }
}