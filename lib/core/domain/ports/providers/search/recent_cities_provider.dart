// lib/core/domain/ports/providers/search/recent_cities_provider.dart

import 'package:riverpod/riverpod.dart';
import '../../../models/search/recent_city.dart';
import '../../../models/shared/city_model.dart';
import '../../../services/search/recent_cities_service.dart';
import '../../search/recent_cities_port.dart';

/// Provider pour l'accès au port des recherches récentes
final recentCitiesPortProvider = Provider<RecentCitiesPort>((ref) {
  throw UnimplementedError('recentCitiesPortProvider doit être surchargé');
});

/// Provider pour le service de gestion des recherches récentes
final recentCitiesServiceProvider = Provider<RecentCitiesService>((ref) {
  final port = ref.watch(recentCitiesPortProvider);
  return RecentCitiesService(port);
});

/// Provider pour la liste des recherches récentes
final recentCitiesProvider = FutureProvider<List<RecentCity>>((ref) async {
  final service = ref.watch(recentCitiesServiceProvider);
  return service.getRecentCities();
});

/// Notifier pour gérer les opérations sur les recherches récentes
class RecentCitiesNotifier extends StateNotifier<AsyncValue<List<RecentCity>>> {
  final RecentCitiesService _service;

  RecentCitiesNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadRecentCities();
  }

  Future<void> _loadRecentCities() async {
    try {
      final cities = await _service.getRecentCities();
      state = AsyncValue.data(cities);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> addCity(City city) async {
    await _service.addCityToRecent(city);
    _loadRecentCities(); // Recharger la liste
  }

  Future<void> clearHistory() async {
    await _service.clearHistory();
    state = const AsyncValue.data([]);
  }
}

/// Provider pour le notifier des recherches récentes
final recentCitiesNotifierProvider = StateNotifierProvider<RecentCitiesNotifier, AsyncValue<List<RecentCity>>>((ref) {
  final service = ref.watch(recentCitiesServiceProvider);
  return RecentCitiesNotifier(service);
});