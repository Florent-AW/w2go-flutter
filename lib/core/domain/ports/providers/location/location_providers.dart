// lib/core/domain/ports/providers/location/location_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../../../domain/services/location_service.dart';
import '../../../../adapters/google_maps/maps_adapter.dart';
import '../../../../adapters/cache/hive_location_cache_adapter.dart';
import '../../../../adapters/supabase/search/city_cache_adapter.dart';
import '../../../../adapters/supabase/search/suggested_cities_adapter.dart';
import '../../../models/shared/city_model.dart';
import '../../../services/location/enhanced_location_service.dart';
import '../../../ports/location/location_cache_port.dart';
import '../../../ports/location/city_cache_port.dart';
import '../../../ports/search/city_search_port.dart';
import '../../../ports/search/suggested_cities_port.dart';
import '../../../../common/constants/city_constants.dart';



// Provider pour Supabase client
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

// Provider pour le client HTTP
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

// Provider pour le LocationService
final locationServiceProvider = Provider<LocationService>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return LocationService(supabase);
});

// Provider pour l'adapter de cache de villes
final cityCacheProvider = Provider<CityCachePort>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseCityCacheAdapter(supabase);
});

// Provider pour l'interface de recherche (utilisant le même adaptateur)
final citySearchProvider = Provider<CitySearchPort>((ref) {
  return ref.watch(cityCacheProvider) as CitySearchPort;
});

// Provider d'état interne pour stocker l'instance initialisée
final initializedCacheProvider = StateProvider<HiveLocationCacheAdapter?>((ref) => null);

// Provider d'initialisation qui retourne l'adaptateur une fois initialisé
final cacheInitializationProvider = FutureProvider<HiveLocationCacheAdapter>((ref) async {
  try {
    await Hive.initFlutter();
  } catch (e) {
    print('Note: Hive.initFlutter a lancé une erreur, probablement déjà initialisé: $e');
  }

  final cacheAdapter = HiveLocationCacheAdapter();
  await cacheAdapter.initializeAsync();

  ref.read(initializedCacheProvider.notifier).state = cacheAdapter;
  return cacheAdapter;
});

// Provider pour le cache de localisation
final locationCacheProvider = Provider<LocationCachePort>((ref) {
  final initializedCache = ref.watch(initializedCacheProvider);
  if (initializedCache != null && initializedCache.isInitialized) {
    return initializedCache;
  }

  final adapter = HiveLocationCacheAdapter();
  adapter.initialize();
  return adapter;
});

// Provider pour l'adaptateur Google Maps existant
final googleMapsAdapterProvider = Provider<GoogleMapsAdapter>((ref) {
  final locationService = ref.watch(locationServiceProvider);
  final httpClient = ref.watch(httpClientProvider);
  return GoogleMapsAdapter(locationService, httpClient: httpClient);
});

// Provider pour le service de localisation avancé
final enhancedLocationServiceProvider = Provider<EnhancedLocationService>((ref) {
  final mapsAdapter = ref.watch(googleMapsAdapterProvider);
  final locationCache = ref.watch(locationCacheProvider);
  final cityCache = ref.watch(cityCacheProvider);

  return EnhancedLocationService(
    mapsAdapter: mapsAdapter,
    locationCache: locationCache,
    cityCache: cityCache,
  );
});

// Provider pour l'adaptateur des villes suggérées
final suggestedCitiesAdapterProvider = Provider<SuggestedCitiesPort>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return SupabaseSuggestedCitiesAdapter(supabase);
});

// Provider pour le port des villes suggérées
final suggestedCitiesPortProvider = Provider<SuggestedCitiesPort>((ref) {
  return ref.watch(suggestedCitiesAdapterProvider);
});

// Provider pour récupérer une ville par son ID
final cityByIdProvider = FutureProvider.family<City?, String>((ref, cityId) async {
  try {
    // Utiliser directement l'adaptateur de recherche
    final cityAdapter = ref.read(citySearchProvider);
    return await cityAdapter.getCityById(cityId);
  } catch (e) {
    print('❌ Erreur lors de la récupération de la ville par ID: $e');
    return null;
  }
});

// Provider pour les villes suggérées (utilise directement le port)
final suggestedCitiesProvider = FutureProvider<List<City>>((ref) async {
  final suggestedCitiesPort = ref.watch(suggestedCitiesPortProvider);

  // Utiliser la nouvelle méthode, pas d'IDs codés en dur
  return suggestedCitiesPort.getSuggestedCities(
      type: SuggestedCityType.aquitaine,
      limit: SuggestedCitiesConfig.defaultSuggestionCount
  );
});