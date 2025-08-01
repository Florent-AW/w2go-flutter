// lib/features/shared_ui/presentation/widgets/molecules/experience_carousel_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/application/pagination_controller.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/application/all_data_preloader.dart';
import '../organisms/generic_experience_carousel.dart';

/// Wrapper stateful unifié pour tous les carrousels avec pagination
/// Centralise la logique T1/T2 commune à CityPage et CategoryPage
class ExperienceCarouselWrapper extends ConsumerStatefulWidget {
  /// Provider de pagination (supporte AutoDispose et normal)
  final dynamic paginationProvider;

  /// Paramètres uniques pour identifier le carrousel dans le provider
  final dynamic providerParams;

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasInitialized) {
        _hasInitialized = true;

        try {
          final controller = ref.read(widget.paginationProvider(widget.providerParams).notifier);
          final currentState = ref.read(widget.paginationProvider(widget.providerParams));

          // ✅ PRIORITÉ 1 : Données préchargées
          final preloadedData = _getPreloadedData();
          if (preloadedData?.isNotEmpty == true) {
            print('🚀 WRAPPER PRELOAD INJECTION: ${widget.title} avec ${preloadedData!.length} items');

            // Déterminer si partiel selon le plan différentiel
            final isPartial = _isPreloadPartial(preloadedData);

            controller.state = currentState.copyWith(
              items: preloadedData,
              isPartial: isPartial,
              currentOffset: preloadedData.length,
              hasMore: true,
              isLoading: false,
            );
            return; // ✅ SORTIE : Pas besoin de fallback
          }

          // ✅ PRIORITÉ 2 : Fallback données existantes
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
    });
  }

  @override
  Widget build(BuildContext context) {
    try {
      final paginationState = ref.watch(widget.paginationProvider(widget.providerParams));

      // ✅ T1 AUTOMATIQUE VIA REF.LISTEN (pattern unifié)
      // ref.listen<PaginationState<ExperienceItem>>(
      //   widget.paginationProvider(widget.providerParams),
      //       (previous, next) {
      //     if (previous != null && !previous.isPartial && next.isPartial) {
      //       print('🔄 WRAPPER T1 REF.LISTEN: Détection false→true pour ${widget.title}');
      //
      //       Future.delayed(const Duration(milliseconds: 1500), () {
      //         if (mounted) {
      //           try {
      //             print('🔄 WRAPPER T1 REF.LISTEN: Complétion pour ${widget.title}');
      //             ref.read(widget.paginationProvider(widget.providerParams).notifier).completeIfPartial();
      //           } catch (e) {
      //             print('❌ WRAPPER T1: Erreur complétion ${widget.title}: $e');
      //           }
      //         }
      //       });
      //     }
      //   },
      // );
      print('🚫 WRAPPER ref.listen DÉSACTIVÉ temporairement pour Step 1');

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

  /// Récupère les données préchargées depuis AllDataPreloader si disponibles
  List<ExperienceItem>? _getPreloadedData() {
    try {
      final preloadData = ref.read(allDataPreloaderProvider);

      // Vérifier si preload a des données
      if (preloadData.isEmpty) {
        return null;
      }

      // ✅ Construire la clé selon le type de provider et paramètres
      String carouselKey;

      if (widget.paginationProvider.toString().contains('cityActivities')) {
        // ✅ CityPage : categoryId_sectionId (format direct)
        final params = widget.providerParams as dynamic;
        carouselKey = '${params.categoryId}_${params.sectionId}';
      } else if (widget.paginationProvider.toString().contains('categoryFeatured')) {
        // ✅ CategoryPage Featured : categoryId_featuredSectionId
        final params = widget.providerParams as dynamic;
        carouselKey = '${params.categoryId}_a62c6046-8814-456f-91ba-b65aa7e73137';
      } else if (widget.paginationProvider.toString().contains('categorySubcategory')) {
        // ✅ CategoryPage Subcategory : categoryId_subcategorySectionId_subcategoryId
        final params = widget.providerParams as dynamic;
        carouselKey = '${params.categoryId}_5aa09feb-397a-4ad1-8142-7dcf0b2edd0f_${params.subcategoryId}';
      } else {
        // ✅ Fallback générique
        final params = widget.providerParams as dynamic;
        carouselKey = '${params.categoryId}_${params.sectionId}';
      }

      final preloadedItems = preloadData[carouselKey];

      if (preloadedItems?.isNotEmpty == true) {
        print('🎯 WRAPPER PRELOAD INJECTION: ${widget.title} avec ${preloadedItems!.length} items préchargés');
        return preloadedItems;
      }

      return null;

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