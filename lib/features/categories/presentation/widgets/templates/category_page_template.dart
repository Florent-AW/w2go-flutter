// lib/features/categories/presentation/widgets/templates/category_page_template.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';

import 'package:travel_in_perigord_app/features/preload/preloader/subcategory_preloader.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_interactions.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/components/organisms/app_header.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../../core/domain/models/shared/subcategory_model.dart';
import '../../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../../core/domain/models/shared/city_model.dart' show City;
import '../../../../../core/common/utils/image_provider_factory.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../../categories/application/state/subcategories_provider.dart';
import '../../../../preload/preloader/subcategory_preloader_wiring.dart';
import '../../../../preload/application/preload_providers.dart';
import '../../../../search/application/state/featured_sections_by_subcategory_provider.dart';
import '../../../application/state/subcategories_provider.dart';
import '../../controllers/cover_controller.dart';
import '../atoms/subcategory_tab.dart';
import '../delegates/subcategory_tabs_delegate.dart';
import '../delegates/category_cover_with_tabs_delegate.dart';
import '../organisms/subcategory_activities_section.dart';
import '../organisms/featured_section_organism.dart';


/// Template pour les pages de catégories
class CategoryPageTemplate extends ConsumerStatefulWidget {
  /// La catégorie actuellement affichée
  final CategoryViewModel currentCategory;

  /// Liste de toutes les catégories disponibles
  final List<CategoryViewModel> allCategories;

  /// Callback quand une catégorie est sélectionnée
  final Function(CategoryViewModel) onCategorySelected;

  /// Callback quand le bouton de recherche est pressé
  final VoidCallback? onSearchTap;

  final Widget Function(BuildContext, VoidCallback, SearchableActivity)? openBuilder;

  const CategoryPageTemplate({
    Key? key,
    required this.currentCategory,
    required this.allCategories,
    required this.onCategorySelected,
    this.onSearchTap,
    this.openBuilder,
  }) : super(key: key);

  @override
  ConsumerState<CategoryPageTemplate> createState() => _CategoryPageTemplateState();
}

