// lib/core/domain/ports/providers/search/suggested_cities_provider.dart

import 'package:riverpod/riverpod.dart';
import '../../../models/shared/city_model.dart';
import '../../search/suggested_cities_port.dart';



/// Provider pour l'accès au port des villes suggérées
final suggestedCitiesPortProvider = Provider<SuggestedCitiesPort>((ref) {
  throw UnimplementedError('suggestedCitiesPortProvider doit être surchargé');
});



/// Provider pour récupérer les villes populaires
final popularCitiesProvider = FutureProvider<List<City>>((ref) async {
  final port = ref.watch(suggestedCitiesPortProvider);
  return port.getPopularCities();
});