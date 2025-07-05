// lib/features/search/application/state/experience_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../../core/domain/models/activity/search/searchable_activity.dart';
import '../../../../core/domain/models/event/search/searchable_event.dart';
import '../../../../core/domain/models/search/config/section_metadata.dart';
import '../../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';
import 'activity_providers.dart';
import 'event_providers.dart';

// Définir une clé composite pour les expériences mixtes
typedef ExperienceKey = ({
String categoryId,
String? subcategoryId,
City? city,
});

typedef FeaturedExperiencesKey = ({
String categoryId,
City? city,
});

/// Provider qui combine activities et events en ExperienceItem
/// pour les expériences mises en avant par catégorie
/// Provider pour les événements mis en avant par catégorie

/// Utilise le nouveau use case avec section_id SPÉCIFIQUE aux events
final featuredExperiencesByCategoryProvider = FutureProvider.family<List<ExperienceItem>, FeaturedExperiencesKey>(
      (ref, key) async {
    final categoryId = key.categoryId;
    final city = key.city;

    print('🔍 Recherche des expériences mixtes mises en avant pour catégorie: $categoryId');

    if (city == null) return [];

    try {
      // ✅ NOUVEAU : Utiliser des sections différentes selon la catégorie
      const String eventsCategoryId = 'c3b42899-fdc3-48f7-bd85-09be3381aba9';
      const String activitiesFeaturedSectionId = 'a62c6046-8814-456f-91ba-b65aa7e73137';
      const String eventsFeaturedSectionId = 'efe12f9f-492c-415a-8bea-74dd147ad6bd';

      final isEventsCategory = categoryId == eventsCategoryId;

      if (isEventsCategory) {
        // Pour la catégorie événements, charger SEULEMENT les events
        final events = await ref.read(getEventsUseCaseProvider).execute(
          latitude: city.lat,
          longitude: city.lon,
          sectionId: eventsFeaturedSectionId,
          categoryId: categoryId,
          limit: 20,
        );

        // Convertir en ExperienceItem
        final experiences = events.map((event) => ExperienceItem.event(event)).toList();

        print('✅ Événements chargés: ${events.length} événements');
        return experiences;
      } else {
        // Pour les autres catégories, charger activities + events en parallèle
        final results = await Future.wait([
          ref.read(featuredActivitiesByCategoryProvider(
              (categoryId: categoryId, city: city)
          ).future),
          ref.read(featuredEventsByCategoryProvider(
              (categoryId: categoryId, city: city)
          ).future),
        ]);

        final activities = results[0] as List<SearchableActivity>;
        final events = results[1] as List<SearchableEvent>;

        // Convertir en ExperienceItem et mélanger
        final List<ExperienceItem> experiences = [];
        experiences.addAll(activities.map((activity) => ExperienceItem.activity(activity)));
        experiences.addAll(events.map((event) => ExperienceItem.event(event)));

        // Trier intelligemment
        experiences.sort((a, b) {
          if (a.isEvent && !b.isEvent) {
            final now = DateTime.now();
            if (a.startDate != null && a.startDate!.isAfter(now)) {
              return -1;
            }
          }
          if (!a.isEvent && b.isEvent) {
            final now = DateTime.now();
            if (b.startDate != null && b.startDate!.isAfter(now)) {
              return 1;
            }
          }
          return b.ratingAvg.compareTo(a.ratingAvg);
        });

        print('✅ Expériences mixtes chargées: ${activities.length} activités + ${events.length} événements = ${experiences.length} total');
        return experiences;
      }
    } catch (e) {
      print('❌ Erreur lors du chargement des expériences mixtes: $e');
      return [];
    }
  },
);
/// Provider qui combine activities et events par sous-catégorie
final subcategorySectionExperiencesProvider = FutureProvider.family<Map<String, List<ExperienceItem>>, ExperienceKey>(
      (ref, key) async {
    final categoryId = key.categoryId;
    final subcategoryId = key.subcategoryId;
    final city = key.city;

    print('🔄 Chargement des expériences mixtes pour (catégorie: $categoryId, sous-catégorie: $subcategoryId)');
    print('🔄 DEBUG EXPERIENCES: categoryId=$categoryId, subcategoryId=$subcategoryId, city=${city?.cityName}');
    print('🔄 DEBUG EXPERIENCES: isEventsCategory=${categoryId == "c3b42899-fdc3-48f7-bd85-09be3381aba9"}');

    if (subcategoryId == null || city == null) return {};

    try {
      // Charger activities et events en parallèle
      print('🔄 DEBUG: Avant Future.wait...');
      final futures = await Future.wait([
        ref.read(subcategorySectionActivitiesProvider(
            (categoryId: categoryId, subcategoryId: subcategoryId, city: city)
        ).future),
        ref.read(subcategorySectionEventsProvider(
            (categoryId: categoryId, subcategoryId: subcategoryId, city: city)
        ).future),
      ]);
      print('🔄 DEBUG: Après Future.wait, résultats reçus');

      final activitiesBySections = futures[0] as Map<String, List<SearchableActivity>>;
      final eventsBySections = futures[1] as Map<String, List<SearchableEvent>>;
      print('🔄 DEBUG: Activities sections: ${activitiesBySections.keys.toList()}');
      print('🔄 DEBUG: Events sections: ${eventsBySections.keys.toList()}');

      // Fusionner les résultats par section
      final Map<String, List<ExperienceItem>> result = {};

      // Traiter toutes les sections (activités + événements)
      final allSectionKeys = <String>{
        ...activitiesBySections.keys,
        ...eventsBySections.keys,
      };

      for (final sectionKey in allSectionKeys) {
        final activities = activitiesBySections[sectionKey] ?? [];
        final events = eventsBySections[sectionKey] ?? [];

        if (activities.isEmpty && events.isEmpty) continue;

        // Convertir en ExperienceItem et mélanger
        final List<ExperienceItem> experiences = [];

        // Ajouter les activités
        experiences.addAll(activities.map((activity) => ExperienceItem.activity(activity)));

        // Ajouter les événements
        experiences.addAll(events.map((event) => ExperienceItem.event(event)));

        // Trier de manière intelligente selon le contexte
        experiences.sort((a, b) {
          // Pour les événements, trier par date de début (plus proche en premier)
          if (a.isEvent && b.isEvent) {
            final aDate = a.startDate!;
            final bDate = b.startDate!;
            return aDate.compareTo(bDate);
          }

          // Prioriser les événements à venir par rapport aux activités
          if (a.isEvent && !b.isEvent) {
            final now = DateTime.now();
            if (a.startDate != null && a.startDate!.isAfter(now)) {
              return -1;
            }
          }
          if (!a.isEvent && b.isEvent) {
            final now = DateTime.now();
            if (b.startDate != null && b.startDate!.isAfter(now)) {
              return 1;
            }
          }

          // Sinon trier par rating
          return b.ratingAvg.compareTo(a.ratingAvg);
        });

        // Limiter à 20 expériences par section
        result[sectionKey] = experiences.take(20).toList();

      }

      return result;
    } catch (e) {
      print('❌ Erreur lors du chargement des expériences mixtes par sous-catégorie: $e');
      return {};
    }
  },
);

