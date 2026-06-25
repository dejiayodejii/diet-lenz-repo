import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:openapi/api.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/providers/sentry_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:diet_lenz/core/services/iap_service.dart';
import 'package:diet_lenz/core/services/push_notification_service.dart';
import 'package:diet_lenz/core/services/sentry_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Extension to extract error message from ApiException
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

/// Sentinel wrapper that lets [AuthState.copyWith] distinguish between
/// "caller wants to set this field to null" and "caller didn't touch this field".
class _Nullable<T> {
  const _Nullable(this.value);
  final T? value;
}

/// Auth state to track loading, success, error states
class AuthState {
  final bool isLoading;
  final AuthResponse? authResponse;
  final String? errorMessage;
  final bool isAuthenticated;

  AuthState({
    this.isLoading = false,
    this.authResponse,
    this.errorMessage,
    this.isAuthenticated = false,
  });

  AuthState copyWith({
    bool? isLoading,
    _Nullable<AuthResponse>? authResponse,
    _Nullable<String>? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      authResponse:
          authResponse != null ? authResponse.value : this.authResponse,
      errorMessage:
          errorMessage != null ? errorMessage.value : this.errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth ViewModel provider
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  final iapService = ref.watch(iapServiceProvider);
  final pushService = ref.watch(pushNotificationServiceProvider);
  final sentryService = ref.read(sentryServiceProvider);
  return AuthViewModel(apiService, iapService, pushService, sentryService);
});

/// Auth ViewModel with all authentication methods
class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel(
    this._apiService,
    this._iapService,
    this._pushService,
    this._sentryService,
  ) : super(AuthState()) {
    _checkAuthStatus();
  }

  final ApiService _apiService;
  final IAPService _iapService;
  final PushNotificationService _pushService;
  final SentryService _sentryService;

  /// Check if user is already authenticated on app start
  void _checkAuthStatus() {
    log('Checking authentication status...');
    final token = _apiService.getAuthToken();
    if (token != null && token.isNotEmpty) {
      // Restore saved auth response from local storage
      final savedAuthJson = _apiService.getSavedAuthResponse();
      AuthResponse? savedAuthResponse;
      if (savedAuthJson != null && savedAuthJson.isNotEmpty) {
        try {
          savedAuthResponse = AuthResponse.fromJson(json.decode(savedAuthJson));
        } catch (_) {
          log("Failed to parse saved auth response");
        }
      }
      log("auth response is $savedAuthResponse");
      state = state.copyWith(
        isAuthenticated: true,
        authResponse: _Nullable(savedAuthResponse),
      );
      // Restore Sentry user context for the active session.
      _sentryService.setUser(
        id: savedAuthResponse?.userId ?? 'unknown',
        email: savedAuthResponse?.email,
        name: [
          savedAuthResponse?.firstName,
          savedAuthResponse?.lastName,
        ].whereType<String>().join(' ').trim().isEmpty
            ? null
            : [
                savedAuthResponse?.firstName,
                savedAuthResponse?.lastName,
              ].whereType<String>().join(' ').trim(),
      );
    } else {
      log('No auth token found, user is not authenticated');
    }
  }

  /// Save auth response to local storage
  Future<void> _saveAuthResponseToStorage(AuthResponse response) async {
    final jsonStr = json.encode(response.toJson());
    await _apiService.saveAuthResponse(jsonStr);
  }

  /// Retrieve real app version and device ID
  Future<({String appVersion, String deviceId})> _getDeviceInfo() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final appVersion = packageInfo.version;

    final deviceInfoPlugin = DeviceInfoPlugin();
    String deviceId;
    if (Platform.isIOS) {
      final iosInfo = await deviceInfoPlugin.iosInfo;
      deviceId = iosInfo.identifierForVendor ?? 'unknown';
    } else {
      final androidInfo = await deviceInfoPlugin.androidInfo;
      deviceId = androidInfo.id;
    }

