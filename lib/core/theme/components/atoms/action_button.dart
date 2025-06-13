// lib/core/theme/components/atoms/action_button.dart

import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../app_typography.dart';
import '../../app_dimensions.dart';
import '../../app_interactions.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onPressed;

  const ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppInteractions.addCompactRipple(
      onTap: onPressed,
      rippleColor: AppColors.primary,
      debugMode: false, // Mettre true pour debug
      child: Opacity(
        opacity: onPressed != null ? 1.0 : 0.5,
        child: Container(
          padding: EdgeInsets.symmetric(
            vertical: AppDimensions.spacingXxs,
          ),          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.primary,
                size: AppDimensions.iconSizeM,
              ),
              Text(
                label,
                style: AppTypography.buttonS(
                  isDark: Theme.of(context).brightness == Brightness.dark,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}