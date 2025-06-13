// lib/features/experience_detail/presentation/molecules/hero_image_carousel.dart

import 'package:flutter/material.dart';
import '../../../../core/common/utils/caching_image_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../atoms/hero_image.dart';

/// ✅ MOLECULE : Transition progressive Hero → Carousel avec pré-paint GPU complet
class HeroImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final String heroTag;
  final ValueChanged<int>? onPageChanged;
  final bool enableCarousel;
  final double height;

  const HeroImageCarousel({
    Key? key,
    required this.imageUrls,
    required this.heroTag,
    this.onPageChanged,
    this.enableCarousel = true,
    this.height = 400.0,
  }) : super(key: key);

  @override
  State<HeroImageCarousel> createState() => _HeroImageCarouselState();
}

class _HeroImageCarouselState extends State<HeroImageCarousel> {
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _precacheImages();

    // ✅ Warm-up GPU de départ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _warmUpGpu(1); // Première image suivante
    });
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Une seule image = Hero simple
    if (widget.imageUrls.length <= 1) {
      return _buildSingleHeroImage();
    }

    // ✅ Carousel pas encore activé = Hero simple sur première image
    if (!widget.enableCarousel) {
      return _buildSingleHeroImage();
    }

    // ✅ Carousel activé = PageView avec pré-paint GPU complet
    return _buildCarouselWithHero();
  }

  /// ✅ ATOM : Hero simple
  Widget _buildSingleHeroImage() {
    return SizedBox(
      height: widget.height,
      child: HeroImage(
        tag: widget.heroTag,
        url: widget.imageUrls.first,
        fit: BoxFit.cover,
      ),
    );
  }

  /// ✅ Carousel avec pré-paint GPU complet (CPU + GPU)
  Widget _buildCarouselWithHero() {
    return SizedBox(
      height: widget.height,
      child: PageView.builder(
        controller: PageController(keepPage: true),
        itemCount: widget.imageUrls.length,
        // ✅ 1. Pré-paint des pages adjacentes
        allowImplicitScrolling: true,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) => _buildCarouselItem(index),
      ),
    );
  }

  /// ✅ 2. Gestion changement de page avec warm-up GPU
  void _onPageChanged(int index) {
    // ✅ Warm-up des images adjacentes
    _warmUpGpu(index + 1);
    _warmUpGpu(index - 1);

    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
      widget.onPageChanged?.call(index);
    }
  }

  /// ✅ 2. Warm-up GPU pour index ± 1
  void _warmUpGpu(int index) {
    if (index < 0 || index >= widget.imageUrls.length) return;

    final entry = OverlayEntry(
      builder: (_) => Offstage(
        child: RepaintBoundary(
          child: Image(
            image: CachingImageProvider.of(widget.imageUrls[index]),
            fit: BoxFit.cover,
            gaplessPlayback: true,
          ),
        ),
      ),
    );

    Overlay.of(context).insert(entry);
    WidgetsBinding.instance.addPostFrameCallback((_) => entry.remove());
  }

  /// ✅ 3. Slide protégée avec RepaintBoundary
  Widget _buildCarouselItem(int index) {
    final imageUrl = widget.imageUrls[index];
    final isFirst = index == 0;

    return RepaintBoundary(
      child: isFirst
          ? HeroImage(
        tag: widget.heroTag,
        url: imageUrl,
        fit: BoxFit.cover,
      )
          : Image(
        image: CachingImageProvider.of(imageUrl),
        fit: BoxFit.cover,
        gaplessPlayback: true,
        loadingBuilder: _buildLoadingWidget,
        errorBuilder: _buildErrorWidget,
      ),
    );
  }

  /// ✅ Loading minimal
  Widget _buildLoadingWidget(BuildContext context, Widget child, ImageChunkEvent? loadingProgress) {
    if (loadingProgress == null) return child;
    return Container(color: AppColors.neutral100);
  }

  /// ✅ Error builder
  Widget _buildErrorWidget(BuildContext context, Object error, StackTrace? stackTrace) {
    return Container(
      color: AppColors.neutral300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_not_supported, color: AppColors.neutral700, size: 48),
          const SizedBox(height: 8),
          Text(
            'Image non disponible',
            style: TextStyle(color: AppColors.neutral700, fontSize: 14),
          ),
        ],
      ),
    );
  }

  /// ✅ Précache toutes les images dès l'initialisation
  void _precacheImages() {
    if (widget.imageUrls.length <= 1) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      CachingImageProvider.precacheMultiple(
        widget.imageUrls,
        context,
        cacheWidth: 800,
        cacheHeight: 600,
        maxConcurrent: 3,
      );
    });
  }
}