class _CategoryPageTemplateState extends ConsumerState<CategoryPageTemplate>
    with TickerProviderStateMixin {

  CategoryCoverWithTabsDelegate? _coverDelegate;
  late final CoverController coverController;
  late ScrollController _tabScrollController;
  late ScrollController _subcategoryScrollController;
  final List<GlobalKey> _categoryTabKeys = [];
  late TabController _subcategoryTabController;
  late final ScrollController _verticalController;
  bool _isAnimating = false;
  bool _isHeaderScrolled = false;
  CategoryViewModel? _previousCategory;

  // Ajouter pour gérer les chips de sous-catégories
  final Map<String, List<GlobalKey>> _subcategoryChipKeys = {};

  var currentSubcategoryProvider;

  // Gestion offset via PageStorage (persiste entre reconstructions)
  double _initialOffset = 0.0;
  bool _usedHandoffOffset = false;
  bool _suppressRestoreOnce = false;

  // Écoute changement de ville pour déclencher T3
  ProviderSubscription<City?>? _citySub;

  @override
  void initState() {
    super.initState();
    coverController = CoverController(widget.currentCategory);
    _tabScrollController = ScrollController();
    _subcategoryScrollController = ScrollController();
    _previousCategory = null;
    // Restaurer offset avec priorité au handoff depuis la catégorie précédente
    final handoff = _consumeHandoffOffsetFor(widget.currentCategory.id);
    if (handoff != null) {
      _initialOffset = handoff;
      _usedHandoffOffset = true;
      _suppressRestoreOnce = true; // désactive la restauration PageStorage pour 1 frame
    } else {
      // Ne pas restaurer par catégorie; utiliser seulement la dernière position globale
      _initialOffset = _readLastGlobalOffset() ?? 0.0;
    }
    _verticalController = ScrollController(
      // Désactiver la persistance automatique par PageStorage
      keepScrollOffset: false,
      initialScrollOffset: _initialOffset,
    );
    _categoryTabKeys.addAll(
        List.generate(widget.allCategories.length, (_) => GlobalKey())
    );

    // Initialiser avec une valeur par défaut, mais ne pas l'utiliser tout de suite
    _subcategoryTabController = TabController(
      length: 1,
      vsync: this,
    );

    // Écouter les changements de ville et déclencher le T3 de la catégorie courante
    _citySub = ref.listenManual(selectedCityProvider, (previous, next) {
      if (next != null && previous?.id != next.id) {
        // Re-câbler le preloader et déclencher T3 pour la catégorie affichée
        try {
          // Scope par ville, puis re-wire
          SubcategoryPreloader.instance.setScope(next.id);
          wireSubcategoryPreloaderForCategory(
            ref: ref,
            city: next,
            categoryId: widget.currentCategory.id,
          );
        } catch (_) {}
        // Déclencher immédiatement (sans attendre frame), si le widget est monté
        if (mounted) {
          _triggerT3Preload(widget.currentCategory.id);
        }
      }
    });
  }

  @override
  void dispose() {
    _citySub?.close();
    try {
      // Sauvegarder uniquement l'offset global courant (pas par catégorie)
      if (_verticalController.hasClients) {
        final bucket = PageStorage.of(context);
        bucket?.writeState(
          context,
          _verticalController.position.pixels,
          identifier: 'last_global_offset',
        );
      }
    } catch (_) {}
    _tabScrollController.dispose();
    _subcategoryScrollController.dispose();
    _subcategoryTabController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CategoryPageTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentCategory.id != widget.currentCategory.id) {
      // ✅ HEADER INSTANTANÉ avec preload lors changement catégorie
      final preloadData = ref.read(preloadControllerProvider);
      final categoryHeader = preloadData.categoryHeaders[widget.currentCategory.id];

      // Utiliser header préchaché ou fallback
      final displayTitle = categoryHeader?.title ?? widget.currentCategory.name;
      final displayCoverUrl = categoryHeader?.coverUrl ?? widget.currentCategory.imageUrl;

      // ✅ Mettre à jour avec données préchargées
      coverController.updateCategoryWithPreload(
        widget.currentCategory,
        preloadTitle: displayTitle,
        preloadCoverUrl: displayCoverUrl,
      );

      // S'assurer que les clés des catégories sont mises à jour si la liste a changé
      if (oldWidget.allCategories.length != widget.allCategories.length) {
        _categoryTabKeys.clear();
        _categoryTabKeys.addAll(
            List.generate(widget.allCategories.length, (_) => GlobalKey())
        );
      }

      // Appliquer un handoff d'offset si fourni pour éviter le flash et forcer la parité visuelle
      final double? handoff = _consumeHandoffOffsetFor(widget.currentCategory.id);
      if (handoff != null) {
        // Appliquer immédiatement l'offset pour éviter tout premier paint à l'ancienne position
        if (_verticalController.hasClients) {
          final max = _verticalController.position.maxScrollExtent;
          final clamped = handoff.clamp(0.0, max);
          if ((_verticalController.position.pixels - clamped).abs() > 0.5) {
            _verticalController.jumpTo(clamped);
          }
          _isHeaderScrolled = clamped > 150.0;
        } else {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) return;
            if (_verticalController.hasClients) {
              final max = _verticalController.position.maxScrollExtent;
              final clamped = handoff.clamp(0.0, max);
              if ((_verticalController.position.pixels - clamped).abs() > 0.5) {
                _verticalController.jumpTo(clamped);
              }
              _isHeaderScrolled = clamped > 150.0;
            }
          });
        }
      }

      // Header scrolled recalculé sur prochaine frame via listener
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ TOUJOURS initialiser le cover controller
    try {
      // ✅ HEADER INSTANTANÉ avec preload
      final preloadData = ref.read(preloadControllerProvider);
      final categoryHeader = preloadData.categoryHeaders[widget.currentCategory.id];

      if (categoryHeader != null) {
        // ✅ Utiliser données preload si disponibles
        coverController.updateCategoryWithPreload(
          widget.currentCategory,
          preloadTitle: categoryHeader.title,
          preloadCoverUrl: categoryHeader.coverUrl,
        );
        print('🎯 COVER INIT PRELOAD: ${categoryHeader.title}');

        // 🔔 T3: précharger les sous-catégories de la catégorie affichée
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _triggerT3Preload(widget.currentCategory.id);
        });
      } else {
        // ✅ Fallback normal si pas de preload
        coverController.updateCategory(widget.currentCategory);
        print('🎯 COVER INIT NORMAL: ${widget.currentCategory.name}');
      }

    } catch (e) {
      print('⚠️ PRELOAD HEADER: Erreur récupération, fallback vers données normales: $e');
      // ✅ Fallback robuste en cas d'erreur
      coverController.updateCategory(widget.currentCategory);
    }

    // ✅ Câbler le préloader T3 pour la catégorie courante si la ville est connue
    try {
      final city = ref.read(selectedCityProvider);
      if (city != null) {
        // Scope le preloader par ville pour réactiver T3 à chaque changement de ville
        SubcategoryPreloader.instance.setScope(city.id);
        wireSubcategoryPreloaderForCategory(
          ref: ref,
          city: city,
          categoryId: widget.currentCategory.id,
        );

        // ✅ Toujours déclencher T3 après wiring, même si le header n'est pas déjà préchauffé
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _triggerT3Preload(widget.currentCategory.id);
          }
        });
      }
    } catch (_) {}

      // ✅ TOUJOURS créer le delegate (même en cas d'erreur preload)
    _coverDelegate = CategoryCoverWithTabsDelegate(
      controller: coverController,
      categories: widget.allCategories,
      onCategorySelected: _handleCategoryChange,
      screenHeight: MediaQuery.of(context).size.height,
      tabScrollController: _tabScrollController,
      tabKeys: _categoryTabKeys,
      contextRef: context,
    );

      // Appliquer initialScrollOffset si nécessaire (premier build)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        if (_verticalController.hasClients) {
          // Si on a utilisé un handoff, ne pas rejouer une restauration qui causerait un flash
          if (!_usedHandoffOffset) {
            final stored = _readLastGlobalOffset();
            if (stored != null) {
              final max = _verticalController.position.maxScrollExtent;
              final clamped = stored.clamp(0.0, max);
              if ((_verticalController.position.pixels - clamped).abs() > 0.5) {
                _verticalController.jumpTo(clamped);
              }
              setState(() {
                _isHeaderScrolled = clamped > 150.0;
              });
            }
          }
          // lever le suppression flag après la première frame
          if (_suppressRestoreOnce) {
            setState(() => _suppressRestoreOnce = false);
          }
        }
      });
  }


  // Méthode pour mettre à jour le TabController quand les sous-catégories changent
  void _updateTabController(List<Subcategory> subcategories,
      Subcategory? selectedSubcategory) {
    // Vérifier si le contrôleur doit être mis à jour
    if (_subcategoryTabController.length != subcategories.length) {
      // Disposer immédiatement l'ancien contrôleur
      _subcategoryTabController.dispose();

      // Créer un nouveau contrôleur
      _subcategoryTabController = TabController(
        length: subcategories.length,
        vsync: this,
      );
    }

    // Gérer la sélection de l'onglet
    if (selectedSubcategory != null) {
      final index = subcategories.indexWhere((s) =>
      s.id == selectedSubcategory.id);
      if (index >= 0 && index != _subcategoryTabController.index) {
        _subcategoryTabController.animateTo(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
      }
    }
  }

  void _handleCategoryChange(CategoryViewModel category, int index) async {
    // Marquer l'animation comme active
    setState(() {
      _isAnimating = true;
      _previousCategory = widget.currentCategory;
    });

    // 0) Synchroniser l'offset de la catégorie cible avec l'offset courant (parité visuelle)
    try {
      final double currentOffset = _verticalController.hasClients
          ? _verticalController.position.pixels
          : 0.0;
      final bucket = PageStorage.of(context);
      // Stocker un handoff dédié à la catégorie cible (consommé au prochain init)
      bucket?.writeState(
        context,
        currentOffset,
        identifier: 'handoff_offset_${category.id}',
      );
    } catch (_) {}

    // ✅ 1) Récupérer header préchargé ou fallback
    final preloadData = ref.read(preloadControllerProvider);
    final categoryHeader = preloadData.categoryHeaders[category.id];
    final nextTitle = categoryHeader?.title ?? category.name;
    final nextCover = categoryHeader?.coverUrl ?? category.imageUrl;

    // ✅ 2) Précache cover AVANT de switcher (zéro flash)
    if (nextCover.isNotEmpty) {
      try {
        await precacheImage(
            ImageProviderFactory.coverProvider(nextCover, category.id),
            context
        );        print('🖼️ PRECACHED SWITCH COVER: $nextCover');
      } catch (e) {
        print('⚠️ PRECACHE SWITCH COVER FAILED: $nextCover - $e');
      }
    }

    // ✅ 3) Mise à jour UI instantanée (cover déjà décodée)
    coverController.updateCategoryWithPreload(
      category,
      preloadTitle: nextTitle,
      preloadCoverUrl: nextCover,
    );

    // 4) Notifier le parent
    widget.onCategorySelected(category);

    final city = ref.read(selectedCityProvider);
    final subcat = ref.read(currentSubcategoryProvider.select((s) => s?.id)); // adapte le provider/chemin

    if (city != null && subcat != null) {
      wireSubcategoryPreloaderWith(
        ref: ref,
        city: city,
        categoryId: category.id,
        subcategoryId: subcat,
      );
    }

    // 5)🔔 T3: précharger les sous-catégories de la nouvelle catégorie
    _triggerT3Preload(category.id);



    // 6) Fin d'animation inchangée
    Future.delayed(AppInteractions.categoryContentFadeDelay, () {
      Future.delayed(AppInteractions.categoryFadeDuration, () {
        if (mounted) {
          setState(() {
            _isAnimating = false;
            _previousCategory = null;
          });
        }
      });
    });
  }

  Future<void> _triggerT3Preload(String categoryId) async {
    try {
      print('[T3] 🔔 trigger depuis CategoryPageTemplate pour $categoryId');
      await SubcategoryPreloader.instance.preloadForCategoryT3(
        context: context,
        categoryId: categoryId,
      );
    } catch (e, st) {
      // Si les fetchers ne sont pas câblés, on log plutôt que crasher
      print('[T3] ❌ preloadForCategoryT3 a échoué: $e');
      print(st);
    }
  }


  @override
  Widget build(BuildContext context) {
    // Utiliser les physics appropriées selon la plateforme
    final scrollPhysics = Theme
        .of(context)
        .platform == TargetPlatform.iOS
        ? const BouncingScrollPhysics()
        : const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

    return Scaffold(
      backgroundColor: Theme
          .of(context)
          .colorScheme
          .background,
      extendBodyBehindAppBar: true,
      // 1. Remettre le header en tant que appBar du Scaffold plutôt que SliverAppBar
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: _isHeaderScrolled ? AppColors.blueBackground : Colors.transparent,
          child: SafeArea(
            child: AppHeader(
              onSearchTap: widget.onSearchTap,
              searchText: 'Trouvez des activités',
              iconColor: Colors.white,
              locationTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white,
                shadows: [],
              ),
              // ✅ Padding et height gérés dans AppHeader
              targetPageType: 'category',
            ),
          ),
        ),
      ),      body: MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: RepaintBoundary(
          child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification &&
                notification.depth ==
                    0) { // depth 0 = scroll principal (vertical)

              final isScrolled = notification.metrics.pixels > 150;
              if (isScrolled != _isHeaderScrolled) {
                setState(() => _isHeaderScrolled = isScrolled);
              }

                // Mémoriser uniquement l'offset global dans PageStorage
                final bucket = PageStorage.of(context);
                if (bucket != null) {
                  bucket.writeState(
                    context,
                    notification.metrics.pixels,
                    identifier: 'last_global_offset',
                  );
                }
            }
            return false;
          },
          child: CustomScrollView(
              // Unifier la clé pour éviter une restauration par catégorie
              key: const PageStorageKey('category_scroll_global'),
            controller: _verticalController, // contrôleur dédié
            primary: false,                  // sinon le PrimaryScrollController reprend la main
            physics: scrollPhysics,
            slivers: [
              // Plus de SliverAppBar ici, commencer directement avec la cover
              SliverPersistentHeader(
                pinned: false,
                delegate: _coverDelegate!, // Utiliser l'instance stable initialisée dans didChangeDependencies
              ),

              // ✅ 3. Featured Activities - SIMPLIFIÉ avec Organism
              SliverToBoxAdapter(
                key: PageStorageKey('featured_section_${widget.currentCategory.id}'),
                child: RepaintBoundary(
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Ajouter de l'espace en haut
                        SizedBox(height: AppDimensions.spacingM),

                        // ✅ NOUVEAU : Organism unifié pour Featured
                        FeaturedSectionOrganism(
                          currentCategory: widget.currentCategory,
                          openBuilder: widget.openBuilder,
                        ),
                      ],
                    ),
                  ),
                ),
              ),


              // 4. Subcategory Selector - AVEC SKELETON PENDANT CHARGEMENT
              Consumer(
                builder: (context, ref, _) {
                  final selectedCity = ref.watch(selectedCityProvider);
                  final selectedSubcategory = ref.watch(
                      selectedSubcategoryByCategoryProvider(widget.currentCategory.id)
                  );

                  // ✅ NOUVEAU : Utiliser le provider filtré avec skeleton
                  final subcategoriesAsync = ref.watch(subcategoriesWithContentProvider((
                  categoryId: widget.currentCategory.id,
                  city: selectedCity,
                  )));

                  return subcategoriesAsync.when(
                    data: (subcategoriesWithContent) {
                      // Si aucune sous-catégorie n'a de contenu, masquer complètement
                      if (subcategoriesWithContent.isEmpty) {
                        return SliverToBoxAdapter(child: SizedBox.shrink());
                      }

                      // Ajuster la sélection si nécessaire
                      if (selectedSubcategory != null &&
                          !subcategoriesWithContent.contains(selectedSubcategory)) {
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          ref.read(selectedSubcategoryByCategoryProvider(widget.currentCategory.id).notifier)
                              .state = subcategoriesWithContent.first;
                        });
                      }

                      // Mettre à jour le TabController avec les sous-catégories filtrées
                      _updateTabController(subcategoriesWithContent, selectedSubcategory);

                      return SliverPersistentHeader(
                        pinned: false,
                        delegate: SubcategoryTabsDelegate(
                          subcategories: subcategoriesWithContent,
                          tabController: _subcategoryTabController,
                          onSubcategorySelected: (subcategory, index) {
                            ref.read(selectedSubcategoryByCategoryProvider(widget.currentCategory.id).notifier)
                                .state = subcategory;
                          },
                          categoryColor: AppColors.getCategoryColor(
                              widget.currentCategory.name,
                              isDark: Theme.of(context).brightness == Brightness.dark),
                        ),
                      );
                    },

                    // ✅ NOUVEAU : Skeleton pendant le chargement
                    loading: () => SliverPersistentHeader(
                      pinned: false,
                      delegate: _SubcategoryTabsSkeletonDelegate(
                        categoryColor: AppColors.getCategoryColor(
                            widget.currentCategory.name,
                            isDark: Theme.of(context).brightness == Brightness.dark),
                      ),
                    ),

                    // ✅ Masquer en cas d'erreur
                    error: (error, stackTrace) => SliverToBoxAdapter(child: SizedBox.shrink()),
                  );
                },
              ),


              // 5. Subcategory Activities - Déjà corrigé avec une clé constante
              SliverToBoxAdapter(
                key: PageStorageKey('subcategory_section_${widget.currentCategory.id}'),
                // Renommé pour plus de clarté
                child: SubcategoryActivitiesSection(
                  openBuilder: widget.openBuilder,
                ),
              ),
            ],
          ),
        ),
      ),
    ),
    );
  }

  // Helpers de restauration d'offset
  double? _readStoredOffsetFor(String categoryId) {
    try {
      final bucket = PageStorage.of(context);
      final value = bucket?.readState(context, identifier: 'offset_$categoryId');
      if (value is double) return value;
      if (value is num) return value.toDouble();
    } catch (_) {}
    return null;
  }

  double? _readLastGlobalOffset() {
    try {
      final bucket = PageStorage.of(context);
      final value = bucket?.readState(context, identifier: 'last_global_offset');
      if (value is double) return value;
      if (value is num) return value.toDouble();
    } catch (_) {}
    return null;
  }

  // Consomme et supprime le handoff offset si présent pour éviter un second jump (flash)
  double? _consumeHandoffOffsetFor(String categoryId) {
    try {
      final bucket = PageStorage.of(context);
      final id = 'handoff_offset_${categoryId}';
      final value = bucket?.readState(context, identifier: id);
      if (value != null) {
        // effacer après lecture
        bucket?.writeState(context, null, identifier: id);
      }
      if (value is double) return value;
      if (value is num) return value.toDouble();
    } catch (_) {}
    return null;
  }

}
/// Delegate pour afficher un skeleton des onglets de sous-catégories
class _SubcategoryTabsSkeletonDelegate extends SliverPersistentHeaderDelegate {
  final Color categoryColor;
  final double height;

  _SubcategoryTabsSkeletonDelegate({
    required this.categoryColor,
    this.height = 72.0,
  });

  @override
  double get minExtent => height;

  @override
  double get maxExtent => height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    // ✅ CORRECTION : Pas de TabBar, juste ListView avec SubcategoryTab
    return Skeletonizer(
      enabled: true,
      child: SizedBox(
        height: height - 1,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.only(left: AppDimensions.spacingS),
          itemCount: 4, // ✅ Nombre d'onglets skeleton
          itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.only(right: AppDimensions.spacingS),
              child: SubcategoryTab(
                // ✅ MOCK DATA
                subcategory: Subcategory(
                  id: 'skeleton-$index',
                  name: 'Skeleton ${index + 1}',
                  categoryId: 'mock',
                ),
                isSelected: index == 0, // Premier sélectionné
                categoryColor: categoryColor,
                height: height - 8,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}