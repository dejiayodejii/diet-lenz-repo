import 'dart:convert';

import 'package:openapi/api.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:diet_lenz/core/services/sentry_service.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/onboarding/controller/splash_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockApiService extends Mock implements ApiService {}

class MockSentryService extends Mock implements SentryService {}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Builds a minimal signed JWT whose [exp] claim is in the past (expired)
/// or the future (valid), without requiring a real signing key.
/// jwt_decoder only base64-decodes the payload, so the signature is ignored.
String _buildToken({required bool expired}) {
  final exp = expired
      ? DateTime.now()
              .subtract(const Duration(hours: 1))
              .millisecondsSinceEpoch ~/
          1000
      : DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/
          1000;

  // URL-safe base64 without padding, as required by JWT.
  String b64(String json) =>
      base64Url.encode(utf8.encode(json)).replaceAll('=', '');

  final header = b64('{"alg":"HS256","typ":"JWT"}');
  final payload = b64('{"sub":"uid-123","exp":$exp}');
  return '$header.$payload.fake_signature';
}

AuthState _authenticatedState({String email = 'user@test.com'}) => AuthState(
      isAuthenticated: true,
      authResponse: AuthResponse(email: email),
    );

// ---------------------------------------------------------------------------
// Factory
// ---------------------------------------------------------------------------

