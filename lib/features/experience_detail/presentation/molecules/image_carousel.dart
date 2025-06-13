// lib/features/experience_detail/presentation/molecules/image_carousel.dart

import 'package:flutter/material.dart';
import '../../../../core/common/utils/caching_image_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// ✅ MOLECULE : Carousel d'images simple avec PageView
class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final ValueChanged<int>? onPageChanged;
  final double height;

  const ImageCarousel({
    Key? key,
    required this.imageUrls,
    this.onPageChanged,
    this.height = 400.0,
  }) : super(key: key);

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return _buildPlaceholder();
    }

    return Container(
      height: widget.height,
      child: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          if (mounted) {
            setState(() {
              _currentIndex = index;
            });
            widget.onPageChanged?.call(index);
          }
        },
        itemCount: widget.imageUrls.length,
        itemBuilder: (context, index) {
          return _buildImageItem(widget.imageUrls[index]);
        },
      ),
    );
  }

  /// ✅ Image item simple avec CachingImageProvider
  Widget _buildImageItem(String imageUrl) {
    return Image(
      image: CachingImageProvider.of(imageUrl),
      fit: BoxFit.cover,
      gaplessPlayback: true,
      loadingBuilder: _buildLoadingWidget,
      errorBuilder: _buildErrorWidget,
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

  /// ✅ Placeholder vide
  Widget _buildPlaceholder() {
    return Container(
      height: widget.height,
      color: AppColors.neutral200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.image_outlined, color: AppColors.neutral600, size: 64),
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