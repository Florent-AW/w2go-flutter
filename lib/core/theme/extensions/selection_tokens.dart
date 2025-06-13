// lib/core/theme/extensions/selection_tokens.dart

import 'package:flutter/material.dart';
import '../app_colors.dart';
import '../app_dimensions.dart';

enum SelectionState {
  selected,
  unselected,
}

@immutable
class SelectionTokens extends ThemeExtension<SelectionTokens> {
  final Map<SelectionState, Color> textColors;
  final Map<SelectionState, Color> iconColors;
  final Color backgroundColor;
  final double height;
  final Color dropdownIconColor;

  const SelectionTokens({
    required this.textColors,
    required this.iconColors,
    required this.backgroundColor,
    required this.height,
    required this.dropdownIconColor,
  });

  static SelectionTokens light() {
    return SelectionTokens(
      textColors: {
        SelectionState.selected: AppColors.neutral50,
        SelectionState.unselected: AppColors.neutral200,
      },
      iconColors: {
        SelectionState.selected: AppColors.accent,
        SelectionState.unselected: AppColors.accent,
      },
      backgroundColor: AppColors.neutral200.withOpacity(0.07),
      height: 50,
      dropdownIconColor: AppColors.neutral200,
    );
  }

  static SelectionTokens dark() {
    return SelectionTokens(
      textColors: {
        SelectionState.selected: AppColors.neutral50,
        SelectionState.unselected: AppColors.neutral200,
      },
      iconColors: {
        SelectionState.selected: AppColors.accent,
        SelectionState.unselected: AppColors.accent,
      },
      backgroundColor: AppColors.neutral700.withOpacity(0.2),
      height: 50,
      dropdownIconColor: AppColors.neutral200,
    );
  }

  @override
  SelectionTokens copyWith({
    Map<SelectionState, Color>? textColors,
    Map<SelectionState, Color>? iconColors,
    Color? backgroundColor,
    double? height,
    Color? dropdownIconColor,
  }) {
    return SelectionTokens(
      textColors: textColors ?? this.textColors,
      iconColors: iconColors ?? this.iconColors,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      height: height ?? this.height,
      dropdownIconColor: dropdownIconColor ?? this.dropdownIconColor,
    );
  }

  @override
  SelectionTokens lerp(SelectionTokens? other, double t) {
    if (other is! SelectionTokens) {
      return this;
    }
    return this;
  }
}