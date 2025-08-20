// lib/features/favorites/presentation/widgets/favorites_header.dart

import 'package:flutter/material.dart';
import 'package:travel_in_perigord_app/core/theme/app_typography.dart';
import 'package:travel_in_perigord_app/core/theme/app_dimensions.dart';
import 'package:travel_in_perigord_app/core/theme/app_colors.dart';

class FavoritesHeader extends StatelessWidget {
  const FavoritesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Mes favoris', style: AppTypography.titleS(isDark: isDark)),
        const SizedBox(height: AppDimensions.spacingXxxs),
        Text(
          'Vos activités et événements enregistrés',
          style: AppTypography.caption(isDark: isDark, isSecondary: true).copyWith(
            color: isDark ? Colors.white70 : AppColors.neutral500,
          ),
        ),
      ],
    );
  }
}
