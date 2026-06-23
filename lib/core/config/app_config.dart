/// Environment-driven configuration.
///
/// All values are injected at compile time via --dart-define.
/// Never hardcode environment-specific values elsewhere in the codebase.
///
/// Usage:
///   flutter run --dart-define=ENVIRONMENT=development
///   flutter run --dart-define=ENVIRONMENT=staging
///   flutter run --dart-define=ENVIRONMENT=production
class AppConfig {
  AppConfig._();

  static const String _environment = String.fromEnvironment('ENVIRONMENT');

  static const String _apiUrl = String.fromEnvironment('API_URL');

  static const String _sentryDsn = String.fromEnvironment(
    'SENTRY_DSN',
    defaultValue:
        'https://47876b6e83b82001e26d5b531e2491e4@o4511177626746880.ingest.de.sentry.io/4511259656716368',
  );

  // ── Environment ──────────────────────────────────────────────────────────

  static String get environment {
    if (_environment.isEmpty) {
      throw StateError(
        'ENVIRONMENT was not supplied. Pass it using '
        '--dart-define=ENVIRONMENT=<environment>.',
      );
    }
    return _environment;
  }

  static bool get isDevelopment => environment == 'development';
  static bool get isStaging => environment == 'staging';
  static bool get isProduction => environment == 'production';

  // ── API ──────────────────────────────────────────────────────────────────

  static String get apiUrl {
    if (_apiUrl.isEmpty) {
      throw StateError(
        'API_URL was not supplied. Pass it using '
        '--dart-define=API_URL=<url>.',
      );
    }
    return _apiUrl;
  }

  // ── Sentry ───────────────────────────────────────────────────────────────

  static String get sentryDsn => _sentryDsn;

  /// Capture 100% of transactions in dev/staging, 10% in production.
  static double get sentryTracesSampleRate => isProduction ? 0.1 : 1.0;

  /// Profile 100% of sampled transactions in dev/staging, 20% in production.
  static double get sentryProfilesSampleRate => isProduction ? 0.2 : 1.0;

  /// Session replay: 10% in dev/staging, 5% in production.
  static double get sentryReplaySessionSampleRate => isProduction ? 0.05 : 0.1;
}
