// lib/features/activity_detail/presentation/molecules/info_item_tile.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/domain/models/shared/info_item.dart';

class InfoItemTile extends StatelessWidget {
  final InfoItem item;

  const InfoItemTile({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        vertical: AppDimensions.spacingXxxs,  // ✅ Padding vertical seulement
      ),
      child: Row(
        children: [
          // Icône alignée à gauche
          Icon(
            _getIconData(item.iconName),
            size: AppDimensions.iconSizeSM,
            color: item.valueColor ?? AppColors.primary,
          ),

          SizedBox(width: AppDimensions.spacingXs),

          // Contenu
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Valeur
                Text(
                  item.value,
                  style: AppTypography.caption(isDark: isDark).copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),

                // Subtitle optionnel
                if (item.subtitle != null) ...[
                  SizedBox(height: AppDimensions.spacingXxxs),
                  Text(
                    item.subtitle!,
                    style: AppTypography.caption(
                      isDark: isDark,
                      isSecondary: true,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Map string iconName vers IconData Lucide
  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'users':
        return LucideIcons.users;
      case 'calendar-check':
        return LucideIcons.calendarCheck;
      case 'clock':
        return LucideIcons.clock;
      case 'euro':
        return LucideIcons.euro;
      case 'wheelchair':
        return LucideIcons.accessibility;
      case 'clock-3':
        return LucideIcons.clock3;
      default:
        return LucideIcons.info;
    }
  }
}