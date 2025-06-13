// lib/core/common/exceptions/geometry_calculation_exception.dart
class GeometryCalculationException implements Exception {
  final String message;

  GeometryCalculationException(this.message);

  @override
  String toString() => 'GeometryCalculationException: $message';
}