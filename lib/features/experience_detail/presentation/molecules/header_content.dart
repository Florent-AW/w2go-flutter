// lib/features/experience_detail/presentation/molecules/header_content.dart

import 'package:flutter/material.dart';
import '../../../../core/common/utils/caching_image_provider.dart';
import '../../../../core/theme/app_colors.dart';
import 'infinite_image_carousel.dart';

/// Widget qui gère le progressive loading du header :
/// Phase 1 (Hero en vol) : Image simple du premier slide
/// Phase 2 (Hero terminé) : Carrousel complet
class HeaderContent extends StatefulWidget {
  const HeaderContent({
    Key? key,
    required this.imageUrls,
    required this.heroTag,
    required this.experienceId,
  }) : super(key: key);

  final List<String> imageUrls;
  final String heroTag;
  final String experienceId;

  @override
  State<HeaderContent> createState() => _HeaderContentState();
}

class _HeaderContentState extends State<HeaderContent> {
  bool _showCarousel = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    print('🎠 HEADER CONTENT: Écoute de l\'animation de route');

    // Quand l'animation de route se termine → on affiche le carrousel
    final routeAnimation = ModalRoute.of(context)?.animation;
    if (routeAnimation != null) {
      routeAnimation.addStatusListener(_onAnimationStatusChanged);
    }
  }

  void _onAnimationStatusChanged(AnimationStatus status) {
    print('🎠 HEADER CONTENT: Animation status = $status');

    if (status == AnimationStatus.completed && mounted) {
      print('🎠 HEADER CONTENT: Animation terminée → Switch vers carrousel');
      setState(() {
        _showCarousel = true;
      });
    }
  }

  @override
  void dispose() {
    // Nettoyer le listener
    final routeAnimation = ModalRoute.of(context)?.animation;
    if (routeAnimation != null) {
      routeAnimation.removeStatusListener(_onAnimationStatusChanged);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('🎠 HEADER CONTENT: Build - showCarousel = $_showCarousel');

    // Phase 1 : Simple image (cache déjà préchargé)
    if (!_showCarousel) {
      print('🖼️ HEADER CONTENT: Phase 1 - Image simple du premier slide');
      return Hero(
        tag: widget.heroTag,
        createRectTween: (begin, end) => MaterialRectCenterArcTween(begin: begin, end: end),
        placeholderBuilder: (_, __, ___) => const SizedBox.expand(),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          child: Image(
            image: CachingImageProvider.of(widget.imageUrls.first),
            fit: BoxFit.cover,
            gaplessPlayback: true,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: AppColors.neutral300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image_not_supported, color: AppColors.neutral700, size: 48),
                    const SizedBox(height: 8),
                    Text('Image non disponible', style: TextStyle(color: AppColors.neutral700, fontSize: 14)),
                  ],
                ),
              );
            },
          ),
        ),
      );
    }

    // Phase 2 : Carrousel complet (Hero déjà terminé)
    print('🎠 HEADER CONTENT: Phase 2 - Carrousel complet');
    return InfiniteImageCarousel(
      heroTag: widget.heroTag,
      imageUrls: widget.imageUrls,
      experienceId: widget.experienceId,
      imageFit: BoxFit.cover,
    );
  }
}