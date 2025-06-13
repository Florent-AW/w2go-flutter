// lib/core/common/exceptions/trip_exceptions.dart

/// Exception de base pour les erreurs liées aux voyages
abstract class TripException implements Exception {
  final String message;
  TripException(this.message);
}

/// Exception levée quand la ville de départ est invalide
class InvalidDepartureCityException extends TripException {
  InvalidDepartureCityException(String message) : super(message);
}

/// Exception levée quand les dates du voyage sont invalides
class InvalidTripDatesException extends TripException {
  InvalidTripDatesException(String message) : super(message);
}

/// Exception levée quand la création du voyage échoue
class TripCreationException extends TripException {
  TripCreationException(String message) : super(message);
}

/// Exception levée quand la récupération du voyage échoue
class TripNotFoundException extends TripException {
  TripNotFoundException(String message) : super(message);
}

/// Exception levée quand le groupe de voyage est invalide
class InvalidTravelGroupException extends TripException {
  InvalidTravelGroupException(String message) : super(message);
}