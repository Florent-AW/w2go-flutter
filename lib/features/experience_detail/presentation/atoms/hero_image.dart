// lib/features/experience_detail/presentation/atoms/hero_image.dart

import 'package:flutter/material.dart';
import '../../../../core/common/utils/caching_image_provider.dart';
import '../../../../core/theme/app_colors.dart';

/// ✅ ATOM : Hero Image optimisé avec CachingImageProvider
class HeroImage extends StatelessWidget {
  const HeroImage({
    Key? key,
    required this.tag,
    required this.url,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
  }) : super(key: key);

  final String tag;
  final String url;
  final BoxFit fit;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: tag,
      // ✅ EXPERT : flightShuttleBuilder avec CachingImageProvider
      flightShuttleBuilder: (_, __, ___, ____, _____) => Image(
        image: CachingImageProvider.of(url),
        fit: fit,
        gaplessPlayback: true,
        width: width,
        height: height,
      ),
      // ✅ EXPERT : placeholderBuilder avec même provider
      placeholderBuilder: (_, __, ___) => Image(
        image: CachingImageProvider.of(url),
        fit: fit,
        gaplessPlayback: true,
        width: width,
        height: height,
      ),
      child: Image(
        image: CachingImageProvider.of(url),
        fit: fit,
        gaplessPlayback: true,
        width: width,
        height: height,
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

  /// ✅ Error builder unifié
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
}