// core/domain/ports/trip_port.dart

import '../models/trip_designer/trip/trip_model.dart';
import '../models/shared/city_model.dart';
import '../use_cases/create_trip_use_case.dart'; // Pour CreateTripParams

/// Port définissant les opérations de gestion des voyages
abstract class TripPort {
  /// Crée un nouveau voyage
  Future<Trip> createTrip(CreateTripParams params, City departureCity);

  /// Récupère un voyage par son ID
  Future<Trip> getTrip(String tripId);

  /// Récupère tous les voyages d'un utilisateur
  Future<List<Trip>> getTripsForUser(String userId);
}