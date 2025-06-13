// lib/core/common/exceptions/location_exceptions.dart

/// Exception de base pour tous les problèmes liés à la localisation
class LocationException implements Exception {
  final String message;

  LocationException(this.message);

  @override
  String toString() => 'LocationException: $message';
}

/// Exception spécifique pour les problèmes de permission de localisation
class LocationPermissionException extends LocationException {
  LocationPermissionException(String message) : super(message);
}

/// Exception spécifique pour les problèmes de services de localisation désactivés
class LocationServicesDisabledException extends LocationException {
  LocationServicesDisabledException(String message) : super(message);
}

/// Exception spécifique pour les problèmes d'API Google Places
class PlacesApiException extends LocationException {
  final String? errorCode;

  PlacesApiException(String message, {this.errorCode}) : super(message);

  @override
  String toString() => 'PlacesApiException: $message (code: $errorCode)';
}

/// Exception spécifique pour les problèmes de cache de localisation
class LocationCacheException extends LocationException {
  LocationCacheException(String message) : super(message);
}