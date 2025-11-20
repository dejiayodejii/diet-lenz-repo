import 'dart:developer';

import 'package:diet_lenz/core/repositories/storage_repository.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/data/network/api_endpoints.dart';
import 'package:dio/dio.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';

class TokenInterceptor extends Interceptor {
  final Dio _dio;
  final StorageRepository _storageRepository;
  int consecutive401Count = 0;

  TokenInterceptor(this._dio, this._storageRepository);

  @override
  Future<void> onError(e, ErrorInterceptorHandler handler) async {
    if (e.response?.statusCode == 401) {
      if (consecutive401Count < 2) {
        final newAccessToken = await refreshToken();
        if (newAccessToken != null) {
          final request = e.requestOptions;
          request.headers['Authorization'] = 'Bearer $newAccessToken';
          final retryResponse = await _dio.request(
            request.path,
            data: request.data,
            queryParameters: request.queryParameters,
            options: Options(
              method: request.method,
              headers: request.headers,
              sendTimeout: request.sendTimeout,
              receiveTimeout: request.receiveTimeout,
            ),
          );
          return handler.resolve(retryResponse);
        } else {
          consecutive401Count++;
          return handler.next(e);
        }
      } else {
        consecutive401Count = 0;
        return handler.next(e);
      }
    } else if (e.response?.statusCode == 400) {
      return handler.next(e);
    } else {
      return handler.next(e);
    }
  }

  Future<String?> refreshToken() async {
    try {
      final token = _storageRepository.getRefreshToken();
      if (token?.trim().isNotEmpty ?? false) {
        log("---------------REFRESHING TOKEN-------------");
        const String baseUrl =
            AppEndpoint.isLive ? AppEndpoint.baseUrl : AppEndpoint.stageUrl;
        final refreshResponse = await _dio.post(
          baseUrl + AppEndpoint.refreshAccessToken,
          options: Options(contentType: 'application/json'),
          data: {'refresh_token': token},
        );

        if (refreshResponse.statusCode == 200 ||
            refreshResponse.statusCode == 201) {
          final newAccessToken = refreshResponse.data['data']['access'];
          await _storageRepository.saveToken(newAccessToken);
          return newAccessToken;
        } else {
          // NavigationService.push(child: const WelcomeBackScreen());
          ToastService().showError("Session expired, kindly login again.");
        }
      }
      return null;
    } catch (e) {
      //i need this tracked
      // NavigationService.push(child: const WelcomeBackScreen());
      ToastService().showError("Session expired, kindly login again.");
      return null;
    }
  }
}

//login
// user data
