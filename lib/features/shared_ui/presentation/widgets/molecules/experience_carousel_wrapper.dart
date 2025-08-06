// lib/features/shared_ui/presentation/widgets/molecules/experience_carousel_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../preload/application/pagination_controller.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../preload/application/preload_providers.dart';
import '../../../../preload/application/preload_controller.dart';
import '../../../../categories/application/state/categories_provider.dart';
import '../../../../../core/domain/models/shared/category_model.dart';
import '../organisms/generic_experience_carousel.dart';


// lib/shared_ui/presentation/widgets/molecules/experience_carousel_wrapper.dart

// ✅ 1. ENUM pour contexte carrousel (remplace toString() fragile)
enum CarouselContext { city, categoryFeatured, categorySub }

class ExperienceCarouselWrapper extends ConsumerStatefulWidget {
  /// Provider de pagination (supporte AutoDispose et normal)
  final dynamic paginationProvider;

  /// Paramètres uniques pour identifier le carrousel dans le provider
  final dynamic providerParams;

  /// Context du carrousel pour calcul clé preload
  final CarouselContext carouselContext;

  /// Titre du carrousel
  final String title;

  /// Préfixe pour les hero animations
  final String heroPrefix;

  /// Callback pour ouvrir une expérience
  final Widget Function(BuildContext, VoidCallback, ExperienceItem)? openBuilder;

  /// Callback pour "Voir tout" (optionnel)
  final VoidCallback? onSeeAllPressed;

  /// Afficher les distances (par défaut true)
  final bool showDistance;

  /// Données de fallback si pagination vide (optionnel)
  final List<ExperienceItem>? fallbackExperiences;

  const ExperienceCarouselWrapper({
    Key? key,
    required this.paginationProvider,
    required this.providerParams,
    required this.carouselContext, // ✅ NOUVEAU
    required this.title,
    required this.heroPrefix,
    this.openBuilder,
    this.onSeeAllPressed,
    this.showDistance = true,
    this.fallbackExperiences,
  }) : super(key: key);

  @override
  ConsumerState<ExperienceCarouselWrapper> createState() => _ExperienceCarouselWrapperState();
}

class _ExperienceCarouselWrapperState extends ConsumerState<ExperienceCarouselWrapper> {
  bool _hasInitialized = false;

  @override
  void initState() {
    super.initState();

    // ✅ NOUVEAU : Écouter bootstrap completion pour re-injection
    ref.listenManual(preloadControllerProvider, (previous, next) {
      if (previous?.state != PreloadState.ready && next.state == PreloadState.ready) {
        print('🔄 WRAPPER BOOTSTRAP READY: Re-injection pour ${widget.title}');
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _attemptPreloadInjection();
          }
        });
      }
    });

