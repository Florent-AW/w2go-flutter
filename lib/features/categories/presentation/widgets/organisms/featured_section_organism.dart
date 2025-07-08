// lib/features/categories/presentation/widgets/organisms/featured_section_organism.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../../core/domain/models/event/search/searchable_event.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart';
import '../../../../search/application/state/experience_providers.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../../shared_ui/presentation/widgets/molecules/experience_carousel_wrapper.dart';
import '../../../../experience_detail/presentation/pages/experience_detail_page.dart';
import '../../../application/pagination/category_pagination_providers.dart';



/// Organism pour afficher la section Featured d'une catégorie
/// Utilise le wrapper unifié ExperienceCarouselWrapper (architecture identique CityPage)
class FeaturedSectionOrganism extends ConsumerStatefulWidget {
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
  ConsumerState<FeaturedSectionOrganism> createState() =>
      _FeaturedSectionOrganismState();
}


class _FeaturedSectionOrganismState extends ConsumerState<FeaturedSectionOrganism> {

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final selectedCity = ref.watch(selectedCityProvider);

    // Si aucune ville sélectionnée, afficher un skeleton
    if (selectedCity == null) {
      return SizedBox(
        height: AppDimensions.activityCardHeight + AppDimensions.space20,
        child: GenericExperienceCarousel(
          title: 'Chargement...',
          experiences: null,
          isLoading: true,
        ),
      );
    }

    return _buildFeaturedSections(selectedCity);
  }

  /// Construit les sections Featured avec fallback data (évite conflits)
  Widget _buildFeaturedSections(dynamic selectedCity) {
    final sectionsAsync = ref.watch(featuredSectionsByCategoryProvider(widget.currentCategory.id));

    return sectionsAsync.when(
      data: (sections) {
        print('🎯 FEATURED SECTIONS DATA: Reçu ${sections.length} sections à ${DateTime.now().millisecondsSinceEpoch}');

        if (sections.isEmpty) {
          return const SizedBox.shrink();
        }

        final sectionWidgets = <Widget>[];

        for (final section in sections) {
          sectionWidgets.add(
            _buildFeaturedSectionWithFallback(section, selectedCity),
          );
        }

        return Column(children: sectionWidgets);
      },
      loading: () => Container(
        height: AppDimensions.activityCardHeight + AppDimensions.space20,
        margin: EdgeInsets.only(bottom: AppDimensions.spacingXs),
        child: GenericExperienceCarousel(
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

  /// Construit un wrapper Featured avec données fallback pour éviter les conflits
  Widget _buildFeaturedSectionWithFallback(dynamic section, dynamic selectedCity) {
    const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
    final isEventsCategory = widget.currentCategory.id == eventsCategoryId;

    // ✅ RÉCUPÉRER les données existantes comme fallback
    final fallbackDataAsync = ref.watch(
        isEventsCategory
            ? featuredEventsBySectionProvider((
        sectionId: section.id,
        categoryId: widget.currentCategory.id,
        city: selectedCity,
        ))
            : featuredActivitiesBySectionProvider((
        sectionId: section.id,
        categoryId: widget.currentCategory.id,
        city: selectedCity,
        ))
    );

    return fallbackDataAsync.when(
      data: (fallbackExperiences) {
        print('🎯 FEATURED FALLBACK: ${section.title} avec ${fallbackExperiences.length} items à ${DateTime.now().millisecondsSinceEpoch}');

        final params = createFeaturedParams(
          city: selectedCity,
          sectionId: section.id,
          categoryId: widget.currentCategory.id,
        );

        return ExperienceCarouselWrapper(
          key: ValueKey('featured_unified_${widget.currentCategory.id}_${section.id}'),
          paginationProvider: categoryFeaturedPaginationProvider,
          providerParams: params,
          title: section.title,
          heroPrefix: 'featured-${widget.currentCategory.id}-${section.id}',
          openBuilder: _buildOpenBuilder(),
          showDistance: true,
          fallbackExperiences: fallbackExperiences, // ✅ DONNÉES FALLBACK
        );
      },
      loading: () => Container(
        height: AppDimensions.activityCardHeight + AppDimensions.space20,
        margin: EdgeInsets.only(bottom: AppDimensions.spacingXs),
        child: GenericExperienceCarousel(
          title: section.title,
          experiences: null,
          isLoading: true,
        ),
      ),
      error: (error, stack) {
        print('❌ FEATURED FALLBACK: Erreur ${section.title}: $error');
        return const SizedBox.shrink();
      },
    );
  }


  /// OpenBuilder unifié Activities + Events
  Widget Function(BuildContext, VoidCallback, dynamic)? _buildOpenBuilder() {
    return widget.openBuilder != null
        ? (context, action, experience) {
      if (experience is ExperienceItem) {
        return ExperienceDetailPage(
          experienceItem: experience,
          onClose: action,
        );
      } else {
// Fallback legacy pour SearchableActivity
        if (experience.isEvent) {
          print('Navigation vers événement: ${experience.name}');
          return ExperienceDetailPage(
            experienceItem: experience is ExperienceItem
                ? experience
                : ExperienceItem.event(experience as SearchableEvent),
            onClose: action,
          );
        } else {
          return widget.openBuilder!(context, action, experience.asActivity!);
        }
      }
    }
        : null;
  }
}