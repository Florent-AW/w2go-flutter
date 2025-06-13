// core/domain/use_cases/process_activities_use_case.dart

import '../ports/activity_processing_port.dart';
import '../ports/trip_port.dart';
import '../../domain/models/trip_designer/processing/activity_processing_model.dart';
import '../models/trip_designer/trip/trip_model.dart';
import '../../common/exceptions/exceptions.dart';
import '../../common/exceptions/trip_exception.dart';


class ProcessActivitiesUseCase {
  final ActivityProcessingPort _processingPort;
  final TripPort _tripPort;

  ProcessActivitiesUseCase(this._processingPort, this._tripPort);

  Future<List<ActivityForProcessing>> execute(String tripId) async {
    try {
      print('🔄 Début du processing des activités pour le voyage: $tripId');

      // 1. Récupérer les détails du voyage
      try {
        final trip = await _tripPort.getTrip(tripId);
        print('✅ Voyage récupéré: ${trip.title}');

        // 2. Récupérer les activités brutes
        final activities = await _processingPort.getActivitiesForTrip(tripId);
        print('✅ ${activities.length} activités récupérées');

        // 3. Obtenir les activités filtrées
        return await _processingPort.getFilteredActivities(
          tripId: tripId,
          trip: trip,
          activities: activities,
        );
      } on TripNotFoundException catch (e) {
        print('❌ Voyage non trouvé: $tripId');
        throw TripNotFoundException('Le voyage spécifié n\'existe pas: $tripId');
      }
    } catch (e) {
      print('❌ Erreur pendant le processing: $e');
      throw DomainException('Erreur pendant le traitement des activités: $e');
    }
  }
}