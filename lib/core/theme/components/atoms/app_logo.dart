// lib/core/theme/components/atoms/app_logo.dart

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../app_colors.dart';
import '../../app_dimensions.dart';

enum LogoSize {
  small,
  medium,
  large,
}

class AppLogo extends StatelessWidget {
  final LogoSize size;
  final bool showTagline;

  const AppLogo({
    Key? key,
    this.size = LogoSize.medium,
    this.showTagline = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Taille du logo selon l'enum, avec scaling responsive
    final double baseSize = switch (size) {
      LogoSize.small => 120,
      LogoSize.medium => 180,
      LogoSize.large => 240,
    };

    // Calculer taille relative à l'écran
    final screenWidth = MediaQuery.of(context).size.width;
    final logoWidth = AppDimensions.responsiveSize(
      context,
      small: baseSize * 0.8,
      medium: baseSize,
      large: baseSize * 1.1,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Utilisation du SVG pour le logo
        SvgPicture.asset(
          'assets/logos/Where2go.svg',
          width: logoWidth,
        ),

        // Tagline optionnelle
        if (showTagline) ...[
          SizedBox(height: AppDimensions.space3),
          Text(
            'Choisissez votre ville',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.neutral50,
            ),
          ),
        ],
      ],
    );
  }
}