/// Provider pour récupérer toutes les sections featured d'une catégorie
final featuredSectionsByCategoryProvider = FutureProvider.family<List<SectionMetadata>, String>((ref, categoryId) async {
  try {
    final client = Supabase.instance.client;

    // ✅ NOUVEAU : Récupérer TOUTES les sections featured (spécifiques + génériques)
    final response = await client
        .from('home_sections')
        .select('id, title, priority, query_filter, category_id')
        .eq('section_type', 'featured')
        .order('priority')
        .order('display_order');

    final allSections = (response as List).map((json) => SectionMetadata(
      id: json['id'],
      title: json['title'],
      sectionType: 'featured',
      priority: json['priority'],
      categoryId: json['category_id'], // ✅ AJOUT nécessaire
    )).toList();

    // ✅ LOGIQUE FALLBACK : Séparer spécifiques vs génériques
    final specifics = allSections.where((s) => s.categoryId == categoryId).toList();
    final generics = allSections.where((s) => s.categoryId == null).toList();

    // ✅ RÈGLE INTELLIGENTE : spécifique sinon générique
    final effectiveSections = specifics.isNotEmpty ? specifics : generics;

    // Tri par priorité
    effectiveSections.sort((a, b) => a.priority.compareTo(b.priority));

    print('📊 Sections featured pour catégorie $categoryId:');
    print('   - Spécifiques: ${specifics.length} (${specifics.map((s) => s.title).join(", ")})');
    print('   - Génériques: ${generics.length} (${generics.map((s) => s.title).join(", ")})');
    print('   - Utilisées: ${effectiveSections.length} (${effectiveSections.map((s) => s.title).join(", ")})');

    return effectiveSections;
  } catch (e) {
    print('❌ Erreur récupération sections featured: $e');
    return [];
  }
});

/// Provider pour les événements d'une section featured spécifique
final featuredEventsBySectionProvider = FutureProvider.family<List<ExperienceItem>, ({String sectionId, String categoryId, City? city})>((ref, params) async {
  final sectionId = params.sectionId;
  final categoryId = params.categoryId;
  final city = params.city;

  if (city == null) return [];

  try {
    final events = await ref.read(getEventsUseCaseProvider).execute(
      latitude: city.lat,
      longitude: city.lon,
      sectionId: sectionId,
      categoryId: categoryId, // ✅ AJOUT : Nécessaire pour les jointures
      limit: 30,
    );

    // ✅ AJOUT : Cache des distances comme pour les activities
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
    print('✅ Section $sectionId: ${experiences.length} événements avec logos/subcategory');
    return experiences;
  } catch (e) {
    print('❌ Erreur section $sectionId: $e');
    return [];
  }
});

/// Provider pour les activités d'une section featured spécifique
final featuredActivitiesBySectionProvider = FutureProvider.family<List<ExperienceItem>, ({String sectionId, String categoryId, City? city})>((ref, params) async {
  final sectionId = params.sectionId;
  final categoryId = params.categoryId;
  final city = params.city;

  if (city == null) return [];

  try {
    final activities = await ref.read(getActivitiesUseCaseProvider).execute(
      latitude: city.lat,
      longitude: city.lon,
      sectionId: sectionId,
      categoryId: categoryId,
      limit: 30,
    );

    // ✅ Cache des distances
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
    print('✅ Section $sectionId: ${experiences.length} activités');
    return experiences;
  } catch (e) {
    print('❌ Erreur section $sectionId: $e');
    return [];
  }
});