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

/// Utility to retry an asynchronous action with a delay.
Future<T> _retry<T>(
    Future<T> Function() action, {
      int retries = 2,
      Duration delay = const Duration(milliseconds: 500),
    }) async {
  for (var attempt = 0; attempt < retries; attempt++) {
    try {
      return await action();
    } catch (_) {
      if (attempt == retries - 1) rethrow;
      await Future.delayed(delay);
    }
  }
  throw Exception('Unreachable');
}


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
final cityActivitiesBySectionProvider = FutureProvider.family<List<ExperienceItem>, ({String sectionId, String? categoryId, City city, int limit})>((ref, params) async {
  final sectionId = params.sectionId;
  final categoryId = params.categoryId;
  final city = params.city;
  final limit = params.limit; // ✅ NOUVEAU

  try {
    final activities = await ref.read(getActivitiesUseCaseProvider).execute(
      latitude: city.lat,
      longitude: city.lon,
      sectionId: sectionId,
      categoryId: categoryId,
      limit: limit, // ✅ Utiliser le paramètre au lieu de 30
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
    print('✅ CITY Section $sectionId: ${experiences.length} activités (categoryId: $categoryId, limit: $limit)');
    return experiences;
  } catch (e) {
    print('❌ CITY Erreur section $sectionId: $e');
    return [];
  }
});

/// Provider spécifique VillePage pour événements (signature cohérente)
final cityEventsBySectionProvider = FutureProvider.family<List<ExperienceItem>, ({String sectionId, String? categoryId, City city, int limit})>((ref, params) async {
  final sectionId = params.sectionId;
  final categoryId = params.categoryId;
  final city = params.city;
  final limit = params.limit; // ✅ NOUVEAU

  // Les événements doivent avoir un categoryId non-null
  if (categoryId == null) return [];

  try {
    final events = await ref.read(getEventsUseCaseProvider).execute(
      latitude: city.lat,
      longitude: city.lon,
      sectionId: sectionId,
      categoryId: categoryId,
      limit: limit, // ✅ Utiliser le paramètre au lieu de 30
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
    print('✅ CITY Section $sectionId: ${experiences.length} événements (limit: $limit)');
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

      // ✅ NOUVEAU : Récupérer les vraies sections
      final citySections = await _getCitySections();

      // ✅ NOUVEAU : Définir la section générale comme fallback
      final generalSection = citySections.where((s) => s.categoryId == null).firstOrNull;

      // ✅ DEBUG : Voir les matches par catégorie
      final eventSection = citySections.where((s) => s.categoryId == eventCategory.id).firstOrNull;


      // 3. Charger en parallèle avec les vraies sections ET fallback
      final results = await Future.wait([
        // ✅ ÉVÉNEMENTS avec vraie section
        _loadEventsCategoryExperiences(
            eventCategory,
            selectedCity,
            eventSection
        ),
        // ✅ ACTIVITÉS avec sections spécifiques OU générale
        ...activityCategories.map((category) =>
            _loadActivityCategoryExperiences(
                category,
                selectedCity,
                citySections.where((s) => s.categoryId == category.id).firstOrNull ?? generalSection
            )
        ),
      ]);

      // 4. Filtrer les sections vides
      final nonEmptyResults = results.where((cat) => cat.sections.isNotEmpty).toList();

      print('✅ CITY CONTROLLER: ${nonEmptyResults.length} carrousels chargés pour ville $cityId');
      print('   - 1 catégorie événements (PREMIÈRE)');
      print('   - ${activityCategories.length} catégories activités');

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

      final response = await _retry(
            () => client
            .from('merged_filter_config')
            .select('section_id, title, priority, section_type, category_id, display_order, filter_config')
            .eq('section_type', 'city_featured')
            .order('display_order') // ✅ Utiliser display_order pour l'ordre
            .timeout(const Duration(seconds: 10)),
      );

      final sections = (response as List).map((json) => SectionMetadata(
        id: json['section_id'],
        title: json['title'],
        sectionType: json['section_type'],
        priority: json['priority'],
        categoryId: json['category_id'],
        displayOrder: json['display_order'] ?? 999, // ✅ NOUVEAU
        filterConfig: json['filter_config'] as Map<String, dynamic>?, // ✅ NOUVEAU
      )).toList();

      print('📊 CITY SECTIONS: ${sections.length} sections city_featured trouvées depuis la base');
      return sections;

    } catch (e) {
      print('❌ CITY SECTIONS: Erreur récupération: $e');
      return [];
    }
  }


  Future<CategoryExperiences> _loadActivityCategoryExperiences(
      Category category,
      City city,
      SectionMetadata? section, {
        int? customLimit,
      }) async {
    try {
      // Debug pour voir quelle catégorie on traite
      print('🔍 DEBUG: _loadActivityCategoryExperiences pour ${category.name} (id: "${category.id}")');

      // ✅ DEBUG : Voir ce qu'il y a dans filterConfig
      print('🔍 DEBUG filterConfig pour ${category.name}: ${section?.filterConfig}');

      final activitiesSectionId = section?.id ?? '5aa09feb-397a-4ad1-8142-7dcf0b2edd0f';

      // ✅ PARSING ROBUSTE de la limite
      int? limit;
      if (customLimit != null) {
        limit = customLimit; // Preload
        print('🔍 DEBUG utilisation customLimit: $limit');
      } else if (section?.filterConfig != null) {
        final filterLimit = section!.filterConfig!['limit'];
        if (filterLimit is int) {
          limit = filterLimit;
        } else if (filterLimit is String) {
          limit = int.tryParse(filterLimit);
        }
        print('🔍 DEBUG limite parsée: $limit (original: $filterLimit, type: ${filterLimit.runtimeType})');
      } else {
        limit = 20; // Vraiment aucune config
        print('🔍 DEBUG aucune section, limite par défaut: $limit');
      }

      final experiences = await _retry(() async {
        return await ref.read(cityActivitiesBySectionProvider((
        sectionId: activitiesSectionId,
        categoryId: category.id,
        city: city,
        limit: limit ?? 20, // Fallback final
        )).future).timeout(const Duration(seconds: 10));
      });

      final experiencesList = experiences ?? <ExperienceItem>[];

      final sectionExp = SectionExperiences(
        section: SectionMetadata(
          id: section?.id ?? activitiesSectionId,
          title: category.name, // ✅ TOUJOURS utiliser le nom de catégorie pour les activités
          sectionType: section?.sectionType ?? 'city_featured',
          priority: section?.priority ?? 1,
          categoryId: category.id,
          displayOrder: section?.displayOrder ?? 999,
          filterConfig: section?.filterConfig,
        ),
        experiences: experiencesList,
      );

      print('✅ CITY CATEGORY: ${category.name} → ${experiencesList.length} activités (limit: $limit)');

      return CategoryExperiences(
        category: category,
        sections: experiencesList.isNotEmpty ? [sectionExp] : [],
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
      City city,
      SectionMetadata? section, {
        int? customLimit,  // ✅ CORRECTION : paramètre optionnel nommé
      }) async {
    try {
      // ✅ Utiliser customLimit en priorité, puis section, puis défaut
      final eventsSectionId = section?.id ?? '7f94df23-ab30-4bf3-afb2-59320e5466a7';
      final limit = customLimit ?? section?.filterConfig?['limit'] as int? ?? 15;

      final experiences = await _retry(() async {
        return await ref.read(cityEventsBySectionProvider((
        sectionId: eventsSectionId,
        categoryId: eventCategory.id,
        city: city,
        limit: limit,
        )).future).timeout(const Duration(seconds: 10));
      });

      final experiencesList = experiences ?? <ExperienceItem>[];

      final sectionExp = SectionExperiences(
        section: SectionMetadata(
          id: section?.id ?? eventsSectionId,
          title: section?.title ?? eventCategory.name, // ✅ Titre section si existe, sinon nom catégorie
          sectionType: section?.sectionType ?? 'city_featured',
          priority: section?.priority ?? 2,
          categoryId: eventCategory.id,
          displayOrder: section?.displayOrder ?? 999,
          filterConfig: section?.filterConfig,
        ),
        experiences: experiencesList,
      );

      print('✅ CITY EVENTS: ${eventCategory.name} → ${experiencesList.length} événements (limit: $limit)');

      return CategoryExperiences(
        category: eventCategory,
        sections: experiencesList.isNotEmpty ? [sectionExp] : [],
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

  /// Méthodes publiques pour le PreloadController
  /// Charge une catégorie d'activités avec limite personnalisée
  Future<CategoryExperiences> loadActivityCategoryWithLimit(
      Category category,
      City city,
      int customLimit,
      ) async {
    return await _loadActivityCategoryExperiences(
      category,
      city,
      null, // pas de section spécifique
      customLimit: customLimit,
    );
  }

  /// Charge les événements avec limite personnalisée
  Future<CategoryExperiences> loadEventsCategoryWithLimit(
      Category eventCategory,
      City city,
      int customLimit,
      ) async {
    return await _loadEventsCategoryExperiences(
      eventCategory,
      city,
      null, // pas de section spécifique
      customLimit: customLimit,
    );
  }

  /// Complète un carrousel en rechargeant avec la limite Supabase complète
  Future<void> completeCarouselForCategory(String categoryId, City city) async {
    try {
      print('🔄 COMPLETION: Début complétion pour catégorie $categoryId');

      // Récupérer les catégories et sections
      final allCategories = await ref.read(categoriesProvider.future);
      final citySections = await _getCitySections();
      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';

      // Trouver la catégorie
      final category = allCategories.where((cat) => cat.id == categoryId).firstOrNull;
      if (category == null) {
        print('❌ COMPLETION: Catégorie $categoryId non trouvée');
        return;
      }

      // Trouver la section appropriée
      final generalSection = citySections.where((s) => s.categoryId == null).firstOrNull;
      final categorySection = citySections.where((s) => s.categoryId == categoryId).firstOrNull ?? generalSection;

      // Recharger avec limite complète (pas de customLimit)
      CategoryExperiences newCategoryExperiences;
      if (categoryId == eventsCategoryId) {
        newCategoryExperiences = await _loadEventsCategoryExperiences(category, city, categorySection);
      } else {
        newCategoryExperiences = await _loadActivityCategoryExperiences(category, city, categorySection);
      }

      // Mettre à jour l'état
      final currentState = await future;
      final updatedState = currentState.map((cat) {
        if (cat.category.id == categoryId) {
          return newCategoryExperiences;
        }
        return cat;
      }).toList();

      // Déclencher le rebuild
      state = AsyncValue.data(updatedState);

      print('✅ COMPLETION: Catégorie ${category.name} complétée');

    } catch (e) {
      print('❌ COMPLETION: Erreur $e');
    }
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

/// Provider pour accéder aux méthodes publiques du controller
final cityExperiencesControllerInstanceProvider = Provider.family<CityExperiencesController, String?>((ref, cityId) {
  return ref.read(cityExperiencesControllerProvider(cityId).notifier);
});

