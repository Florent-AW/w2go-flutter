// lib/core/common/exceptions/empty_trip_generation_exception.dart

class EmptyTripGenerationException implements Exception {
  final String message;

  EmptyTripGenerationException(this.message);

  @override
  String toString() => 'EmptyTripGenerationException: $message';
}