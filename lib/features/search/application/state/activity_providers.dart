// lib/features/search/application/state/activity_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../core/domain/models/search/config/section_metadata.dart';
import '../../../../core/domain/services/search/activity_search_service.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../../core/adapters/supabase/search/activity_search_adapter.dart';
import '../../../../core/domain/use_cases/search/get_activities_use_case.dart';
import '../../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';
import 'section_discovery_providers.dart';


// Définir une clé composite pour les activités
typedef ActivityKey = ({
  String categoryId,
  String? subcategoryId,
  City? city,
});

// Définir une clé composite pour les activités en vedette
typedef FeaturedActivitiesKey = ({
  String categoryId,
  City? city,
});

/// Provider pour l'adapter de recherche d'activités
final activitySearchAdapterProvider = Provider<ActivitySearchAdapter>((ref) {
  final client = Supabase.instance.client;
  return ActivitySearchAdapter(client);
});

/// Provider pour le service de recherche d'activités
final activitySearchServiceProvider = Provider<ActivitySearchService>((ref) {
  final searchAdapter = ref.read(activitySearchAdapterProvider);
  return ActivitySearchService(searchAdapter);
});

/// Provider pour le use case de récupération d'activités
final getActivitiesUseCaseProvider = Provider<GetActivitiesUseCase>((ref) {
  final searchAdapter = ref.read(activitySearchAdapterProvider);
  return GetActivitiesUseCase(searchAdapter);
});

/// Provider pour les activités mises en avant par catégorie
/// Utilise le nouveau use case avec section_id
final featuredActivitiesByCategoryProvider = FutureProvider.family<List<SearchableActivity>, FeaturedActivitiesKey>(
      (ref, key) async {
    final categoryId = key.categoryId;
    final city = key.city;

    print('🔍 Recherche des activités mises en avant pour catégorie: $categoryId (ville: ${city?.cityName})');

    final useCase = ref.read(getActivitiesUseCaseProvider);

    // Utiliser directement l'objet city
    if (city == null) return [];

    try {
      // Utiliser la section ID des activités par catégorie
      const String featuredSectionId = 'a62c6046-8814-456f-91ba-b65aa7e73137';

      // Exécuter la recherche avec city.lat et city.lon
      final activities = await useCase.execute(
        latitude: city.lat,
        longitude: city.lon,
        sectionId: featuredSectionId,
        categoryId: categoryId,
        limit: 20,
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

      return activities;
    } catch (e) {
      print('❌ Erreur lors du chargement des activités mises en avant: $e');
      return [];
    }
  },
);

/// Provider optimisé pour les activités filtrées par sous-catégorie
/// Utilise une clé composite pour un cache granulaire par (catégorie, sous-catégorie)
final subcategorySectionActivitiesProvider = FutureProvider.family<Map<String, List<SearchableActivity>>, ActivityKey>(
      (ref, key) async {
    final categoryId = key.categoryId;
    final subcategoryId = key.subcategoryId;
    final city = key.city;  // Utiliser city au lieu de cityId

    if (subcategoryId == null) return {};

    // Utiliser ref.read pour les dépendances non réactives
    final useCase = ref.read(getActivitiesUseCaseProvider);

    // Pas besoin de charger la ville, on l'a déjà
    if (city == null) {
      print('⚠️ Ville non trouvée, impossible de charger les activités');
      return {};
    }

    // Récupérer les sections et attendre explicitement leur chargement
    final sections = await ref.read(
      subcategorySectionsProvider.future,
    ).catchError((_) => <SectionMetadata>[]);

    if (sections.isEmpty) {
      print('⚠️ Aucune section de sous-catégorie n\'a été trouvée');
      return {};
    }

    // Ajout de logs pour vérifier l'ordre avant tri

    // Tri explicite par priorité (ascendant)
    sections.sort((a, b) => a.priority.compareTo(b.priority));

    // Logs après tri pour confirmation

    // Paramètres pour la déduplication
    final int desiredLimit = 20; // Nombre d'activités souhaitées par section
    final int fetchSize = desiredLimit * 2; // Over-fetch: 2x le nombre souhaité
    final Map<String, List<SearchableActivity>> result = {};
    final seenIds = <String>{}; // Set global pour la déduplication

    try {
      // Pour chaque section, récupérer et dédupliquer les activités
      for (final section in sections) {
        final sectionKey = 'section-${section.id}';

        // 1. Over-fetch: récupérer plus d'activités que nécessaire
        final activities = await useCase.execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: section.id,
          subcategoryId: subcategoryId,
          categoryId: categoryId,
          limit: fetchSize, // Récupérer 2x plus d'activités
        );

        // 2. Déduplication: ne garder que les activités non vues précédemment
        final uniqueActivities = <SearchableActivity>[];
        for (final activity in activities) {
          if (seenIds.add(activity.base.id)) { // Retourne true si l'ID n'était pas déjà dans le set
            uniqueActivities.add(activity);
            if (uniqueActivities.length == desiredLimit) break;
          }
        }

        // 3. Tronçage et stockage
        final displayActivities = uniqueActivities.take(desiredLimit).toList();

        if (displayActivities.isNotEmpty) {
          result[sectionKey] = displayActivities;
        } else {
          print('⚠️ Aucune activité unique pour la section ${section.title}');
        }
      }

      // Cache des distances pour toutes les activités
      final allActivities = result.values.expand((list) => list).toList();
      if (allActivities.isNotEmpty) {
        ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
            allActivities.map((activity) => (
            id: activity.base.id,
            lat: activity.base.latitude,
            lon: activity.base.longitude,
            )).toList()
        );
      }

      return result;
    } catch (e) {
      print('❌ Erreur lors du chargement des activités par sous-catégorie: $e');
      return {};
    }
  },
);

/// Provider pour obtenir les titres des sections par ID
final sectionTitlesProvider = FutureProvider<Map<String, String>>((ref) async {
  final sections = await ref.watch(subcategorySectionsProvider.future);

  // Map de base avec les clés spéciales
  final Map<String, String> titles = {
    'featured': 'Activités recommandées',
  };

  // Ajouter les titres des sections découvertes
  for (final section in sections) {
    titles['section-${section.id}'] = section.title;
  }

  return titles;
});