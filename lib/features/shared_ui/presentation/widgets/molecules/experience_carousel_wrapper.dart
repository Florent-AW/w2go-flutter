// lib/features/shared_ui/presentation/widgets/molecules/experience_carousel_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import '../../../../categories/application/state/categories_provider.dart' show selectedCategoryProvider;
import '../../../../preload/application/pagination_controller.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/domain/models/shared/city_model.dart' show City;
import '../../../../../core/domain/models/shared/category_model.dart' show Category;
import '../../../../preload/application/preload_providers.dart';
import '../../../../preload/application/preload_controller.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../organisms/generic_experience_carousel.dart';


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
  late InfiniteScrollController _scrollController;

  String? _currentCarouselKey;

  ProviderSubscription<PaginationState<ExperienceItem>>? _t1Sub;
  ProviderSubscription<PreloadData>? _preloadSub;
  ProviderSubscription<City?>? _citySub;
  ProviderSubscription<Category?>? _catSub;

  bool _t1InFlight = false;
  bool _hasInitialized = false;
  bool _suspendOneFrame = false;   // masque 1 frame au switch
  int _revision = 0;                // 🔑 incrémenté à chaque switch
  bool _hasScrolled = false;



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // ✅ SUPPRIMÉ : Plus de ref.listen ici
  }

  @override
  void initState()
  {
    super.initState();
    _currentCarouselKey = _buildCarouselKey(widget.providerParams);
    _scrollController = InfiniteScrollController(initialItem: 0);
    debugPrint('INIT  ⇢ rev=$_revision ctrl=${_scrollController.hashCode}');

    _scrollController.addListener(() {
      print('SCROLL ⇢ offset=${_scrollController.offset.toStringAsFixed(1)}''  rev=$_revision');
          if (!_hasScrolled && _scrollController.hasClients && _scrollController.offset != 0.0) {
        setState(() => _hasScrolled = true);
      }
    });

    // Preload READY → tenter injection T0
    _preloadSub = ref.listenManual(preloadControllerProvider, (previous, next) {
      if (previous?.state != PreloadState.ready && next.state == PreloadState.ready) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) _attemptPreloadInjection();
        });
      }
    });

    // Changement de ville → reset + réinjection
    _citySub = ref.listenManual(selectedCityProvider, (prev, next) {
      if (prev?.id != next?.id) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (!mounted) return;
          _resetPaginationForCityChange();
          _attemptPreloadInjection();
        });
      }
    });

    // Changement de catégorie (sur Category*) → index 0 + reset + réinjection
    if (widget.carouselContext != CarouselContext.city) {
      _catSub = ref.listenManual(selectedCategoryProvider, (prev, next) {
        if (prev?.id != next?.id) {

           // 1️⃣  On est encore dans l’ancienne catégorie ⇒ offset à 0 tout de suite
           if (_scrollController.hasClients) {
             _scrollController.jumpToItem(0);   // synchro, pas d’animation
           }
           _hasScrolled = false;                // réinitialise le flag
           _revision++;                         // invalide PageStorage + clés

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            _resetPaginationForCategoryChange();
            _attemptPreloadInjection();
          });
        }
      });
    }

    _wireT1Listener(); // abonne le listener T1 hors de build()

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_hasInitialized) {
        _hasInitialized = true;
        _attemptPreloadInjection();
      }
    });
  }



  @override
  void dispose() {
    _t1Sub?.close();
    _preloadSub?.close();
    _citySub?.close();
    _catSub?.close();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ pas d’accès à offset si le controller n’a pas encore de positions
    final offsetText = _scrollController.hasClients
        ? _scrollController.offset.toStringAsFixed(1)
        : 'n/a';

    debugPrint(
      'BUILD ⇢ rev=$_revision key=$_currentCarouselKey offset=$offsetText',
    );
    try {
      // 1. Contexte & clés
      final city = ref.watch(selectedCityProvider);
      final String logicalKey =
          _currentCarouselKey ?? _buildCarouselKey(widget.providerParams);
      final String wrapperKey =
          'wrapper_${widget.heroPrefix}_${city?.id ?? 'none'}_${logicalKey}_$_revision';

      // 2. Données
      final paginationState =
      ref.watch(widget.paginationProvider(widget.providerParams));

      final experiences = paginationState.items.isNotEmpty
          ? paginationState.items
          : widget.fallbackExperiences;

      if ((experiences?.isEmpty ?? true) && !paginationState.isLoading) {
        return const SizedBox.shrink();
      }

      // ⚠️ Si le carrousel a déjà défilé ET qu’il redevient visible,
      // on remplace le ScrollController pour qu’il reparte à 0 sans frame intermédiaire
      if (_hasScrolled && _scrollController.hasClients && _scrollController.offset != 0.0) {
        _scrollController.removeListener(() {});   // retire l’ancien listener
        _scrollController.dispose();
        _scrollController = InfiniteScrollController(initialItem: 0);
        _hasScrolled = false;                      // reset le flag
        _revision++;                   // 🔑 force une clé unique => rebuild complet

      }

      // 3. Carrousel
      final carousel = GenericExperienceCarousel(
        key: ValueKey(wrapperKey),
        title: widget.title,
        experiences: experiences,
        isLoading: paginationState.isLoading,
        errorMessage: paginationState.error,
        heroPrefix: '${widget.heroPrefix}_$logicalKey',
        openBuilder: widget.openBuilder,
        showDistance: widget.showDistance,
        onLoadMore: _loadMoreExperiences,
        onSeeAllPressed: widget.onSeeAllPressed,
        scrollController: _scrollController,
        uniqueKey: '${city?.id ?? "none"}_${logicalKey}_${widget.title}_$_revision',
      );

      // 4. Masque 1 frame (anti-flash)
      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: AnimatedOpacity(
          opacity: _suspendOneFrame ? 0.0 : 1.0,
          duration: const Duration(milliseconds: 90),
          curve: Curves.easeOut,
          child: IgnorePointer(
            ignoring: _suspendOneFrame,
            child: carousel,
          ),
        ),
      );
    } catch (e) {
      // 5. Fallback
      final cityId = ref.read(selectedCityProvider)?.id ?? 'none';
      final String logicalKey =
          _currentCarouselKey ?? _buildCarouselKey(widget.providerParams);

      return Padding(
        padding: const EdgeInsets.only(bottom: 4.0),
        child: GenericExperienceCarousel(
          key: ValueKey(
            'wrapper_fallback_${widget.heroPrefix}_${cityId}_${logicalKey}_$_revision',
          ),
          title: widget.title,
          experiences: widget.fallbackExperiences,
          isLoading: false,
          heroPrefix: '${widget.heroPrefix}_$logicalKey',
          openBuilder: widget.openBuilder,
          showDistance: widget.showDistance,
          onSeeAllPressed: widget.onSeeAllPressed,
          scrollController: _scrollController,

          // clé unique : ville + logicalKey + titre + révision
          uniqueKey: '${cityId}_${logicalKey}_${widget.title}_$_revision',
        ),
      );


    }
  }


  /// Injection T0 sûre : reset scroll SYNCHRONE avant de muter le state
  void _attemptPreloadInjection() {
    try {
      final controller =
      ref.read(widget.paginationProvider(widget.providerParams).notifier);
      final currentState =
      ref.read(widget.paginationProvider(widget.providerParams));

      // 1️⃣ Pré-load disponible
      final preloaded = _getPreloadedData();
      if (preloaded != null && preloaded.isNotEmpty) {
        // ⛔️ PAS de post-frame : on remet l’offset tout de suite
        if (_scrollController.hasClients) _scrollController.jumpToItem(0);

        controller.state = currentState.copyWith(
          items: preloaded,
          isPartial: true,
          currentOffset: preloaded.length,
          hasMore: true,
          isLoading: false,
        );
        return;
      }

      // 2️⃣ Fallback local éventuel
      if (widget.fallbackExperiences?.isNotEmpty == true) {
        if (_scrollController.hasClients) _scrollController.jumpToItem(0);

        controller.state = currentState.copyWith(
          items: widget.fallbackExperiences!,
          isPartial: widget.fallbackExperiences!.length <= 10,
          currentOffset: widget.fallbackExperiences!.length,
          hasMore: true,
          isLoading: false,
        );
        return;
      }

      // 3️⃣ Première requête réseau
      if (currentState.items.isEmpty && !currentState.isLoading) {
        controller.loadPreload();
      }
    } catch (e) {
      print('❌ _attemptPreloadInjection: $e');
    }
  }




  /// ✅ T2 LAZY LOADING (append)
  void _loadMoreExperiences() {
    try {
      final controller =
      ref.read(widget.paginationProvider(widget.providerParams).notifier);
      final currentState =
      ref.read(widget.paginationProvider(widget.providerParams));

      // Garde anti-duplication (et évite d'empiler sur T0 en cours)
      if (currentState.isLoading || currentState.currentOffset == 0) {
        print('⚠️ WRAPPER T2 SKIP: isLoading=${currentState.isLoading}, offset=${currentState.currentOffset}');
        return;
      }

      if (!currentState.isLoadingMore && currentState.hasMore) {
        controller.loadMore();
        print('🚀 WRAPPER T2: loadMore (offset=${currentState.currentOffset})');
      }
    } catch (e) {
      print('❌ WRAPPER T2: Erreur loadMore ${widget.title}: $e');
    }
  }

  void _resetPaginationForCategoryChange() {
    print('RESET CAT ⇢ rev=$_revision  offset=${_scrollController.offset}');
    try {

      // --- 0. Ramener immédiatement le carrousel à l’index 0 ----
      if (_scrollController.hasClients) {
         // ⛔️ Pas d’animation : on “téléporte” avant le prochain paint.
        _scrollController.jumpToItem(0);
       }

      final notifier =
      ref.read(widget.paginationProvider(widget.providerParams).notifier);

      notifier.state = notifier.state.copyWith(
        items: <ExperienceItem>[],
        isPartial: false,
        currentOffset: 0,
        hasMore: true,
        isLoading: false,
        error: null,
      );

      _scrollController.dispose();
      _scrollController = InfiniteScrollController(initialItem: 0);

      // --- 1. Réinitialise l’état d’UI ---
      setState(() {
        _revision++; // force un nouveau key/hash
        _hasScrolled = false;
        _suspendOneFrame = true; // masque la frame suivante (sécurité visuelle)
      });
      // --- 2. Rétablit l’opacité après la frame masquée ---
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _suspendOneFrame = false);
      });

    } catch (e) {
      print('❌ _resetPaginationForCategoryChange: $e');
    }
  }

  /// Reset complet lorsqu’on change de ville (city switch)
  void _resetPaginationForCityChange() {
    try {
      final notifier =
      ref.read(widget.paginationProvider(widget.providerParams).notifier);

      notifier.state = notifier.state.copyWith(
        items: <ExperienceItem>[],
        isPartial: false,
        currentOffset: 0,
        hasMore: true,
        isLoading: false,
        error: null,
      );

      // Nouveau scrollController déjà positionné à 0
      _scrollController.dispose();
      _scrollController = InfiniteScrollController(initialItem: 0);

      // Révision pour invalider le PageStorageBucket
      setState(() {
        _revision++;      // <- incrémente à chaque changement de ville
        _hasScrolled = false;
      });
    } catch (e) {
      print('❌ _resetPaginationForCityChange: $e');
    }
  }



  /// 🔑 Clé preload alignée avec PreloadController
  String _buildCarouselKey(dynamic params) {
    switch (widget.carouselContext) {
      case CarouselContext.city:
      // city: "<categoryId>_<sectionId>"
        return '${params.categoryId}_${params.sectionId}';
      case CarouselContext.categoryFeatured:
      // category featured: "cat:<categoryId>:featured:<sectionId>"
        return 'cat:${params.categoryId}:featured:${params.sectionId}';
      case CarouselContext.categorySub:
      // category sub: "cat:<categoryId>:sub:<subcategoryId>:<sectionId>"
        return 'cat:${params.categoryId}:sub:${params.subcategoryId}:${params.sectionId}';
    }
  }

  /// 🧊 Lecture T0 uniquement quand le preload est READY (anti-bleed de ville)
  List<ExperienceItem>? _getPreloadedData() {
    try {
      final preloadData = ref.read(preloadControllerProvider);
      final currentCity = ref.read(selectedCityProvider);

      print('🔍 WRAPPER PRELOAD: ${widget.title} '
          '(city=${currentCity?.id}/${currentCity?.cityName}, state=${preloadData.state})');

      if (preloadData.state != PreloadState.ready) {
        // Pas d’injection tant que la ville courante n’est pas totalement préchargée
        return null;
      }

      final key = _buildCarouselKey(widget.providerParams);
      final data = preloadData.carouselData[key];

      if (data != null && data.isNotEmpty) {
        print('✅ PRELOAD HIT: "$key" → ${data.length} items');
        return data;
      } else {
        print('⚠️ PRELOAD MISS: "$key"');
        return null;
      }
    } catch (e) {
      print('❌ PRELOAD READ ERROR (${widget.title}): $e');
      return null;
    }
  }

  @override
  void didUpdateWidget(covariant ExperienceCarouselWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);

    final oldKey = _buildCarouselKey(oldWidget.providerParams);
    final newKey = _buildCarouselKey(widget.providerParams);

    if (newKey != oldKey) {
      _currentCarouselKey = newKey;

      _t1Sub?.close();
      _scrollController.dispose();
      _scrollController = InfiniteScrollController(initialItem: 0);

      // ⬇️ masque une frame pour éviter le flash de l'ancienne position
      setState(() => _suspendOneFrame = true);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) setState(() => _suspendOneFrame = false);
      });

      _resetPaginationForCategoryChange();
      _attemptPreloadInjection();
      _wireT1Listener();
    }

  }


  void _wireT1Listener() {
    // détacher l’ancien listener s’il existe
    _t1Sub?.close();

    _t1Sub = ref.listenManual<PaginationState<ExperienceItem>>(
      widget.paginationProvider(widget.providerParams),
          (previous, next) async {
        if (!mounted) return;

        // Détection T0 -> T1
        if (previous != null && !previous.isPartial && next.isPartial) {
          if (_t1InFlight) return; // déjà un append en cours
          _t1InFlight = true;
          try {
            final controller =
            ref.read(widget.paginationProvider(widget.providerParams).notifier);
            final state = ref.read(widget.paginationProvider(widget.providerParams));

            // Append-only si éligible
            if (state.isPartial && !state.isLoading && !state.isLoadingMore && state.hasMore) {
              await controller.loadMore();
            }
          } catch (_) {
            // ignore
          } finally {
            _t1InFlight = false;
          }
        }
      },
    );
  }


}