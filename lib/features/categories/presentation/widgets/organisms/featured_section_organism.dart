// lib/features/categories/presentation/widgets/organisms/featured_section_organism.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import '../../../../../core/domain/models/shared/category_view_model.dart';
import '../../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../../core/domain/models/event/search/searchable_event.dart';
import '../../../../../core/domain/models/shared/experience_item.dart';
import '../../../../../core/theme/app_dimensions.dart';
import '../../../../../core/application/pagination_controller.dart';
import '../../../../shared_ui/presentation/widgets/organisms/generic_experience_carousel.dart';
import '../../../../search/application/state/experience_providers.dart';
import '../../../../search/application/state/city_selection_state.dart';
import '../../../../experience_detail/presentation/pages/experience_detail_page.dart';
import '../../../../preload/application/preload_providers.dart';
import '../../../application/providers/category_experiences_controller.dart';
import '../../../application/pagination/category_pagination_providers.dart';

/// Feature flag pour activer/désactiver le nouveau système de pagination
const bool _USE_NEW_PAGINATION_SYSTEM = true;

/// Organism pour afficher la section Featured d'une catégorie
/// Système hybride : nouveau PaginationController + fallback ancien système
class FeaturedSectionOrganism extends ConsumerStatefulWidget {
  /// La catégorie actuellement affichée
  final CategoryViewModel currentCategory;

  /// Callback pour ouvrir une expérience (legacy compatibility)
  final Widget Function(BuildContext, VoidCallback, SearchableActivity)? openBuilder;

