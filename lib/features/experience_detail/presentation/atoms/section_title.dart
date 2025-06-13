// lib/features/experience_detail/presentation/atoms/section_title.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/theme/app_colors.dart';

class SectionTitle extends StatelessWidget {
  final String title;
  final TextAlign alignment;
  final Color? color;
  final bool hasUnderline;
  final VoidCallback? onMorePressed;
  final String? moreText;

  const SectionTitle({
    Key? key,
    required this.title,
    this.alignment = TextAlign.left,
    this.color,
    this.hasUnderline = false,
    this.onMorePressed,
    this.moreText = 'Voir plus',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                title,
                style: AppTypography.subtitle(
                  isDark: Theme.of(context).brightness == Brightness.dark,
                ).copyWith(
                  fontWeight: FontWeight.w600,
                ),
                textAlign: alignment,
              ),
            ),
            if (onMorePressed != null)
              TextButton(
                onPressed: onMorePressed,
                child: Text(
                  moreText!,
                  style: AppTypography.buttonS(
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ).copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
          ],
        ),
        if (hasUnderline)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Container(
              height: 2,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
      ],
    );
  }
}