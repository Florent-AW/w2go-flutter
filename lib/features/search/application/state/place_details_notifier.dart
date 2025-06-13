// lib/features/search/application/state/place_details_notifier.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:async/async.dart';
import '../../../../core/domain/models/location/place_details.dart';
import '../../../../core/domain/services/location/enhanced_location_service.dart';
import '../../../../core/domain/ports/providers/location/location_providers.dart';
import 'place_details_state.dart';

class PlaceDetailsNotifier extends StateNotifier<PlaceDetailsState> {
  final EnhancedLocationService _locationService;

  PlaceDetailsNotifier(this._locationService)
      : super(const PlaceDetailsState.initial());

  Future<void> getLocationDetails(String placeId) async {
    state = const PlaceDetailsState.loading();

    final result = await _locationService.getPlaceDetails(placeId);

    if (result.isError) {
      state = PlaceDetailsState.error(
          result.asError!.error.toString()
      );
      return;
    }

    state = PlaceDetailsState.loaded(result.asValue!.value);
  }

  Future<void> getCurrentLocation() async {
    state = const PlaceDetailsState.loading();

    final locationResult = await _locationService.getCurrentLocation();

    if (locationResult.isError) {
      state = PlaceDetailsState.error(
          locationResult.asError!.error.toString()
      );
      return;
    }

    // Pour la géolocalisation directe, on crée un PlaceDetails simplifié
    // avec les coordonnées obtenues
    final userLocation = locationResult.asValue!.value;
    final placeDetails = PlaceDetails(
      placeId: 'current_location',
      formattedAddress: 'Position actuelle',
      name: 'Ma position',
      location: userLocation,
      lastUpdated: DateTime.now(),
    );

    state = PlaceDetailsState.loaded(placeDetails);
  }

  void reset() {
    state = const PlaceDetailsState.initial();
  }
}

// Provider pour le notifier
final placeDetailsNotifierProvider = StateNotifierProvider<PlaceDetailsNotifier, PlaceDetailsState>((ref) {
  final locationService = ref.watch(enhancedLocationServiceProvider);
  return PlaceDetailsNotifier(locationService);
});