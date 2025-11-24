// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/core/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

/// HTTP client wrapper that logs all API requests and responses
class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;
  final bool enableLogging;

  LoggingHttpClient(this._inner, {this.enableLogging = true});

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (enableLogging) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔵 API Request: ${request.method} ${request.url}');
      // print('Headers: ${request.headers}');
      if (request is http.Request && request.body.isNotEmpty) {
        log('''Body: 
        ${request.body}
        ''');
      }
    }

    final startTime = DateTime.now();

    try {
      final response = await _inner.send(request);
      final duration = DateTime.now().difference(startTime);

      if (enableLogging) {
        // Read response body for logging (must convert stream to bytes then back to stream)
        final responseBytes = await response.stream.toBytes();
        final responseBody = String.fromCharCodes(responseBytes);

        log('''✅ Response: ${response.statusCode} in ${duration.inMilliseconds}ms''');
        if (responseBody.isNotEmpty) {
          log('''Response Body:
$responseBody''');
        }
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');

        // Return a new response with the bytes we read
        return http.StreamedResponse(
          http.ByteStream.fromBytes(responseBytes),
          response.statusCode,
          contentLength: responseBytes.length,
          request: response.request,
          headers: response.headers,
          isRedirect: response.isRedirect,
          persistentConnection: response.persistentConnection,
          reasonPhrase: response.reasonPhrase,
        );
      }

      return response;
    } catch (e) {
      final duration = DateTime.now().difference(startTime);

      if (enableLogging) {
        print('❌ Error after ${duration.inMilliseconds}ms: $e');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      }

      rethrow;
    }
  }
}

/// Centralized API service that manages the API client and authentication
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // API client instance
  late final ApiClient _apiClient;

  // Storage repository for token persistence
  late final StorageRepository _storageRepository;

  // API Controllers - initialize once and reuse
  late final AuthControllerApi authApi;
  late final UserControllerApi userApi;
  late final FoodLoggingControllerApi foodLoggingApi;
  late final RecipeControllersApi recipeApi;

  /// Initialize the API service with base URL, storage repository, and optional logging
  void initialize({
    required StorageRepository storageRepository,
    String baseUrl = 'https://diet-lenz-api.onrender.com',
    bool enableLogging = true,
  }) {
    _storageRepository = storageRepository;
    _apiClient = ApiClient(basePath: baseUrl);

    // Add logging HTTP client wrapper
    _apiClient.client = LoggingHttpClient(
      http.Client(),
      enableLogging: enableLogging,
    );

    // Initialize all API controllers
    authApi = AuthControllerApi(_apiClient);
    userApi = UserControllerApi(_apiClient);
    foodLoggingApi = FoodLoggingControllerApi(_apiClient);
    recipeApi = RecipeControllersApi(_apiClient);
  }

  /// Set the authentication token for authenticated requests
  Future<void> setAuthToken(String token) async {
    await _storageRepository.saveToken(token);
    _apiClient.addDefaultHeader('Authorization', 'Bearer $token');
  }

  /// Get stored auth token
  String? getAuthToken() {
    return _storageRepository.getToken();
  }

  /// Clear auth token (for logout)
  Future<void> clearAuthToken() async {
    await _storageRepository.saveToken('');
    await _storageRepository.saveRefreshToken('');
    // Clear the authorization header by setting it to empty
    _apiClient.addDefaultHeader('Authorization', '');
  }

  /// Store refresh token
  Future<void> setRefreshToken(String token) async {
    await _storageRepository.saveRefreshToken(token);
  }

  /// Get refresh token
  String? getRefreshToken() {
    return _storageRepository.getRefreshToken();
  }

  /// Restore authentication state on app start
  void restoreAuthentication() {
    final token = getAuthToken();
    if (token != null && token.isNotEmpty) {
      _apiClient.addDefaultHeader('Authorization', 'Bearer $token');
    }
  }
}

// OLD COMMENTED CODE BELOW (keep for reference)
// class ApiService {
//   final String baseUrl;
//   final Map<String, String> defaultHeaders;

//   ApiService({
//     required this.baseUrl,
//     this.defaultHeaders = const {
//       'Content-Type': 'application/json',
//     },
//   });

//   Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
//     final response = await http.get(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: {...defaultHeaders, ...?headers},
//     );
//     return _handleResponse(response);
//   }

//   Future<dynamic> post(
//     String endpoint, {
//     Map<String, String>? headers,
//     dynamic body,
//   }) async {
//     final response = await http.post(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: {...defaultHeaders, ...?headers},
//       body: jsonEncode(body),
//     );
//     return _handleResponse(response);
//   }

//   Future<dynamic> put(
//     String endpoint, {
//     Map<String, String>? headers,
//     dynamic body,
//   }) async {
//     final response = await http.put(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: {...defaultHeaders, ...?headers},
//       body: jsonEncode(body),
//     );
//     return _handleResponse(response);
//   }

//   Future<dynamic> delete(String endpoint,
//       {Map<String, String>? headers}) async {
//     final response = await http.delete(
//       Uri.parse('$baseUrl$endpoint'),
//       headers: {...defaultHeaders, ...?headers},
//     );
//     return _handleResponse(response);
//   }

//   dynamic _handleResponse(http.Response response) {
//     if (response.statusCode >= 200 && response.statusCode < 300) {
//       return jsonDecode(response.body);
//     } else {
//       throw HttpException(
//         response.body,
//         uri: response.request?.url,
//         statusCode: response.statusCode,
//       );
//     }
//   }
// }
