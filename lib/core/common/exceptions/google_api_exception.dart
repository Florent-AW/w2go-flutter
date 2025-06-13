// lib/core/common/exceptions/google_api_exception.dart

class GoogleAPIException implements Exception {
  final String message;

  GoogleAPIException(this.message);

  @override
  String toString() => 'GoogleAPIException: $message';
}