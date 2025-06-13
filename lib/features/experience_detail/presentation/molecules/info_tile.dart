// lib/features/activity_detail/presentation/molecules/info_tile.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../atoms/icon_with_text.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool hasBorder;
  final Color? backgroundColor;
  final Color? iconColor;
  final EdgeInsets padding;

  const InfoTile({
    Key? key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.onTap,
    this.hasBorder = true,
    this.backgroundColor,
    this.iconColor,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12.0),
      child: Container(
        padding: padding,
        decoration: BoxDecoration(
          color: backgroundColor ?? Colors.transparent,
          border: hasBorder
              ? Border.all(color: AppColors.neutral200)
              : null,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconWithText(
              icon: icon,
              text: title,
              iconColor: iconColor ?? AppColors.primary,
              textStyle: AppTypography.subtitle(
                isDark: Theme.of(context).brightness == Brightness.dark,
              ).copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4.0),
              Padding(
                padding: const EdgeInsets.only(left: 32.0),
                child: Text(
                  subtitle!,
                  style: AppTypography.caption(
                    isDark: Theme.of(context).brightness == Brightness.dark,
                    isSecondary: false,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}