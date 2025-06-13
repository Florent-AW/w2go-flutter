// lib/features/shared_ui/presentation/widgets/buttons/back_button_widget.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';

class BackButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final double size;
  final EdgeInsets padding;

  const BackButtonWidget({
    super.key,
    required this.onPressed,
    this.size = 40,
    this.padding = const EdgeInsets.all(8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          customBorder: const CircleBorder(),
          child: Padding(
            padding: padding,
            child: Icon(
              LucideIcons.arrowLeft,
              size: size * 0.5,
              color: AppColors.neutral900,
            ),
          ),
        ),
      ),
    );
  }
}