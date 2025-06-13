// lib/core/theme/components/molecules/bottom_bar_wrapper.dart

import 'package:flutter/material.dart';
import '../atoms/bottom_bar_container.dart';
import '../../app_colors.dart';
import '../../app_dimensions.dart';

/// Molecule qui combine BottomBarContainer + logique d'état
/// Gère les états loading, error, content
class BottomBarWrapper extends StatelessWidget {
  final Widget content;
  final bool isLoading;
  final Widget? loadingWidget;
  final Widget? errorWidget;
  final EdgeInsets? customPadding;

  const BottomBarWrapper({
    Key? key,
    required this.content,
    this.isLoading = false,
    this.loadingWidget,
    this.errorWidget,
    this.customPadding,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomBarContainer(
      padding: customPadding,
      child: _buildContent(),
    );
  }

  Widget _buildContent() {
    if (isLoading) {
      return loadingWidget ?? _buildDefaultLoadingState();
    }

    return content;
  }

  Widget _buildDefaultLoadingState() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.neutral300,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        SizedBox(width: AppDimensions.spacingS),
        Container(
          width: 120,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.neutral300,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
      ],
    );
  }
}