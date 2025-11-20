import 'package:diet_lenz/data/network/app_exception.dart';
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static dynamic handleError(dynamic error) {
    if (error is DioException) {
      return ApiError.fromDioError(error);
    }
    return ApiError(
      errorCode: 'unknown_error',
      errorMessage: 'An unexpected error occurred',
    );
  }

  static bool isSuccessful(int? statusCode) {
    return statusCode != null && (statusCode >= 200 && statusCode < 300);
  }
}
