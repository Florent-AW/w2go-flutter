// lib/features/experience_detail/presentation/molecules/experience_header_carousel.dart

import 'package:flutter/material.dart';
import '../molecules/hero_image_carousel.dart';
import '../molecules/carousel_overlay.dart';

/// ✅ ORGANISM : Orchestrateur simple selon Atomic Design
class ExperienceHeaderCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final String heroTag;
  final String experienceId;
  final VoidCallback onDismiss;
  final bool showCarousel;

  const ExperienceHeaderCarousel({
    Key? key,
    required this.imageUrls,
    required this.heroTag,
    required this.experienceId,
    required this.onDismiss,
    this.showCarousel = false,
  }) : super(key: key);

  @override
  State<ExperienceHeaderCarousel> createState() => _ExperienceHeaderCarouselState();
}

class _ExperienceHeaderCarouselState extends State<ExperienceHeaderCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 400,
      child: Stack(
        children: [
          // ✅ MOLECULE : Carousel d'images avec Hero
          HeroImageCarousel(
            imageUrls: widget.imageUrls,
            heroTag: widget.heroTag,
            enableCarousel: widget.showCarousel,
            onPageChanged: (index) {
              if (mounted) {
                setState(() {
                  _currentIndex = index;
                });
              }
            },
          ),

          // ✅ MOLECULE : Overlay avec contrôles
          CarouselOverlay(
            onDismiss: widget.onDismiss,
            currentIndex: _currentIndex,
            totalCount: widget.imageUrls.length,
            showIndicator: widget.showCarousel,
          ),
        ],
      ),
    );
  }
}