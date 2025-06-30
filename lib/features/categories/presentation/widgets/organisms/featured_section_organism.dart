// lib/features/categories/presentation/widgets/organisms/featured_section_organism.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../../core/domain/models/event/search/searchable_event.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart';
import '../../../../search/application/state/experience_providers.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../../experience_detail/presentation/pages/experience_detail_page.dart';

/// Organism pour afficher la section Featured d'une catégorie
/// Remplace les méthodes _buildFeaturedSection, _buildMultipleFeaturedSections, etc.
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
  ConsumerState<FeaturedSectionOrganism> createState() => _FeaturedSectionOrganismState();
}

class _FeaturedSectionOrganismState extends ConsumerState<FeaturedSectionOrganism> {
  // ✅ Stockage stable des contrôleurs par section
  final Map<String, InfiniteScrollController> _scrollControllers = {};

  // ✅ Tracker les changements pour reset les positions
  String? _lastCategoryId;

  @override
  void dispose() {
    // ✅ Nettoyer tous les contrôleurs
    for (final controller in _scrollControllers.values) {
      controller.dispose();
    }
    _scrollControllers.clear();
    super.dispose();
  }

  // ✅ Méthode pour obtenir/créer un contrôleur stable
  InfiniteScrollController _getControllerForSection(String sectionKey) {
    return _scrollControllers.putIfAbsent(
      sectionKey,
          () => InfiniteScrollController(initialItem: 0),
    );
  }

  // ✅ Méthode pour reset tous les contrôleurs
  void _resetAllControllers() {
    print('🔄 FEATURED: Reset des contrôleurs pour catégorie ${widget.currentCategory.id}');
    for (final controller in _scrollControllers.values) {
      if (controller.hasClients) {
        controller.jumpToItem(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedCity = ref.watch(selectedCityProvider);

    // ✅ NOUVEAU : Détecter changement de catégorie pour reset
    final currentCategoryId = widget.currentCategory.id;
    final hasChanged = _lastCategoryId != currentCategoryId;

    if (hasChanged) {
      _resetAllControllers();
      _lastCategoryId = currentCategoryId;
    }

    // ✅ Si aucune ville sélectionnée, afficher un skeleton
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

    // ✅ LOGIQUE UNIFIÉE : Toutes les catégories utilisent sections multiples
    return _buildMultipleFeaturedSections(selectedCity);
  }

  /// ✅ EXTRACTION : Events multiples sections avec contrôleurs
  Widget _buildMultipleFeaturedSections(dynamic selectedCity) {
    final sectionsAsync = ref.watch(featuredSectionsByCategoryProvider(widget.currentCategory.id));

    return sectionsAsync.when(
      data: (sections) {
        if (sections.isEmpty) {
          return const SizedBox.shrink(); // ✅ Rien si pas de sections
        }

        // ✅ CORRECTION : Filtrer et construire seulement les sections avec données
        final sectionWidgets = <Widget>[];

        for (int i = 0; i < sections.length; i++) {
          final section = sections[i];
          sectionWidgets.add(
            Consumer(
              builder: (context, ref, _) {
                // ✅ LOGIQUE INTELLIGENTE : Choisir le bon provider selon la catégorie
                const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
                final isEventsCategory = widget.currentCategory.id == eventsCategoryId;

                final experiencesAsync = ref.watch(
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

                return experiencesAsync.when(
                  data: (experiences) {
                    // ✅ CONDITION : Seulement si il y a des expériences
                    if (experiences.isEmpty) {
                      return const SizedBox.shrink(); // ✅ Rien du tout si vide
                    }

                    // ✅ Container seulement si il y a du contenu + contrôleur unique
                    return Container(
                      margin: EdgeInsets.only(bottom: AppDimensions.spacingM),
                      child: GenericExperienceCarousel(
                        key: ValueKey('featured_events_${widget.currentCategory.id}_${section.id}'),
                        scrollController: _getControllerForSection('events_${widget.currentCategory.id}_${section.id}'), // ✅ AJOUT
                        title: section.title,
                        experiences: experiences,
                        openBuilder: _buildOpenBuilder(),
                      ),
                    );
                  },
                  loading: () => Container(
                    margin: EdgeInsets.only(bottom: AppDimensions.spacingM),
                    height: AppDimensions.activityCardHeight + AppDimensions.space20,
                    child: GenericExperienceCarousel(
                      key: ValueKey('featured_events_loading_${widget.currentCategory.id}_${section.id}'),
                      scrollController: _getControllerForSection('events_loading_${widget.currentCategory.id}_${section.id}'), // ✅ AJOUT
                      title: section.title,
                      experiences: null,
                      isLoading: true,
                    ),
                  ),
                  error: (error, stack) => const SizedBox.shrink(), // ✅ Masquer les erreurs
                );
              },
            ),
          );
        }

        return Column(children: sectionWidgets);
      },
      loading: () => Container(
        height: AppDimensions.activityCardHeight + AppDimensions.space20,
        margin: EdgeInsets.only(bottom: AppDimensions.spacingM),
        child: GenericExperienceCarousel(
          key: ValueKey('featured_events_loading_${widget.currentCategory.id}'),
          scrollController: _getControllerForSection('events_general_loading_${widget.currentCategory.id}'), // ✅ AJOUT
          title: 'Événements',
          experiences: null,
          isLoading: true,
        ),
      ),
      error: (error, stack) => const SizedBox.shrink(), // ✅ Masquer les erreurs
    );
  }

  /// ✅ EXTRACTION : OpenBuilder unifié Activities + Events
  Widget Function(BuildContext, VoidCallback, dynamic)? _buildOpenBuilder() {
    return widget.openBuilder != null
        ? (context, action, experience) {
      // ✅ Navigation unifiée vers ExperienceDetailPage
      if (experience is ExperienceItem) {
        return ExperienceDetailPage(
          experienceItem: experience,
          onClose: action,
        );
      } else {
        // ✅ Fallback legacy pour SearchableActivity (à supprimer progressivement)
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