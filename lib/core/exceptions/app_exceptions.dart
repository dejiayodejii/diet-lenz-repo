abstract class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic error;

  AppException({
    required this.message,
    this.code,
    this.error,
  });

  @override
  String toString() => message;
}

// Network related exceptions
class NetworkException extends AppException {
  NetworkException({
    required String message,
    String? code,
    dynamic error,
  }) : super(message: message, code: code, error: error);
}

class UnauthorizedException extends NetworkException {
  UnauthorizedException({
    String message = 'Unauthorized access',
    String? code,
    dynamic error,
  }) : super(message: message, code: code, error: error);
}

class ServerException extends NetworkException {
  ServerException({
    String message = 'Server error occurred',
    String? code,
    dynamic error,
  }) : super(message: message, code: code, error: error);
}

// Data related exceptions
class DataException extends AppException {
  DataException({
    required String message,
    String? code,
    dynamic error,
  }) : super(message: message, code: code, error: error);
}

class CacheException extends DataException {
  CacheException({
    String message = 'Cache error occurred',
    String? code,
    dynamic error,
  }) : super(message: message, code: code, error: error);
}
