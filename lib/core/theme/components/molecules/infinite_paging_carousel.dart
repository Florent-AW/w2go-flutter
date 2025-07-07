// lib/core/theme/components/molecules/infinite_paging_carousel.dart

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../app_dimensions.dart';
import '../physics/threshold_40px_physics.dart';
import '../physics/loop_snap_scroll_physics.dart';

/// Configuration par défaut pour le carousel
class InfinitePagingCarouselConfig {
  static const int defaultLookAhead = 10;
  static const int defaultPrecacheAhead = 3;
}

/// Carousel de pagination infinie optimisé - VERSION FINALE
class InfinitePagingCarousel<T> extends StatefulWidget {
  /// Liste des items à afficher dans le carousel infini
  final List<T> items;

  /// Builder pour construire chaque item du carousel
  final Widget Function(BuildContext context, T item, int index) itemBuilder;

  /// Hauteur totale du carousel
  final double height;

  /// Contrôleur de scroll optionnel
  final InfiniteScrollController? scrollController;

  /// Callback appelé quand il faut charger plus d'items
  final VoidCallback? onLoadMore;

  /// Indique s'il reste du contenu à charger
  final bool hasMore;

  /// Indique si un chargement est en cours
  final bool isLoading;

  /// Seuil de déclenchement du lazy loading
  final int lookAhead;

  /// Nombre d'images à pré-cacher en avance
  final int precacheAhead;

  /// Fonction pour extraire l'URL d'image depuis un item
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
  }) : lookAhead = lookAhead ?? InfinitePagingCarouselConfig.defaultLookAhead,
        precacheAhead = precacheAhead ?? InfinitePagingCarouselConfig.defaultPrecacheAhead;

  @override
  State<InfinitePagingCarousel<T>> createState() => _InfinitePagingCarouselState<T>();
}

class _InfinitePagingCarouselState<T> extends State<InfinitePagingCarousel<T>> {
  static const int kMiddle = 1 << 29; // ~536M pour position centrale

  late final InfiniteScrollController _infiniteController;
  late final ValueNotifier<int> _currentRealIndexNotifier;
  final Set<int> _triggeredOffsets = <int>{};
  final Set<String> _precachedUrls = <String>{};

  // ✅ NOUVEAU : Tracker l'index absolu pour lazy-load correct
  int _absoluteIndex = 1 << 20; // Commence au même niveau que initialItem

  @override
  void initState() {
    super.initState();

    // ✅ CORRECTIF : Position initiale alignée sur le premier item
    final initialPosition = widget.items.isNotEmpty
        ? (1 << 20) - ((1 << 20) % widget.items.length)  // Multiple exact de items.length
        : 1 << 20;

    _infiniteController = widget.scrollController ?? InfiniteScrollController(
      initialItem: initialPosition,
    );

    _currentRealIndexNotifier = ValueNotifier<int>(0);
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

    // ✅ SIMPLE : juste reset cache
    if (widget.items.length > oldWidget.items.length) {
      _triggeredOffsets.clear();
      _precachedUrls.clear();
      print('🔄 INFINITE CAROUSEL: Reset cache (items = ${widget.items.length})');
    }
  }

  /// Listener principal pour scroll
  void _onScroll() {
    // Garde pour error handling si besoin, mais calcul d'index déplacé vers onIndexChanged
    if (!mounted || widget.items.isEmpty) return;
  }

  /// ✅ CORRECTION : Utiliser index absolu pour lazy-load
  void _handleIndexChange(int itemIndex) {
    if (!mounted || widget.items.isEmpty) return;

    // ✅ Calculer l'index absolu à partir de l'offset
    final currentOffset = _infiniteController.offset;
    final itemExtentEstimate = currentOffset > 0 ? currentOffset / itemIndex : 300.0;
    final absoluteIndex = (currentOffset / itemExtentEstimate).round();

    final logical = absoluteIndex % widget.items.length;

    if (_currentRealIndexNotifier.value != logical) {
      _currentRealIndexNotifier.value = logical;

      _checkLoadMore(absoluteIndex); // ✅ Passer l'index absolu
      _precacheImages(logical);
    }
  }

  /// ✅ CORRECTION : Lazy loading sur index absolu, pas modulo
  void _checkLoadMore(int absoluteIndex) {
    if (widget.onLoadMore == null || widget.isLoading || !widget.hasMore) return;

    final totalItems = widget.items.length;
    if (totalItems == 0) return;

    // ✅ NOUVEAU : Calculer combien d'items uniques on a vraiment vus
    final itemsSeen = absoluteIndex - (1 << 20); // Soustraire la position initiale
    final remaining = totalItems - itemsSeen;

    // ✅ CORRECTION : Ne déclencher que si on approche vraiment de la fin
    if (remaining <= widget.lookAhead && itemsSeen > 0) {
      final triggerKey = itemsSeen ~/ widget.lookAhead;

      if (!_triggeredOffsets.contains(triggerKey)) {
        _triggeredOffsets.add(triggerKey);
        print('🚀 INFINITE CAROUSEL: Lazy load trigger à itemsSeen=$itemsSeen, remaining=$remaining');
        widget.onLoadMore!();
      }
    }
  }

  /// Pré-cache intelligent d'images
  void _precacheImages(int realIndex) {
    if (widget.getImageUrl == null) return;

    try {
      // Pré-cache en avant
      for (var i = 1; i <= widget.precacheAhead; i++) {
        final targetIndex = (realIndex + i) % widget.items.length;
        _precacheImageAtIndex(targetIndex);
      }

      // Pré-cache en arrière pour scroll inverse
      final behindIndex = (realIndex - 1 + widget.items.length) % widget.items.length;
      _precacheImageAtIndex(behindIndex);

    } catch (e) {
      print('❌ INFINITE CAROUSEL: Erreur pré-cache: $e');
    }
  }

  /// Pré-cache une image spécifique
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
        // Silent fail pour ne pas bloquer l'UX
      });

    } catch (e) {
      // Error handling robuste
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return SizedBox(height: widget.height);
    }

    return SizedBox(
      height: widget.height,
      // ✅ CORRECTION : LayoutBuilder direct (pas AppDimensions.buildResponsiveCarousel)
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cardWidth = AppDimensions.calculateCarouselCardWidth(constraints);
          final itemExtent = cardWidth + AppDimensions.spacingS;

          return RepaintBoundary(
            child: InfiniteCarousel.builder(
              controller: _infiniteController,
              itemCount: widget.items.length,
              itemExtent: itemExtent,
              anchor: 0.0,
              velocityFactor: 0.8,
              loop: true,
              onIndexChanged: _handleIndexChange,
              physics: LoopSnapScrollPhysics(
                itemExtent: itemExtent,
                anchor: 0.0,
              ),
              itemBuilder: (context, itemIndex, realIndex) {
                // ✅ GARDER : itemBuilder comme il est, mais modulo positif forcé
                final logical = (realIndex % widget.items.length + widget.items.length) % widget.items.length;
                final item = widget.items[logical];

                return Padding(
                  padding: EdgeInsets.only(
                    left: 0,
                    right: AppDimensions.spacingS,
                  ),
                  child: SizedBox(
                    width: cardWidth,
                    child: widget.itemBuilder(context, item, logical),
                  ),
                );
              },
            ),
          );
          },
      ),
    );
  }
}