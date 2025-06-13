# Documentation Technique: CityPickerPage & Système de Sélection de Ville

@version 2.0.0
## Changelog
- v2.0.0 (2025-05-07): Unification des adaptateurs, optimisation de recherche, amélioration des suggestions
- v1.0.0 (2025-06-05): Version initiale

Cette documentation couvre l'implémentation améliorée du système de sélection de ville qui utilise une base de données Supabase centralisée avec recherche optimisée.

## Architecture & Flux de Données

Le système utilise une architecture hexagonale avec:
- **Domain**: `City`, providers pour l'état partagé
- **Application**: Services de localisation et sélection
- **Infrastructure**: Adapters unifiés pour Supabase
- **Presentation**: Composants UI atomiques et page de sélection

**Flux principal**:
1. Recherche utilisateur → Requête RPC optimisée vers Supabase
2. Résultats correctement triés par pertinence et affichés dans une liste unifiée
3. Sélection → Mise à jour provider global → Navigation
4. Persistance automatique des données géographiques complètes (code postal, département)

## Fichiers Impliqués et Modifications

### Common Layer (Nouveau)
- `core/common/constants/city_constants.dart` - Définition des villes suggérées par région

### Domain Layer
- `core/domain/models/shared/city_model.dart` - Modèle City avec propriétés code postal et département
- `core/domain/ports/search/city_search_port.dart` - Interface pour recherche de villes
- `core/domain/ports/location/city_cache_port.dart` - Port pour persistance des villes (augmenté avec getCityById)

### Infrastructure Layer
- `core/adapters/supabase/search/city_cache_adapter.dart` - Adaptateur unifié implémentant les deux ports
- `core/adapters/supabase/search/suggested_cities_adapter.dart` - Adaptateur optimisé pour les suggestions de villes

### Presentation Layer
- `core/theme/components/molecules/suggested_cities_list.dart` - Layout harmonisé en liste verticale
- `core/theme/components/organisms/city_picker_content.dart` - Simplification de l'organisme principal

## Composants Critiques Améliorés

### 1. Adaptateur Unifié

L'application utilise désormais un adaptateur unifié qui implémente à la fois `CityCachePort` et `CitySearchPort`. Cette approche respecte le principe DRY et garantit une cohérence dans la manipulation des données.

```dart
class SupabaseCityCacheAdapter implements CityCachePort, CitySearchPort {
  // Implémentations combinées...
}
```

### 2. Recherche Optimisée via RPC

Une fonction RPC PostgreSQL est utilisée pour optimiser la recherche:

```sql
create or replace function search_cities_prefix(q text, lim int default 20)
returns setof cities
language sql stable
as $$
  select *
  from public.cities
  where unaccent(lower(city_name)) like '%' || unaccent(lower(q)) || '%'
     or postal_code ilike q || '%'
  order by
    case
      when q ~ '^[0-9]{5}$' and postal_code ilike q || '%' then 0
      when unaccent(lower(city_name)) like unaccent(lower(q)) || '%' then 1
      when postal_code ilike q || '%' then 2
      else 3
    end,
    char_length(city_name),
    city_name
  limit lim;
$$;
```

Cette fonction offre:
- Insensibilité aux accents (Évreux/evreux)
- Prioritisation intelligente des résultats:
    1. Code postal exact pour saisies à 5 chiffres
    2. Villes dont le nom commence par la requête
    3. Codes postaux commençant par la requête
    4. Autres correspondances partielles
- Préférence pour les noms courts (souvent les villes plus importantes)

### 3. Gestion des Villes Suggérées

Les villes suggérées sont désormais gérées par catégorie dans un fichier de constantes plutôt que par IDs codés en dur:

```dart
enum SuggestedCityType {
  perigord,  // Villes principales du Périgord
  major,     // Grandes villes françaises
  touristic  // Villes touristiques populaires
}

class SuggestedCitiesConfig {
  static const List<String> perigordCities = [...];
  static const List<String> majorCities = [...];
  // ...
}
```

Ce système est plus robuste et extensible, avec un fallback automatique si les villes suggérées ne sont pas trouvées.

### 4. Interface Utilisateur Unifiée

L'interface utilisateur a été harmonisée:
- Affichage cohérent des villes (liste verticale pour les suggestions et les résultats)
- Affichage systématique du code postal et du département pour toutes les villes
- Style visuel uniforme pour toutes les listes

## Performance et Optimisation

- **Indexation**: Utilisation d'index trigram pour des recherches performantes
- **Pagination**: Limitation des résultats à 20 pour réduire la charge réseau
- **Ordre optimal**: Calcul côté serveur de la pertinence des résultats

## Patterns Implémentés

1. **Adaptateur Unifié**:
   L'adaptateur `SupabaseCityCacheAdapter` implémente plusieurs interfaces tout en maintenant le principe de responsabilité unique dans son implémentation

2. **Provider Projection**:
   ```dart
   final citySearchProvider = Provider<CitySearchPort>((ref) {
     return ref.watch(citySearchAdapterProvider);
   });
   ```
   Exposition sécurisée de l'adaptateur sous différentes interfaces

3. **Constants Centralisées**:
   Utilisation d'un fichier dédié pour les constantes liées aux villes

## Points d'Extension Futurs

1. Ajout de mécanismes de favoris ou d'historique personnalisé par utilisateur
2. Implémentation d'une sélection multi-villes pour des itinéraires
3. Intégration de données démographiques ou touristiques pour enrichir l'affichage

## Dépendances Critiques

- **providers**: selectedCityProvider, cityCacheProvider, citySearchProvider, suggestedCitiesProvider
- **services**: EnhancedLocationService
- **adapters**: SupabaseCityCacheAdapter, SupabaseSuggestedCitiesAdapter
- **composants**: CityListItem, SearchHeader, CityPickerContent