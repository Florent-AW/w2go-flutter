// lib/features/categories/presentation/widgets/templates/category_page_template.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_interactions.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../../core/domain/models/shared/subcategory_model.dart';
import '../../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../shared_ui/presentation/widgets/organisms/generic_bottom_bar.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../application/state/subcategories_provider.dart';
import '../../controllers/cover_controller.dart';
import '../atoms/subcategory_tab.dart';
import '../delegates/subcategory_tabs_delegate.dart';
import '../delegates/category_cover_with_tabs_delegate.dart';
import '../organisms/subcategory_activities_section.dart';
import '../organisms/category_header.dart';
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
  bool _isAnimating = false;
  bool _isHeaderScrolled = false;
  CategoryViewModel? _previousCategory;

  // Ajouter pour gérer les chips de sous-catégories
  final Map<String, List<GlobalKey>> _subcategoryChipKeys = {};

  @override
  void initState() {
    super.initState();
    coverController = CoverController(widget.currentCategory);
    _tabScrollController = ScrollController();
    _subcategoryScrollController = ScrollController();
    _previousCategory = null;
    _categoryTabKeys.addAll(
        List.generate(widget.allCategories.length, (_) => GlobalKey())
    );

    // Initialiser avec une valeur par défaut, mais ne pas l'utiliser tout de suite
    _subcategoryTabController = TabController(
      length: 1,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _tabScrollController.dispose();
    _subcategoryScrollController.dispose();
    _subcategoryTabController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CategoryPageTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.currentCategory.id != widget.currentCategory.id) {
      coverController.updateCategory(widget.currentCategory);

      // S'assurer que les clés des catégories sont mises à jour si la liste a changé
      if (oldWidget.allCategories.length != widget.allCategories.length) {
        _categoryTabKeys.clear();
        _categoryTabKeys.addAll(
            List.generate(widget.allCategories.length, (_) => GlobalKey())
        );
      }
    }
  }

  // Ajouter une méthode de centrage
  void _centerCategoryTab(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final tabKey = _categoryTabKeys[index];
      final ctx = tabKey.currentContext;
      if (ctx == null) return;

      final renderTab = ctx.findRenderObject() as RenderBox?;
      final renderTrack = _tabScrollController.position.context.storageContext
          .findRenderObject() as RenderBox?;
      if (renderTab == null || renderTrack == null) return;

      // Calcul de l'offset pour centrer l'onglet horizontalement
      final tabOffset = renderTab
          .localToGlobal(Offset.zero, ancestor: renderTrack)
          .dx;
      final tabWidth = renderTab.size.width;
      final viewportW = renderTrack.size.width;
      final wanted = _tabScrollController.offset +
          tabOffset - (viewportW - tabWidth) / 2;

      // Animation horizontale uniquement
      _tabScrollController.animateTo(
        wanted.clamp(
          _tabScrollController.position.minScrollExtent,
          _tabScrollController.position.maxScrollExtent,
        ),
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Créer le delegate seulement s'il n'existe pas encore ou si un changement pertinent est survenu
    if (_coverDelegate == null) {
      _coverDelegate = CategoryCoverWithTabsDelegate(
        controller: coverController,
        categories: widget.allCategories,
        onCategorySelected: _handleCategoryChange,
        screenHeight: MediaQuery
            .of(context)
            .size
            .height,
        tabScrollController: _tabScrollController,
        tabKeys: _categoryTabKeys,
        contextRef: context,
      );
    }
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

  void _handleCategoryChange(CategoryViewModel category, int index) {
    // Marquer l'animation comme active
    setState(() {
      _isAnimating = true;
      _previousCategory = widget.currentCategory;
    });

    // Informer le parent
    widget.onCategorySelected(category);

    // Centrer la catégorie
    _centerCategoryTab(index);

    // Uniquement conserver la gestion de fin d'animation
    Future.delayed(AppInteractions.categoryContentFadeDelay, () {
      // Marquer l'animation comme terminée après un délai
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
          color: _isHeaderScrolled
              ? AppColors.blueBackground
              : Colors.transparent,
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spacingS,
                // Utiliser la constante appropriée de vos AppDimensions
                vertical: 8,
              ),
              child: CategoryHeader(
                onSearchTap: widget.onSearchTap,
              ),
            ),
          ),
        ),
      ),
      body: MediaQuery.removePadding(
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
              }
              return false;
            },
            child: CustomScrollView(
              key: const PageStorageKey('category_scroll'),
              primary: true,
              physics: scrollPhysics,
              slivers: [
                // Plus de SliverAppBar ici, commencer directement avec la cover
                SliverPersistentHeader(
                  pinned: false,
                  delegate: _coverDelegate!, // Utiliser l'instance stable initialisée dans didChangeDependencies
                ),

                // ✅ 3. Featured Activities - SIMPLIFIÉ avec Organism
                SliverToBoxAdapter(
                  key: const PageStorageKey('featured_section'),
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
                  key: const PageStorageKey('subcategory_section'),
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
      bottomNavigationBar: GenericBottomBar( // ✅ AJOUTER cette section
        selectedTab: BottomNavTab.explorer,
        onTabSelected: (tab) {
          // TODO : Navigation vers les autres sections
          print('Navigation vers : $tab');
        },
      ),
    );
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