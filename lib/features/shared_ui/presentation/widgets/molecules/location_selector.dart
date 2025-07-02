// lib/features/shared_ui/presentation/widgets/molecules/location_selector.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/components/atoms/location_icon.dart';
import 'city_picker.dart';

/// Molecule : Sélecteur de localisation avec icône + city picker
class LocationSelector extends ConsumerWidget {
  final bool showIcon;
  final TextStyle? textStyle;
  final Color? iconColor;

  const LocationSelector({
    Key? key,
    this.showIcon = true,
    this.textStyle,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showIcon) ...[
          LocationIcon(color: iconColor ?? AppColors.accent),
          SizedBox(width: AppDimensions.spacingXxs),
        ],
        CityPicker(
          textStyle: textStyle,
          iconColor: iconColor ?? Colors.white,
        ),
      ],
    );
  }
}