// core/common/exceptions/scoring_exceptions.dart

abstract class ScoringException implements Exception {
  final String message;
  ScoringException(this.message);
}

class PreferencesNotFoundException extends ScoringException {
  PreferencesNotFoundException(String message) : super(message);
}

class ScoreCalculationException extends ScoringException {
  ScoreCalculationException(String message) : super(message);
}

class CacheOperationException extends ScoringException {
  CacheOperationException(String message) : super(message);
}