// lib/features/city_page/presentation/templates/city_page_template.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/components/organisms/app_header.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/shared/category_model.dart';
import '../../../../core/domain/models/search/config/section_metadata.dart';
import '../../../preload/application/pagination_controller.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart';
import '../../../shared_ui/presentation/widgets/molecules/experience_carousel_wrapper.dart';
import '../../../categories/application/state/categories_provider.dart';
import '../../application/providers/city_experiences_controller.dart';
import '../../application/pagination/city_pagination_providers.dart';
import '../widgets/delegates/city_page_cover_delegate.dart';
import '../widgets/delegates/city_page_cover_delegate_skeleton.dart';

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
      extendBodyBehindAppBar: true,
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
        removeTop: true,
        child: NotificationListener<ScrollNotification>(
          onNotification: (notification) {
            if (notification is ScrollUpdateNotification && notification.depth == 0) {
              final isScrolled = notification.metrics.pixels > 200;
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
              // 1. Cover défilable - ✅ GARDÉ TEL QUEL
              SliverPersistentHeader(
                pinned: false,
                delegate: experiencesAsync.when(
                  data: (categories) => _buildCoverDelegate(context, categories, screenWidth),
                  loading: () => CityPageCoverDelegateSkeleton(screenWidth: screenWidth),
                  error: (_, __) => _buildCoverDelegate(context, [], screenWidth),
                ),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.spacingM),
              ),
              // 2. Contenu principal - ✅ HYBRIDE : CityExperiencesController + Preload fallback
              experiencesAsync.when(
                data: (categories) => _buildCategorySections(context, categories),
                loading: () => _buildPreloadedSections(context), // ✅ NOUVEAU : Preload pendant loading
                error: (error, stackTrace) => _buildErrorSection(context, error),
              ),
              SliverToBoxAdapter(
                child: SizedBox(height: AppDimensions.spacingXl),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ✅ NOUVEAU : Sections avec données préchargées pendant le loading du controller
  Widget _buildPreloadedSections(BuildContext context) {
    final selectedCity = ref.watch(selectedCityProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    if (selectedCity == null) return _buildLoadingSections(context);

    return categoriesAsync.when(
      data: (categories) {
        return SliverList(
          delegate: SliverChildBuilderDelegate(
                (context, index) {
              final category = categories[index];

              return Container(
                margin: EdgeInsets.only(bottom: AppDimensions.spacingL),
                child: ExperienceCarouselWrapper(
                  key: ValueKey('city_preload_${category.id}'),
                  paginationProvider: cityActivitiesPaginationProvider,
                  providerParams: CityCarouselParams(
                    city: selectedCity,
                    sectionId: '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f', // Featured section
                    categoryId: category.id,
                  ),
                  title: category.name, // ✅ Vrai nom de catégorie
                  heroPrefix: 'city-preload-${category.id}',
                  openBuilder: widget.openBuilder,
                  showDistance: true,
                  onSeeAllPressed: () => _onSeeAllPressed(context, category, null),
                  // ✅ PAS de fallbackExperiences - le wrapper utilise directement le preload
                ),
              );
            },
            childCount: categories.length,
          ),
        );
      },
      loading: () => _buildLoadingSections(context),
      error: (_, __) => _buildLoadingSections(context),
    );
  }



  /// Construit les sections par catégorie avec des données
  Widget _buildCategorySections(BuildContext context, List<CategoryExperiences> categories) {
    // Filtrer les catégories qui ont du contenu
    final categoriesWithContent = categories.where((cat) => cat.sections.isNotEmpty).toList();

    if (categoriesWithContent.isEmpty) {
      return SliverToBoxAdapter(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(AppDimensions.spacingXl),
            child: Column(
              children: [
                Icon(
                  Icons.explore_off,
                  size: AppDimensions.iconSizeXl,
                  color: AppColors.neutral400,
                ),
                SizedBox(height: AppDimensions.spacingM),
                Text(
                  'Aucune expérience disponible',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.neutral600,
                  ),
                ),
                SizedBox(height: AppDimensions.spacingS),
                Text(
                  'Essayez de sélectionner une autre ville',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral500,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return SliverList(
      delegate: SliverChildBuilderDelegate(
            (context, categoryIndex) {
          final categoryExp = categoriesWithContent[categoryIndex];

          return Column(
            children: [
              // ✅ NOUVEAU : Pour chaque section, créer un carrousel paginé
              ...categoryExp.sections.map((sectionExp) {
                return _buildUnifiedPaginatedCarousel(
                  context,
                  categoryExp,
                  sectionExp,
                  categoryIndex,
                );
              }).toList(),

              // Espacement entre catégories
              if (categoryIndex < categoriesWithContent.length - 1)
                SizedBox(height: AppDimensions.spacingL),
            ],
          );
        },
        childCount: categoriesWithContent.length,
      ),
    );
  }

  /// ✅ NOUVEAU : Construit un carrousel paginé pour n'importe quelle section
  Widget _buildUnifiedPaginatedCarousel(
      BuildContext context,
      CategoryExperiences categoryExp,
      SectionExperiences sectionExp,
      int categoryIndex,
      ) {
    final selectedCity = ref.read(selectedCityProvider);
    if (selectedCity == null) return SizedBox.shrink();

    final params = CityCarouselParams(
      city: selectedCity,
      sectionId: sectionExp.section.id,
      categoryId: categoryExp.category.id,
    );

    return ExperienceCarouselWrapper(
      key: ValueKey('city_unified_${categoryExp.category.id}_${sectionExp.section.id}'),
      paginationProvider: cityActivitiesPaginationProvider,
      providerParams: params,
      title: sectionExp.section.title,
      heroPrefix: 'city-${categoryExp.category.id}-${sectionExp.section.id}',
      openBuilder: widget.openBuilder,
      showDistance: true,
      onSeeAllPressed: () => _onSeeAllPressed(context, categoryExp.category, sectionExp.section),
      // ✅ SUPPRIMÉ : fallbackExperiences
    );
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
    print('📋 Voir tout pour catégorie: ${category.name}');

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

}
