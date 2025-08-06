// lib/features/categories/presentation/widgets/organisms/subcategory_activities_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/domain/models/shared/subcategory_model.dart';
import '../../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../../core/domain/models/event/search/searchable_event.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/domain/pagination/paginated_data_provider.dart';
import '../../../../experience_detail/presentation/pages/experience_detail_page.dart';
import '../../../../shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../../shared_ui/presentation/widgets/molecules/experience_carousel_wrapper.dart';
import '../../../../search/application/state/section_discovery_providers.dart';
import '../../../../preload/application/preload_providers.dart';
import '../../../application/pagination/category_pagination_providers.dart';
import '../../../application/state/categories_provider.dart';
import '../../../application/state/subcategories_provider.dart';

/// Widget pour afficher les sections d'activités d'une sous-catégorie
/// Utilise les vrais providers pour afficher les données
class SubcategoryActivitiesSection extends ConsumerWidget {
  final Widget Function(BuildContext, VoidCallback, SearchableActivity)? openBuilder;

  const SubcategoryActivitiesSection({
    Key? key,
    this.openBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentCategory = ref.watch(selectedCategoryProvider);
    final selectedSubcategory = ref.watch(selectedSubcategoryByCategoryProvider(currentCategory?.id ?? ''));
    final selectedCity = ref.watch(selectedCityProvider);

    // Si aucune sous-catégorie n'est sélectionnée, afficher un message
    if (selectedSubcategory == null) {
      return _buildNoSubcategorySelectedUI(context);
    }

    // Si aucune ville sélectionnée
    if (selectedCity == null) {
      return _buildLoadingSkeleton(context, selectedSubcategory);
    }

    return _buildSubcategorySections(context, ref, currentCategory, selectedSubcategory, selectedCity);
  }

  /// Construit les sections Subcategory avec les vraies données
  Widget _buildSubcategorySections(BuildContext context, WidgetRef ref, dynamic currentCategory, Subcategory selectedSubcategory, dynamic selectedCity) {
    final sectionsAsync = ref.watch(effectiveSubcategorySectionsProvider(currentCategory?.id));

    return sectionsAsync.when(
      data: (sections) {
        if (sections.isEmpty) {
          return _buildNoSectionsAvailableUI(context);
        }

        // ✅ NOUVEAU : Récupérer preload data
        final preloadData = ref.watch(preloadControllerProvider);
        final sectionWidgets = <Widget>[];

        for (final section in sections) {
          final params = createSubcategoryParams(
            city: selectedCity,
            sectionId: section.id,
            categoryId: currentCategory?.id ?? '',
            subcategoryId: selectedSubcategory.id,
          );

          // ✅ NOUVEAU : Clé de fallback preload
          final fallbackKey = 'cat:${currentCategory?.id}:sub:${selectedSubcategory.id}:${section.id}';
          final fallbackExperiences = preloadData.carouselData[fallbackKey];

          sectionWidgets.add(
            Container(
              margin: EdgeInsets.only(bottom: AppDimensions.spacingXs),
              child: ExperienceCarouselWrapper(
                key: ValueKey('subcategory_unified_${currentCategory?.id}_${selectedSubcategory.id}_${section.id}'),
                paginationProvider: categorySubcategoryPaginationProvider,
                providerParams: params,
                carouselContext: CarouselContext.categorySub,
                title: section.title,
                heroPrefix: 'subcategory-${currentCategory?.id}-${selectedSubcategory.id}-${section.id}',
                openBuilder: _buildOpenBuilder(),
                showDistance: true,
                // ✅ NOUVEAU : Fallback avec données preload
                fallbackExperiences: fallbackExperiences,
              ),
            ),
          );
        }

        if (sectionWidgets.isEmpty) {
          return _buildNoActivitiesFoundUI(context, selectedSubcategory.name);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: AppDimensions.spacingXs),
            ...sectionWidgets,
            const SizedBox(height: 80),
          ],
        );
      },
      loading: () => _buildLoadingSkeleton(context, selectedSubcategory),
      error: (error, stack) {
        print('❌ SUBCATEGORY SECTIONS: Erreur: $error');
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              "Erreur de chargement: $error",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
              ),
            ),
          ),
        );
      },
    );
  }

  /// OpenBuilder unifié pour les expériences
  Widget Function(BuildContext, VoidCallback, dynamic)? _buildOpenBuilder() {
    return openBuilder != null
        ? (context, action, experience) {
      if (experience is ExperienceItem) {
        return ExperienceDetailPage(
          experienceItem: experience,
          onClose: action,
        );
      } else {
        // Fallback legacy
        try {
          if (experience is SearchableEvent) {
            return ExperienceDetailPage(
              experienceItem: ExperienceItem.event(experience),
              onClose: action,
            );
          } else if (experience is SearchableActivity) {
            return openBuilder!(context, action, experience);
          }
        } catch (e) {
          print('❌ OpenBuilder error: $e');
        }
        // Fallback par défaut
        return ExperienceDetailPage(
          experienceItem: experience is ExperienceItem
              ? experience
              : ExperienceItem.activity(experience as SearchableActivity),
          onClose: action,
        );
      }
    }
        : null;
  }

  Widget _buildLoadingSkeleton(BuildContext context, Subcategory selectedSubcategory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDimensions.spacingXs),
        Container(
          height: AppDimensions.activityCardHeight + AppDimensions.space20,
          margin: EdgeInsets.only(bottom: AppDimensions.spacingXs),
          child: const GenericExperienceCarousel(
            title: 'Chargement sections...',
            experiences: null,
            isLoading: true,
          ),
        ),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildNoSectionsAvailableUI(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "Aucune section disponible",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.neutral500,
          ),
        ),
      ),
    );
  }

  Widget _buildNoSubcategorySelectedUI(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              "Sélectionnez une sous-catégorie pour explorer les activités",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.neutral500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoActivitiesFoundUI(BuildContext context, String subcategoryName) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          "Aucune activité trouvée pour $subcategoryName",
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.neutral500,
          ),
        ),
      ),
    );
  }
}