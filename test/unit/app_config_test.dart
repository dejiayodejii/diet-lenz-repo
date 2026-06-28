import 'package:diet_lenz/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig', () {
    test('throws when ENVIRONMENT is not supplied', () {
      expect(
        () => AppConfig.environment,
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('ENVIRONMENT was not supplied'),
          ),
        ),
      );
    });

    test('isDevelopment throws when ENVIRONMENT is not supplied', () {
      expect(() => AppConfig.isDevelopment, throwsA(isA<StateError>()));
    });

    test('isProduction throws when ENVIRONMENT is not supplied', () {
      expect(() => AppConfig.isProduction, throwsA(isA<StateError>()));
    });

    test('throws when API_URL is not supplied', () {
      expect(
        () => AppConfig.apiUrl,
        throwsA(
          isA<StateError>().having(
            (error) => error.message,
            'message',
            contains('API_URL was not supplied'),
          ),
        ),
      );
    });

    test('sentryTracesSampleRate throws when ENVIRONMENT is not supplied', () {
      expect(
        () => AppConfig.sentryTracesSampleRate,
        throwsA(isA<StateError>()),
      );
    });
  });
}
