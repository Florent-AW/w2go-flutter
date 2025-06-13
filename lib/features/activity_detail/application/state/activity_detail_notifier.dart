// lib/features/activity_detail/application/state/activity_detail_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/usecases/get_activity_details_use_case.dart';
import '../../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';
import '../../../../core/domain/models/shared/activity_details_model.dart';
import '../../../../features/search/application/state/city_selection_state.dart';
import '../../../../core/domain/ports/providers/search/distance_providers.dart';
import 'activity_detail_state.dart';

// Dans la classe ActivityDetailNotifier, modifier la méthode loadActivityDetails
class ActivityDetailNotifier extends StateNotifier<ActivityDetailState> {
  final GetActivityDetailsUseCase _getActivityDetailsUseCase;
  final Ref _ref; // ✅ Ajouter référence vers Riverpod

  /// Constructeur qui injecte le use case et la référence Riverpod
  ActivityDetailNotifier(this._getActivityDetailsUseCase, this._ref)
      : super(const ActivityDetailState.initial());

  /// Charge les détails d'une activité par son ID
  Future<void> loadActivityDetails(String activityId) async {
    try {
      // Passer à l'état de chargement
      state = const ActivityDetailState.loading();
      print('📊 NOTIFIER: Loading started for activity $activityId');

      // Récupérer les détails via le use case
      final details = await _getActivityDetailsUseCase.execute(activityId);

      // ✅ NOUVEAU : Calculer et alimenter l'ancien cache de distances
      await _calculateAndCacheDistance(details);

      // Si les détails sont bien récupérés, passer à l'état chargé
      state = ActivityDetailState.loaded(details);
      print('📊 NOTIFIER: Successfully loaded details for activity $activityId');
      print('📊 NOTIFIER: Images count: ${details.images?.length ?? 0}');
    } catch (e, stackTrace) {
      debugPrint('Erreur dans le notifier: $e');
      debugPrint('Stack trace: $stackTrace');

      // En cas d'erreur, passer à l'état d'erreur avec le message
      state = ActivityDetailState.error(e.toString());
      print('📊 NOTIFIER: Error loading activity $activityId: $e');
    }
  }

  /// ✅ NOUVEAU : Alimente directement le cache de l'ancien système
  Future<void> _calculateAndCacheDistance(ActivityDetails details) async {
    try {
      // Récupérer la ville sélectionnée
      final selectedCity = _ref.read(selectedCityProvider);

      if (selectedCity == null) {
        return;
      }

      // ✅ SOLUTION DIRECTE : Calculer et alimenter le cache manuellement
      final distanceService = _ref.read(activityDistanceProvider);
      final oldCacheNotifier = _ref.read(activityDistancesProvider.notifier);

      // Calculer la distance avec le service existant
      final userLocation = LatLng(selectedCity.lat, selectedCity.lon);
      final activityLocation = LatLng(details.latitude, details.longitude);

      final distance = distanceService.calculateDistance(
        activityId: details.id,
        userLocation: userLocation,
        activityLocation: activityLocation,
      );

      // ✅ Alimenter directement le state du notifier (pas via cacheDistances)
      final currentState = oldCacheNotifier.state;
      final newState = <String, double>{...currentState, details.id: distance};
      oldCacheNotifier.state = newState;
    } catch (e) {
    }
  }
}
