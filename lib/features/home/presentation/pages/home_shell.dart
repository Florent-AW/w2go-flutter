// lib/features/home/presentation/pages/home_shell.dart

import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../categories/presentation/pages/category_page.dart';
import '../../../city_page/presentation/pages/city_page.dart';
import '../../../shared_ui/presentation/widgets/organisms/generic_bottom_bar.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../preload/application/preload_providers.dart';
import '../../../preload/application/preload_controller.dart';
import '../../../categories/application/state/categories_provider.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../../core/common/utils/image_provider_factory.dart';
import '../../../../core/domain/models/shared/category_model.dart';
import '../../../../core/domain/models/shared/category_view_model.dart';


class HomeShell extends ConsumerStatefulWidget {
  /// Tab initial à afficher
  final BottomNavTab initialTab;

  const HomeShell({
    Key? key,
    this.initialTab = BottomNavTab.explorer,
  }) : super(key: key);

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  late BottomNavTab _currentTab;
  bool _hasInitialized = false;
  bool _isTransitioning = false;
  double _overlayOpacity = 1.0;

  // ✅ Garde anti-doublon preload
  City? _lastPreloadCity;
  bool _categoryBootstrapped = false;

  String? _lastPreloadTarget;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Initialisation unique avec protection
    if (!_hasInitialized) {
      _hasInitialized = true;

      WidgetsBinding.instance.addPostFrameCallback((_) {
        final currentCity = ref.read(selectedCityProvider);
        if (currentCity != null) {
          print('🏙️ INIT: Ville déjà sélectionnée ${currentCity.cityName}');
          _triggerPreload(currentCity);
        }
      });
    }

    // ✅ Écouter changements de ville
    ref.listen<City?>(selectedCityProvider, (previous, next) {
      print('🔥 CITY CHANGE: ${previous?.cityName} → ${next?.cityName}');

      if (next != null && (previous == null || previous.id != next.id)) {
        print('🌍 TRIGGER: Preload pour ${next.cityName}');
        _triggerPreload(next);
      }
    });

    // ✅ Écouter fin preload pour lever overlay
    ref.listen<PreloadData>(preloadControllerProvider, (previous, next) {
      if (previous?.state != PreloadState.ready && next.state == PreloadState.ready) {
        print('✅ PRELOAD READY: Lever overlay');
        _onPreloadBecameReady();
      }
    });

