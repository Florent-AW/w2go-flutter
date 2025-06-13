// lib/core/documentation/category_page_architecture.dart

/// # 📚 Documentation : Architecture de la Category Page
///
/// @version 2.0.0
/// ## Changelog
/// - v2.0.0 (2025-04-25):
///   • Ajout de la clé composite ActivityKey incluant City objet
///   • Over-fetch & déduplication optimisée par priorité de section
///   • Documentation unifiée et exemples de providers Riverpod
///
///
/// ## 1. Introduction & Contexte
///
/// La **Category Page** est le point d'entrée principal pour l'exploration des activités
/// touristiques par catégorie et sous-catégorie. Cette implémentation optimise :
///
/// - **Performance** : CustomScrollView avec SliverPersistentHeader
/// - **Expérience** : Transitions fluides entre catégories (fade 300ms)
/// - **Cache intelligent** : Mise en cache granulaire par (catégorie, sous-catégorie, ville)
/// - **Déduplication** : Évite l'affichage des mêmes activités dans différentes sections
///
/// ## 2. Architecture globale
///
/// ```
/// Supabase                        Flutter/Riverpod                   UI
/// ┌─────────────┐  get_activities  ┌──────────────────┐             ┌──────────────────┐
/// │merged_filter│◄──────RPC───────►│GetActivitiesUse  │            ┌┤CategoryPageTemp. │
/// │_config (MV) │                  │Case              │            │└──────────────────┘
/// └─────────────┘                  └──────────────────┘            │┌──────────────────┐
///       ▲                                   ▲                      ││FeaturedActivities│
///       │                                   │                      ││Carousel          │
/// ┌─────────────┐                  ┌──────────────────┐            │└──────────────────┘
/// │section_     │                  │Providers (family)│◄───watch───┘┌──────────────────┐
/// │filter_      │                  │• featured        │             │SubcategoryAct.   │
/// │overrides    │                  │• subcategorySect.│◄───watch────┤Section           │
/// └─────────────┘                  └──────────────────┘             └──────────────────┘
/// ```
///
/// ## 3. Modèles de données (DTOs & Domain Models)
///
/// ```dart
/// // Principales entités
/// class Category extends Equatable { ... }
/// class Subcategory extends Equatable { ... }
/// class City extends Equatable { ... }
/// class SectionMetadata { ... } // Configuration de section
/// class SearchableActivity { ... } // Activité formatée pour UI
///
/// // Clés composites pour providers
/// typedef ActivityKey = ({
///   String categoryId,
///   String? subcategoryId,
///   City? city, // Objet complet pour éviter requêtes inutiles
/// });
///
/// typedef FeaturedActivitiesKey = ({
///   String categoryId,
///   City? city,
/// });
/// ```
///
/// ## 4. Accès aux données & Use Cases
///
/// ### 4.1 Supabase RPC et Vue Matérialisée
///
/// - **merged_filter_config** fusionne `home_sections` et `section_filter_overrides`
/// - **get_activities_list** prend `section_id`, `lat/lon`, `category/subcategory_id`
/// - La vue doit être rafraîchie après modifications : `REFRESH MATERIALIZED VIEW merged_filter_config`
///
/// ### 4.2 GetActivitiesUseCase
///
/// ```dart
/// // Point d'entrée unifié pour récupérer des activités
/// Future<List<SearchableActivity>> execute({
///   required double latitude,
///   required double longitude,
///   required String sectionId,  // ID de configuration (MV)
///   String? categoryId,         // Filtrage optionnel par catégorie
///   String? subcategoryId,      // Filtrage optionnel par sous-catégorie
///   int limit = 20,             // Limite par défaut
/// }) async {
///   final filter = ActivityFilter(
///     categoryId: categoryId,
///     subcategoryId: subcategoryId,
///     sectionId: sectionId,
///     limit: limit,
///   );
///
///   return _searchPort.getActivitiesWithFilter(filter, latitude, longitude);
/// }
/// ```
///
/// ## 5. Providers Riverpod
///
/// ### 5.1 Catégories & Sous-catégories
///
/// ```dart
/// // Providers pour catégories et sélection
/// final categoriesProvider = FutureProvider<List<Category>>(...);
/// final selectedCategoryProvider = StateProvider<Category?>(...);
///
/// // Provider pour sous-catégories par catégorie
/// final subCategoriesForCategoryProvider = FutureProvider.family<List<Subcategory>, String>(...);
///
/// // Provider pour la sous-catégorie sélectionnée (par catégorie)
/// final selectedSubcategoryByCategoryProvider = StateProvider.family<Subcategory?, String>(...);
///
/// // Provider pour les sections de configuration
/// final subcategorySectionsProvider = FutureProvider<List<SectionMetadata>>(...);
/// ```
///
/// ### 5.2 Featured Activities
///
/// ```dart
/// // Activités mises en avant par catégorie et ville
/// final featuredActivitiesByCategoryProvider = FutureProvider.family
///   List<SearchableActivity>,
///   FeaturedActivitiesKey
/// >((ref, key) async {
///   final categoryId = key.categoryId;
///   final city = key.city;
///
///   // Pas de requête DB, utilisation directe de l'objet City
///   if (city == null) return [];
///
///   final activities = await useCase.execute(
///     latitude: city.lat,
///     longitude: city.lon,
///     sectionId: featuredSectionId,
///     categoryId: categoryId,
///     limit: 20,
///   );
///
///   // Cache des distances
///   ref.read(activityDistancesProvider.notifier).cacheDistances(...);
///
///   return activities;
/// });
/// ```
///
/// ### 5.3 Subcategory Section Activities
///
/// ```dart
/// // Activities par sections pour une sous-catégorie
/// final subcategorySectionActivitiesProvider = FutureProvider.family
///   Map<String, List<SearchableActivity>>,
///   ActivityKey
/// >((ref, key) async {
///   final categoryId = key.categoryId;
///   final subcategoryId = key.subcategoryId;
///   final city = key.city;
///
///   if (subcategoryId == null || city == null) return {};
///
///   // 1. Récupérer et trier les sections de configuration
///   final sections = await _getSections(ref);
///   sections.sort((a, b) => a.priority.compareTo(b.priority));
///
///   // 2. Pour chaque section, récupérer et dédupliquer
///   final result = <String, List<SearchableActivity>>{};
///   final seenIds = <String>{};  // Global pour déduplication inter-sections
///   final desiredLimit = 20;     // Objectif par section
///   final fetchSize = desiredLimit * 2;  // Over-fetch pour compenser déduplication
///
///   for (final section in sections) {
///     // Over-fetch: récupérer plus d'activités que nécessaire
///     final activities = await useCase.execute(
///       latitude: city.lat,
///       longitude: city.lon,
///       sectionId: section.id,
///       categoryId: categoryId,
///       subcategoryId: subcategoryId,
///       limit: fetchSize,
///     );
///
///     // Dédupliquer et tronquer
///     final unique = <SearchableActivity>[];
///     for (final activity in activities) {
///       if (seenIds.add(activity.base.id)) {  // true si ajout réussi (nouvel ID)
///         unique.add(activity);
///         if (unique.length == desiredLimit) break;
///       }
///     }
///
///     if (unique.isNotEmpty) {
///       result['section-${section.id}'] = unique;
///     }
///   }
///
///   return result;
/// });
/// ```
///
/// ## 6. UI & Intégration
///
/// ### 6.1 CategoryPage / CategoryPageTemplate
///
/// - **CustomScrollView** avec SliverPersistentHeader pour cover et tabs
/// - Structure: Cover → Category Tabs → Featured Carousel → Subcategory Tabs → Section Carousels
/// - **Transitions**: Fade cover 300ms, fade content 180ms, reset scroll contrôlé
///
/// ### 6.2 FeaturedActivitiesCarousel
///
/// ```dart
/// // Dans build():
/// final selectedCity = ref.watch(selectedCityProvider);
/// final activitiesAsync = ref.watch(
///   featuredActivitiesByCategoryProvider((
///     categoryId: categoryId,
///     city: selectedCity,
///   ))
/// );
///
/// // Utilisation du pattern when():
/// activitiesAsync.when(
///   data: (activities) => /* Affichage normal */,
///   loading: () => /* Shimmer skeleton */,
///   error: (error, _) => /* Message d'erreur */,
/// );
/// ```
///
/// ### 6.3 SubcategoryActivitiesSection
///
/// ```dart
/// // Dans build():
/// final currentCategory = ref.watch(selectedCategoryProvider);
/// final selectedSubcategory = ref.watch(selectedSubcategoryByCategoryProvider(currentCategory?.id ?? ''));
/// final selectedCity = ref.watch(selectedCityProvider);
///
/// final sectionsActivitiesAsync = ref.watch(
///   subcategorySectionActivitiesProvider((
///     categoryId: currentCategory?.id ?? '',
///     subcategoryId: selectedSubcategory?.id,
///     city: selectedCity,
///   ))
/// );
///
/// // Affichage: mappage des sections → carousels GenericActivityCarousel
/// ```
///
/// ## 7. Cache & Invalidation
///
/// - Cache granulaire par `(catégorie, sous-catégorie, ville)`
/// - Passage direct de `City` plutôt que `cityId` pour éviter requêtes DB supplémentaires
/// - Utilisation de `ref.watch` pour réactivité automatique au changement de ville
/// - Invalidation automatique quand la clé composite change (nouvelle ville, etc.)
///
/// ## 8. Déduplication & Priorisation
///
/// - Tri des sections par `priority` (valeur numérique ascendante)
/// - Over-fetch (2x) pour compenser la déduplication
/// - Set global `seenIds` garantissant unicité entre sections
/// - Plafonnement à `desiredLimit` activités par section
/// - Les sections prioritaires (priority plus basse) reçoivent les premières activités
///
/// ## 9. Optimisations additionnelles
///
/// - `Shimmer` pendant les chargements pour améliorer l'UX
/// - `RepaintBoundary` autour des carousels pour limiter les repaints
/// - `cacheExtent: 2.5 * MediaQuery.of(context).size.width` pour pré-rendu hors-écran
/// - Cache des distances calculées pour éviter recalculs
/// - Initialisation automatique de la première sous-catégorie
///
/// ## 10. Considérations sur l'état initial
///
/// ```dart
/// // Dans le provider de sous-catégories:
/// if (subcategories.isNotEmpty) {
///   // Précharger sections AVANT de sélectionner sous-catégorie
///   final sections = await ref.read(subcategorySectionsProvider.future);
///
///   // Vérifier si déjà une sélection pour cette catégorie
///   final currentSelection = ref.read(selectedSubcategoryByCategoryProvider(categoryId));
///
///   // Sélectionner seulement si aucune sous-catégorie n'est déjà sélectionnée
///   if (currentSelection == null) {
///     WidgetsBinding.instance.addPostFrameCallback((_) {
///       ref.read(selectedSubcategoryByCategoryProvider(categoryId).notifier)
///         .state = subcategories.first;
///     });
///   }
/// }
/// ```
///
/// ## 11. Bonnes pratiques & Conventions
///
/// - **Logging**: Différents niveaux avec émojis pour traçabilité
/// - **Erreurs**: Toujours remontées visuellement avec texte d'erreur explicite
/// - **Nommage**: CamelCase pour méthodes privées, SnakeCase pour SQL
/// - **Performance**: Ne jamais rebuild ce qui peut être évité
/// - **Persistance**: Passage par `selectedCategoryProvider` toujours
///
/// ## 12. Maintenance & Évolution
///
/// - Pour ajouter une section, modifier `merged_filter_config` puis `REFRESH MATERIALIZED VIEW`
/// - La priorité (`priority`) contrôle l'ordre d'apparition et la priorité de déduplication
/// - Toute modification côté Supabase nécessite de tester le cache client (invalidation correcte)
///
/// ## 13. FAQ
///
/// **Q: Pourquoi l'over-fetch à 2x?**
/// R: Pour garantir un nombre d'activités constant même après déduplication.
///
/// **Q: Pourquoi utiliser `City` complet plutôt que `cityId`?**
/// R: Économise une requête DB et élimine les risques d'échec si ID invalide.
///
/// **Q: Comment se passe le changement de ville?**
/// R: La clé composite change, invalidant automatiquement le cache et déclenchant un rechargement.
///
/// **Q: Comment rafraîchir la vue matérialisée?**
/// R: Via SQL: `REFRESH MATERIALIZED VIEW merged_filter_config;`
///
/// 
/// ## 📑 Annexes : Extraits de migrations SQL
///
/// ```sql
/// -- 1. Materialized View merged_filter_config
/// CREATE OR REPLACE MATERIALIZED VIEW merged_filter_config AS
/// SELECT
///   hs.id                 AS section_id,
///   hs.title,
///   hs.priority,
///   hs.section_type,
///   hs.display_order,
///   hs.filter_config
///     || coalesce(jsonb_object_agg(o.filter_key, o.value), '{}'::jsonb)
///     AS filter_config
/// FROM home_sections hs
/// LEFT JOIN section_filter_overrides o ON o.section_id = hs.id
/// GROUP BY hs.id, hs.title, hs.priority, hs.section_type, hs.display_order;
///
/// -- 2. Fonction RPC get_activities_list
/// CREATE OR REPLACE FUNCTION get_activities_list(
///   p_section_id uuid,
///   p_lat         double precision,
///   p_lon         double precision,
///   p_limit       integer DEFAULT 20
/// )
/// RETURNS TABLE (
///   id         uuid,
///   name       text,
///   city       text,
///   rating_avg float,
///   distance   double precision
/// ) AS $$
/// BEGIN
///   PERFORM set_config('plan_cache_mode', 'force_generic_plan', true);
///   RETURN QUERY
///     WITH cfg AS (
///       SELECT filter_config
///       FROM merged_filter_config
///       WHERE section_id = p_section_id
///     )
///     SELECT
///       a.id,
///       a.name,
///       a.city,
///       a.rating_avg,
///       ST_Distance(a.location, ST_MakePoint(p_lon,p_lat)::geography) AS distance
///     FROM activities a
///     JOIN cfg ON true
///     WHERE
///       (cfg.filter_config->>'minRating')::float <= a.rating_avg
///       AND a.category_id = (cfg.filter_config->>'categoryId')
///       AND ST_DWithin(a.location, ST_MakePoint(p_lon,p_lat)::geography,
///           COALESCE((cfg.filter_config->>'maxDistance')::int, 50000))
///     ORDER BY distance
///     LIMIT p_limit;
/// END;
/// $$ LANGUAGE plpgsql STABLE;
/// ```
class CategoryPageArchitectureDoc {}