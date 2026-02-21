import 'dart:convert';

import 'package:diet_lenz/data/network/app_exception.dart';

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

extension ApiExceptionExtension on ApiException {
  String? get extractMessage {
    final message = this.message;

    // Try to parse JSON if the message is in JSON format
    if (message != null && message.contains('{')) {
      try {
        final jsonData = json.decode(message);
        return jsonData['message'] as String?;
      } catch (e) {
        // If parsing fails, return the raw message
        return message;
      }
    }
    return message;
  }
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



