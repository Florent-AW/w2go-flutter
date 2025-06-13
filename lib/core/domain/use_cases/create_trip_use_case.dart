// core/domain/use_cases/create_trip_use_case.dart

import '../ports/trip_port.dart';
import '../ports/geocoding_port.dart';
import '../models/trip_designer/trip/trip_model.dart';
import '../../common/enums/trip_enums.dart';
import '../../common/exceptions/trip_exception.dart';

/// Use case pour créer un nouveau voyage
/// Coordonne la création d'un voyage en validant la ville de départ
class CreateTripUseCase {
  final TripPort _tripPort;
  final GeocodingPort _geocodingPort;

  CreateTripUseCase(this._tripPort, this._geocodingPort);

  Future<Trip> execute(CreateTripParams params) async {
    try {
      print('CreateTripUseCase - Début de l\'exécution');
      print('Recherche de la ville: ${params.departureCityName}');

      final city = await _geocodingPort.getCity(params.departureCityName);
      print('Ville trouvée: ${city.cityName}');

      print('Création du voyage...');
      final trip = await _tripPort.createTrip(params, city);
      print('Voyage créé avec succès');

      return trip;
    } catch (e, stackTrace) {
      print('Erreur dans CreateTripUseCase: $e');
      print('Stack trace: $stackTrace');
      throw TripCreationException('Erreur lors de la création du voyage: $e');
    }
  }
}

/// Paramètres requis pour la création d'un voyage
class CreateTripParams {
  final String userId;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final String departureCityName;
  final TravelGroup travelGroup;
  final ActivityHours activityHours;
  final double dailyBudget;
  final TravelStyle travelStyle;
  final PreferredMoment preferredMoment;
  final String transportMode;

  CreateTripParams({
    required this.userId,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.departureCityName,
    required this.travelGroup,
    required this.activityHours,
    required this.dailyBudget,
    required this.travelStyle,
    required this.preferredMoment,
    required this.transportMode,
  });
}