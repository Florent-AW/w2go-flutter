// lib/core/theme/components/atoms/circle_back_button.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';

class CircleBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? iconColor;
  final double size;
  final double iconSize;
  final EdgeInsets? padding;
  final String? tooltip;

  const CircleBackButton({
    Key? key,
    this.onPressed,
    this.backgroundColor,
    this.iconColor,
    this.size = 40.0,
    this.iconSize = 20.0,
    this.padding,
    this.tooltip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: tooltip ?? MaterialLocalizations.of(context).backButtonTooltip,
      child: Padding(
        padding: padding ?? EdgeInsets.all(AppDimensions.spacingXs),
        child: Material(
          color: backgroundColor ?? Colors.white,
          elevation: 2.0,
          shadowColor: Colors.black26,
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onPressed ?? () => Navigator.maybePop(context),
            splashColor: AppColors.primary.withOpacity(0.1),
            highlightColor: AppColors.primary.withOpacity(0.05),
            child: SizedBox(
              width: size,
              height: size,
              child: Center(
                child: Icon(
                  Icons.arrow_back,
                  color: iconColor ?? AppColors.primary,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}