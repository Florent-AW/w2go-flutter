// lib/core/theme/components/molecules/location_button.dart

import 'package:flutter/material.dart';
import '../atoms/text_icon_button.dart';

class LocationButton extends StatelessWidget {
  final VoidCallback onTap;

  const LocationButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextIconButton(
      text: 'Utiliser ma position actuelle',
      icon: Icons.my_location_rounded,
      onTap: onTap,
      iconLeading: true,
    );
  }
}