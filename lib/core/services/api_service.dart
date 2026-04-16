// ignore_for_file: avoid_print

import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/core/repositories/storage_repository.dart';
import 'package:http/http.dart' as http;

/// HTTP client wrapper that logs all API requests and responses
/// and automatically handles 401 errors with token refresh
class LoggingHttpClient extends http.BaseClient {
  final http.Client _inner;
  final bool enableLogging;
  final ApiService _apiService;

  LoggingHttpClient(
    this._inner,
    this._apiService, {
    this.enableLogging = true,
  });

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (enableLogging) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🔵 API Request: ${request.method} ${request.url}');
      log('Headers: ${request.headers}');
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

      // Read response bytes
      final responseBytes = await response.stream.toBytes();
      final responseBody = String.fromCharCodes(responseBytes);

      if (enableLogging) {
        log('''✅ Response: ${response.statusCode} in ${duration.inMilliseconds}ms''');
        if (responseBody.isNotEmpty) {
          log('''Response Body:
$responseBody''');
        }
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      }

      // Check for 401 Unauthorized and handle token refresh
      // Only refresh if the response body indicates a token-related issue
      final isTokenExpired401 = response.statusCode == 401 &&
          // !request.url.path.contains('/auth/refresh') &&
          // !request.url.path.contains('/auth/login') &&
          // !request.url.path.contains('/auth/register') &&
          _isTokenRelatedError(responseBody);

      if (isTokenExpired401) {
        print(
            '🔐 Got 401 with token-related error - attempting token refresh...');

        final refreshed = await _apiService.refreshAccessToken();

        if (refreshed) {
          // Retry the original request with new token
          print('🔄 Retrying original request with new token...');

          // Clone the request with updated authorization header
          final newRequest = _cloneRequest(request);
          final newToken = _apiService.getAuthToken();
          if (newToken != null) {
            newRequest.headers['Authorization'] = 'Bearer $newToken';
          }

          return await send(newRequest);
        }
      }

