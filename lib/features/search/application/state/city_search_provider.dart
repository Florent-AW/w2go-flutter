// lib/features/search/application/state/city_search_provider.dart
import 'package:riverpod/riverpod.dart';
import '../../../../core/domain/models/shared/city_model.dart';
import '../../../../core/domain/ports/search/city_search_port.dart';
import '../../../../core/domain/ports/providers/location/location_providers.dart';

// Utiliser directement le citySearchProvider du fichier location_providers.dart
// Cette ligne doit être supprimée car elle crée un conflit de définition
// final citySearchProvider = Provider<CitySearchPort>((ref) {
//   return ref.watch(citySearchAdapterProvider);
// });

// Simplement réexporter le provider défini dans location_providers
export '../../../../core/domain/ports/providers/location/location_providers.dart' show citySearchProvider;

final citiesSearchResultsProvider = FutureProvider.family<List<City>, String?>((ref, query) async {
  print('DEBUG: Searching cities with query: $query');
  try {
    final cityAdapter = ref.read(citySearchProvider);
    final results = await cityAdapter.searchCities(query);
    print('DEBUG: Found ${results.length} cities');
    return results;
  } catch (e) {
    print('DEBUG: Error in citiesSearchResultsProvider: $e');
    rethrow;
  }
});

// Utiliser l'adaptateur unifié
final cityByIdProvider = FutureProvider.family<City?, String>((ref, cityId) async {
  try {
    final cityAdapter = ref.read(citySearchProvider);
    return await cityAdapter.getCityById(cityId);
  } catch (e) {
    print('❌ Erreur lors de la récupération de la ville par ID: $e');
    return null;
  }
});