SplashViewModel _makeViewModel({
  required MockApiService apiService,
  required MockSentryService sentryService,
  AuthState? authState,
  bool biometricEnabled = false,
}) {
  return SplashViewModel(
    apiService: apiService,
    authState: authState ?? AuthState(),
    biometricEnabled: biometricEnabled,
    sentryService: sentryService,
    // Skip the 3-second splash delay in tests.
    splashDuration: Duration.zero,
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late MockApiService mockApiService;
  late MockSentryService mockSentryService;

  setUp(() {
    mockApiService = MockApiService();
    mockSentryService = MockSentryService();
    // Stub setUser so tests that reach it don't hit the real Sentry SDK.
    when(() => mockSentryService.setUser(
          id: any(named: 'id'),
          email: any(named: 'email'),
          name: any(named: 'name'),
        )).thenAnswer((_) async {});
  });

  group('SplashViewModel – initial state', () {
    test('starts as SplashStatus.initial', () {
      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
      );
      expect(vm.state.status, SplashStatus.initial);
    });
  });

  group('SplashViewModel – not authenticated', () {
    test('navigates to login when user is not authenticated', () async {
      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: AuthState(isAuthenticated: false),
      );

      await vm.initialize();

      expect(vm.state.status, SplashStatus.navigateToLogin);
    });

    test('navigates to login when authenticated but authResponse is null',
        () async {
      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: AuthState(isAuthenticated: true, authResponse: null),
      );

      await vm.initialize();

      expect(vm.state.status, SplashStatus.navigateToLogin);
    });
  });

  group('SplashViewModel – valid access token', () {
    test('navigates to login when token valid but no saved profile', () async {
      when(() => mockApiService.getAuthToken())
          .thenReturn(_buildToken(expired: false));
      when(() => mockApiService.getSavedUserProfile()).thenReturn(null);

      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: _authenticatedState(),
      );

      await vm.initialize();

      expect(vm.state.status, SplashStatus.navigateToLogin);
    });

    test('navigates to home when token valid and profile exists', () async {
      when(() => mockApiService.getAuthToken())
          .thenReturn(_buildToken(expired: false));
      when(() => mockApiService.getSavedUserProfile())
          .thenReturn('{"id":"1","email":"user@test.com"}');

      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: _authenticatedState(),
        biometricEnabled: false,
      );

      await vm.initialize();

      expect(vm.state.status, SplashStatus.navigateToHome);
    });

    test(
        'navigates to biometric lock when biometric enabled and profile exists',
        () async {
      when(() => mockApiService.getAuthToken())
          .thenReturn(_buildToken(expired: false));
      when(() => mockApiService.getSavedUserProfile())
          .thenReturn('{"id":"1","email":"user@test.com"}');

      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: _authenticatedState(),
        biometricEnabled: true,
      );

      await vm.initialize();

      expect(vm.state.status, SplashStatus.navigateToBiometricLock);
    });
  });

  group('SplashViewModel – token refresh scenarios', () {
    test('navigates to login when both access and refresh tokens are absent',
        () async {
      when(() => mockApiService.getAuthToken()).thenReturn(null);
      when(() => mockApiService.getRefreshToken()).thenReturn(null);

      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: _authenticatedState(),
      );

      await vm.initialize();

      expect(vm.state.status, SplashStatus.navigateToLogin);
    });

    test('navigates to login when access and refresh tokens are both expired',
        () async {
      final expired = _buildToken(expired: true);
      when(() => mockApiService.getAuthToken()).thenReturn(expired);
      when(() => mockApiService.getRefreshToken()).thenReturn(expired);

      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: _authenticatedState(),
      );

      await vm.initialize();

      expect(vm.state.status, SplashStatus.navigateToLogin);
    });

    test('navigates to home after a successful token refresh', () async {
      final expired = _buildToken(expired: true);
      final validRefresh = _buildToken(expired: false);

      when(() => mockApiService.getAuthToken()).thenReturn(expired);
      when(() => mockApiService.getRefreshToken()).thenReturn(validRefresh);
      when(() => mockApiService.setAuthToken(any())).thenAnswer((_) async {});
      when(() => mockApiService.refreshAccessToken())
          .thenAnswer((_) async => true);
      when(() => mockApiService.getSavedUserProfile()).thenReturn('{"id":"1"}');

      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: _authenticatedState(),
        biometricEnabled: false,
      );

      await vm.initialize();

      expect(vm.state.status, SplashStatus.navigateToHome);
      verify(() => mockApiService.setAuthToken('')).called(1);
      verify(() => mockApiService.refreshAccessToken()).called(1);
    });

    test('navigates to login when token refresh call returns false', () async {
      final expired = _buildToken(expired: true);
      final validRefresh = _buildToken(expired: false);

      when(() => mockApiService.getAuthToken()).thenReturn(expired);
      when(() => mockApiService.getRefreshToken()).thenReturn(validRefresh);
      when(() => mockApiService.setAuthToken(any())).thenAnswer((_) async {});
      when(() => mockApiService.refreshAccessToken())
          .thenAnswer((_) async => false);

      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: _authenticatedState(),
      );

      await vm.initialize();

      expect(vm.state.status, SplashStatus.navigateToLogin);
    });

    test('emits refreshingToken status while refresh is in progress', () async {
      final expired = _buildToken(expired: true);
      final validRefresh = _buildToken(expired: false);

      when(() => mockApiService.getAuthToken()).thenReturn(expired);
      when(() => mockApiService.getRefreshToken()).thenReturn(validRefresh);
      when(() => mockApiService.setAuthToken(any())).thenAnswer((_) async {});
      when(() => mockApiService.refreshAccessToken())
          .thenAnswer((_) async => true);
      when(() => mockApiService.getSavedUserProfile()).thenReturn('{"id":"1"}');

      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: _authenticatedState(),
      );

      final emittedStatuses = <SplashStatus>[];
      vm.addListener((s) => emittedStatuses.add(s.status));

      await vm.initialize();

      expect(emittedStatuses, contains(SplashStatus.refreshingToken));
    });
  });

  group('SplashViewModel – error handling', () {
    test('navigates to login when an unexpected exception is thrown', () async {
      when(() => mockApiService.getAuthToken())
          .thenThrow(Exception('Unexpected storage error'));

      final vm = _makeViewModel(
        apiService: mockApiService,
        sentryService: mockSentryService,
        authState: _authenticatedState(),
      );

      await vm.initialize();

      expect(vm.state.status, SplashStatus.navigateToLogin);
    });
  });

  group('SplashState – equality', () {
    test('two states with the same status are equal', () {
      expect(
        const SplashState(status: SplashStatus.navigateToHome),
        const SplashState(status: SplashStatus.navigateToHome),
      );
    });

    test('two states with different statuses are not equal', () {
      expect(
        const SplashState(status: SplashStatus.navigateToHome),
        isNot(const SplashState(status: SplashStatus.navigateToLogin)),
      );
    });
  });
}
