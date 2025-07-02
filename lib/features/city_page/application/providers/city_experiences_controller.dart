// lib/features/city_page/application/providers/city_experiences_controller.dart

import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../../core/domain/models/shared/category_model.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/search/config/section_metadata.dart';
import '../../../categories/application/state/categories_provider.dart';
import '../../../search/application/state/experience_providers.dart';
import '../../../search/application/state/city_selection_state.dart';
import '../../../search/application/state/activity_providers.dart';
import '../../../search/application/state/event_providers.dart';
import '../../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';

/// Modèle pour organiser les expériences d'une catégorie
class CategoryExperiences {
  final Category category;
  final List<SectionExperiences> sections;
  final bool isLoading;
  final String? error;

  const CategoryExperiences({
    required this.category,
    required this.sections,
    this.isLoading = false,
    this.error,
  });

  CategoryExperiences copyWith({
    Category? category,
    List<SectionExperiences>? sections,
    bool? isLoading,
    String? error,
  }) {
    return CategoryExperiences(
      category: category ?? this.category,
      sections: sections ?? this.sections,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

/// Modèle pour une section d'expériences
class SectionExperiences {
  final SectionMetadata section;
  final List<ExperienceItem> experiences;

  const SectionExperiences({
    required this.section,
    required this.experiences,
  });
}

/// Provider spécifique VillePage pour activités (accepte categoryId nullable)
final cityActivitiesBySectionProvider = FutureProvider.family<List<ExperienceItem>, ({String sectionId, String? categoryId, City city})>((ref, params) async {
  final sectionId = params.sectionId;
  final categoryId = params.categoryId;
  final city = params.city;

  try {
    final activities = await ref.read(getActivitiesUseCaseProvider).execute(
      latitude: city.lat,
      longitude: city.lon,
      sectionId: sectionId,
      categoryId: categoryId, // ✅ Le use case accepte nullable
      limit: 30,
    );

    // Cache des distances
    if (activities.isNotEmpty) {
      ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
          activities.map((activity) => (
          id: activity.base.id,
          lat: activity.base.latitude,
          lon: activity.base.longitude,
          )).toList()
      );
    }

    final experiences = activities.map((activity) => ExperienceItem.activity(activity)).toList();
    print('✅ CITY Section $sectionId: ${experiences.length} activités (categoryId: $categoryId)');
    return experiences;
  } catch (e) {
    print('❌ CITY Erreur section $sectionId: $e');
    return [];
  }
});

/// Provider spécifique VillePage pour événements (signature cohérente)
final cityEventsBySectionProvider = FutureProvider.family<List<ExperienceItem>, ({String sectionId, String? categoryId, City city})>((ref, params) async {
  final sectionId = params.sectionId;
  final categoryId = params.categoryId;
  final city = params.city;

  // Les événements doivent avoir un categoryId non-null
  if (categoryId == null) return [];

  try {
    final events = await ref.read(getEventsUseCaseProvider).execute(
      latitude: city.lat,
      longitude: city.lon,
      sectionId: sectionId,
      categoryId: categoryId,
      limit: 30,
    );

    // Cache des distances
    if (events.isNotEmpty) {
      ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
          events.map((event) => (
          id: event.base.id,
          lat: event.base.latitude,
          lon: event.base.longitude,
          )).toList()
      );
    }

    final experiences = events.map((event) => ExperienceItem.event(event)).toList();
    print('✅ CITY Section $sectionId: ${experiences.length} événements');
    return experiences;
  } catch (e) {
    print('❌ CITY Erreur section $sectionId: $e');
    return [];
  }
});

/// Controller pour gérer les expériences par ville
/// Utilise FamilyAsyncNotifier pour cache granulaire par ville
class CityExperiencesController extends FamilyAsyncNotifier<List<CategoryExperiences>, String?> {

  @override
  Future<List<CategoryExperiences>> build(String? cityId) async {
    if (cityId == null) return <CategoryExperiences>[];

    try {
      // 1. Récupérer la ville complète pour avoir lat/lon
      final selectedCity = await _getCityFromId(cityId);
      if (selectedCity == null) {
        throw Exception('Ville non trouvée: $cityId');
      }

      // 2. Récupérer les 6 catégories (toutes sauf événements)
      final allCategories = await ref.watch(categoriesProvider.future);
      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';

      // Séparer activités et événements
      final activityCategories = allCategories
          .where((cat) => cat.id != eventsCategoryId)
          .take(6) // Limiter à 6 catégories d'activités
          .toList();

      final eventCategory = allCategories.firstWhere(
            (cat) => cat.id == eventsCategoryId,
        orElse: () => Category(id: eventsCategoryId, name: 'Événements'),
      );

      // 3. Charger en parallèle : 6 catégories activités + 1 événements
      final results = await Future.wait([
        // Activités par catégorie
        ...activityCategories.map((category) =>
            _loadActivityCategoryExperiences(category, selectedCity)
        ),
        // Événements
        _loadEventsCategoryExperiences(eventCategory, selectedCity),
      ]);

      // 4. Filtrer les sections vides
      final nonEmptyResults = results.where((cat) => cat.sections.isNotEmpty).toList();

      print('✅ CITY CONTROLLER: ${nonEmptyResults.length} carrousels chargés pour ville $cityId');
      print('   - ${activityCategories.length} catégories activités');
      print('   - 1 catégorie événements');

      return nonEmptyResults;

    } catch (e) {
      print('❌ CITY CONTROLLER: Erreur chargement ville $cityId: $e');
      throw Exception('Erreur lors du chargement des expériences: $e');
    }
  }

