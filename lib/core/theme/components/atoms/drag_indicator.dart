// lib/core/theme/components/atoms/drag_indicator.dart

import 'package:flutter/material.dart';
import '../../app_colors.dart';
import '../../app_dimensions.dart';

class DragIndicator extends StatelessWidget {
  final Color? color;

  const DragIndicator({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: color ?? (isDark ? AppColors.neutral600 : AppColors.neutral300),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}