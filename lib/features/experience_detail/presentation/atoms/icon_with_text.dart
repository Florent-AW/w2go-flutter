// lib/features/experience_detail/presentation/atoms/icon_with_text.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class IconWithText extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? iconColor;
  final Color? textColor;
  final double iconSize;
  final TextStyle? textStyle;
  final double spacing;

  const IconWithText({
    Key? key,
    required this.icon,
    required this.text,
    this.iconColor,
    this.textColor,
    this.iconSize = 24.0,
    this.textStyle,
    this.spacing = 8.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor ?? AppColors.primary,
          size: iconSize,
        ),
        SizedBox(width: spacing),
        Flexible(
          child: Text(
            text,
            style: textStyle ?? AppTypography.body(
              isDark: Theme.of(context).brightness == Brightness.dark,
              isSecondary: true,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}