  /// Récupère les sections spécifiques à la VillePage
  Future<List<SectionMetadata>> _getCitySections() async {
    try {
      final client = Supabase.instance.client;

      final response = await client
          .from('merged_filter_config')
          .select('section_id, title, priority, section_type, category_id')
          .eq('section_type', 'city_featured')
          .order('priority');

      final sections = (response as List).map((json) => SectionMetadata(
        id: json['section_id'],
        title: json['title'],
        sectionType: json['section_type'],
        priority: json['priority'],
        categoryId: json['category_id'],
      )).toList();

      print('📊 CITY SECTIONS: ${sections.length} sections city_featured trouvées');
      return sections;

    } catch (e) {
      print('❌ CITY SECTIONS: Erreur récupération: $e');
      return [];
    }
  }

  /// Charge les expériences d'une section VillePage
  Future<CategoryExperiences> _loadCitySectionExperiences(
      SectionMetadata section,
      City city
      ) async {
    try {
      // Déterminer le type d'expériences selon la section
      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
      final isEventsSection = section.categoryId == eventsCategoryId;

      // ✅ CORRECTION: Utiliser les providers spécifiques VillePage
      final experiences = await ref.read(
          isEventsSection
              ? cityEventsBySectionProvider((
          sectionId: section.id,
          categoryId: section.categoryId,
          city: city,
          )).future
              : cityActivitiesBySectionProvider((
          sectionId: section.id,
          categoryId: section.categoryId, // ✅ Peut être null maintenant
          city: city,
          )).future
      );

      // Créer une pseudo-catégorie pour l'affichage
      final pseudoCategory = Category(
        id: section.id,
        name: section.title,
      );

      final sectionExp = SectionExperiences(
        section: section,
        experiences: experiences,
      );

      print('✅ CITY SECTION: ${section.title} → ${experiences.length} expériences');

      return CategoryExperiences(
        category: pseudoCategory,
        sections: experiences.isNotEmpty ? [sectionExp] : [],
      );

    } catch (e) {
      print('❌ CITY SECTION: Erreur ${section.title}: $e');
      return CategoryExperiences(
        category: Category(id: section.id, name: section.title),
        sections: [],
        error: e.toString(),
      );
    }
  }

  /// Charge les activités d'une catégorie avec section générique
  Future<CategoryExperiences> _loadActivityCategoryExperiences(
      Category category,
      City city
      ) async {
    try {
      // Utiliser la section générique activités
      const String activitiesSectionId = '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';

      final experiences = await ref.read(
          cityActivitiesBySectionProvider((
          sectionId: activitiesSectionId,
          categoryId: category.id, // ✅ Spécifier la catégorie
          city: city,
          )).future
      );

      final sectionExp = SectionExperiences(
        section: SectionMetadata(
          id: activitiesSectionId,
          title: category.name,
          sectionType: 'city_featured',
          priority: 1,
          categoryId: category.id,
        ),
        experiences: experiences,
      );

      print('✅ CITY CATEGORY: ${category.name} → ${experiences.length} activités');

      return CategoryExperiences(
        category: category,
        sections: experiences.isNotEmpty ? [sectionExp] : [],
      );

    } catch (e) {
      print('❌ CITY CATEGORY: Erreur ${category.name}: $e');
      return CategoryExperiences(
        category: category,
        sections: [],
        error: e.toString(),
      );
    }
  }

  /// Charge les événements avec section spécialisée
  Future<CategoryExperiences> _loadEventsCategoryExperiences(
      Category eventCategory,
      City city
      ) async {
    try {
      // Utiliser la section spécialisée événements
      const String eventsSectionId = '7f94df23-ab30-4bf3-afb2-59320e5466a7';

      final experiences = await ref.read(
          cityEventsBySectionProvider((
          sectionId: eventsSectionId,
          categoryId: eventCategory.id,
          city: city,
          )).future
      );

      final sectionExp = SectionExperiences(
        section: SectionMetadata(
          id: eventsSectionId,
          title: 'Événements à venir',
          sectionType: 'city_featured',
          priority: 2,
          categoryId: eventCategory.id,
        ),
        experiences: experiences,
      );

      print('✅ CITY EVENTS: Événements → ${experiences.length} événements');

      return CategoryExperiences(
        category: eventCategory,
        sections: experiences.isNotEmpty ? [sectionExp] : [],
      );

    } catch (e) {
      print('❌ CITY EVENTS: Erreur événements: $e');
      return CategoryExperiences(
        category: eventCategory,
        sections: [],
        error: e.toString(),
      );
    }
  }

  /// Helper pour récupérer une ville depuis son ID
  /// TODO: Remplacer par le vrai provider de ville si disponible
  Future<City?> _getCityFromId(String cityId) async {
    // Temporaire: utiliser la ville sélectionnée actuelle
    // Dans une vraie implémentation, on ferait un appel à un CityRepository
    return ref.read(selectedCityProvider);
  }

  /// Méthode pour refresh manuel
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Provider principal pour le controller
final cityExperiencesControllerProvider = AsyncNotifierProvider.family<
    CityExperiencesController,
    List<CategoryExperiences>,
    String?
>(CityExperiencesController.new);

/// Selector pour vérifier si on a du contenu à afficher
final hasCityContentProvider = Provider.family<bool, String?>((ref, cityId) {
  final experiencesAsync = ref.watch(cityExperiencesControllerProvider(cityId));

  return experiencesAsync.when(
    data: (categories) => categories.any((cat) => cat.sections.isNotEmpty),
    loading: () => false,
    error: (_, __) => false,
  );
});