// ✅ NOUVEAU : Listener Featured spécifique pour carouselData updates
    ref.listenManual(preloadControllerProvider, (prev, next) {
      if (!mounted) return;
      if (widget.carouselContext != CarouselContext.categoryFeatured) return;

      final params = widget.providerParams as dynamic; // ✅ CORRECTION: dynamic au lieu de CategoryCarouselParams
      final exactKey = 'cat:${params.categoryId}:featured:${params.sectionId}';

    });

    // ✅ REF.LISTEN catégorie (existant)
    if (widget.carouselContext != CarouselContext.city) {
      ref.listenManual(selectedCategoryProvider, (previous, next) {
        if (previous is Category? && next is Category?) {
          if (previous?.id != next?.id) {
            print('🔄 WRAPPER CATEGORY CHANGE: ${widget.title} - re-injection needed');
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _attemptPreloadInjection();
              }
            });
          }
        }
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasInitialized) {
        _hasInitialized = true;
        _attemptPreloadInjection();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ SUPPRIMÉ : Plus de ref.listen ici
  }

  @override
  Widget build(BuildContext context) {
    try {
      final paginationState = ref.watch(widget.paginationProvider(widget.providerParams));

// ✅ T1 AUTOMATIQUE VIA REF.LISTEN (pattern unifié)
      ref.listen<PaginationState<ExperienceItem>>(
        widget.paginationProvider(widget.providerParams),
            (previous, next) {
          // ✅ CORRECTION : Détecter transition vers partiel (not previous.isPartial && next.isPartial)
          if (previous != null && !previous.isPartial && next.isPartial) {
            print('🔄 WRAPPER T1 REF.LISTEN: Détection false→true pour ${widget.title}');

            Future.delayed(const Duration(milliseconds: 1500), () {
              if (mounted) {
                try {
                  print('🔄 WRAPPER T1 REF.LISTEN: Complétion pour ${widget.title}');
                  ref.read(widget.paginationProvider(widget.providerParams).notifier).completeIfPartial();
                } catch (e) {
                  print('❌ WRAPPER T1: Erreur complétion ${widget.title}: $e');
                }
              }
            });
          }
        },
      );

      // ✅ DONNÉES HYBRIDES : Pagination prioritaire, fallback si nécessaire
      final experiences = paginationState.items.isNotEmpty
          ? paginationState.items
          : widget.fallbackExperiences;

      final isLoading = paginationState.isLoading;
      final errorMessage = paginationState.error;

      // Masquer si aucune donnée
      if ((experiences?.isEmpty ?? true) && !isLoading) {
        return const SizedBox.shrink();
      }

      return Container(
        padding: EdgeInsets.only(bottom: 4.0),
        child: GenericExperienceCarousel(
          key: ValueKey('wrapper_${widget.heroPrefix}'),
          title: widget.title,
          experiences: experiences,
          isLoading: isLoading,
          errorMessage: errorMessage,
          heroPrefix: widget.heroPrefix,
          openBuilder: widget.openBuilder,
          showDistance: widget.showDistance,
          onLoadMore: () => _loadMoreExperiences(),
          onSeeAllPressed: widget.onSeeAllPressed,
        ),
      );
    } catch (e) {
      print('❌ WRAPPER BUILD: Erreur ${widget.title}: $e');
      // Fallback vers les données de secours
      return Container(
        padding: EdgeInsets.only(bottom: 4.0),
        child: GenericExperienceCarousel(
          key: ValueKey('wrapper_fallback_${widget.heroPrefix}'),
          title: widget.title,
          experiences: widget.fallbackExperiences,
          isLoading: false,
          heroPrefix: widget.heroPrefix,
          openBuilder: widget.openBuilder,
          showDistance: widget.showDistance,
          onSeeAllPressed: widget.onSeeAllPressed,
        ),
      );
    }
  }

  /// ✅ CORRECTION T0 : méthode centralisée pour injection preload
  void _attemptPreloadInjection() {
    try {
      final controller = ref.read(widget.paginationProvider(widget.providerParams).notifier);
      final currentState = ref.read(widget.paginationProvider(widget.providerParams));

      print('🔍 WRAPPER INJECTION ATTEMPT: ${widget.title}');
      print('  - currentState.items.length: ${currentState.items.length}');
      print('  - currentState.isLoading: ${currentState.isLoading}');

      // ✅ PRIORITÉ 1 : Données T0 préchargées (nouveau système)
      final preloadedData = _getPreloadedData();
      if (preloadedData?.isNotEmpty == true) {
        print('🚀 WRAPPER T0 INJECTION: ${widget.title} avec ${preloadedData!.length} items T0');

        // ✅ INJECTION T0 : items + isPartial=true + hasMore=true + isLoading=false
        controller.state = currentState.copyWith(
          items: preloadedData,
          isPartial: true, // ✅ TOUJOURS partiel pour T0 (permet T1)
          currentOffset: preloadedData.length,
          hasMore: true, // ✅ TOUJOURS plus de contenu disponible
          isLoading: false, // ✅ PAS de loader pendant T0
        );

        print('✅ WRAPPER T0 INJECTED: ${widget.title} → isPartial=true, hasMore=true');
        return; // ✅ SORTIE : Pas besoin de fallback/loadPreload
      }

      // ✅ PRIORITÉ 2 : Fallback données existantes (ancien système)
      if (widget.fallbackExperiences?.isNotEmpty == true) {
        print('🔄 WRAPPER FALLBACK INJECTION: ${widget.title} avec ${widget.fallbackExperiences!.length} items');

        controller.state = currentState.copyWith(
          items: widget.fallbackExperiences!,
          isPartial: widget.fallbackExperiences!.length <= 10,
          currentOffset: widget.fallbackExperiences!.length,
          hasMore: true,
          isLoading: false,
        );
        return; // ✅ SORTIE : Pas besoin de loadPreload
      }

      // ✅ PRIORITÉ 3 : LoadPreload classique (dernier recours)
      if (currentState.items.isEmpty && !currentState.isLoading) {
        print('🚀 WRAPPER PAGINATION INIT: ${widget.title}');
        controller.loadPreload();
      }

    } catch (e) {
      print('❌ WRAPPER INIT: Erreur ${widget.title}: $e');
    }
  }

  /// ✅ T2 LAZY LOADING (pattern unifié)
  void _loadMoreExperiences() {
    try {
      final controller = ref.read(widget.paginationProvider(widget.providerParams).notifier);
      final currentState = ref.read(widget.paginationProvider(widget.providerParams));

      // ✅ GARDE ANTI-DUPLICATION (pattern CityPage)
      if (currentState.isLoading || currentState.currentOffset == 0) {
        print('⚠️ WRAPPER T2 SKIP: Preload en cours (isLoading=${currentState.isLoading}, offset=${currentState.currentOffset})');
        return;
      }

      if (!currentState.isLoadingMore && currentState.hasMore) {
        print('🚀 WRAPPER T2 LAZY LOADING: ${widget.title} - Chargement de la page suivante (offset=${currentState.currentOffset}) à ${DateTime.now().millisecondsSinceEpoch}');
        controller.loadMore();
      } else {
        print('⚠️ WRAPPER T2 SKIP: isLoadingMore=${currentState.isLoadingMore}, hasMore=${currentState.hasMore}');
      }
    } catch (e) {
      print('❌ WRAPPER T2: Erreur loadMore ${widget.title}: $e');
    }
  }

  /// ✅ 3. HELPER UNIFIÉ pour calcul clé (même logique que PreloadController)
  String _buildCarouselKey(dynamic params) {
    switch (widget.carouselContext) {
      case CarouselContext.city:
      // Format : categoryId_sectionId
        return '${params.categoryId}_${params.sectionId}';

      case CarouselContext.categoryFeatured:
      // Format : cat:categoryId:featured:sectionId
        return 'cat:${params.categoryId}:featured:${params.sectionId}';

      case CarouselContext.categorySub:
      // Format : cat:categoryId:sub:subcategoryId:sectionId
        return 'cat:${params.categoryId}:sub:${params.subcategoryId}:${params.sectionId}';
    }
  }

  /// Récupère les données préchargées depuis PreloadController si disponibles
  List<ExperienceItem>? _getPreloadedData() {
    try {
      final preloadData = ref.read(preloadControllerProvider);

      print('🔍 WRAPPER DEBUG DETAILED: ${widget.title}');
      print('  - preload state: ${preloadData.state}');
      print('  - context: ${widget.carouselContext}');

      // ✅ 1. SUPPRESSION garde bloquante globale (sauf CityPage si nécessaire)
      final isCity = widget.carouselContext == CarouselContext.city;
      if (isCity && preloadData.state != PreloadState.ready) {
        print('🔍 WRAPPER DEBUG: City preload not ready - state=${preloadData.state}');
        return null;
      }

      // ✅ UTILISER helper unifié pour clé
      final carouselKey = _buildCarouselKey(widget.providerParams);
      print('🔍 WRAPPER DEBUG: cherche clé "$carouselKey" pour ${widget.title}');

      // ✅ AFFICHER toutes les clés disponibles pour debug
      print('🔍 WRAPPER DEBUG: clés disponibles dans preload:');
      for (final key in preloadData.carouselData.keys) {
        final count = preloadData.carouselData[key]?.length ?? 0;
        print('  - "$key": $count items');
      }

      // ✅ RÉCUPÉRER les vraies données (c'était ça le problème !)
      final preloadedData = preloadData.carouselData[carouselKey];

      if (preloadedData?.isNotEmpty == true) {
        print('✅ WRAPPER PRELOAD FOUND: ${widget.title} → ${preloadedData!.length} items avec clé "$carouselKey"');
        return preloadedData;
      } else {
        print('⚠️ WRAPPER PRELOAD NOT FOUND: ${widget.title} - clé "$carouselKey" vide ou inexistante');
        return null;
      }

    } catch (e) {
      print('❌ WRAPPER PRELOAD: Erreur récupération ${widget.title}: $e');
      return null;
    }
  }

  /// Détermine si les données préchargées sont partielles selon le plan
  bool _isPreloadPartial(List<ExperienceItem> preloadedData) {
    // Selon le plan différentiel :
    // - Événements (carrousel 1) : 10 items → partiel (T1 possible)
    // - Culture (carrousel 2) : 10 items → partiel (T1 possible)
    // - Autres (carrousels 3-7) : 5 items → partiel (T1 nécessaire)

    if (preloadedData.length <= 5) {
      return true; // Toujours partiel si 5 items ou moins
    } else if (preloadedData.length == 10) {
      return true; // 10 items = partiel pour permettre T1 → 25 items
    } else {
      return false; // Plus de 10 items = complet
    }
  }
}