// lib/features/shared_ui/presentation/widgets/atoms/activity_image.dart

import 'package:flutter/material.dart';
import '../../../../../core/common/utils/caching_image_provider.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/common/utils/viewport_clamped_rect_tween_mixin.dart';
import '../atoms/image_placeholders.dart';

class ActivityImage extends StatelessWidget with ViewportClampedRectTweenMixin {
  final String imageUrl;
  final double height;
  final double? width;
  final BoxFit fit;
  final String? heroTag;

  const ActivityImage({
    Key? key,
    required this.imageUrl,
    required this.height,
    this.width,
    this.fit = BoxFit.cover,
    this.heroTag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // ✅ Provider simple - PAS de dimensions complexes
    final imageProvider = imageUrl.isNotEmpty
        ? CachingImageProvider.of(imageUrl)
        : null;

    // ✅ Image avec frameBuilder anti-flash (logique inchangée)
    final image = imageUrl.isNotEmpty
        ? Image(
      image: imageProvider!,
      gaplessPlayback: true,
      filterQuality: FilterQuality.medium,
      fit: fit,
      height: height,
      width: width ?? double.infinity,
      // ✅ CRITIQUE : frameBuilder pour éliminer flash première frame
      frameBuilder: (context, child, frame, wasSnychronouslyLoaded) {
        // Si image en cache RAM → affichage instantané
        if (wasSnychronouslyLoaded || frame != null) {
          return child;
        }
        // Sinon placeholder stable (pas de shimmer flash)
        return LoadingImagePlaceholder(height: height, width: width);
      },
      errorBuilder: (context, error, stackTrace) {
        return ErrorImagePlaceholder(height: height, width: width);
      },
    )
        : LoadingImagePlaceholder(height: height, width: width);

    // ✅ Hero logic reste identique mais utilise même provider
    if (heroTag != null && imageProvider != null) {
      return Hero(
        tag: heroTag!,
        createRectTween: (b, e) => viewportClampedRectTween(b, e, context),
        placeholderBuilder: (context, heroSize, child) => child,
        flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
          return Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM),
              child: Image(
                image: imageProvider, // ✅ MÊME provider
                gaplessPlayback: true,
                filterQuality: FilterQuality.medium,
                fit: fit,
                height: height,
                width: width ?? double.infinity,
                frameBuilder: (context, child, frame, wasSnychronouslyLoaded) {
                  return wasSnychronouslyLoaded || frame != null
                      ? child
                      : LoadingImagePlaceholder(height: height, width: width);
                },
                errorBuilder: (context, error, stackTrace) {
                  return ErrorImagePlaceholder(height: height, width: width);
                },
              ),
            ),
          );
        },
        child: image,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDimensions.radiusS),
      child: image,
    );
  }
}