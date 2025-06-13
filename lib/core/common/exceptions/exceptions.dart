// core/common/exceptions/exceptions.dart

class DomainException implements Exception {
  final String message;
  DomainException(this.message);

  @override
  String toString() => message;
}

class DataException implements Exception {
  final String message;
  DataException(this.message);
}

class ProcessingException implements Exception {
  final String message;
  ProcessingException(this.message);
}