  const FeaturedSectionOrganism({
  Key? key,
  required this.currentCategory,
  this.openBuilder,
}

/// ✅ NOUVEAU : Wrapper stable pour les sections Featured (évite les reconstructions)
class _CategoryFeaturedSectionsWrapper extends ConsumerStatefulWidget {
  final String categoryId;
  final dynamic city;
  final Widget Function(BuildContext, VoidCallback, dynamic)? openBuilder;

  const _CategoryFeaturedSectionsWrapper({
    Key? key,
    required this.categoryId,
    required this.city,
    this.openBuilder,
  }) : super(key: key);

  @override
  ConsumerState<_CategoryFeaturedSectionsWrapper> createState() => _CategoryFeaturedSectionsWrapperState();
}

class _CategoryFeaturedSectionsWrapperState extends ConsumerState<_CategoryFeaturedSectionsWrapper>
    with AutomaticKeepAliveClientMixin {

  @override
  bool get wantKeepAlive => true; // ✅ GARDER VIVANT pour éviter reconstructions

  @override
  Widget build(BuildContext context) {
    super.build(context); // ✅ REQUIS pour AutomaticKeepAliveClientMixin

    final sectionsAsync = ref.watch(featuredSectionsByCategoryProvider(widget.categoryId));

    return sectionsAsync.when(
      data: (sections) {
        if (sections.isEmpty) {
          return const SizedBox.shrink();
        }

        // ✅ CONSTRUIRE une seule fois - les carrousels ne seront plus reconstruits
        final sectionWidgets = <Widget>[];

        for (final section in sections) {
          sectionWidgets.add(
            _CategoryFeaturedCarousel(
              key: ValueKey('featured_stable_${widget.categoryId}_${section.id}'),
              categoryId: widget.categoryId,
              sectionId: section.id,
              sectionTitle: section.title,
              city: widget.city,
              openBuilder: widget.openBuilder,
            ),
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
        print('❌ FEATURED STABLE: Erreur sections: $error');
        return const SizedBox.shrink();
      },
    );
  }
}) : super(key: key);

@override
ConsumerState<FeaturedSectionOrganism> createState() => _FeaturedSectionOrganismState();
}

class _FeaturedSectionOrganismState extends ConsumerState<FeaturedSectionOrganism> {
// Stockage stable des contrôleurs par section (ancien système)
final Map<String, InfiniteScrollController> _scrollControllers = {};

/// Détermine si un carrousel est partiel (ancien système seulement)
bool _isCarouselPartial(String categoryId, String sectionId) {
if (_USE_NEW_PAGINATION_SYSTEM) return false; // Pas utilisé dans le nouveau système

final preloadData = ref.read(preloadControllerProvider);
final carouselInfo = preloadData.carouselsInfo
    .where((info) => info.categoryId == categoryId && info.sectionId == sectionId)
    .firstOrNull;
return carouselInfo?.isPartial ?? false;
}

/// Déclenche la complétion d'un carrousel Featured (ancien système seulement)
void _completeCarousel(String categoryId, String sectionId) {
if (_USE_NEW_PAGINATION_SYSTEM) return; // Pas utilisé dans le nouveau système

print('🔄 ANCIEN SYSTÈME - DEMANDE COMPLÉTION FEATURED pour catégorie: $categoryId, section: $sectionId');

final selectedCity = ref.read(selectedCityProvider);
if (selectedCity == null) {
print('❌ COMPLETION: Pas de ville sélectionnée');
return;
}

ref.read(categoryExperiencesControllerProvider.notifier)
    .completeCarouselForCategory(
categoryId,
sectionId,
selectedCity,
isFeatured: true
);
}

// Tracker les changements pour reset les positions
String? _lastCategoryId;

@override
void dispose() {
// Nettoyer tous les contrôleurs
for (final controller in _scrollControllers.values) {
controller.dispose();
}
_scrollControllers.clear();
super.dispose();
}

// Méthode pour obtenir/créer un contrôleur stable (ancien système)
InfiniteScrollController _getControllerForSection(String sectionKey) {
return _scrollControllers.putIfAbsent(
sectionKey,
() => InfiniteScrollController(initialItem: 0),
);
}

// Méthode pour reset tous les contrôleurs
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

// Détecter changement de catégorie pour reset
final currentCategoryId = widget.currentCategory.id;
final hasChanged = _lastCategoryId != currentCategoryId;

if (hasChanged) {
_resetAllControllers();
_lastCategoryId = currentCategoryId;
}

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

// ✅ NOUVEAU : Système hybride avec feature flag
if (_USE_NEW_PAGINATION_SYSTEM) {
return _buildNewPaginationSystem(selectedCity);
} else {
return _buildLegacySystem(selectedCity);
}
}

/// ✅ NOUVEAU : Système de pagination unifié (SANS reconstruction)
Widget _buildNewPaginationSystem(dynamic selectedCity) {
print('🆕 FEATURED: Utilisation du nouveau système de pagination');

// ✅ CORRECTION : Créer directement les wrappers stables sans dépendre de sectionsAsync
return _CategoryFeaturedSectionsWrapper(
key: ValueKey('featured_wrapper_${widget.currentCategory.id}'),
categoryId: widget.currentCategory.id,
city: selectedCity,
openBuilder: _buildOpenBuilder(),
);
}

/// ✅ ANCIEN : Système legacy pour fallback
Widget _buildLegacySystem(dynamic selectedCity) {
print('🔄 FEATURED: Utilisation de l\'ancien système (fallback)');

final sectionsAsync = ref.watch(featuredSectionsByCategoryProvider(widget.currentCategory.id));

return sectionsAsync.when(
data: (sections) {
if (sections.isEmpty) {
return const SizedBox.shrink();
}

final sectionWidgets = <Widget>[];

for (int i = 0; i < sections.length; i++) {
final section = sections[i];
sectionWidgets.add(
Consumer(
builder: (context, ref, _) {
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
if (experiences.isEmpty) {
return const SizedBox.shrink();
}

// Timer T1 automatique si partiel (ancien système)
final isPartial = _isCarouselPartial(widget.currentCategory.id, section.id);
if (isPartial) {
WidgetsBinding.instance.addPostFrameCallback((_) {
Future.delayed(const Duration(milliseconds: 1500), () {
if (mounted) {
_completeCarousel(widget.currentCategory.id, section.id);
}
});
});
}

return Container(
padding: EdgeInsets.only(bottom: 4.0),
child: GenericExperienceCarousel(
key: ValueKey('featured_legacy_${widget.currentCategory.id}_${section.id}'),
scrollController: _getControllerForSection('events_${widget.currentCategory.id}_${section.id}'),
title: section.title,
heroPrefix: 'featured-${widget.currentCategory.id}-${section.id}',
experiences: experiences,
openBuilder: _buildOpenBuilder(),
),
);
},
loading: () => Container(
margin: EdgeInsets.only(bottom: AppDimensions.spacingXs),
height: AppDimensions.activityCardHeight + AppDimensions.space20,
child: GenericExperienceCarousel(
key: ValueKey('featured_legacy_loading_${widget.currentCategory.id}_${section.id}'),
scrollController: _getControllerForSection('events_loading_${widget.currentCategory.id}_${section.id}'),
title: section.title,
heroPrefix: 'featured-${widget.currentCategory.id}-${section.id}',
experiences: null,
isLoading: true,
),
),
error: (error, stack) => const SizedBox.shrink(),
);
},
),
);
}

return Column(children: sectionWidgets);
},
loading: () => Container(
height: AppDimensions.activityCardHeight + AppDimensions.space20,
margin: EdgeInsets.only(bottom: AppDimensions.spacingXs),
child: GenericExperienceCarousel(
key: ValueKey('featured_legacy_loading_${widget.currentCategory.id}'),
scrollController: _getControllerForSection('events_general_loading_${widget.currentCategory.id}'),
title: 'Événements',
heroPrefix: 'featured-${widget.currentCategory.id}',
experiences: null,
isLoading: true,
),
),
error: (error, stack) => const SizedBox.shrink(),
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

/// ✅ NOUVEAU : Wrapper stateful pour un carrousel Featured avec nouveau système
class _CategoryFeaturedCarousel extends ConsumerStatefulWidget {
final String categoryId;
final String sectionId;
final String sectionTitle;
final dynamic city;
final Widget Function(BuildContext, VoidCallback, dynamic)? openBuilder;

const _CategoryFeaturedCarousel({
Key? key,
required this.categoryId,
required this.sectionId,
required this.sectionTitle,
required this.city,
this.openBuilder,
}) : super(key: key);

@override
ConsumerState<_CategoryFeaturedCarousel> createState() => _CategoryFeaturedCarouselState();
}

class _CategoryFeaturedCarouselState extends ConsumerState<_CategoryFeaturedCarousel> {
late final CategoryCarouselParams params;
bool _hasInitialized = false;

@override
void initState() {
super.initState();

params = createFeaturedParams(
city: widget.city,
sectionId: widget.sectionId,
categoryId: widget.categoryId,
);

// ✅ INITIALISATION UNE SEULE FOIS
WidgetsBinding.instance.addPostFrameCallback((_) {
if (mounted && !_hasInitialized) {
_hasInitialized = true;

final controller = ref.read(categoryFeaturedPaginationProvider(params).notifier);
final currentState = ref.read(categoryFeaturedPaginationProvider(params));

if (currentState.items.isEmpty && !currentState.isLoading) {
print('🚀 FEATURED PAGINATION INIT: ${widget.sectionTitle}');
controller.loadPreload();
}
}
});
}

@override
Widget build(BuildContext context) {
final paginationState = ref.watch(categoryFeaturedPaginationProvider(params));

// ✅ CORRECTION : Pattern exact CityPage - Détecter transition vers isPartial
ref.listen<PaginationState<ExperienceItem>>(
categoryFeaturedPaginationProvider(params),
(previous, next) {
if (previous != null && !previous.isPartial && next.isPartial) {
print('🔄 FEATURED T1 REF.LISTEN: Détection false→true pour ${widget.sectionTitle}');

Future.delayed(const Duration(milliseconds: 1500), () {
if (mounted) {
print('🔄 FEATURED T1 REF.LISTEN: Complétion pour ${widget.sectionTitle}');
ref.read(categoryFeaturedPaginationProvider(params).notifier).completeIfPartial();
}
});
}
},
);

// Masquer si aucune donnée
if (paginationState.items.isEmpty && !paginationState.isLoading) {
return const SizedBox.shrink();
}

return Container(
padding: EdgeInsets.only(bottom: 4.0),
child: GenericExperienceCarousel(
key: ValueKey('featured_pagination_${widget.categoryId}_${widget.sectionId}'),
title: widget.sectionTitle,
experiences: paginationState.items,
isLoading: paginationState.isLoading,
errorMessage: paginationState.error,
heroPrefix: 'featured-${widget.categoryId}-${widget.sectionId}',
openBuilder: widget.openBuilder,
showDistance: true,
onLoadMore: () => _loadMoreFeaturedCarousel(),
// Pas de onSeeAllPressed pour Featured
),
);
}

/// T2 lazy loading
void _loadMoreFeaturedCarousel() {
final controller = ref.read(categoryFeaturedPaginationProvider(params).notifier);
final currentState = ref.read(categoryFeaturedPaginationProvider(params));

if (!currentState.isLoadingMore && currentState.hasMore) {
print('🚀 FEATURED T2 LAZY LOADING: Chargement de la page suivante (offset=${currentState.currentOffset})');
controller.loadMore();
}
}

