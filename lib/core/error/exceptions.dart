/// Infrastructure-level exceptions thrown by data sources.
/// These are caught at the repository boundary and mapped to [Failure]s.
sealed class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => '$runtimeType: $message';
}

/// No network connectivity.
final class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.']);
}

/// HTTP error response from the server.
final class ServerException extends AppException {
  final int statusCode;
  const ServerException(super.message, {required this.statusCode});
}

/// Request timed out.
final class TimeoutException extends AppException {
  const TimeoutException([super.message = 'Request timed out.']);
}

/// 401 Unauthorized response.
final class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Unauthorized.']);
}

/// Data parsing / deserialization error.
final class ParseException extends AppException {
  const ParseException([super.message = 'Failed to parse server response.']);
}

/// Secure / local storage error.
final class StorageException extends AppException {
  const StorageException([super.message = 'Local storage error.']);
}
