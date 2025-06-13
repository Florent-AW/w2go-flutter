// lib/features/shared_ui/presentation/widgets/atoms/activity_image.dart

import 'package:flutter/material.dart';
import '../../../../../core/common/utils/caching_image_provider.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../atoms/image_placeholders.dart';

class ActivityImage extends StatelessWidget {
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
    // ✅ Specs EXACTES de l'expert Adam : Image.network + optimisations GPU
    final image = imageUrl.isNotEmpty
        ? Image(
      image: CachingImageProvider.of(imageUrl), // ✅ SINGLETON - même instance partout
      gaplessPlayback: true, // ✅ Anti-flash critique
      filterQuality: FilterQuality.medium, // ✅ Performance GPU
      fit: fit,
      height: height,
      width: width ?? double.infinity,
      errorBuilder: (context, error, stackTrace) {
        return ErrorImagePlaceholder(height: height, width: width);
      },
    )
        : LoadingImagePlaceholder(height: height, width: width);

    // Si heroTag fourni, wrapper avec Hero optimisé
    if (heroTag != null) {
      return Hero(
        tag: heroTag!,
        // ✅ Optimisations Hero selon experts
        placeholderBuilder: (context, heroSize, child) => child,
        flightShuttleBuilder: (flightContext, animation, flightDirection, fromHeroContext, toHeroContext) {
          return Container(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(AppDimensions.radiusM), // ✅ Cohérent
              child: Image(
                image: CachingImageProvider.of(imageUrl),
                gaplessPlayback: true,
                filterQuality: FilterQuality.medium,
                fit: fit,
                height: height,
                width: width ?? double.infinity,
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