    return (appVersion: appVersion, deviceId: deviceId);
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
    String? deviceId,
    String? deviceName,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: const _Nullable(null));

    try {
      // Create login request
      final loginRequest = LoginRequest(
        email: email,
        password: password,
      );

      await _apiService.clearAuthToken();

      final timeZone = await FlutterTimezone.getLocalTimezone();
      final deviceInfo = await _getDeviceInfo();

      // Create device request (if you need device info)
      final loginWithDeviceRequest = LoginWithDeviceRequest(
        login: loginRequest,
        device: RegisterDeviceRequest(
          pushToken: _pushService.fcmToken ?? 'xyz',
          platform: Platform.isIOS
              ? RegisterDeviceRequestPlatformEnum.IOS
              : RegisterDeviceRequestPlatformEnum.ANDROID,
          deviceId: deviceInfo.deviceId,
          appVersion: deviceInfo.appVersion,
          timeZone: timeZone,
        ),
      );

      // Call the API
      final response = await _apiService.authApi.login(loginWithDeviceRequest);

      if (response != null && response.accessToken != null) {
        // Save tokens
        await _apiService.setAuthToken(response.accessToken!);
        if (response.refreshToken != null) {
          await _apiService.setRefreshToken(response.refreshToken!);
        }

        // Save auth response to local storage
        await _saveAuthResponseToStorage(response);

        // Identify user with RevenueCat
        await _identifyWithRevenueCat(response.email);

        // Identify user in Sentry
        await _sentryService.setUser(
          id: response.userId ?? response.email ?? 'unknown',
          email: response.email,
          name: [response.firstName, response.lastName]
                  .whereType<String>()
                  .join(' ')
                  .trim()
                  .isEmpty
              ? null
              : [response.firstName, response.lastName]
                  .whereType<String>()
                  .join(' ')
                  .trim(),
        );

        state = state.copyWith(
          isLoading: false,
          authResponse: _Nullable(response),
          isAuthenticated: true,
          errorMessage: const _Nullable(null),
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: const _Nullable('Login failed: No token received'),
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _Nullable(_parseApiError(e)),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            _Nullable('An unexpected error occurred: ${e.toString()}'),
      );
      return false;
    }
  }

  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: const _Nullable(null));

    try {
      await _apiService.clearAuthToken();
      final registerRequest = RegisterRequest(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      final response = await _apiService.authApi.register(registerRequest);

      if (response != null && response.accessToken != null) {
        await _apiService.setAuthToken(response.accessToken!);
        if (response.refreshToken != null) {
          await _apiService.setRefreshToken(response.refreshToken!);
        }

        // Save auth response to local storage
        await _saveAuthResponseToStorage(response);

        // Identify user with RevenueCat
        await _identifyWithRevenueCat(response.email);

        // Identify user in Sentry
        await _sentryService.setUser(
          id: response.userId ?? response.email ?? 'unknown',
          email: response.email,
          name: [response.firstName, response.lastName]
                  .whereType<String>()
                  .join(' ')
                  .trim()
                  .isEmpty
              ? null
              : [response.firstName, response.lastName]
                  .whereType<String>()
                  .join(' ')
                  .trim(),
        );

        state = state.copyWith(
          isLoading: false,
          authResponse: _Nullable(response),
          isAuthenticated: true,
          errorMessage: const _Nullable(null),
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: const _Nullable('Registration failed'),
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _Nullable(_parseApiError(e)),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage:
            _Nullable('An unexpected error occurred: ${e.toString()}'),
      );
      return false;
    }
  }

  /// Refresh authentication token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _apiService.getRefreshToken();
      if (refreshToken == null) {
        await logout();
        return false;
      }

      final refreshRequest = RefreshTokenRequest(
        refreshToken: refreshToken,
      );

      await _apiService.setAuthToken(
          ""); // Clear token before refreshing to avoid using expired token

      final response = await _apiService.authApi.refresh(refreshRequest);

      if (response != null && response.accessToken != null) {
        await _apiService.setAuthToken(response.accessToken!);
        if (response.refreshToken != null) {
          await _apiService.setRefreshToken(response.refreshToken!);
        }
        return true;
      }
      return false;
    } catch (e) {
      await logout();
      return false;
    }
  }

  /// Google login
  Future<bool> googleLogin({
    required String idToken,
    String? deviceId,
    String? deviceName,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: const _Nullable(null));

    try {
      await _apiService.clearAuthToken();

      final timeZone = await FlutterTimezone.getLocalTimezone();
      final deviceInfo = await _getDeviceInfo();

      final socialLoginRequest = SocialLoginRequest(
        idToken: idToken,
        device: RegisterDeviceRequest(
          pushToken: _pushService.fcmToken ?? "xyzoi",
          platform: Platform.isIOS
              ? RegisterDeviceRequestPlatformEnum.IOS
              : RegisterDeviceRequestPlatformEnum.ANDROID,
          deviceId: deviceInfo.deviceId,
          appVersion: deviceInfo.appVersion,
          timeZone: timeZone,
        ),
      );

      final response =
          await _apiService.authApi.googleLogin(socialLoginRequest);

      if (response != null && response.accessToken != null) {
        await _apiService.setAuthToken(response.accessToken!);
        if (response.refreshToken != null) {
          await _apiService.setRefreshToken(response.refreshToken!);
        }

        // Save auth response to local storage
        await _saveAuthResponseToStorage(response);

        // Identify user with RevenueCat
        await _identifyWithRevenueCat(response.email);

        // Identify user in Sentry
        await _sentryService.setUser(
          id: response.userId ?? response.email ?? 'unknown',
          email: response.email,
        );

        state = state.copyWith(
          isLoading: false,
          authResponse: _Nullable(response),
          isAuthenticated: true,
          errorMessage: const _Nullable(null),
        );
        return true;
      }
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _Nullable(_parseApiError(e)),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _Nullable('Google login failed: ${e.toString()}'),
      );
      return false;
    }
  }

  /// Apple login
  Future<bool> appleLogin({
    required String idToken,
    String? deviceId,
    String? deviceName,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: const _Nullable(null));

    try {
      await _apiService.clearAuthToken();

      final timeZone = await FlutterTimezone.getLocalTimezone();
      final deviceInfo = await _getDeviceInfo();

      final socialLoginRequest = SocialLoginRequest(
        idToken: idToken,
        device: RegisterDeviceRequest(
          pushToken: _pushService.fcmToken ?? "xzss",
          platform: Platform.isIOS
              ? RegisterDeviceRequestPlatformEnum.IOS
              : RegisterDeviceRequestPlatformEnum.ANDROID,
          deviceId: deviceInfo.deviceId,
          appVersion: deviceInfo.appVersion,
          timeZone: timeZone,
        ),
      );

      final response = await _apiService.authApi.appleLogin(socialLoginRequest);

      if (response != null && response.accessToken != null) {
        await _apiService.setAuthToken(response.accessToken!);
        if (response.refreshToken != null) {
          await _apiService.setRefreshToken(response.refreshToken!);
        }

        // Save auth response to local storage
        await _saveAuthResponseToStorage(response);

        // Identify user with RevenueCat
        await _identifyWithRevenueCat(response.email);

        // Identify user in Sentry
        await _sentryService.setUser(
          id: response.userId ?? response.email ?? 'unknown',
          email: response.email,
        );

        state = state.copyWith(
          isLoading: false,
          authResponse: _Nullable(response),
          isAuthenticated: true,
          errorMessage: const _Nullable(null),
        );
        return true;
      }
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _Nullable(_parseApiError(e)),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _Nullable('Apple login failed: ${e.toString()}'),
      );
      return false;
    }
  }

  /// Verify Email
  Future<bool> verifyEmail({
    required String email,
    required String otp,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: const _Nullable(null));

    try {
      await _apiService.authApi.verifyEmail(email, otp);

      state = state.copyWith(
        isLoading: false,
        errorMessage: const _Nullable(null),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _Nullable(_parseApiError(e)),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _Nullable('Verification failed: ${e.toString()}'),
      );
      return false;
    }
  }

  /// Resend OTP
  Future<bool> resendOtp({
    required String email,
  }) async {
    state =
        state.copyWith(isLoading: true, errorMessage: const _Nullable(null));

    try {
      final request = ForgotPasswordRequest(email: email);
      await _apiService.authApi.requestOtpResend(request);

      state = state.copyWith(
        isLoading: false,
        errorMessage: const _Nullable(null),
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _Nullable(_parseApiError(e)),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _Nullable('Resend failed: ${e.toString()}'),
      );
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    // Clear Sentry user context
    await _sentryService.clearUser();

    // Log out from RevenueCat (creates anonymous user)
    try {
      if (_iapService.isConfigured) {
        await _iapService.logout();
      }
    } catch (_) {
      // Non-fatal
    }

    await _apiService.clearAuthToken();
    state = AuthState(); // Reset to initial state
  }

  /// Identify the user with RevenueCat after authentication.
  Future<void> _identifyWithRevenueCat(String? userId) async {
    if (userId == null || userId.isEmpty) return;
    try {
      await _iapService.login(userId);
    } catch (_) {
      // Non-fatal — RevenueCat failure should never break authentication.
    }
  }

  /// Parse API error messages
  String _parseApiError(ApiException e) {
    final errorMessage = e.extractMessage;
    switch (e.code) {
      case 400:
        return errorMessage ?? 'Invalid request';
      case 401:
        return errorMessage ?? 'Invalid email or password';
      case 403:
        return errorMessage ?? 'Access forbidden';
      case 404:
        return errorMessage ?? 'Endpoint not found';
      case 409:
        return errorMessage ?? 'User already exists';
      case 500:
        return errorMessage ?? 'Server error. Please try again later';
      default:
        return errorMessage ?? 'An error occurred. Please try again';
    }
  }

  /// Update profile photo in state
  void updateProfilePhoto(String photoUrl) {
    if (state.authResponse != null) {
      final current = state.authResponse!;
      final updatedResponse = AuthResponse(
        message: current.message,
        accessToken: current.accessToken,
        refreshToken: current.refreshToken,
        userId: current.userId,
        email: current.email,
        firstName: current.firstName,
        lastName: current.lastName,
        emailVerified: current.emailVerified,
        profilePhoto: photoUrl,
      );
      state = state.copyWith(authResponse: _Nullable(updatedResponse));
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: const _Nullable(null));
  }
}
