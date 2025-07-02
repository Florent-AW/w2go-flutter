// lib/features/city_page/presentation/templates/city_page_template.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/theme/components/organisms/app_header.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart';
import '../../../shared_ui/presentation/widgets/organisms/generic_bottom_bar.dart';
import '../../application/providers/city_experiences_controller.dart';

/// Template pour la page ville
/// Affiche les carrousels par catégorie sans sous-catégories
class CityPageTemplate extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final experiencesAsync = ref.watch(cityExperiencesControllerProvider(cityId));

    // Utiliser les physics appropriées selon la plateforme
    final scrollPhysics = Theme.of(context).platform == TargetPlatform.iOS
        ? const BouncingScrollPhysics()
        : const ClampingScrollPhysics(parent: AlwaysScrollableScrollPhysics());

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      // ✅ REPRENDRE l'approche CategoryPage
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Container(
          color: AppColors.background, // ✅ Couleur fixe pour CityPage
          child: SafeArea(
            child: AppHeader(
              onSearchTap: () => _onSearchTap(context),
              searchText: 'Trouver des activités',
              iconColor: AppColors.accent,
              locationTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.neutral800,
              ),
            ),
          ),
        ),
      ),
      // ✅ BODY avec CustomScrollView standard (pas de SliverAppBar)
      body: CustomScrollView(
        key: const PageStorageKey('city_scroll'),
        primary: true,
        physics: scrollPhysics,
        slivers: [
          // ✅ PLUS de SliverAppBar - commencer directement par le contenu

          // 1. Espacement après la barre
          SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.spacingM),
          ),

          // 2. Contenu principal basé sur l'état
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
    );  }

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
              // Pour chaque section de la catégorie, créer un carousel
              ...categoryExp.sections.map((sectionExp) {
                return Container(
                  margin: EdgeInsets.only(bottom: AppDimensions.spacingM),
                  child: GenericExperienceCarousel(
                    key: ValueKey('city-${cityId}-${categoryExp.category.id}-${sectionExp.section.id}'),
                    title: sectionExp.section.title,
                    experiences: sectionExp.experiences,
                    heroPrefix: 'city-${categoryExp.category.id}-${sectionExp.section.id}',
                    openBuilder: openBuilder,
                    showDistance: true,
                    onSeeAllPressed: () => _onSeeAllPressed(context, categoryExp.category, sectionExp.section),
                  ),
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
    print('🔄 Retry loading pour ville: $cityId');
  }

  /// Gère la navigation depuis la bottom bar
  void _handleBottomNavigation(BuildContext context, BottomNavTab tab) {
    switch (tab) {
      case BottomNavTab.explorer:
        Navigator.of(context).pushReplacementNamed('/category');
        break;
      case BottomNavTab.favoris:
      // TODO: Navigation vers favoris
        print('Navigation vers favoris');
        break;
      case BottomNavTab.visiter:
      // Déjà sur la page ville, ne rien faire
        break;
      case BottomNavTab.profil:
      // TODO: Navigation vers profil
        print('Navigation vers profil');
        break;
    }
  }

  /// Gère la recherche dans la ville
  void _onSearchTap(BuildContext context) {
    // TODO: Navigation vers page de recherche avec ville pré-sélectionnée
    print('🔍 Recherche dans la ville');
  }
}