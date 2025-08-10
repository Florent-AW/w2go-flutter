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
      // ✅ EXPERT : flightShuttleBuilder avec transition en fondu
      flightShuttleBuilder:
          (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
        final fromHero = fromHeroContext.widget as Hero;
        final toHero = toHeroContext.widget as Hero;

        final fromWidget = fromHero.child;
        final toWidget = toHero.child;

        return AnimatedBuilder(
          animation: animation,
          builder: (context, child) {
            return Stack(
              fit: StackFit.passthrough,
              children: [
                Opacity(opacity: 1.0 - animation.value, child: fromWidget),
                Opacity(opacity: animation.value, child: toWidget),
              ],
            );
          },
        );
      },
      // ✅ Place un placeholder neutre pendant le vol pour éviter l'apparition anticipée
      placeholderBuilder: (_, __, ___) => const SizedBox.expand(),
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