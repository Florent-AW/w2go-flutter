// lib/core/domain/models/empty_trips/value_objects/generation_result.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import '../empty_daily_trip.dart';

part 'generation_result.freezed.dart';

@freezed
class EmptyTripGenerationResult with _$EmptyTripGenerationResult {
  const factory EmptyTripGenerationResult({
    required List<EmptyDailyTrip> halfDayTrips,
    required List<EmptyDailyTrip> fullDayTrips,
    required String departureGeohash5,
    required List<String> errors,
  }) = _EmptyTripGenerationResult;
}