    // ✅ NOUVEAU : Détecter changement d'onglet vers CategoryPage
    if (_currentTab != widget.initialTab &&
        _currentTab == BottomNavTab.explorer &&
        !_categoryBootstrapped) {

      // Vérifier si CategoryPage déjà warm (venant de CityPage)
      final preloadData = ref.read(preloadControllerProvider);
      final hasCategoryHeaders = preloadData.categoryHeaders.isNotEmpty;
      final hasFeaturedCarousels = preloadData.carouselData.keys
          .any((key) => key.startsWith('cat:'));

      if (hasCategoryHeaders && hasFeaturedCarousels) {
        print('✅ TAB CHANGE DETECTION: CategoryPage déjà warm, bootstrap immédiat');

        // Marquer comme bootstrappé immédiatement
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            setState(() {
              _categoryBootstrapped = true;
            });
          }
        });
      }
    }

    final preloadData = ref.watch(preloadControllerProvider);
    final selectedCity = ref.watch(selectedCityProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final isCategoryTab = _currentTab == BottomNavTab.explorer;


// ✅ OVERLAY : Uniquement avant bootstrap (première catégorie)
    final shouldShowOverlay = selectedCity != null && (_isTransitioning || (
        isCategoryTab
            ? !_categoryBootstrapped  // ✅ Overlay uniquement avant bootstrap
            : preloadData.state == PreloadState.loading  // City : garde l'ancien comportement
    ));

    return Scaffold(
      body: Stack(
        children: [
          // ⚡️ Pages construites immédiatement (injection sous overlay)
          PageTransitionSwitcher(
            duration: const Duration(milliseconds: 200),
            transitionBuilder: (child, animation, secondaryAnimation) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: SharedAxisTransitionType.horizontal,
                fillColor: Theme.of(context).colorScheme.background,
                child: child,
              );
            },
            child: KeyedSubtree(
              key: ValueKey(_currentTab),
              child: _getPageForTab(_currentTab),
            ),
          ),

          // 🔵 Overlay avec fade-out élégant
          if (shouldShowOverlay)
            Positioned.fill(
              child: AnimatedOpacity(
                opacity: _overlayOpacity,
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeOutCubic,
                child: Container(
                  color: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          'Chargement de ${selectedCity!.cityName}...',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _getLoadingSubtitle(),
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: GenericBottomBar(
        selectedTab: _currentTab,
        onTabSelected: (tab) {
          if (tab != _currentTab) {
            // ✅ NOUVEAU : Anticiper CategoryPage warm avant changement
            if (tab == BottomNavTab.explorer && !_categoryBootstrapped) {
              final preloadData = ref.read(preloadControllerProvider);
              final hasCategoryHeaders = preloadData.categoryHeaders.isNotEmpty;
              final hasFeaturedCarousels = preloadData.carouselData.keys
                  .any((key) => key.startsWith('cat:'));

              if (hasCategoryHeaders && hasFeaturedCarousels) {
                print('✅ TAB ANTICIPATION: CategoryPage warm détecté, bootstrap préventif');
                _categoryBootstrapped = true; // ✅ PAS de setState, juste le flag
              }
            }

            // ✅ Changement d'onglet avec flag déjà préparé
            setState(() => _currentTab = tab);
          }
        },
      ),
    );
  }

  /// ✅ Déclenche preload selon le type de page
  void _triggerPreload(City city) {
    try {
      final targetPageType = _currentTab == BottomNavTab.visiter ? 'city' : 'category';

      // ✅ Garde anti-doublon
      if (_lastPreloadCity?.id == city.id && _lastPreloadTarget == targetPageType) {
        print('⚠️ PRELOAD SKIP: Déjà lancé pour ${city.cityName} ($targetPageType)');
        return;
      }

      _lastPreloadCity = city;
      _lastPreloadTarget = targetPageType;

      // ✅ Reset overlay
      setState(() {
        _overlayOpacity = 1.0;
      });

      print('🚀 TRIGGER PRELOAD: ${city.cityName} → $targetPageType');

      // ✅ API simplifiée selon type
      if (targetPageType == 'city') {
        ref.read(preloadControllerProvider.notifier).startPreload(city, 'city');
      } else {
        // ✅ CategoryPage : utiliser API standard avec fallback
        _triggerCategoryPreload(city);
      }

    } catch (e) {
      print('❌ TRIGGER PRELOAD: Erreur $e');
      // Fallback : pas d'overlay si erreur
      setState(() {
        _isTransitioning = false;
        _overlayOpacity = 1.0;
      });
    }
  }

  /// Preload CategoryPage avec gestion bootstrap
  void _triggerCategoryPreload(City city) async {
    try {
      final selectedCategory = ref.read(selectedCategoryProvider);

      // ✅ NOUVEAU : Vérifier si CategoryPage déjà warm (venant de CityPage)
      final preloadData = ref.read(preloadControllerProvider);
      final hasCategoryHeaders = preloadData.categoryHeaders.isNotEmpty;
      final hasFeaturedCarousels = preloadData.carouselData.keys
          .any((key) => key.startsWith('cat:'));

      if (hasCategoryHeaders && hasFeaturedCarousels) {
        // ✅ CategoryPage déjà warm → Skip preload, juste bootstrap flag
        print('✅ CATEGORY WARM DETECTED: Skip preload, données déjà prêtes');

        setState(() {
          _categoryBootstrapped = true;
        });

        // ✅ Marquer comme ready pour lever overlay
        if (preloadData.state != PreloadState.ready) {
          // Forcer l'état ready si pas déjà (évite overlay bloqué)
          Future.delayed(Duration.zero, () {
            if (mounted) {
              _onPreloadBecameReady();
            }
          });
        }

        return; // ✅ SORTIE : Pas de preload
      }

      if (!_categoryBootstrapped) {
        // ✅ PREMIÈRE CATÉGORIE : Preload bloquant avec overlay
        if (selectedCategory != null) {
          print('🚀 BOOTSTRAP CATEGORY: ${selectedCategory.name} (${selectedCategory.id})');
          await ref.read(preloadControllerProvider.notifier).startPreloadCategory(city, selectedCategory.id);
        } else {
          // Fallback première catégorie
          final categories = await ref.read(categoriesProvider.future);
          if (categories.isNotEmpty) {
            print('🚀 BOOTSTRAP FALLBACK: ${categories.first.name}');
            await ref.read(preloadControllerProvider.notifier).startPreloadCategory(city, categories.first.id);
          }
        }

        // ✅ Marquer comme bootstrappé
        setState(() {
          _categoryBootstrapped = true;
        });

        // ✅ WARM suivantes en arrière-plan après bootstrap
        _warmNextCategoriesInBackground(city);

      } else {
        // ✅ CATÉGORIES SUIVANTES : Warm silencieux (pas d'overlay)
        if (selectedCategory != null) {
          print('🔥 WARM CATEGORY: ${selectedCategory.name} (silencieux)');
          ref.read(preloadControllerProvider.notifier).warmCategorySilently(city, selectedCategory.id);
        }
      }

    } catch (e) {
      print('❌ CATEGORY PRELOAD: Erreur $e');
      // Fallback : marquer comme bootstrappé pour éviter blocage
      setState(() {
        _categoryBootstrapped = true;
      });
    }
  }

  /// ✅ Préchauffe les headers des catégories voisines en arrière-plan
  void _warmNextCategoriesInBackground(City city) async {
    try {
      // Récupérer toutes les catégories
      final categories = await ref.read(categoriesProvider.future);
      final selectedCategory = ref.read(selectedCategoryProvider);

      if (categories.length <= 1 || selectedCategory == null) return;

      // Trouver les autres catégories (exclure la courante)
      final otherCategoryIds = categories
          .where((c) => c.id != selectedCategory.id)
          .take(7)
          .map((c) => c.id)
          .toList();

      if (otherCategoryIds.isEmpty) return;

      print('🔥 WARM HEADERS BACKGROUND: ${otherCategoryIds.length} catégories');

      // ✅ NOUVEAU : Warm headers au lieu des carrousels complets
      final ctrl = ref.read(preloadControllerProvider.notifier);
      await ctrl.warmCategoryHeadersSilently(city, otherCategoryIds);

      // ✅ NOUVEAU : Precaching des covers
      if (mounted) {
        final preloadData = ref.read(preloadControllerProvider);
        final coverUrls = preloadData.coverUrlsFor(otherCategoryIds);

        print('🖼️ PRECACHING: ${coverUrls.length} covers');
        for (final categoryId in otherCategoryIds) {
          final categoryHeader = preloadData.categoryHeaders[categoryId];
          if (categoryHeader?.coverUrl.isNotEmpty == true) {
            try {
              await precacheImage(
                  ImageProviderFactory.coverProvider(
                      categoryHeader!.coverUrl, categoryId),
                  context
              );
              print('✅ PRECACHED: ${categoryHeader.coverUrl}');
            } catch (e) {
            }
          }
        }
      }

      print('✅ WARM HEADERS BACKGROUND: Terminé');

    } catch (e) {
      print('❌ WARM HEADERS BACKGROUND: Erreur $e');
    }
  }

  /// Pages selon tab
  Widget _getPageForTab(BottomNavTab tab) {
    switch (tab) {
      case BottomNavTab.explorer:
        return const CategoryPage();
      case BottomNavTab.visiter:
        return const CityPage();
      case BottomNavTab.favoris:
        return const Scaffold(
          body: Center(child: Text('🚧 Favoris - À implémenter')),
        );
      case BottomNavTab.profil:
        return const Scaffold(
          body: Center(child: Text('🚧 Profil - À implémenter')),
        );
    }
  }

  /// ✅ Sous-titre adaptatif selon le tab
  String _getLoadingSubtitle() {
    return _currentTab == BottomNavTab.visiter
        ? 'Préparation des expériences'
        : 'Chargement de la catégorie';
  }

  /// ✅ Animation fade-out overlay AVEC précache images critiques
  void _onPreloadBecameReady() {
    setState(() {
      _isTransitioning = true;
    });

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!mounted) return;
      print('🎨 FADE OUT: Animation overlay');

      // 0) Lecture initiale (sera re-lue après warm)
      var preloadData = ref.read(preloadControllerProvider);

      // 1) Précache de la cover "de départ"
      //    - Si une catégorie est déjà sélectionnée -> précache direct
      //    - Sinon, si on arrive depuis CityPage -> warm + précache de la 1ʳᵉ catégorie
      final selectedCategory = ref.read(selectedCategoryProvider);
      if (selectedCategory != null) {
        final header = preloadData.categoryHeaders[selectedCategory.id];
        final String? coverUrl = header?.coverUrl;
        if (coverUrl != null && coverUrl.isNotEmpty) {
          try {
            print('🖼️ PRECACHING FIRST COVER: $coverUrl');
            await precacheImage(
              ImageProviderFactory.coverProvider(coverUrl, selectedCategory.id),
              context,
            );
            print('✅ PRECACHED FIRST COVER: $coverUrl');
          } catch (e) {
            print('❌ PRECACHE FIRST COVER FAILED: $coverUrl - $e');
          }
        }
      } else if (widget.initialTab == BottomNavTab.visiter) {
        // Arrivée depuis CityPage sans catégorie sélectionnée
        final selectedCity = ref.read(selectedCityProvider);
        if (selectedCity != null) {
          try {
            // Typage explicite + gestion d’erreur propre
            List<Category> categories;
            try {
              categories = await ref.read(categoriesProvider.future);
            } catch (_) {
              categories = <Category>[];
            }

            if (categories.isNotEmpty) {
              final Category firstCat = categories.first;

              // Charger le header si absent (ajoute aussi la cover aux criticalImageUrls)
              final preload = ref.read(preloadControllerProvider);
              if (!preload.categoryHeaders.containsKey(firstCat.id)) {
                await ref
                    .read(preloadControllerProvider.notifier)
                    .warmCategoryHeadersSilently(selectedCity, <String>[firstCat.id], concurrency: 1);
              }

              // Précache la cover avec le même provider/clé que le rendu
              final header = ref.read(preloadControllerProvider).categoryHeaders[firstCat.id];
              final String? coverUrl = header?.coverUrl;
              if (coverUrl != null && coverUrl.isNotEmpty) {
                try {
                  await precacheImage(
                    ImageProviderFactory.coverProvider(coverUrl, firstCat.id),
                    context,
                  );
                  print('✅ PRECACHED FIRST CATEGORY COVER: $coverUrl');
                } catch (e) {
                  print('❌ PRECACHE FIRST CATEGORY COVER FAILED: $coverUrl - $e');
                }
              }
            }
          } catch (e) {
            print('⚠️ PRECACHE FIRST CATEGORY FROM CITY FAILED: $e');
          }
        }
      }

      // 2) Re-lecture du preload après warm (liste critique mise à jour)
      preloadData = ref.read(preloadControllerProvider);

      // 3) Précache batch des images critiques (T0) AVANT de retirer l’overlay
      await _precacheFirstBatchImages(context, preloadData.criticalImageUrls);

      // 4) Retrait de l’overlay (après précache)
      if (mounted) {
        setState(() {
          _overlayOpacity = 0.0;
        });

        // Supprimer overlay après animation
        Future.delayed(const Duration(milliseconds: 250), () {
          if (mounted) {
            print('🚀 OVERLAY REMOVED: Page révélée');
            setState(() {
              _isTransitioning = false;
              _overlayOpacity = 1.0; // Reset pour prochaine fois
            });
          }
        });
      }

      // 5) Warm complémentaire après fade-out (structure + carrousels)
      Future.delayed(const Duration(milliseconds: 250), () async {
        if (!mounted) return;

        try {
          final selectedCity = ref.read(selectedCityProvider);
          if (selectedCity == null) return;

          if (widget.initialTab == BottomNavTab.visiter) {
            print('🔥 HOME SHELL (CITY): Démarrage warm CategoryPage');

            // a) Récupère les catégories
            List<Category> categories;
            try {
              categories = await ref.read(categoriesProvider.future);
            } catch (_) {
              categories = <Category>[];
            }
            if (categories.isEmpty) return;

            final List<String> categoryIds = categories.map((c) => c.id).toList(growable: false);
            final String firstCategoryId = categories.first.id;

            print('🎯 WARM: ${categoryIds.length} catégories (première: ${categories.first.name})');

            // b) Warm headers (covers instantanés)
            await ref
                .read(preloadControllerProvider.notifier)
                .warmCategoryHeadersSilently(selectedCity, categoryIds, concurrency: 3);

            // c) Warm featured carousels (structure instantanée)
            await ref
                .read(preloadControllerProvider.notifier)
                .warmFeaturedCarouselsSilently(selectedCity, itemsPerCarousel: 3, concurrency: 3);

            // d) Vérification sans firstOrNull
            WidgetsBinding.instance.addPostFrameCallback((_) {
              final data = ref.read(preloadControllerProvider);
              final firstHeader = data.categoryHeaders[firstCategoryId];

              String? firstFeaturedKey;
              for (final String key in data.carouselData.keys) {
                if (key.startsWith('cat:$firstCategoryId:featured:')) {
                  firstFeaturedKey = key;
                  break;
                }
              }

              final int featuredCount = (firstFeaturedKey != null)
                  ? (data.carouselData[firstFeaturedKey]?.length ?? 0)
                  : 0;

              print('🔍 VERIF PREMIÈRE CATÉGORIE: '
                  'header="${firstHeader?.title}" cover=${(firstHeader?.coverUrl.isNotEmpty ?? false)} '
                  'featuredKey="$firstFeaturedKey" items=$featuredCount');
            });

            print('✅ HOME SHELL (CITY): Warm CategoryPage terminé');
          } else if (widget.initialTab == BottomNavTab.explorer) {
            // Depuis CategoryPage : déjà préchargé par T0
            print('🔥 HOME SHELL (CATEGORY): Pas de warm nécessaire (déjà en T0)');
          }
        } catch (e) {
          print('❌ HOME SHELL WARM: Erreur $e');
        }
      });
    });
  }

  /// ✅ Helper : Précache lot d'images critiques (max 24)
  Future<void> _precacheFirstBatchImages(BuildContext ctx, List<String> urls, {int max = 24}) async {
    print('🖼️ PRECACHING T0: ${urls.take(max).length} images critiques');
    for (final url in urls.take(max)) {
      try {
        await precacheImage(ImageProviderFactory.thumbnailProvider(url), ctx);
        print('✅ PRECACHED T0: $url');
      } catch (e) {
        print('⚠️ PRECACHE T0 FAILED: $url - $e');
      }
    }
    print('✅ PRECACHING T0: Terminé');
  }

}