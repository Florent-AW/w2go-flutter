// lib/features/city_page/presentation/templates/city_page_template.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/components/organisms/app_header.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart';
import '../../../preload/application/preload_providers.dart';
import '../../application/providers/city_experiences_controller.dart';
import '../widgets/delegates/city_page_cover_delegate.dart';
import '../widgets/delegates/city_page_cover_delegate_skeleton.dart';
import '../../application/pagination/city_pagination_providers.dart';

/// Template pour la page ville
/// Affiche les carrousels par catégorie sans sous-catégories
class CityPageTemplate extends ConsumerStatefulWidget {
  /// ID de la ville à afficher
  final String? cityId;

  /// Callback pour ouvrir une expérience
  final Widget Function(BuildContext, VoidCallback, ExperienceItem)? openBuilder;

  const CityPageTemplate({
    Key? key,
    required this.cityId,
    this.openBuilder,
  }) : super(key: key);

  @override
  ConsumerState<CityPageTemplate> createState() => _CityPageTemplateState();
}

class _CityPageTemplateState extends ConsumerState<CityPageTemplate> {
  bool _isHeaderScrolled = false; // ✅ Variable d'état pour le scroll

  @override
  Widget build(BuildContext context) {
    final experiencesAsync = ref.watch(cityExperiencesControllerProvider(widget.cityId));
    final screenWidth = MediaQuery.of(context).size.width;

    // Utiliser les physics appropriées selon la plateforme
    final scrollPhysics = Theme.of(context).platform == TargetPlatform.iOS
        ? const BouncingScrollPhysics()
        : const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      extendBodyBehindAppBar: true, // ✅ CLEF - Body derrière AppBar

      // ✅ AppBar sticky avec animation background/couleur
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          color: _isHeaderScrolled
              ? (Theme.of(context).brightness == Brightness.dark
              ? AppColors.backgroundDark
              : AppColors.background)
              : Colors.transparent,
          child: SafeArea(
            child: AppHeader(
              onSearchTap: () => _onSearchTap(context),
              searchText: 'Trouver des activités',
              iconColor: AppColors.accent,
              locationTextColor: _isHeaderScrolled
                  ? (Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppColors.primary)
                  : Colors.white,
              targetPageType: 'city',
            ),
          ),
        ),
      ),

      body: MediaQuery.removePadding(
        context: context,
        removeTop: true, // ✅ Supprime le padding du haut
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification && notification.depth == 0) {
              final isScrolled = notification.metrics.pixels > 200; // ✅ Seuil adapté à la cover
              if (isScrolled != _isHeaderScrolled) {
                setState(() => _isHeaderScrolled = isScrolled);
              }
            }
            return false;
          },
          child: CustomScrollView(
            key: const PageStorageKey('city_scroll'),
            primary: true,
            physics: scrollPhysics,
            slivers: [
              // 1. Cover défilable
              SliverPersistentHeader(
                pinned: false, // ✅ Cover défilable
                delegate: experiencesAsync.when(
                  data: (categories) => _buildCoverDelegate(context, categories, screenWidth),
                  loading: () => CityPageCoverDelegateSkeleton(screenWidth: screenWidth),
                  error: (_, __) => _buildCoverDelegate(context, [], screenWidth),
                ),
              ),

              SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.spacingM), // ✅ PADDING SOUS COVER
              ),

              // 2. Contenu principal (carrousels)
              experiencesAsync.when(
                data: (categories) => _buildCategorySections(context, categories),
                loading: () => _buildLoadingSections(context),
                error: (error, stackTrace) => _buildErrorSection(context, error),
              ),

              // 3. Espacement final
              SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.spacingXl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Construit les sections par catégorie avec des données
  /// Construit les sections par catégorie avec des données
  Widget _buildCategorySections(BuildContext context, List<CategoryExperiences> categories) {
    // Filtrer les catégories qui ont du contenu
    final categoriesWithContent = categories.where((cat) => cat.sections.isNotEmpty).toList();

    if (categoriesWithContent.isEmpty) {
      return SliverToBoxAdapter(/* ... message vide existant ... */);
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, categoryIndex) {
          final categoryExp = categoriesWithContent[categoryIndex];

          // ✅ NOUVEAU : Test du premier carrousel avec pagination
          if (categoryIndex == 0) {
            return _buildPaginatedCarousel(context, categoryExp);
          }

          // ✅ ANCIEN : Garder les autres carrousels avec l'ancien système
          return Column(/* ... code existant ... */);
        },
        childCount: categoriesWithContent.length,
      ),
    );
  }

  /// ✅ NOUVEAU : Widget de test pour le carrousel paginé
  Widget _buildPaginatedCarousel(BuildContext context, CategoryExperiences categoryExp) {
    final selectedCity = ref.read(selectedCityProvider);

    if (selectedCity == null) {
      return SizedBox.shrink();
    }

    final section = categoryExp.sections.first.section;

    final params = CityCarouselParams(
      city: selectedCity,
      sectionId: section.id,
      categoryId: categoryExp.category.id,
    );

    return Consumer(
      builder: (context, ref, child) {
        final controller = ref.watch(cityActivitiesPaginationProvider(params).notifier);
        final paginationState = ref.watch(cityActivitiesPaginationProvider(params));

        // ✅ GARDE : Initialiser UNE SEULE FOIS
        if (paginationState.items.isEmpty &&
            !paginationState.isLoading &&
            !paginationState.isLoadingMore) {

          print('🎯 INITIALISATION PAGINATION pour ${categoryExp.category.name}');
          WidgetsBinding.instance.addPostFrameCallback((_) {
            controller.loadInitial(); // ✅ Essayer loadInitial au lieu de loadPreload
          });
        }

        return Container(
          child: GenericExperienceCarousel(
            key: ValueKey('paginated-${categoryExp.category.id}'),
            title: '🔄 PAGINATION TEST - ${categoryExp.category.name} (${paginationState.items.length} items)',
            experiences: paginationState.items,
            isLoading: paginationState.isLoading,
            errorMessage: paginationState.error,
            heroPrefix: 'paginated-${categoryExp.category.id}',
            showDistance: true,
            isPartial: paginationState.isPartial,
            onRequestCompletion: () => _completePaginatedCarousel(params),
          ),
        );
      },
    );
  }
  /// ✅ NOUVEAU : Complétion pour carrousel paginé
  void _completePaginatedCarousel(CityCarouselParams params) {
    ref.read(cityActivitiesPaginationProvider(params).notifier).completeIfPartial();
  }

  /// Construit l'état de chargement avec skeletons
  Widget _buildLoadingSections(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, index) {
          return Container(
            margin: EdgeInsets.only(bottom: AppDimensions.spacingXl),
            child: Skeletonizer(
              enabled: true,
              child: GenericExperienceCarousel(
                key: ValueKey('city-loading-$index'),
                title: 'Chargement catégorie ${index + 1}',
                experiences: null,
                isLoading: true,
                loadingItemCount: 3,
                showDistance: true,
              ),
            ),
          );
        },
        childCount: 7, // 7 catégories max selon le brief
      ),
    );
  }

  /// Construit l'état d'erreur
  Widget _buildErrorSection(BuildContext context, Object error) {
    return SliverToBoxAdapter(
      child: Center(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spacingXl),
          child: Column(
            children: [
              Icon(
                Icons.error_outline,
                size: AppDimensions.iconSizeXl,
                color: AppColors.error,
              ),
              SizedBox(height: AppDimensions.spacingM),
              Text(
                'Erreur de chargement',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.error,
                ),
              ),
              SizedBox(height: AppDimensions.spacingS),
              Text(
                error.toString(),
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.neutral600,
                ),
              ),
              SizedBox(height: AppDimensions.spacingM),
              ElevatedButton(
                onPressed: () => _retryLoading(context),
                child: const Text('Réessayer'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Callback pour "Voir tout" - navigation vers CategoryPage
  void _onSeeAllPressed(BuildContext context, dynamic category, dynamic section) {
    print('📋 Voir tout pour catégorie: ${category.name}, section: ${section.title}');

    // Navigation vers CategoryPage avec cette catégorie
    Navigator.of(context).pushNamed(
      '/category/${category.id}',
    );
  }

  /// Retry en cas d'erreur
  void _retryLoading(BuildContext context) {
    // Le refresh sera géré automatiquement par Riverpod
    print('🔄 Retry loading pour ville: ${widget.cityId}');
  }

  /// Construit le delegate de cover avec données
  CityPageCoverDelegate _buildCoverDelegate(
      BuildContext context,
      List<CategoryExperiences> categories,
      double screenWidth
      ) {
    final totalExperiences = categories.fold<int>(
      0,
          (sum, category) => sum + category.sections.fold<int>(
        0,
            (sectionSum, section) => sectionSum + section.experiences.length,
      ),
    );

    final cityName = ref.read(selectedCityProvider)?.cityName ?? 'Ville inconnue';

    return CityPageCoverDelegate(
      cityName: cityName,
      activityCount: totalExperiences,
      screenWidth: screenWidth,
    );
  }

  /// Gère la recherche dans la ville
  void _onSearchTap(BuildContext context) {
    // TODO: Navigation vers page de recherche avec ville pré-sélectionnée
    print('🔍 Recherche dans la ville');
  }

  /// ✅ NOUVEAU : Détermine si un carrousel est partiel (chargé avec 5 items au lieu de 10+)
  bool _isCarouselPartial(String categoryId, int categoryIndex) {
    final preloadData = ref.read(preloadControllerProvider);

    // Chercher dans les infos de preload
    final carouselInfo = preloadData.carouselsInfo
        .where((info) => info.categoryId == categoryId)
        .firstOrNull;

    return carouselInfo?.isPartial ?? false;
  }

  /// ✅ NOUVEAU : Déclenche la complétion d'un carrousel
  void _completeCarousel(String categoryId) {
    print('🔄 DEMANDE COMPLÉTION pour catégorie: $categoryId');

    // Récupérer la ville sélectionnée
    final selectedCity = ref.read(selectedCityProvider);
    if (selectedCity == null) {
      print('❌ COMPLETION: Pas de ville sélectionnée');
      return;
    }

    // Appeler le controller pour compléter le carrousel
    ref.read(cityExperiencesControllerProvider(widget.cityId).notifier)
        .completeCarouselForCategory(categoryId, selectedCity);
  }


}