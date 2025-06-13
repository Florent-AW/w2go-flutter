// lib/features/shared_ui/presentation/widgets/molecules/activity_category_label.dart
import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_typography.dart';
import '../../../../../core/common/constants/subcategory_icons.dart';

class ActivityCategoryLabel extends StatelessWidget {
  final String category;
  final String? subcategoryIcon;
  final String? subcategoryName;

  const ActivityCategoryLabel({
    Key? key,
    required this.category,
    this.subcategoryIcon,
    this.subcategoryName,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          SubcategoryIcons.getIcon(subcategoryIcon ?? category),
          size: 14,
          color: AppColors.primary,
        ),
        const SizedBox(width: 6),
        Text(
          subcategoryName ?? category,
          style: AppTypography.caption(
            isDark: false,
            isSecondary: false,
          ).copyWith(
            color: AppColors.primary,
            letterSpacing: -0.05,
          ),
        ),
      ],
    );
  }
}