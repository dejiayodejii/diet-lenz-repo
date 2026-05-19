import 'package:diet_lenz/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig', () {
    test('defaults to development environment', () {
      // dart-define is not set in test, so defaultValue applies
      expect(AppConfig.environment, equals('development'));
    });

    test('isDevelopment is true when environment is development', () {
      expect(AppConfig.isDevelopment, isTrue);
    });

    test('isProduction is false when environment is development', () {
      expect(AppConfig.isProduction, isFalse);
    });

    test('apiUrl has a non-empty default', () {
      expect(AppConfig.apiUrl, isNotEmpty);
    });

    test('sentryTracesSampleRate is 1.0 in non-production', () {
      expect(AppConfig.sentryTracesSampleRate, equals(1.0));
    });
  });
}
