// lib/core/theme/components/molecules/infinite_paging_carousel.dart

import 'package:flutter/material.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_dimensions.dart';
import '../physics/threshold_40px_physics.dart';

/// ✅ NOUVEAU : Configuration par défaut pour le carousel
class InfinitePagingCarouselConfig {
  static const int defaultLookAhead = 10;
  static const int defaultPrecacheAhead = 3;

  // ✅ Futur : RemoteConfig integration
  static int get lookAhead => defaultLookAhead; // TODO: RemoteConfig
  static int get precacheAhead => defaultPrecacheAhead; // TODO: RemoteConfig
}

/// Carousel de pagination infinie optimisé - VERSION FINALE
/// Step 7: Configuration, error handling robuste, documentation complète
class InfinitePagingCarousel<T> extends StatefulWidget {
  /// Liste des items à afficher dans le carousel infini
  final List<T> items;

  /// Builder pour construire chaque item du carousel
  /// [context] : Contexte Flutter
  /// [item] : L'item de type T à afficher
  /// [index] : Index réel de l'item (après modulo)
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Hauteur totale du carousel
  final double height;

  /// Contrôleur de scroll optionnel (pour animations externes)
  final InfiniteScrollController? scrollController;

  /// Callback appelé quand il faut charger plus d'items (lazy loading T2)
  final VoidCallback? onLoadMore;

  /// Indique s'il reste du contenu à charger depuis le backend
  final bool hasMore;

  /// Indique si un chargement est actuellement en cours
  final bool isLoading;

  /// Seuil de déclenchement du lazy loading (nombre d'items avant la fin)
  /// Plus petit = chargement plus précoce, plus grand = moins d'appels réseau
  final int lookAhead;

  /// Nombre d'images à pré-cacher en avance pour éviter les blancs
  /// Recommandé: 2-3 pour équilibrer performance/mémoire
  final int precacheAhead;

  /// Fonction pour extraire l'URL d'image depuis un item (pour pré-cache)
  /// Retourne null si l'item n'a pas d'image à pré-cacher
  final String? Function(T item)? getImageUrl;

  const InfinitePagingCarousel({
    super.key,
    required this.items,
    required this.itemBuilder,
    this.height = 240.0,
    this.scrollController,
    this.onLoadMore,
    this.hasMore = true,
    this.isLoading = false,
    int? lookAhead,
    int? precacheAhead,
    this.getImageUrl,
  }) : lookAhead = lookAhead ?? 10,
        precacheAhead = precacheAhead ?? 3;

  @override
  State<InfinitePagingCarousel<T>> createState() => _InfinitePagingCarouselState<T>();
}

class _InfinitePagingCarouselState<T> extends State<InfinitePagingCarousel<T>> {
  static const int kMiddle = 1 << 29;

  late final InfiniteScrollController _infiniteController;
  late final ValueNotifier<int> _currentRealIndexNotifier;
  final Set<int> _triggeredOffsets = <int>{};
  final Set<String> _precachedUrls = <String>{};



