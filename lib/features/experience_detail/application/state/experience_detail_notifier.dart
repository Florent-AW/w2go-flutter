// lib/features/experience_detail/application/state/experience_detail_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../domain/usecases/get_experience_details_use_case.dart';
import '../../../../core/domain/models/shared/experience_item.dart';
import '../../../../core/domain/models/shared/experience_details_model.dart';
import '../../../../core/domain/ports/providers/search/activity_distance_manager_providers.dart';
import '../../../../features/search/application/state/city_selection_state.dart';
import '../../../../core/domain/ports/providers/search/distance_providers.dart';
import 'experience_detail_state.dart';

class ExperienceDetailNotifier extends StateNotifier<ExperienceDetailState> {
  final GetExperienceDetailsUseCase _getExperienceDetailsUseCase;
  final Ref _ref;

  ExperienceDetailNotifier(this._getExperienceDetailsUseCase, this._ref)
      : super(const ExperienceDetailState.initial());

  /// Charge les détails d'une expérience
  Future<void> loadExperienceDetails(ExperienceItem item) async {
    try {
      state = const ExperienceDetailState.loading();
      print('📊 NOTIFIER: Loading started for experience ${item.id} (isEvent: ${item.isEvent})');

      final details = await _getExperienceDetailsUseCase.execute(item);

      // Cache de distance unifié
      await _calculateAndCacheDistance(details);

      state = ExperienceDetailState.loaded(details);
      print('📊 NOTIFIER: Successfully loaded details for experience ${item.id}');
      print('📊 NOTIFIER: Images count: ${details.imageUrls.length}');
    } catch (e, stackTrace) {
      debugPrint('Erreur dans le notifier: $e');
      debugPrint('Stack trace: $stackTrace');

      state = ExperienceDetailState.error(e.toString());
      print('📊 NOTIFIER: Error loading experience ${item.id}: $e');
    }
  }

  /// Cache de distance unifié Activities + Events
  Future<void> _calculateAndCacheDistance(ExperienceDetails details) async {
    try {
      final selectedCity = _ref.read(selectedCityProvider);
      if (selectedCity == null) return;

      final distanceService = _ref.read(activityDistanceProvider);
      final oldCacheNotifier = _ref.read(activityDistancesProvider.notifier);

      final userLocation = LatLng(selectedCity.lat, selectedCity.lon);
      final experienceLocation = LatLng(details.latitude, details.longitude);

      final distance = distanceService.calculateDistance(
        activityId: details.id,
        userLocation: userLocation,
        activityLocation: experienceLocation,
      );

      // Cache unifié Activities + Events
      final currentState = oldCacheNotifier.state;
      final newState = <String, double>{...currentState, details.id: distance};
      oldCacheNotifier.state = newState;
    } catch (e) {
      // Silent fail pour le cache
    }
  }
}