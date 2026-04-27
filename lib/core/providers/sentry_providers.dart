import 'package:diet_lenz/core/services/sentry_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Globally available [SentryService] instance.
///
/// Consume with `ref.read(sentryServiceProvider)` to report errors anywhere
/// in the app without importing the Sentry SDK directly.
final sentryServiceProvider = Provider<SentryService>((ref) {
  return SentryService();
});