  @override
  void initState() {
    super.initState();

    _infiniteController = widget.scrollController ?? InfiniteScrollController(
      initialItem: kMiddle, // ✅ Au lieu de 0
    );

    _currentRealIndexNotifier = ValueNotifier<int>(0);
    _infiniteController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _infiniteController.removeListener(_onScroll);
    _currentRealIndexNotifier.dispose();

    if (widget.scrollController == null) {
      _infiniteController.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant InfinitePagingCarousel<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Reset des triggers et cache si nouveaux items
    if (widget.items.length > oldWidget.items.length) {
      _triggeredOffsets.clear();
      _precachedUrls.clear();
      print('🔄 INFINITE CAROUSEL: Reset cache (nouveaux items: ${widget.items.length})');
    }
  }

  /// Listener principal: gère position tracking + lazy loading + pré-cache
  void _onScroll() {
    if (!mounted || widget.items.isEmpty) return;

    try {
      // Calcul position réelle avec modulo (formule clé de l'infini)
      final currentItem = _infiniteController.offset.round();
      final realIndex = currentItem % widget.items.length;

      if (_currentRealIndexNotifier.value != realIndex) {
        _currentRealIndexNotifier.value = realIndex;

        // Fonctionnalités déclenchées par changement de position
        _checkLoadMore(realIndex);
        _precacheImages(realIndex);
      }
    } catch (e) {
      print('❌ INFINITE CAROUSEL: Erreur scroll listener: $e');
    }
  }

  /// Gestion du lazy loading T2
  void _checkLoadMore(int realIndex) {
    if (widget.onLoadMore == null || widget.isLoading || !widget.hasMore) return;

    final totalItems = widget.items.length;
    if (totalItems == 0) return;

    final distanceFromEnd = totalItems - realIndex;
    if (distanceFromEnd <= widget.lookAhead) {
      final triggerKey = (realIndex ~/ widget.lookAhead) * widget.lookAhead;

      if (!_triggeredOffsets.contains(triggerKey)) {
        _triggeredOffsets.add(triggerKey);
        print('🚀 INFINITE CAROUSEL: Lazy load trigger à $realIndex/$totalItems');
        widget.onLoadMore!();
      }
    }
  }

  /// Pré-cache intelligent d'images (bidirectionnel)
  void _precacheImages(int realIndex) {
    if (widget.getImageUrl == null) return;

    try {
      // Pré-cache en avant (lookAhead)
      for (var i = 1; i <= widget.precacheAhead; i++) {
        final targetIndex = (realIndex + i) % widget.items.length;
        _precacheImageAtIndex(targetIndex);
      }

      // Pré-cache en arrière (pour scroll inverse)
      final behindIndex = (realIndex - 1 + widget.items.length) % widget.items.length;
      _precacheImageAtIndex(behindIndex);

    } catch (e) {
      print('❌ INFINITE CAROUSEL: Erreur pré-cache: $e');
    }
  }

  /// Pré-cache une image spécifique avec error handling
  void _precacheImageAtIndex(int index) {
    if (index >= widget.items.length) return;

    try {
      final item = widget.items[index];
      final imageUrl = widget.getImageUrl!(item);

      if (imageUrl == null || imageUrl.isEmpty || _precachedUrls.contains(imageUrl)) {
        return;
      }

      final provider = CachedNetworkImageProvider(imageUrl);
      precacheImage(provider, context).then((_) {
        if (mounted) {
          _precachedUrls.add(imageUrl);
        }
      }).catchError((error) {
        // Silent fail - ne pas bloquer l'UX pour une image
        print('⚠️ INFINITE CAROUSEL: Image pré-cache échoué (index $index)');
      });

    } catch (e) {
      // Error handling robuste
      print('⚠️ INFINITE CAROUSEL: Exception pré-cache index $index: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Guard: retourner placeholder si vide
    if (widget.items.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return SizedBox(
      height: widget.height,
      child: AppDimensions.buildResponsiveCarousel(
        builder: (context, constraints) {
          final cardWidth = AppDimensions.calculateCarouselCardWidth(constraints);
          final itemExtent = cardWidth + AppDimensions.spacingS;

          return RepaintBoundary(
            child: InfiniteCarousel.builder(
              controller: _infiniteController,
              itemCount: kMiddle * 2, // ✅ Garder grand nombre pour infini pratique
              itemExtent: itemExtent,
              anchor: 0.0,
              velocityFactor: 0.8,
              loop: false,
              physics: Threshold40pxPhysics(
                landingFactor: 1.7,
                triggerPx: 40.0,
                itemExtent: itemExtent,
              ),
              itemBuilder: (context, itemIndex, realIndex) {
                // ✅ CORRECTION : Utiliser itemIndex avec modulo (évite index négatif)
                final int actualIndex = itemIndex % widget.items.length;
                final item = widget.items[actualIndex];

                return Padding(
                  padding: EdgeInsets.only(
                    left: 0,
                    right: AppDimensions.spacingS,
                  ),
                  child: widget.itemBuilder(context, item, actualIndex),
                );
              },
            ),          );
        },
      ),
    );
  }
}

