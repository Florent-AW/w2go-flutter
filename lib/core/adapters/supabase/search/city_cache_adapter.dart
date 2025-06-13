// lib/core/adapters/supabase/search/city_cache_adapter.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart'; // Ajoutez cette dépendance à pubspec.yaml
import '../../../domain/ports/location/city_cache_port.dart';
import '../../../domain/ports/search/city_search_port.dart';
import '../../../domain/models/shared/city_model.dart';
import '../../../domain/models/location/place_details.dart';
import '../../../common/utils/geohash.dart';
import '../../../common/constants/city_constants.dart';
import '../../../common/exceptions/location_exceptions.dart';

class SupabaseCityCacheAdapter implements CityCachePort, CitySearchPort {
  final SupabaseClient _supabase;
  final _uuid = Uuid();

  SupabaseCityCacheAdapter(this._supabase);

  @override
  Future<City?> getCityByPlaceId(String placeId) async {
    try {
      // Rechercher d'abord par place_id (nouvelle colonne)
      final response = await _supabase
          .from('cities')
          .select()
          .eq('place_id', placeId)  // Utiliser 'place_id' au lieu de 'id'
          .maybeSingle();

      if (response == null) return null;

      return City.fromJson(response);
    } catch (e) {
      print('❌ Erreur lors de la récupération de la ville par place_id: $e');
      return null;
    }
  }

  @override
  Future<City?> getCityByName(String cityName) async {
    try {
      final response = await _supabase
          .from('cities')
          .select()
          .eq('city_name', cityName)
          .maybeSingle();

      if (response == null) return null;

      return City.fromJson(response);
    } catch (e) {
      print('❌ Erreur lors de la récupération de la ville par nom: $e');
      return null;
    }
  }

  @override
  @override
  Future<List<City>> searchCities(String? query) async {
    try {
      final q = query?.trim() ?? '';
      if (q.isEmpty) return [];

      // Utiliser la fonction RPC
      final response = await _supabase.rpc(
        'search_cities_prefix',
        params: {'q': q, 'lim': 20},
      );

      if (response == null) return [];

      return (response as List)
          .map<City>((json) => City.fromJson(json))
          .toList();
    } catch (e) {
      print('❌ Erreur lors de la recherche de villes: $e');
      return [];
    }
  }
  @override
  Future<City> saveCity({
    required String placeId,
    required String cityName,
    required double lat,
    required double lon,
    String? postalCode,
    String? department,
  }) async {
    try {
      // Générer le geohash
      final geohash5 = Geohash.encode(lat, lon);

      // Générer un UUID valide pour la colonne 'id'
      final uuid = _uuid.v4();

      // Préparer les données
      final cityData = {
        'id': uuid,
        'place_id': placeId,      // Google Place ID dans une colonne dédiée
        'city_name': cityName,
        'lat': lat,
        'lon': lon,
        'geohash_5': geohash5,
        'postal_code': postalCode,
        'department': department,
      };

      print('📍 VILLE À SAUVEGARDER: $cityName');
      print('  └─ Latitude: $lat');
      print('  └─ Longitude: $lon');
      print('  └─ Geohash: $geohash5');

      // Upsert pour gérer à la fois insertion et mise à jour
      final response = await _supabase
          .from('cities')
          .upsert(cityData, onConflict: 'place_id')
          .select()
          .single();

      return City.fromJson(response);
    } catch (e) {
      print('❌ Erreur lors de la sauvegarde de la ville: $e');
      throw LocationException('Erreur lors de la sauvegarde de la ville: $e');
    }
  }

  @override
  Future<City> savePlaceDetailsAsCity(PlaceDetails placeDetails) async {
    // Extraction du code postal et du département
    String? postalCode;
    String? department;

    // Analyser les composants d'adresse pour trouver le code postal
    if (placeDetails.addressComponents != null) {
      for (var component in placeDetails.addressComponents!) {
        // Chercher le composant qui contient le code postal
        if (component.types.contains('postal_code')) {
          postalCode = component.longName;
        }
        // Chercher département (administrative_area_level_2 en France)
        if (component.types.contains('administrative_area_level_2')) {
          department = component.longName;
        }
      }
    }

    // Si le département n'est pas trouvé mais que nous avons le code postal,
    // on peut dériver le département à partir des deux premiers chiffres
    if (department == null && postalCode != null && postalCode.length >= 2) {
      department = _getDepartmentFromPostalCode(postalCode.substring(0, 2));
    }

    return saveCity(
      placeId: placeDetails.placeId,
      cityName: placeDetails.name,
      lat: placeDetails.location.latitude,
      lon: placeDetails.location.longitude,
      postalCode: postalCode,
      department: department,
    );
  }

