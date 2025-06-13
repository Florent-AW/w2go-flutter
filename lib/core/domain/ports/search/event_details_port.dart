// lib/core/domain/ports/search/event_details_port.dart

import '../../models/event/details/event_details_model.dart';

/// Port pour récupérer les détails d'un événement
abstract class EventDetailsPort {
  /// Récupère les détails d'un événement par son ID
  Future<EventDetails> getEventDetails(String eventId);
}