// lib/features/search/application/state/event_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/domain/models/event/search/searchable_event.dart';
import '../../../../core/domain/models/search/config/section_metadata.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../../core/adapters/supabase/search/event_search_adapter.dart';
import '../../../../core/domain/use_cases/search/get_events_use_case.dart';
import '../../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';
import 'section_discovery_providers.dart';

// Définir une clé composite pour les événements
typedef EventKey = ({
String categoryId,
String? subcategoryId,
City? city,
});

// Définir une clé composite pour les événements en vedette
typedef FeaturedEventsKey = ({
String categoryId,
City? city,
});

/// Provider pour l'adapter de recherche d'événements
final eventSearchAdapterProvider = Provider<EventSearchAdapter>((ref) {
  final client = Supabase.instance.client;
  return EventSearchAdapter(client);
});


/// Provider pour le use case de récupération d'événements
final getEventsUseCaseProvider = Provider<GetEventsUseCase>((ref) {
  final searchAdapter = ref.read(eventSearchAdapterProvider);
  return GetEventsUseCase(searchAdapter);
});

/// Provider pour les événements mis en avant par catégorie
/// Utilise le nouveau use case avec section_id
final featuredEventsByCategoryProvider = FutureProvider.family<List<SearchableEvent>, FeaturedEventsKey>(
      (ref, key) async {
    final categoryId = key.categoryId;
    final city = key.city;

    print('🔍 Recherche des événements mis en avant pour catégorie: $categoryId (ville: ${city?.cityName})');

    final useCase = ref.read(getEventsUseCaseProvider);

    // Utiliser directement l'objet city
    if (city == null) return [];

    try {
      // Utiliser la section ID des événements par catégorie
      const String featuredSectionId = 'a62c6046-8814-456f-91ba-b65aa7e73137';

      // Exécuter la recherche avec city.lat et city.lon
      final events = await useCase.execute(
        latitude: city.lat,
        longitude: city.lon,
        sectionId: featuredSectionId,
        categoryId: categoryId,
        limit: 20,
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

      return events;
    } catch (e) {
      print('❌ Erreur lors du chargement des événements mis en avant: $e');
      return [];
    }
  },
);

/// Provider optimisé pour les événements filtrés par sous-catégorie
/// Utilise une clé composite pour un cache granulaire par (catégorie, sous-catégorie)
final subcategorySectionEventsProvider = FutureProvider.family<Map<String, List<SearchableEvent>>, EventKey>(
      (ref, key) async {
    final categoryId = key.categoryId;
    final subcategoryId = key.subcategoryId;
    final city = key.city;  // Utiliser city au lieu de cityId

    print('🔄 Chargement des événements pour (catégorie: $categoryId, sous-catégorie: $subcategoryId, ville: ${city?.cityName})');

    if (subcategoryId == null) return {};

    // Utiliser ref.read pour les dépendances non réactives
    final useCase = ref.read(getEventsUseCaseProvider);

    // Pas besoin de charger la ville, on l'a déjà
    if (city == null) {
      print('⚠️ Ville non trouvée, impossible de charger les événements');
      return {};
    }

    // Récupérer les sections et attendre explicitement leur chargement
    final sections = await ref.read(
      effectiveSubcategorySectionsProvider(categoryId).future,
    ).catchError((_) => <SectionMetadata>[]);

    if (sections.isEmpty) {
      print('⚠️ Aucune section de sous-catégorie n\'a été trouvée');
      return {};
    }

    // Ajout de logs pour vérifier l'ordre avant tri
    print('📋 Avant tri: ${sections.map((s) => '${s.title} (priority:${s.priority})').join(' → ')}');

    // Tri explicite par priorité (ascendant)
    sections.sort((a, b) => a.priority.compareTo(b.priority));

    // Logs après tri pour confirmation
    print('🔀 Après tri: ${sections.map((s) => '${s.title} (priority:${s.priority})').join(' → ')}');

    // Paramètres pour la déduplication
    final int desiredLimit = 20; // Nombre d'événements souhaités par section
    final int fetchSize = desiredLimit * 2; // Over-fetch: 2x le nombre souhaité
    final Map<String, List<SearchableEvent>> result = {};
    final seenIds = <String>{}; // Set global pour la déduplication

    try {
      // Pour chaque section, récupérer et dédupliquer les événements
      for (final section in sections) {
        print('🔄 Chargement de la section ${section.title} (${section.id})');
        final sectionKey = 'section-${section.id}';

        // 1. Over-fetch: récupérer plus d'événements que nécessaire
        final events = await useCase.execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: section.id,
          subcategoryId: subcategoryId,
          categoryId: categoryId,
          limit: fetchSize, // Récupérer 2x plus d'événements
        );

        // 2. Déduplication: ne garder que les événements non vus précédemment
        final uniqueEvents = <SearchableEvent>[];
        for (final event in events) {
          if (seenIds.add(event.base.id)) { // Retourne true si l'ID n'était pas déjà dans le set
            uniqueEvents.add(event);
            if (uniqueEvents.length == desiredLimit) break;
          }
        }

        // 3. Tronçage et stockage
        final displayEvents = uniqueEvents.take(desiredLimit).toList();

        if (displayEvents.isNotEmpty) {
          result[sectionKey] = displayEvents;
          print('✅ Section ${section.title}: ${displayEvents.length} événements uniques (sur ${events.length} récupérés)');
        } else {
          print('⚠️ Aucun événement unique pour la section ${section.title}');
        }
      }

      // Cache des distances pour tous les événements
      final allEvents = result.values.expand((list) => list).toList();
      if (allEvents.isNotEmpty) {
        ref.read(activityDistancesProvider.notifier).cacheActivitiesDistances(
            allEvents.map((event) => (
            id: event.base.id,
            lat: event.base.latitude,
            lon: event.base.longitude,
            )).toList()
        );
      }

      print('📊 CACHE: ${result.length} sections avec ${seenIds.length} événements uniques au total');
      return result;
    } catch (e) {
      print('❌ Erreur lors du chargement des événements par sous-catégorie: $e');
      return {};
    }
  },
);