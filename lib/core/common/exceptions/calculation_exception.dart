// lib/core/common/exceptions/calculation_exception.dart

class CalculationException implements Exception {
  final String message;
  CalculationException(this.message);

  @override
  String toString() => 'CalculationException: $message';
}