// core/common/exceptions/route_optimization_exceptions.dart

abstract class RouteOptimizationException implements Exception {
  final String message;
  RouteOptimizationException(this.message);
}

class RouteNotFoundException extends RouteOptimizationException {
  RouteNotFoundException(String message) : super(message);
}

class TravelTimeCalculationException extends RouteOptimizationException {
  TravelTimeCalculationException(String message) : super(message);
}

class DetourEvaluationException extends RouteOptimizationException {
  DetourEvaluationException(String message) : super(message);
}

class GoogleAPIException extends RouteOptimizationException {
  final int? statusCode;
  final String? errorCode;

  GoogleAPIException(String message, {this.statusCode, this.errorCode}) : super(message);
}

class OptimizationTimeoutException extends RouteOptimizationException {
  OptimizationTimeoutException(String message) : super(message);
}