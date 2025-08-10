// lib/features/experience_detail/presentation/molecules/infinite_image_carousel.dart

import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import '../../../../core/common/utils/caching_image_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/common/utils/viewport_clamped_rect_tween_mixin.dart';
import '../atoms/carousel_indicator.dart';

/// Widget pour afficher un carousel d'images en mode infini
class InfiniteImageCarousel extends StatefulWidget {
  final String heroTag;                 // ✅ CORRECTION : tag unique pour le premier slide
  final List<String> imageUrls;
  final BoxFit imageFit;
  final String experienceId;
  final double? height;

  const InfiniteImageCarousel({
    Key? key,
    required this.heroTag,              // ✅ CORRECTION : paramètre obligatoire
    required this.imageUrls,
    required this.experienceId,
    this.imageFit = BoxFit.cover,
    this.height,
  }) : super(key: key);

  @override
  State<InfiniteImageCarousel> createState() => _InfiniteImageCarouselState();
}

class _InfiniteImageCarouselState extends State<InfiniteImageCarousel>
    with ViewportClampedRectTweenMixin {
  late InfiniteScrollController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = InfiniteScrollController(initialItem: 0);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return _buildPlaceholder();
    }

    return Stack(
      children: [
        // Carousel principal
        InfiniteCarousel.builder(
          controller: _controller,
          itemCount: widget.imageUrls.length,
          itemExtent: MediaQuery.of(context).size.width,
          onIndexChanged: (index) {
            if (mounted) {
              setState(() {
                _currentIndex = index;
              });
            }
          },
          itemBuilder: (context, index, realIndex) {
            return _buildImageItem(widget.imageUrls[index], index);
          },
        ),

        // Indicateurs si plusieurs images
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: CarouselIndicator(
              itemCount: widget.imageUrls.length,  // ✅ CORRECTION
              currentIndex: _currentIndex,
            ),
          ),
      ],
    );
  }

  Widget _buildImageItem(String imageUrl, int index) {
    final isFirst = index == 0;
    final tag = isFirst
        ? widget.heroTag
        : 'carousel-${widget.experienceId}-$index';

    return Hero(
      tag: tag,
      createRectTween: (b, e) => viewportClampedRectTween(b, e, context),
      // ✅ Placeholder neutre pendant le vol pour éviter tout double affichage
      placeholderBuilder: (_, __, ___) => SizedBox(
        width: double.infinity,
        height: widget.height,
      ),
      child: Container(
        width: double.infinity,
        height: widget.height,
        child: Image(
          image: CachingImageProvider.of(imageUrl),
          fit: widget.imageFit,
          gaplessPlayback: true,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Container(
              color: AppColors.neutral100,
              child: Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                      : null,
                  strokeWidth: 2,
                ),
              ),
            );
          },
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

  Widget _buildPlaceholder() {
    return Container(
      width: double.infinity,
      height: widget.height,
      color: AppColors.neutral200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.image_outlined,
            color: AppColors.neutral600,
            size: 64,
          ),
          const SizedBox(height: 16),
          Text(
            'Aucune image disponible',
            style: TextStyle(
              color: AppColors.neutral600,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}