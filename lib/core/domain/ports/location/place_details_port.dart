// lib/core/domain/ports/location/place_details_port.dart
import 'package:async/async.dart';
import '../../../domain/models/location/place_details.dart';

abstract class PlaceDetailsPort {
  /// Récupère les détails d'un lieu à partir de son ID
  Future<Result<PlaceDetails>> getPlaceDetailsById(String placeId);
}