// lib/core/theme/components/atoms/bottom_bar_container.dart

import 'package:flutter/material.dart';
import '../../app_dimensions.dart';

/// Container atomique pour les bottom bars de l'application
/// Fournit le style de base : padding, ombres, couleurs
class BottomBarContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final List<BoxShadow>? customShadows;
  final Color? backgroundColor;

  const BottomBarContainer({
    Key? key,
    required this.child,
    this.padding,
    this.customShadows,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.only(
        left: 0,
        right: 0,
        bottom: AppDimensions.spacingXxs,
        top: 0,
      ),
      decoration: BoxDecoration(
        color: backgroundColor ?? Theme.of(context).scaffoldBackgroundColor,
        boxShadow: customShadows ?? [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: child,
      ),
    );
  }
}