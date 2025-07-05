// lib/features/categories/presentation/widgets/delegates/category_cover_delegate.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:async/async.dart';
import 'dart:math' as math;
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../../core/domain/ports/providers/search/category_covers_provider.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_interactions.dart';
import '../../constants/ui_constants.dart';

/// Délégué pour l'affichage de la couverture de catégorie avec comportement de défilement
class CategoryCoverDelegate extends SliverPersistentHeaderDelegate {
  final CategoryViewModel category;
  final CategoryViewModel? previousCategory;
  final bool isAnimating;
  final Function(bool)? onAnimationStateChanged;
  final BuildContext? contextRef;

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
          // Image de fond avec animation de transition
          Positioned.fill(
            child: AnimatedSwitcher(
              duration: AppInteractions.categoryFadeDuration,
              child: Consumer(
                builder: (context, ref, _) {
                  // Observer l'URL de couverture optimale pour la catégorie
                  final coverUrlAsync = ref.watch(
                      categoryDepartmentCoverProvider(category)
                  );

                  return coverUrlAsync.when(
                    data: (coverUrl) {
                      // La nouvelle URL a été chargée avec succès
                      return Container(
                        key: ValueKey<String>("${category.id}_$coverUrl"),
                        width: double.infinity,
                        height: double.infinity,
                        child: CachedNetworkImage(
                          imageUrl: coverUrl,
                          fit: BoxFit.cover,
                          cacheKey: 'category_cover_${category.id}_$coverUrl',
                          fadeInDuration: AppInteractions.categoryFadeDuration,
                          placeholder: (context, url) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            child: Center(
                              child: Icon(
                                Icons.image_not_supported,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    loading: () => Container(
                      key: ValueKey<String>(category.id),
                      width: double.infinity,
                      height: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: category.imageUrl,
                        fit: BoxFit.cover,
                        cacheKey: 'category_cover_${category.id}',
                        fadeInDuration: AppInteractions.categoryFadeDuration,
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        errorWidget: (context, url, error) => Container(
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
                    error: (_, __) => Container(
                      key: ValueKey<String>(category.id),
                      width: double.infinity,
                      height: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: category.imageUrl,
                        fit: BoxFit.cover,
                        cacheKey: 'category_cover_${category.id}',
                        fadeInDuration: AppInteractions.categoryFadeDuration,
                        placeholder: (context, url) => Container(
                          color: Theme.of(context).colorScheme.surfaceVariant,
                        ),
                        errorWidget: (context, url, error) => Container(
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
                  );
                },
              ),
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100, // Hauteur fixe de 100px
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // Même bleu que le dégradé du bas
                    AppColors.blueBackground.withOpacity(0.6), // Plus opaque en haut
                    AppColors.blueBackground.withOpacity(0.3), // Semi-opaque au milieu
                    Colors.transparent, // Complètement transparent en bas
                  ],
                  stops: const [0.0, 0.5, 1.0],
                ),
              ),
            ),
          ),

          // Scrim dynamique pour garantir la lisibilité et le contraste (dégradé du bas)
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    // Stop 0 : transparent pour laisser voir l'image en haut
                    Colors.transparent,
                    // Stop 1 : bleu à opacité dynamique
                    AppColors.blueBackground.withOpacity(scrimOpacity),
                    // Stop 2 : même bleu, opacité augmentée de +0.3 (clamp pour rester entre 0 et 1)
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