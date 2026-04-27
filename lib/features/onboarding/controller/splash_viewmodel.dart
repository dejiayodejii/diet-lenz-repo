import 'dart:developer';

import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/providers/biometric_providers.dart';
import 'package:diet_lenz/core/providers/sentry_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:diet_lenz/core/services/sentry_service.dart';
import 'package:diet_lenz/core/utils/token_utils.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum SplashStatus {
  initial,
  loading,
  refreshingToken,
  navigateToLogin,
  navigateToHome,
  navigateToBiometricLock,
}

class SplashState {
  const SplashState({this.status = SplashStatus.initial});

  final SplashStatus status;

  SplashState copyWith({SplashStatus? status}) {
    return SplashState(status: status ?? this.status);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SplashState &&
          runtimeType == other.runtimeType &&
          status == other.status;

  @override
  int get hashCode => status.hashCode;

  @override
  String toString() => 'SplashState(status: $status)';
}

final splashViewModelProvider =
    StateNotifierProvider.autoDispose<SplashViewModel, SplashState>((ref) {
  return SplashViewModel(
    apiService: ref.read(apiServiceProvider),
    authState: ref.read(authViewModelProvider),
    biometricEnabled: ref.read(biometricEnabledNotifierProvider),
    sentryService: ref.read(sentryServiceProvider),
  );
});

class SplashViewModel extends StateNotifier<SplashState> {
  SplashViewModel({
    required ApiService apiService,
    required AuthState authState,
    required bool biometricEnabled,
    required SentryService sentryService,
    Duration splashDuration = const Duration(seconds: 3),
  })  : _apiService = apiService,
        _authState = authState,
        _biometricEnabled = biometricEnabled,
        _sentryService = sentryService,
        _splashDuration = splashDuration,
        super(const SplashState());

  final ApiService _apiService;
  final AuthState _authState;
  final bool _biometricEnabled;
  final SentryService _sentryService;
  final Duration _splashDuration;

  /// Entry point called from the splash screen on mount.
  /// Waits for the splash duration then determines where to navigate.
  Future<void> initialize() async {
    state = state.copyWith(status: SplashStatus.loading);
    await Future.delayed(_splashDuration);
    await _determineDestination();
  }

  Future<void> _determineDestination() async {
    try {
      if (!_authState.isAuthenticated || _authState.authResponse == null) {
        state = state.copyWith(status: SplashStatus.navigateToLogin);
        return;
      }

      final tokenOk = await _resolveToken();
      if (!tokenOk) {
        state = state.copyWith(status: SplashStatus.navigateToLogin);
        return;
      }

      final savedProfile = _apiService.getSavedUserProfile();
      log("Saved profile: $savedProfile");
      if (savedProfile == null || savedProfile.isEmpty) {
        state = state.copyWith(status: SplashStatus.navigateToLogin);
        return;
      }

      // Restore Sentry user context for the active session.
      final authResponse = _authState.authResponse;
      await _sentryService.setUser(
        id: authResponse?.userId ?? authResponse?.email ?? 'unknown',
        email: authResponse?.email,
        name: [authResponse?.firstName, authResponse?.lastName]
                .whereType<String>()
                .join(' ')
                .trim()
                .isEmpty
            ? null
            : [authResponse?.firstName, authResponse?.lastName]
                .whereType<String>()
                .join(' ')
                .trim(),
      );

      state = state.copyWith(
        status: _biometricEnabled
            ? SplashStatus.navigateToBiometricLock
            : SplashStatus.navigateToHome,
      );
    } catch (_) {
      state = state.copyWith(status: SplashStatus.navigateToLogin);
    }
  }

  /// Returns true if a valid access token is available (either existing or
  /// successfully refreshed).
  Future<bool> _resolveToken() async {
    final token = _apiService.getAuthToken();
    if (token != null &&
        token.isNotEmpty &&
        !TokenUtils.isTokenExpired(token)) {
      return true;
    }

    final refreshToken = _apiService.getRefreshToken();
    final refreshValid = refreshToken != null &&
        refreshToken.isNotEmpty &&
        !TokenUtils.isTokenExpired(refreshToken, isRefreshToken: true);

    if (!refreshValid) return false;

    state = state.copyWith(status: SplashStatus.refreshingToken);
    await _apiService.setAuthToken('');
    final refreshed = await _apiService
        .refreshAccessToken()
        .timeout(const Duration(seconds: 30), onTimeout: () => false);

    return refreshed;
  }
}
