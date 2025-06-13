// lib/core/theme/extensions/action_tokens.dart

import 'package:flutter/material.dart';
import '../app_colors.dart';

@immutable
class ActionTokens extends ThemeExtension<ActionTokens> {
  final Color iconColor;
  final Color textColor;
  final double iconSize;
  final TextDecoration textDecoration;
  final EdgeInsets padding;

  const ActionTokens({
    required this.iconColor,
    required this.textColor,
    required this.iconSize,
    required this.textDecoration,
    required this.padding,
  });

  static ActionTokens light() {
    return const ActionTokens(
      iconColor: AppColors.accent,
      textColor: AppColors.primaryDark,
      iconSize: 20,
      textDecoration: TextDecoration.underline,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }

  static ActionTokens dark() {
    return const ActionTokens(
      iconColor: AppColors.accent,
      textColor: AppColors.primary,
      iconSize: 20,
      textDecoration: TextDecoration.underline,
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
    );
  }

  @override
  ActionTokens copyWith({
    Color? iconColor,
    Color? textColor,
    double? iconSize,
    TextDecoration? textDecoration,
    EdgeInsets? padding,
  }) {
    return ActionTokens(
      iconColor: iconColor ?? this.iconColor,
      textColor: textColor ?? this.textColor,
      iconSize: iconSize ?? this.iconSize,
      textDecoration: textDecoration ?? this.textDecoration,
      padding: padding ?? this.padding,
    );
  }

  @override
  ActionTokens lerp(ActionTokens? other, double t) {
    if (other is! ActionTokens) {
      return this;
    }
    return this;
  }
}