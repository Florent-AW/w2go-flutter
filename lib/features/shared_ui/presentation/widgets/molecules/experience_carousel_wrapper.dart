// lib/features/shared_ui/presentation/widgets/molecules/experience_carousel_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../preload/application/pagination_controller.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../preload/application/all_data_preloader.dart';
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

          // ✅ PRIORITÉ UNIQUE : Données préchargées seulement
          final preloadedData = _getPreloadedData();
          if (preloadedData?.isNotEmpty == true) {
            print('🚀 WRAPPER PRELOAD INJECTION: ${widget.title} avec ${preloadedData!.length} items');

            controller.state = currentState.copyWith(
              items: preloadedData,
              isPartial: true, // Toujours partiel avec 3 items
              currentOffset: preloadedData.length,
              hasMore: true,
              isLoading: false,
            );
          } else {
            print('⚠️ WRAPPER: Aucune donnée préchargée pour ${widget.title}');
            // Pas de fallback, pas de loadPreload - juste un état vide
            controller.state = currentState.copyWith(
              items: [],
              isPartial: false,
              hasMore: false,
              isLoading: false,
            );
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

      // ✅ T1 REF.LISTEN DÉSACTIVÉ pour Step 2 (focus preload seulement)
      print('🚫 WRAPPER ref.listen DÉSACTIVÉ temporairement pour Étape 2');

      // ✅ DONNÉES UNIQUES : Pagination state seulement (plus de fallback)
      final experiences = paginationState.items;
      final isLoading = paginationState.isLoading;
      final errorMessage = paginationState.error;

      // Masquer si aucune donnée ET pas de chargement
      if (experiences.isEmpty && !isLoading) {
        print('📭 WRAPPER: ${widget.title} masqué (aucune donnée préchargée)');
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
      return const SizedBox.shrink(); // Plus de fallback
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
      if (preloadData.isEmpty) return null;

      String carouselKey;
      final providerName = widget.paginationProvider.toString();

      if (providerName.contains('cityActivities')) {
        // CityPage : categoryId_sectionId
        final params = widget.providerParams as dynamic;
        carouselKey = '${params.categoryId}_${params.sectionId}';
      } else if (providerName.contains('categoryFeatured')) {
        // CategoryPage Featured : categoryId_sectionId (dynamique)
        final params = widget.providerParams as dynamic;
        carouselKey = '${params.categoryId}_${params.sectionId}';
      } else if (providerName.contains('categorySubcategory')) {
        // CategoryPage Subcategory : categoryId_sectionId_subcategoryId
        final params = widget.providerParams as dynamic;
        carouselKey = '${params.categoryId}_${params.sectionId}_${params.subcategoryId}';
      } else {
        // Fallback générique
        final params = widget.providerParams as dynamic;
        carouselKey = '${params.categoryId}_${params.sectionId}';
      }

      final preloadedItemsRaw = preloadData[carouselKey];
      if (preloadedItemsRaw?.isNotEmpty == true) {
        // ✅ CORRECTION TYPE-SAFE : Filtre seulement les ExperienceItem valides
        final rawList = preloadedItemsRaw as List;
        final preloadedItems = rawList
            .whereType<ExperienceItem>()  // Filtre automatiquement les types valides
            .toList();

        if (preloadedItems.isNotEmpty) {
          print('🎯 WRAPPER PRELOAD INJECTION: ${widget.title} avec ${preloadedItems.length} items préchargés');
          return preloadedItems;
        }
      }
    } catch (e) {
      print('❌ WRAPPER PRELOAD: Erreur récupération ${widget.title}: $e');
    }
    return null;
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