// lib/core/theme/components/atoms/location_icon.dart

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import '../../app_colors.dart';

/// Atom : Icône de localisation standardisée
class LocationIcon extends StatelessWidget {
  final double size;
  final Color color;

  const LocationIcon({
    Key? key,
    this.size = 20,
    this.color = AppColors.accent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(
      LucideIcons.mapPin,
      size: size,
      color: color,
    );
  }
}