      // Return response with bytes
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
    } catch (e) {
      final duration = DateTime.now().difference(startTime);

      if (enableLogging) {
        print('❌ Error after ${duration.inMilliseconds}ms: $e');
        print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n');
      }

      rethrow;
    }
  }

  /// Check if a 401 response body indicates a token-related error
  /// (e.g. expired, invalid, or missing token) vs other auth failures
  bool _isTokenRelatedError(String responseBody) {
    final lower = responseBody.toLowerCase();
    const tokenKeywords = [
      'token',
      'expired',
      'jwt',
      'invalid_token',
      'token_expired',
      'access denied',
      'unauthorized',
      'invalid signature',
      'malformed',
    ];
    return tokenKeywords.any((keyword) => lower.contains(keyword));
  }

  // Clone request for retry
  http.BaseRequest _cloneRequest(http.BaseRequest request) {
    http.BaseRequest newRequest;

    if (request is http.Request) {
      newRequest = http.Request(request.method, request.url)
        ..body = request.body
        ..encoding = request.encoding;
    } else if (request is http.MultipartRequest) {
      newRequest = http.MultipartRequest(request.method, request.url)
        ..fields.addAll(request.fields)
        ..files.addAll(request.files);
    } else if (request is http.StreamedRequest) {
      throw Exception('Cannot retry streamed requests');
    } else {
      throw Exception('Unknown request type');
    }

    newRequest
      ..persistentConnection = request.persistentConnection
      ..followRedirects = request.followRedirects
      ..maxRedirects = request.maxRedirects
      ..headers.addAll(request.headers);

    return newRequest;
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
  late final SubscriptionControllerApi subscriptionApi;

  // Track if we're currently refreshing to prevent multiple refresh attempts
  bool _isRefreshing = false;

  // Completer to let concurrent callers wait for the same refresh
  Completer<bool>? _refreshCompleter;

  // Callback for logout navigation
  Function()? onUnauthorized;

  /// Initialize the API service with base URL, storage repository, and optional logging
  void initialize({
    required StorageRepository storageRepository,
    String baseUrl = 'https://diet-lenz-stagingapi-d3mbl.ondigitalocean.app',
    bool enableLogging = true,
  }) {
    _storageRepository = storageRepository;
    _apiClient = ApiClient(basePath: baseUrl);

    // Add logging HTTP client wrapper with reference to this ApiService
    _apiClient.client = LoggingHttpClient(
      http.Client(),
      this, // Pass ApiService instance for token refresh
      enableLogging: enableLogging,
    );

    // Initialize all API controllers
    authApi = AuthControllerApi(_apiClient);
    userApi = UserControllerApi(_apiClient);
    foodLoggingApi = FoodLoggingControllerApi(_apiClient);
    recipeApi = RecipeControllersApi(_apiClient);
    subscriptionApi = SubscriptionControllerApi(_apiClient);
  }

  /// Set the authentication token for authenticated requests
  Future<void> setAuthToken(String token) async {
    await _storageRepository.saveToken(token);
    if (token.isEmpty) {
      _apiClient.defaultHeaderMap.remove('Authorization');
    } else {
      _apiClient.addDefaultHeader('Authorization', 'Bearer $token');
    }
  }

  /// Get stored auth token
  String? getAuthToken() {
    return _storageRepository.getToken();
  }

  /// Clear auth token (for logout)
  Future<void> clearAuthToken() async {
    await _storageRepository.saveToken('');
    await _storageRepository.saveRefreshToken('');
    await _storageRepository.clearAuthResponse();
    await _storageRepository.clearUserProfile();
    // Remove the authorization header entirely
    _apiClient.defaultHeaderMap.remove('Authorization');
  }

  /// Save auth response to local storage
  Future<void> saveAuthResponse(String authResponseJson) async {
    await _storageRepository.saveAuthResponse(authResponseJson);
  }

  /// Get saved auth response from local storage
  String? getSavedAuthResponse() {
    return _storageRepository.getAuthResponse();
  }

  /// Save user profile to local storage
  Future<void> saveUserProfile(String profileJson) async {
    await _storageRepository.saveUserProfile(profileJson);
  }

  /// Get saved user profile from local storage
  String? getSavedUserProfile() {
    return _storageRepository.getUserProfile();
  }

  /// Clear saved user profile
  Future<void> clearUserProfile() async {
    await _storageRepository.clearUserProfile();
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

  /// Attempt to refresh the access token using the refresh token
  Future<bool> refreshAccessToken() async {
    if (_isRefreshing) {
      // Already refreshing, wait for the ongoing refresh to complete
      return _refreshCompleter?.future ?? Future.value(false);
    }

    _isRefreshing = true;
    _refreshCompleter = Completer<bool>();

    try {
      final refreshToken = getRefreshToken();

      if (refreshToken == null || refreshToken.isEmpty) {
        print('❌ No refresh token available');
        await _handleTokenExpired();
        return false;
      }

      print('🔄 Attempting to refresh access token...');

      // Create refresh token request
      final request = RefreshTokenRequest(
          refreshToken: refreshToken,
          device: RegisterDeviceRequest(
            pushToken: "xyzoi",
            platform: Platform.isIOS
                ? RegisterDeviceRequestPlatformEnum.IOS
                : RegisterDeviceRequestPlatformEnum.ANDROID,
            deviceId: "zxc",
            appVersion: "sdsds",
          ));

      // Call refresh endpoint
      setAuthToken(
          ""); // Clear token to avoid using expired token during refresh
      final response = await authApi.refresh(request);

      if (response != null && response.accessToken != null) {
        print('✅ Token refreshed successfully');

        // Update tokens
        await setAuthToken(response.accessToken!);

        if (response.refreshToken != null) {
          await setRefreshToken(response.refreshToken!);
        }

        _isRefreshing = false;
        _refreshCompleter?.complete(true);
        return true;
      } else {
        print('❌ Token refresh failed - no access token in response');
        await _handleTokenExpired();
        _refreshCompleter?.complete(false);
        return false;
      }
    } on ApiException catch (e) {
      print('❌ Token refresh failed with API error: ${e.code} - ${e.message}');

      if (e.code == 401 || e.code == 403) {
        // Refresh token is also expired or invalid
        await _handleTokenExpired();
      }

      _isRefreshing = false;
      _refreshCompleter?.complete(false);
      return false;
    } catch (e) {
      print('❌ Token refresh failed with error: $e');
      await _handleTokenExpired();
      _isRefreshing = false;
      _refreshCompleter?.complete(false);
      return false;
    }
  }

  /// Handle expired tokens by clearing auth and navigating to login
  Future<void> _handleTokenExpired() async {
    print('🚪 Handling expired token - clearing auth and navigating to login');
    await clearAuthToken();
    _isRefreshing = false;

    // Trigger logout navigation if callback is set
    if (onUnauthorized != null) {
      onUnauthorized!();
    }
  }

  /// Wrap API calls with automatic token refresh on 401
  Future<T?> executeWithTokenRefresh<T>(
    Future<T?> Function() apiCall,
  ) async {
    try {
      return await apiCall();
    } on ApiException catch (e) {
      if (e.code == 401 && !_isRefreshing) {
        print('🔐 Got 401 - attempting token refresh...');

        final refreshed = await refreshAccessToken();

        if (refreshed) {
          // Retry the original request with new token
          print('🔄 Retrying original request with new token...');
          return await apiCall();
        }
      }

      // Re-throw the exception if refresh failed or not a 401
      rethrow;
    }
  }
}
