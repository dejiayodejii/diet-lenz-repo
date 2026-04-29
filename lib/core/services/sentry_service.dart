import 'package:sentry_flutter/sentry_flutter.dart';

/// Centralised Sentry error-reporting service.
///
/// Wraps the Sentry SDK so that the rest of the app never imports
/// `sentry_flutter` directly — making it easy to swap or mock in tests.
class SentryService {
  // ── Generic exception capture ─────────────────────────────────────────────

  /// Captures [exception] with an optional [stackTrace] and [extras] map.
  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    Map<String, dynamic>? extras,
  }) async {
    await Sentry.captureException(
      exception,
      stackTrace: stackTrace,
      withScope: extras == null
          ? null
          : (scope) {
              extras.forEach((key, value) => scope.setExtra(key, value));
            },
    );
  }

  // ── Message capture ───────────────────────────────────────────────────────

  /// Captures a plain [message] at the given [level] (default: info).
  Future<void> captureMessage(
    String message, {
    SentryLevel level = SentryLevel.info,
    Map<String, dynamic>? extras,
  }) async {
    await Sentry.captureMessage(
      message,
      level: level,
      withScope: extras == null
          ? null
          : (scope) {
              extras.forEach((key, value) => scope.setExtra(key, value));
            },
    );
  }

  // ── Breadcrumbs ───────────────────────────────────────────────────────────

  /// Adds a navigation or action breadcrumb to the current scope.
  void addBreadcrumb({
    required String message,
    String category = 'app',
    String type = 'default',
    Map<String, dynamic>? data,
    SentryLevel level = SentryLevel.info,
  }) {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: message,
        category: category,
        type: type,
        data: data,
        level: level,
      ),
    );
  }

  // ── User context ──────────────────────────────────────────────────────────

  /// Sets the current user on all future Sentry events.
  /// Call this after a successful login.
  Future<void> setUser(
      {required String id, String? email, String? name}) async {
    await Sentry.configureScope(
      (scope) => scope.setUser(
        SentryUser(id: id, email: email, name: name),
      ),
    );
  }

  /// Clears the current user from the Sentry scope.
  /// Call this on logout.
  Future<void> clearUser() async {
    await Sentry.configureScope(
      (scope) => scope.setUser(null),
    );
  }

  // ── API-specific helpers ──────────────────────────────────────────────────

  /// Logs a failed HTTP call as a Sentry event.
  ///
  /// [statusCode] of `null` means a network-level exception occurred before
  /// a response was received.
  Future<void> captureApiFailure({
    required String method,
    required String url,
    int? statusCode,
    String? requestBody,
    Map<String, String>? requestHeaders,
    String? responseBody,
    Object? error,
    StackTrace? stackTrace,
  }) async {
    final bool isServerError = statusCode != null && statusCode >= 500;
    final level = isServerError ? SentryLevel.error : SentryLevel.warning;

    final extras = <String, dynamic>{
      'http.method': method,
      'http.url': url,
      if (statusCode != null) 'http.status_code': statusCode,
      if (requestBody != null && requestBody.length <= 2000)
        'http.request_body': requestBody,
      if (requestHeaders != null && requestHeaders.isNotEmpty)
        'http.request_headers': _sanitizeHeaders(requestHeaders),
      if (responseBody != null && responseBody.length <= 2000)
        'http.response_body': responseBody,
    };

    if (error != null) {
      await captureException(
        error,
        stackTrace: stackTrace,
        extras: extras,
      );
    } else {
      await captureMessage(
        'API failure: $method $url → $statusCode',
        level: level,
        extras: extras,
      );
    }
  }

  // ── Helpers ───────────────────────────────────────────────────────────────

  static const _redactedHeaders = {
    'authorization',
    'cookie',
    'set-cookie',
    'x-api-key',
  };

  Map<String, String> _sanitizeHeaders(Map<String, String> headers) {
    return {
      for (final entry in headers.entries)
        entry.key: _redactedHeaders.contains(entry.key.toLowerCase())
            ? '[redacted]'
            : entry.value,
    };
  }
}
