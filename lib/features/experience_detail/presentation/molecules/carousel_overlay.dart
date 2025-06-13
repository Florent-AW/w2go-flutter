// lib/features/experience_detail/presentation/molecules/carousel_overlay.dart

import 'package:flutter/material.dart';
import '../../../../core/theme/components/atoms/circle_back_button.dart';
import '../../../../core/theme/app_colors.dart';
import '../atoms/carousel_indicator.dart';
import '../atoms/swipe_dismiss_detector.dart';

/// ✅ MOLECULE : Overlay avec boutons + indicateurs + swipe detector
class CarouselOverlay extends StatelessWidget {
  final VoidCallback onDismiss;
  final int currentIndex;
  final int totalCount;
  final bool showIndicator;

  const CarouselOverlay({
    Key? key,
    required this.onDismiss,
    required this.currentIndex,
    required this.totalCount,
    this.showIndicator = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // ✅ ATOM : Bouton back
        SafeArea(
          child: Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: CircleBackButton(
                onPressed: onDismiss,
                backgroundColor: Colors.white,
                iconColor: AppColors.primary,
                size: 38,
                iconSize: 20,
              ),
            ),
          ),
        ),

        // ✅ ATOM : Swipe dismiss detector
        SwipeDismissDetector(onDismiss: onDismiss),

        // ✅ ATOM : Indicateur carousel (si plusieurs images)
        if (showIndicator && totalCount > 1)
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: CarouselIndicator(
              itemCount: totalCount,
              currentIndex: currentIndex,
            ),
          ),
      ],
    );
  }
}