// lib/core/domain/ports/location/geolocation_port.dart

import 'package:async/async.dart';
import '../../../domain/models/location/user_location.dart';

abstract class GeolocationPort {
  /// Récupère la position actuelle de l'utilisateur
  Future<Result<UserLocation>> getCurrentLocation();

  /// Vérifie si les services de localisation sont activés
  Future<bool> isLocationServiceEnabled();

  /// Demande la permission d'accéder à la localisation
  Future<bool> requestLocationPermission();
}