// lib/features/experience_detail/presentation/atoms/cta_button.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

enum CTAButtonStyle {
  primary,
  secondary,
  outline
}

class CTAButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final IconData? icon;
  final CTAButtonStyle style;
  final bool isFullWidth;
  final double height;
  final double borderRadius;
  final bool isLoading;

  const CTAButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.style = CTAButtonStyle.primary,
    this.isFullWidth = false,
    this.height = 48.0,
    this.borderRadius = 24.0,
    this.isLoading = false,
  }) : super(key: key);

  // Constructeurs d'usine pour chaque style
  factory CTAButton.primary({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
  }) {
    return CTAButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: CTAButtonStyle.primary,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
    );
  }

  factory CTAButton.secondary({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
  }) {
    return CTAButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: CTAButtonStyle.secondary,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
    );
  }

  factory CTAButton.outline({
    Key? key,
    required String text,
    required VoidCallback onPressed,
    IconData? icon,
    bool isFullWidth = false,
    bool isLoading = false,
  }) {
    return CTAButton(
      key: key,
      text: text,
      onPressed: onPressed,
      icon: icon,
      style: CTAButtonStyle.outline,
      isFullWidth: isFullWidth,
      isLoading: isLoading,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Définir les couleurs en fonction du style
    final ButtonStyle buttonStyle;

    switch (style) {
      case CTAButtonStyle.primary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minimumSize: Size(isFullWidth ? double.infinity : 0, height),
        );
        break;
      case CTAButtonStyle.secondary:
        buttonStyle = ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: Colors.white,
          elevation: 1,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minimumSize: Size(isFullWidth ? double.infinity : 0, height),
        );
        break;
      case CTAButtonStyle.outline:
        buttonStyle = OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: BorderSide(color: AppColors.primary),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          minimumSize: Size(isFullWidth ? double.infinity : 0, height),
        );
        break;
    }

    // Construction du contenu du bouton
    final Widget content = isLoading
        ? const SizedBox(
      width: 24,
      height: 24,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
      ),
    )
        : Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          const SizedBox(width: 8),
        ],
        Text(
          text,
          style: AppTypography.button(isDark: Theme.of(context).brightness == Brightness.dark),
        ),
      ],
    );

    // Rendu du bouton selon le style
    if (style == CTAButtonStyle.outline) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: content,
      );
    } else {
      return ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: buttonStyle,
        child: content,
      );
    }
  }
}