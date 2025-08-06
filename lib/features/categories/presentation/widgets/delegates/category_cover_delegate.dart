// lib/features/categories/presentation/widgets/delegates/category_cover_delegate.dart

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:async/async.dart';
import 'dart:math' as math;
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/common/utils/image_provider_factory.dart';
import '../../constants/ui_constants.dart';
import '../../controllers/cover_controller.dart';

/// Délégué pour l'affichage de la couverture de catégorie avec comportement de défilement
class CategoryCoverDelegate extends SliverPersistentHeaderDelegate {
  final CategoryViewModel category;
  final CategoryViewModel? previousCategory;
  final bool isAnimating;
  final Function(bool)? onAnimationStateChanged;
  final BuildContext? contextRef;
  final CoverController controller;

  // Pour le précachage des images
  CancelableOperation<void>? _precacheOperation;

  final double _maxExtent;

  CategoryCoverDelegate({
    required this.category,
    this.previousCategory,
    this.isAnimating = false,
    this.onAnimationStateChanged,
    required double screenHeight,
    this.contextRef,
    required this.controller,
  }) : _maxExtent = screenHeight * CategoryUIConstants.coverHeight {
    // Debug : log la hauteur maximale attendue
  }


  @override
  double get minExtent => _maxExtent;

  @override
  double get maxExtent => _maxExtent;

  @override
  Widget build(
      BuildContext context,
      double shrinkOffset,
      bool overlapsContent,
      ) {
    // Calculer l'opacité du scrim en fonction du scroll (avec clamping)
    final double scrollPercentage = (_maxExtent - shrinkOffset).clamp(0.0, _maxExtent) / _maxExtent;
    final double scrimOpacity = (0.4 + (scrollPercentage * 0.3)).clamp(0.0, 1.0);

    return SizedBox.expand(
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ✅ Image de fond avec displayCoverUrl (déjà précachée)
          Positioned.fill(
            child: Container(
              key: ValueKey<String>("${category.id}_${controller.displayCoverUrl}"),
              width: double.infinity,
              height: double.infinity,
              child:
              Image(
                image: ImageProviderFactory.coverProvider(controller.displayCoverUrl, category.id),
                fit: BoxFit.cover,
                frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded || frame != null) {
                    return child;
                  }
                  return Container(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  );
                },
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  child: Center(
                    child: Icon(
                      Icons.image_not_supported,
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Gradient du haut (inchangé)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.blueBackground.withOpacity(0.6),
                    AppColors.blueBackground.withOpacity(0.3),
                    Colors.transparent,
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Scrim dynamique (inchangé)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.transparent,
                    AppColors.blueBackground.withOpacity(scrimOpacity),
                    AppColors.blueBackground
                        .withOpacity((scrimOpacity + 0.3).clamp(0.0, 1.0)),
                  ],
                  stops: const [0.0, 0.7, 1.0],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Précache l'image pour une transition fluide
  void _precacheImage(BuildContext context, String imageUrl, int cacheWidth) {
    // Annuler l'opération précédente si elle existe
    _precacheOperation?.cancel();

    if (imageUrl.isNotEmpty) {
      _precacheOperation = CancelableOperation.fromFuture(
        precacheImage(
          CachedNetworkImageProvider(
            imageUrl,
            cacheKey: 'category_cover_${category.id}',
          ),
          context,
        ),
      );
    }
  }

  @override
  bool shouldRebuild(covariant CategoryCoverDelegate oldDelegate) {
    // Si la catégorie change, déclencher le précachage au prochain frame
    if (oldDelegate.category.id != category.id && contextRef != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _precacheImage(contextRef!, category.imageUrl, 0);
      });
    }

    // Optimisation importante: ne reconstruire que si nécessaire
    return oldDelegate.category.id != category.id ||
        oldDelegate.isAnimating != isAnimating;
  }

  @override
  void dispose() {
    // Important: annuler les opérations asynchrones pour éviter les fuites
    _precacheOperation?.cancel();
  }
}