// lib/features/categories/presentation/widgets/organisms/featured_section_organism.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../../core/domain/models/event/search/searchable_event.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart';
import '../../../../shared_ui/presentation/widgets/molecules/experience_carousel_wrapper.dart';
import '../../../../preload/application/preload_providers.dart';
import '../../../../preload/application/preload_controller.dart';
import '../../../application/pagination/category_pagination_providers.dart';
import '../../../../search/application/state/experience_providers.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../../experience_detail/presentation/pages/experience_detail_page.dart';

/// Organism pour afficher la section Featured d'une catégorie
/// Utilise les vrais providers pour afficher les données
class FeaturedSectionOrganism extends ConsumerWidget {
  /// La catégorie actuellement affichée
  final CategoryViewModel currentCategory;

  /// Callback pour ouvrir une expérience (legacy compatibility)
  final Widget Function(BuildContext, VoidCallback, SearchableActivity)? openBuilder;

  const FeaturedSectionOrganism({
    Key? key,
    required this.currentCategory,
    this.openBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCity = ref.watch(selectedCityProvider);

    // Si aucune ville sélectionnée, afficher un skeleton
    if (selectedCity == null) {
      return SizedBox(
        height: AppDimensions.activityCardHeight + AppDimensions.space20,
        child: const GenericExperienceCarousel(
          title: 'Chargement...',
          experiences: null,
          isLoading: true,
        ),
      );
    }

    return _buildFeaturedSections(ref, selectedCity);
  }

  /// Construit les sections Featured avec les données réelles
  Widget _buildFeaturedSections(WidgetRef ref, dynamic selectedCity) {
    // ✅ NOUVEAU : Récupérer header preload pour titre stable
    final preloadData = ref.watch(preloadControllerProvider);
    final categoryHeader = preloadData.categoryHeaders[currentCategory.id];

    final sectionsAsync = ref.watch(featuredSectionsByCategoryProvider(currentCategory.id));

    return sectionsAsync.when(
      data: (sections) {
        print('🎯 FEATURED SECTIONS DATA: Reçu ${sections.length} sections');
        if (sections.isEmpty) {
          return const SizedBox.shrink();
        }

        final sectionWidgets = <Widget>[];
        for (final section in sections) {
          sectionWidgets.add(
            _buildFeaturedSectionWithData(ref, section, selectedCity, categoryHeader),
          );
        }

        return Column(children: sectionWidgets);
      },
      loading: () => Container(
        height: AppDimensions.activityCardHeight + AppDimensions.space20,
        margin: EdgeInsets.only(bottom: AppDimensions.spacingXs),
        child: const GenericExperienceCarousel(
          title: 'Chargement sections...',
          experiences: null,
          isLoading: true,
        ),
      ),
      error: (error, stack) {
        print('❌ FEATURED SECTIONS: Erreur: $error');
        return const SizedBox.shrink();
      },
    );
  }

  /// Construit un carousel Featured avec le système de pagination + fallback preload
  Widget _buildFeaturedSectionWithData(WidgetRef ref, dynamic section, dynamic selectedCity, CategoryHeader? categoryHeader) {
    // Créer les paramètres pour le provider de pagination
    final params = createFeaturedParams(
      city: selectedCity,
      sectionId: section.id,
      categoryId: currentCategory.id,
    );

    // ✅ NOUVEAU : Récupérer les données preload comme fallback
    final preloadData = ref.watch(preloadControllerProvider);
    final fallbackKey = 'cat:${currentCategory.id}:featured:${section.id}';
    final fallbackExperiences = preloadData.carouselData[fallbackKey];

    // ✅ Titre dynamique de la section en priorité (depuis Supabase)
    final stableTitle = (section.title.isNotEmpty ? section.title : categoryHeader?.title) ?? 'À la une';

    return Container(
      margin: EdgeInsets.only(bottom: AppDimensions.spacingXs),
      child: ExperienceCarouselWrapper(
        key: ValueKey('featured_unified_${currentCategory.id}_${section.id}'),
        paginationProvider: categoryFeaturedPaginationProvider,
        providerParams: params,
        carouselContext: CarouselContext.categoryFeatured,
        title: stableTitle, // ✅ Titre stable
        heroPrefix: 'featured-${currentCategory.id}-${section.id}',
        openBuilder: _buildOpenBuilder(),
        showDistance: true,
        // ✅ NOUVEAU : Fallback avec données preload
        fallbackExperiences: fallbackExperiences,
      ),
    );
  }

  /// OpenBuilder unifié Activities + Events
  Widget Function(BuildContext, VoidCallback, dynamic)? _buildOpenBuilder() {
    return openBuilder != null
        ? (context, action, experience) {
      if (experience is ExperienceItem) {
        return ExperienceDetailPage(
          experienceItem: experience,
          onClose: action,
        );
      } else {
        // Fallback legacy pour SearchableActivity
        if (experience.isEvent) {
          return ExperienceDetailPage(
            experienceItem: experience is ExperienceItem
                ? experience
                : ExperienceItem.event(experience as SearchableEvent),
            onClose: action,
          );
        } else {
          return openBuilder!(context, action, experience.asActivity!);
        }
      }
    }
        : null;
  }
}