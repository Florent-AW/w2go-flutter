// lib/features/shared_ui/presentation/widgets/atoms/activity_tag.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_typography.dart';

class ActivityTag extends StatelessWidget {
  final String label;

  const ActivityTag({
    Key? key,
    required this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spacingXxs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutral100,
        borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      ),
      child: Text(
        label,
        style: AppTypography.caption(
          isDark: false,
          isSecondary: true,
        ).copyWith(
          fontSize: 10.5,
        ),
      ),
    );
  }
}