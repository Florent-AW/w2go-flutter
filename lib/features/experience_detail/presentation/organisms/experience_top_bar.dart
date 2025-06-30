// lib/features/experience_detail/presentation/organisms/experience_top_bar.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/components/atoms/circle_back_button.dart';

class ExperienceTopBar extends StatelessWidget {
  final String categoryName;
  final VoidCallback onBack;
  final VoidCallback onCategoryTap;
  final bool visible;

  const ExperienceTopBar({
    Key? key,
    required this.categoryName,
    required this.onBack,
    required this.onCategoryTap,
    required this.visible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 200),
      opacity: visible ? 1.0 : 0.0,
      child: Container(
        color: AppColors.blueBackground,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingS,
          vertical: AppDimensions.spacingXxs,
        ),
        child: SafeArea(
          bottom: false,
          child: Row(
            children: [
              CircleBackButton(
                onPressed: onBack,
                backgroundColor: Colors.white,
                iconColor: AppColors.primary,
                size: 36,
                iconSize: 20,
              ),
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: onCategoryTap,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppDimensions.spacingS,
                        vertical: AppDimensions.spacingXxs,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(AppDimensions.radiusM),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.rotate_left,
                              size: 18, color: AppColors.primary),
                          SizedBox(width: AppDimensions.spacingXxs),
                          Text(
                            categoryName,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 36),
            ],
          ),
        ),
      ),
    );
  }
}