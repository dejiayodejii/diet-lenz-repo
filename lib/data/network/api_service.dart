import 'dart:io';
import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/repositories/storage_repository.dart';
import 'package:diet_lenz/data/network/api_endpoints.dart';
import 'package:diet_lenz/data/network/api_error_handler.dart';
import 'package:diet_lenz/data/network/app_exception.dart';
import 'package:diet_lenz/data/network/logging_interceptor.dart';
import 'package:diet_lenz/data/network/retry_interceptor.dart';
import 'package:dio_smart_retry/dio_smart_retry.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

final networkProvider = Provider<NetworkProvider>(
  (ref) => NetworkProviderImp(
    ref.watch(storageRepositoryProvider),
  ),
);

abstract class NetworkProvider {
  Future<dynamic> call({
    required String path,
    bool? addToken,
    String? cfrtoken,
    String? cookie,
    // String token,
    required RequestMethod method,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> queryParams = const {},
  });
  Future<dynamic> upload(
      {required String path,
      bool? addToken,
      required RequestMethod method,
      Map<String, dynamic> body = const {},
      Map<String, dynamic> files = const {}});
}

class NetworkProviderImp extends NetworkProvider {
  final String baseUrl =
      AppEndpoint.isLive ? AppEndpoint.baseUrl : AppEndpoint.stageUrl;
  static Dio? _dio;
  final StorageRepository _storageRepository;

  NetworkProviderImp(this._storageRepository);

  // Singleton Dio instance
  Dio get dio => _dio ??= _createDioInstance();

  Dio _createDioInstance() {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 1000),
        receiveTimeout: const Duration(seconds: 1000),
        headers: {
          'accept': 'application/json',
          'content-type': 'application/json',
        },
      ),
    );

    // Add interceptors
    dio.interceptors.addAll([
      LoggingInterceptor(),
      PrettyDioLogger(
        requestHeader: false,
        requestBody: true,
        responseBody: false,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
      RetryInterceptor(
        dio: dio,
        logPrint: print,
        retries: 0,
        retryDelays: const [
          Duration(seconds: 1),
          Duration(seconds: 2),
          Duration(seconds: 3),
        ],
      ),
      CurlLoggerDioInterceptor(printOnSuccess: false),
      TokenInterceptor(dio, _storageRepository),
    ]);

    return dio;
  }

  @override
  Future<dynamic> call({
    required String path,
    bool? addToken,
    String? cfrtoken,
    String? cookie,
    // String token,
    required RequestMethod method,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> queryParams = const {},
  }) async {
    try {
      final token = _storageRepository.getToken();

      // final options = Options(
      //   headers: addToken ?? true ? {'Authorization': 'Bearer $token'} : null,
      // );

      //
      final options = cfrtoken != null
          ? Options(headers: {
              'X-CSRFToken': cfrtoken,
              "Cookie": "csrftoken=$cookie",
              "Referer": "https://api.backend.vepayhq.com"
            })
          : Options(
              headers:
                  addToken ?? true ? {'Authorization': 'Bearer $token'} : null,
            );

      print("option is ${options.headers}");

      final Response response = await _makeRequest(
        method: method,
        path: path,
        data: body,
        queryParameters: queryParams,
        options: options,
      );

      return _handleResponse(response);
    } catch (e) {
      if(e is DioException){

      }
      
      return ApiErrorHandler.handleError(e);
    }
  }

  Future<Response> _makeRequest({
    required RequestMethod method,
    required String path,
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    switch (method) {
      case RequestMethod.get:
        return await dio.get(path,
            queryParameters: queryParameters, options: options);
      case RequestMethod.post:
        return await dio.post(path,
            data: data, queryParameters: queryParameters, options: options);
      case RequestMethod.put:
        return await dio.put(path,
            data: data, queryParameters: queryParameters, options: options);
      case RequestMethod.patch:
        return await dio.patch(path,
            data: data, queryParameters: queryParameters, options: options);
      case RequestMethod.delete:
        return await dio.delete(path,
            data: data, queryParameters: queryParameters, options: options);
    }
  }

  dynamic _handleResponse(Response response) {

    if (response.data == null) {

      return ApiError(
        errorCode: 'null_response',
        errorMessage: 'No data received from server',
      );
    }


    if (ApiErrorHandler.isSuccessful(response.statusCode)) {

      return response.data;
    }


    return ApiError(
      errorCode: 'server_error',
      errorMessage: response.data['message'] ?? 'Server error, try again later',
    );
  }

  @override
  Future<dynamic> upload({
    required String path,
    bool? addToken,
    required RequestMethod method,
    Map<String, dynamic> body = const {},
    Map<String, dynamic> files = const {},
  }) async {
    try {
      final token = _storageRepository.getToken();

      final formData = await _createFormData(body, files);

      final options = Options(
        headers: addToken ?? true ? {'Authorization': 'Bearer $token'} : null,
      );

      final response = await _makeRequest(
        method: method,
        path: path,
        data: formData,
        options: options,
      );

      return _handleResponse(response);
    } catch (e) {
      return ApiErrorHandler.handleError(e);
    }
  }

  Future<FormData> _createFormData(
    Map<String, dynamic> body,
    Map<String, dynamic> files,
  ) async {
    final Map<String, dynamic> formMap = {...body};

    for (final entry in files.entries) {
      if (entry.value is File) {
        formMap[entry.key] = await _createMultipartFile(entry.value as File);
      } else if (entry.value is List<File>) {
        formMap[entry.key] = await Future.wait(
          (entry.value as List<File>).map((file) => _createMultipartFile(file)),
        );
      }
    }

    return FormData.fromMap(formMap);
  }

  Future<MultipartFile> _createMultipartFile(File file) async {
    return MultipartFile.fromFile(
      file.path,
      filename: basename(file.path),
    );
  }
}

enum RequestMethod { get, post, put, patch, delete }
