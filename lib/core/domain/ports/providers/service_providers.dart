// core/domain/ports/providers/service_providers.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../adapters/google_maps/maps_adapter.dart';
import '../../../adapters/google_maps/geocoding_adapter.dart';
import '../maps_port.dart';
import '../geocoding_port.dart';
import 'infrastructure_providers.dart';
import '../../services/location_service.dart';


// Service de base pour les opérations de localisation
final locationServiceProvider = Provider<LocationService>((ref) {
  return LocationService(ref.watch(supabaseProvider));
});

// Service Google Maps qui dépend du LocationService
final mapsServiceProvider = Provider<MapsPort>((ref) {
  return GoogleMapsAdapter(ref.watch(locationServiceProvider));
});

// Service Geocoding qui dépend des deux précédents
final geocodingServiceProvider = Provider<GeocodingPort>((ref) {
  return GeocodingAdapter(
      ref.watch(locationServiceProvider),
      ref.watch(mapsServiceProvider)
  );
});