  // Méthode utilitaire pour dériver le département à partir du code postal
  String? _getDepartmentFromPostalCode(String postalPrefix) {
    // Mapping des codes départementaux
    final departmentMap = {
        '01': 'Ain',
        '02': 'Aisne',
        '03': 'Allier',
        '04': 'Alpes-de-Haute-Provence',
        '05': 'Hautes-Alpes',
        '06': 'Alpes-Maritimes',
        '07': 'Ardèche',
        '08': 'Ardennes',
        '09': 'Ariège',
        '10': 'Aube',
        '11': 'Aude',
        '12': 'Aveyron',
        '13': 'Bouches-du-Rhône',
        '14': 'Calvados',
        '15': 'Cantal',
        '16': 'Charente',
        '17': 'Charente-Maritime',
        '18': 'Cher',
        '19': 'Corrèze',
        '2A': 'Corse-du-Sud',
        '2B': 'Haute-Corse',
        '21': "Côte-d'Or",
        '22': "Côtes-d'Armor",
        '23': 'Creuse',
        '24': 'Dordogne',
        '25': 'Doubs',
        '26': 'Drôme',
        '27': 'Eure',
        '28': 'Eure-et-Loir',
        '29': 'Finistère',
        '30': 'Gard',
        '31': 'Haute-Garonne',
        '32': 'Gers',
        '33': 'Gironde',
        '34': 'Hérault',
        '35': 'Ille-et-Vilaine',
        '36': 'Indre',
        '37': 'Indre-et-Loire',
        '38': 'Isère',
        '39': 'Jura',
        '40': 'Landes',
        '41': 'Loir-et-Cher',
        '42': 'Loire',
        '43': 'Haute-Loire',
        '44': 'Loire-Atlantique',
        '45': 'Loiret',
        '46': 'Lot',
        '47': 'Lot-et-Garonne',
        '48': 'Lozère',
        '49': 'Maine-et-Loire',
        '50': 'Manche',
        '51': 'Marne',
        '52': 'Haute-Marne',
        '53': 'Mayenne',
        '54': 'Meurthe-et-Moselle',
        '55': 'Meuse',
        '56': 'Morbihan',
        '57': 'Moselle',
        '58': 'Nièvre',
        '59': 'Nord',
        '60': 'Oise',
        '61': 'Orne',
        '62': 'Pas-de-Calais',
        '63': 'Puy-de-Dôme',
        '64': 'Pyrénées-Atlantiques',
        '65': 'Hautes-Pyrénées',
        '66': 'Pyrénées-Orientales',
        '67': 'Bas-Rhin',
        '68': 'Haut-Rhin',
        '69': 'Rhône',
        '70': 'Haute-Saône',
        '71': 'Saône-et-Loire',
        '72': 'Sarthe',
        '73': 'Savoie',
        '74': 'Haute-Savoie',
        '75': 'Paris',
        '76': 'Seine-Maritime',
        '77': 'Seine-et-Marne',
        '78': 'Yvelines',
        '79': 'Deux-Sèvres',
        '80': 'Somme',
        '81': 'Tarn',
        '82': 'Tarn-et-Garonne',
        '83': 'Var',
        '84': 'Vaucluse',
        '85': 'Vendée',
        '86': 'Vienne',
        '87': 'Haute-Vienne',
        '88': 'Vosges',
        '89': 'Yonne',
        '90': 'Territoire de Belfort',
        '91': 'Essonne',
        '92': 'Hauts-de-Seine',
        '93': 'Seine-Saint-Denis',
        '94': 'Val-de-Marne',
        '95': "Val-d'Oise",
        '971': 'Guadeloupe',
        '972': 'Martinique',
        '973': 'Guyane',
        '974': 'La Réunion',
        '976': 'Mayotte'
        };

    return departmentMap[postalPrefix];
  }

  @override
  Future<City?> getCityById(String id) async {
    try {
      final response = await _supabase
          .from('cities')
          .select()
          .eq('id', id)
          .maybeSingle();

      if (response == null) return null;

      return City.fromJson(response);
    } catch (e) {
      print('❌ Erreur lors de la récupération de la ville par ID: $e');
      return null;
    }
  }

  @override
  Future<List<City>> getSuggestedCities({
    SuggestedCityType type = SuggestedCityType.aquitaine,
    int limit = SuggestedCitiesConfig.defaultSuggestionCount
  }) async {
    List<String> cityNames;

    switch (type) {
      case SuggestedCityType.aquitaine:
        cityNames = SuggestedCitiesConfig.aquitaineCities;
        break;
      default:
        cityNames = SuggestedCitiesConfig.aquitaineCities;
        break;
    }

    // Limiter au nombre demandé
    cityNames = cityNames.take(limit).toList();

    try {
      final response = await _supabase
          .from('cities')
          .select()
          .filter('city_name', 'in', cityNames) // Recherche par nom de ville avec filter
          .order('city_name');

      if (response == null) return [];

      final cities = (response as List).map<City>((json) => City.fromJson(json)).toList();

      // Fallback - si aucune ville n'est trouvée, prendre les premières de la base
      if (cities.isEmpty) {
        final fallbackResponse = await _supabase
            .from('cities')
            .select()
            .order('city_name')
            .limit(limit);

        if (fallbackResponse != null) {
          return (fallbackResponse as List).map<City>((json) => City.fromJson(json)).toList();
        }
      }

      return cities;
    } catch (e) {
      print('❌ Erreur lors de la récupération des villes suggérées: $e');
      return [];
    }
  }

}

