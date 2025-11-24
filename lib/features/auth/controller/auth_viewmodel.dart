import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    AuthResponse? authResponse,
    String? errorMessage,
    bool? isAuthenticated,
  }) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      authResponse: authResponse ?? this.authResponse,
      errorMessage: errorMessage,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
    );
  }
}

/// Auth ViewModel provider
final authViewModelProvider =
    StateNotifierProvider<AuthViewModel, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthViewModel(apiService);
});

/// Auth ViewModel with all authentication methods
class AuthViewModel extends StateNotifier<AuthState> {
  AuthViewModel(this._apiService) : super(AuthState()) {
    _checkAuthStatus();
  }

  final ApiService _apiService;

  /// Check if user is already authenticated on app start
  void _checkAuthStatus() {
    final token = _apiService.getAuthToken();
    if (token != null && token.isNotEmpty) {
      state = state.copyWith(isAuthenticated: true);
    }
  }

  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
    String? deviceId,
    String? deviceName,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      // Create login request
      final loginRequest = LoginRequest(
        email: email,
        password: password,
      );

      // Create device request (if you need device info)
      final loginWithDeviceRequest = LoginWithDeviceRequest(
        login: loginRequest,
        device: deviceId != null
            ? RegisterDeviceRequest(
                deviceId: deviceId,
                appVersion:
                    deviceName, // Using appVersion field for device info
              )
            : null,
      );

      // Call the API
      final response = await _apiService.authApi.login(loginWithDeviceRequest);

      if (response != null && response.accessToken != null) {
        // Save tokens
        await _apiService.setAuthToken(response.accessToken!);
        if (response.refreshToken != null) {
          await _apiService.setRefreshToken(response.refreshToken!);
        }

        state = state.copyWith(
          isLoading: false,
          authResponse: response,
          isAuthenticated: true,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Login failed: No token received',
        );
        return false;
      }
    } on ApiException catch (e) {
      // API returned an error response (400, 401, 500, etc.)
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      // Network error, parsing error, or other unexpected errors
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
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
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
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

        state = state.copyWith(
          isLoading: false,
          authResponse: response,
          isAuthenticated: true,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Registration failed',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
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
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final socialLoginRequest = SocialLoginRequest(
        idToken: idToken,
        device: deviceId != null
            ? RegisterDeviceRequest(
                deviceId: deviceId,
                appVersion: deviceName,
              )
            : null,
      );

      final response =
          await _apiService.authApi.googleLogin(socialLoginRequest);

      if (response != null && response.accessToken != null) {
        await _apiService.setAuthToken(response.accessToken!);
        if (response.refreshToken != null) {
          await _apiService.setRefreshToken(response.refreshToken!);
        }

        state = state.copyWith(
          isLoading: false,
          authResponse: response,
          isAuthenticated: true,
          errorMessage: null,
        );
        return true;
      }
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Google login failed: ${e.toString()}',
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
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final socialLoginRequest = SocialLoginRequest(
        idToken: idToken,
        device: deviceId != null
            ? RegisterDeviceRequest(
                deviceId: deviceId,
                appVersion: deviceName,
              )
            : null,
      );

      final response = await _apiService.authApi.appleLogin(socialLoginRequest);

      if (response != null && response.accessToken != null) {
        await _apiService.setAuthToken(response.accessToken!);
        if (response.refreshToken != null) {
          await _apiService.setRefreshToken(response.refreshToken!);
        }

        state = state.copyWith(
          isLoading: false,
          authResponse: response,
          isAuthenticated: true,
          errorMessage: null,
        );
        return true;
      }
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Apple login failed: ${e.toString()}',
      );
      return false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    await _apiService.clearAuthToken();
    state = AuthState(); // Reset to initial state
  }

  /// Parse API error messages
  String _parseApiError(ApiException e) {
    // Try to parse the error message from the response body
    final message = e.message;

    switch (e.code) {
      case 400:
        return 'Invalid request: $message';
      case 401:
        return 'Invalid email or password';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Endpoint not found';
      case 409:
        return 'User already exists';
      case 500:
        return 'Server error. Please try again later';
      default:
        return message ?? 'An error occurred. Please try again';
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
