// lib/core/theme/extensions/text_field_tokens.dart

import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_dimensions.dart';

@immutable
class TextFieldTokens extends ThemeExtension<TextFieldTokens> {
  final Color fillColor;
  final Color borderColor;
  final Color focusedBorderColor;
  final double borderRadius;
  final EdgeInsets contentPadding;
  final Color hintTextColor;
  final BoxShadow boxShadow;
  final Color iconColor;

  const TextFieldTokens({
    required this.fillColor,
    required this.borderColor,
    required this.focusedBorderColor,
    required this.borderRadius,
    required this.contentPadding,
    required this.hintTextColor,
    required this.boxShadow,
    required this.iconColor,
  });

  static TextFieldTokens light() {
    return TextFieldTokens(
      fillColor: AppColors.neutral50,
      borderColor: Colors.transparent,
      focusedBorderColor: AppColors.primary,
      borderRadius: AppDimensions.radiusM,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space4,
        vertical: AppDimensions.space3,
      ),
      hintTextColor: AppColors.neutral500,
      boxShadow: BoxShadow(
        color: AppColors.neutral900.withOpacity(0.1),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
      iconColor: AppColors.neutral600,
    );
  }

  static TextFieldTokens dark() {
    return TextFieldTokens(
      fillColor: AppColors.neutral800,
      borderColor: Colors.transparent,
      focusedBorderColor: AppColors.primary,
      borderRadius: AppDimensions.radiusM,
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.space4,
        vertical: AppDimensions.space3,
      ),
      hintTextColor: AppColors.neutral500,
      boxShadow: BoxShadow(
        color: AppColors.neutral900.withOpacity(0.2),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
      iconColor: AppColors.neutral400,
    );
  }

  @override
  TextFieldTokens copyWith({
    Color? fillColor,
    Color? borderColor,
    Color? focusedBorderColor,
    double? borderRadius,
    EdgeInsets? contentPadding,
    Color? hintTextColor,
    BoxShadow? boxShadow,
    Color? iconColor,
  }) {
    return TextFieldTokens(
      fillColor: fillColor ?? this.fillColor,
      borderColor: borderColor ?? this.borderColor,
      focusedBorderColor: focusedBorderColor ?? this.focusedBorderColor,
      borderRadius: borderRadius ?? this.borderRadius,
      contentPadding: contentPadding ?? this.contentPadding,
      hintTextColor: hintTextColor ?? this.hintTextColor,
      boxShadow: boxShadow ?? this.boxShadow,
      iconColor: iconColor ?? this.iconColor,
    );
  }

  @override
  TextFieldTokens lerp(TextFieldTokens? other, double t) {
    if (other is! TextFieldTokens) {
      return this;
    }
    return this;
  }
}