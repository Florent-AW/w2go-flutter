// lib/core/theme/components/atoms/location_info.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../app_colors.dart';
import '../../app_dimensions.dart';
import '../../app_typography.dart';

class LocationInfo extends StatelessWidget {
  final String city;
  final double iconSize;
  final Color? iconColor;
  final TextStyle? textStyle;
  final int maxLines;

  const LocationInfo({
    Key? key,
    required this.city,
    this.iconSize = 12.0,
    this.iconColor,
    this.textStyle,
    this.maxLines = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          LucideIcons.mapPin,
          color: iconColor ?? AppColors.primary,
          size: iconSize,
        ),
        SizedBox(width: AppDimensions.spacingXxxs), // 4px
        Flexible(
          child: Text(
            city,
            style: textStyle ?? AppTypography.caption(
              isDark: false,
              isSecondary: true,
            ),
            maxLines: maxLines,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}