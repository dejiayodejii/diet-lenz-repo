import 'dart:async';
import 'dart:io';
import 'package:diet_lenz/core/utils/functions.dart';
import 'package:dio/dio.dart';

class ApiError {
  final String errorCode;
  final String errorMessage;
  ApiError({
    required this.errorCode,
    required this.errorMessage,
  });

  factory ApiError.fromDioError(Object error) {
    String errorMessage = '';
    String errorCode = '';
    if (error is DioException) {
      var dioError = error;
      switch (dioError.type) {
        case DioExceptionType.cancel:
          errorMessage = 'Request was cancelled';
          errorCode = 'REQUEST_CANCELLED';
          break;
        case DioExceptionType.connectionError:
          errorMessage =
              'No Internet connection. Check your connection and try again.';
          errorCode = 'CONNECTION_ERROR';
          break;
        case DioExceptionType.connectionTimeout:
          errorMessage =
              'No Internet connection. Check your connection and try again.';
          errorCode = 'CONNECTION_TIMEOUT';
          break;
        case DioExceptionType.unknown:
          errorMessage = 'An error occured. Try again.';
          errorCode = 'NETWORK_ERROR';
          break;
        case DioExceptionType.receiveTimeout:
          errorMessage = 'An error occured. Check your connection Try again.';
          errorCode = 'RECEIVE_TIMEOUT';
          break;
        case DioExceptionType.sendTimeout:
          errorMessage = 'Connection timeout';
          errorCode = 'SEND_TIMEOUT';
          break;
        case DioExceptionType.badResponse:
          if (dioError.response != null) {
            appPrint(dioError.response!.data);
            errorMessage = dioError.response!.data['message'] is List
                ? (dioError.response!.data['message'] as List).first.toString()
                : dioError.response!.data['message'];
            errorCode = 'Error';
          } else {
            errorCode = 'Error';
            errorMessage = 'An error occurred, but no response was received.';
          }
          break;

        default:
          errorMessage = 'An error occured';
          errorCode = 'Error';
          break;
      }
    } else {
      errorMessage = _handleException(error);
    }
    appPrint('errorCode: $errorCode, errorMessage: $errorMessage');
    return ApiError(errorCode: errorCode, errorMessage: errorMessage);
  }

  factory ApiError.fromHttp(Object error) {
    String errorMessage = '';
    String errorCode = '';
    if (error is String) {
      errorCode = "Error";
      errorMessage = error;
    }
    if (error is SocketException) {
      errorCode = "Error";
      errorMessage =
          "No Internet connection. Check your connection and try again.";
    }
    if (error is HttpException || error is TimeoutException) {
      errorCode = "Error";
      errorMessage = "An error occurred. Check your connection Try again.";
    } else {
      errorCode = "Error";
      errorMessage = "An error occurred. Please try again";
    }
    appPrint('errorCode: $errorCode, errorMessage: $errorMessage');
    return ApiError(errorCode: errorCode, errorMessage: errorMessage);
  }

  static String _handleException(dynamic exception) {
    if (exception is String) {
      return exception;
    } else {
      return 'An unexpected error occurred, please try again';
    }
  }
}

class ApiException implements Exception {
  final String message;
  final String? url;
  final dynamic body;
  final int? status;
  final dynamic response;
  ApiException(
      {required this.message, this.body, this.status, this.response, this.url});

  @override
  String toString() => '$message';
}
