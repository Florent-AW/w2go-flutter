// lib/features/categories/presentation/widgets/organisms/subcategory_activities_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/domain/models/shared/subcategory_model.dart';
import '../../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../../core/domain/models/event/search/searchable_event.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../experience_detail/presentation/pages/experience_detail_page.dart';
import '../../../../../features/search/application/state/experience_providers.dart';
import '../../../../../features/search/application/state/section_discovery_providers.dart';
import '../../../../../features/search/application/state/city_selection_state.dart';
import '../../../../../features/shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart';
import '../../../application/state/categories_provider.dart';
import '../../../application/state/subcategories_provider.dart';

class SubcategoryActivitiesSection extends ConsumerStatefulWidget {
  final Widget Function(BuildContext, VoidCallback, SearchableActivity)? openBuilder;

  const SubcategoryActivitiesSection({
    Key? key,
    this.openBuilder,
  }) : super(key: key);

  @override
  ConsumerState<SubcategoryActivitiesSection> createState() => _SubcategoryActivitiesSectionState();
}

class _SubcategoryActivitiesSectionState extends ConsumerState<SubcategoryActivitiesSection> {
  // ✅ Stockage stable des contrôleurs par section
  final Map<String, InfiniteScrollController> _scrollControllers = {};

  // ✅ Tracker les changements pour reset les positions
  String? _lastCategoryId;
  String? _lastSubcategoryId;

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
    for (final controller in _scrollControllers.values) {
      if (controller.hasClients) {
        controller.jumpToItem(0);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentCategory = ref.watch(selectedCategoryProvider);
    final selectedSubcategory = ref.watch(selectedSubcategoryByCategoryProvider(currentCategory?.id ?? ''));
    final selectedCity = ref.watch(selectedCityProvider);

    // Si aucune sous-catégorie n'est sélectionnée, afficher un message
    if (selectedSubcategory == null) {
      return _buildNoSubcategorySelectedUI(context);
    }

    // ✅ Provider intelligent avec fallback spécifique → générique
    final sectionsAsync = ref.watch(effectiveSubcategorySectionsProvider(currentCategory?.id));

    // ✅ Provider unifié Activities + Events
    final sectionsDataAsync = ref.watch(subcategorySectionExperiencesProvider((
    categoryId: currentCategory?.id ?? '',
    subcategoryId: selectedSubcategory.id,
    city: selectedCity,
    )));

    // Déterminer si les données sont chargées
    final bool sectionsLoaded = sectionsAsync is AsyncData;
    final bool dataLoaded = sectionsDataAsync is AsyncData;
    final bool hasError = sectionsAsync is AsyncError || sectionsDataAsync is AsyncError;

    // Afficher l'erreur si présente
    if (hasError) {
      final error = (sectionsAsync is AsyncError)
          ? (sectionsAsync as AsyncError).error
          : (sectionsDataAsync as AsyncError).error;
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
    }

    // Transition fluide avec Stack+Opacity
    return Stack(
      children: [
        // Contenu réel (invisible pendant le chargement)
        Opacity(
          opacity: (sectionsLoaded && dataLoaded) ? 1.0 : 0.0,
          child: _buildLoadedContent(
            context,
            sectionsAsync.value ?? [],
            sectionsDataAsync.value ?? {},
            selectedSubcategory,
            selectedCity,
            currentCategory,
          ),
        ),

        // Shimmer (visible uniquement pendant le chargement)
        if (!sectionsLoaded || !dataLoaded)
          _buildSkeletonWithSameStructure(currentCategory, selectedSubcategory),
      ],
    );
  }

  Widget _buildLoadedContent(
      BuildContext context,
      List sections,
      Map<String, List<ExperienceItem>> sectionActivities,
      Subcategory selectedSubcategory,
      dynamic selectedCity,
      dynamic currentCategory,
      ) {
    // ✅ Détecter changement de catégorie/sous-catégorie pour reset
    final currentCategoryId = currentCategory?.id;
    final currentSubcategoryId = selectedSubcategory.id;

    final hasChanged = _lastCategoryId != currentCategoryId ||
        _lastSubcategoryId != currentSubcategoryId;

    if (hasChanged) {
      _resetAllControllers();
      _lastCategoryId = currentCategoryId;
      _lastSubcategoryId = currentSubcategoryId;
    }

    if (sections.isEmpty) {
      return _buildNoSectionsAvailableUI(context);
    }

    if (sectionActivities.isEmpty) {
      return _buildNoActivitiesFoundUI(context, selectedSubcategory.name);
    }

    // ✅ Créer un carousel unifié pour chaque section
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDimensions.spacingXs),
        ...sections.map((section) {
          final sectionKey = 'section-${section.id}';
          final experiences = sectionActivities[sectionKey] ?? [];

          if (experiences.isEmpty) {
            return SizedBox.shrink();
          }

          return RepaintBoundary(
            child: GenericExperienceCarousel(
              key: ValueKey(
                'carousel_${currentCategoryId}_${currentSubcategoryId}_${section.id}',
              ),
              scrollController: _getControllerForSection(
                '${currentCategoryId}_${currentSubcategoryId}_${section.id}',
              ),
              title: section.title,
              heroPrefix: 'subcategory-${currentCategoryId}-${currentSubcategoryId}-${section.id}',
              subtitle: "Pour ${selectedSubcategory.name}",
              experiences: experiences,
              isLoading: false,
              openBuilder: widget.openBuilder != null
                  ? (context, action, experience) {
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
                  : null,
            ),
          );
        }).toList(),
        const SizedBox(height: 80),
      ],
    );
  }

  // ✅ Skeleton unifié avec GenericExperienceCarousel
  Widget _buildSkeletonWithSameStructure(dynamic currentCategory, Subcategory? selectedSubcategory) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppDimensions.spacingXs),

        RepaintBoundary(
          child: GenericExperienceCarousel(
            key: ValueKey('loading_carousel_${currentCategory?.id}_${selectedSubcategory?.id}_1'),
            scrollController: _getControllerForSection('loading_1'),
            title: 'Section exemple 1',
            heroPrefix: 'subcategory-loading-1-${currentCategory?.id}_${selectedSubcategory?.id}',
            subtitle: 'Pour cette sous-catégorie',
            experiences: null,
            isLoading: true,
            loadingItemCount: 3,
          ),
        ),

        RepaintBoundary(
          child: GenericExperienceCarousel(
            key: ValueKey('loading_carousel_${currentCategory?.id}_${selectedSubcategory?.id}_2'),
            scrollController: _getControllerForSection('loading_2'),
            title: 'Section exemple 2',
            heroPrefix: 'subcategory-loading-2-${currentCategory?.id}_${selectedSubcategory?.id}',
            subtitle: 'Pour cette sous-catégorie',
            experiences: null,
            isLoading: true,
            loadingItemCount: 3,
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