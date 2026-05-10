import 'package:upgrader/upgrader.dart';

/// Service that configures and provides an [Upgrader] instance
/// for checking app store updates.
///
/// Usage: inject via Riverpod or construct once and pass to [AppUpdateAlert].
class AppUpdateService {
  static final AppUpdateService _instance = AppUpdateService._internal();

  factory AppUpdateService() => _instance;

  AppUpdateService._internal();

  Upgrader? _upgrader;

  /// Returns a configured [Upgrader] singleton.
  ///
  /// Set [debugLogging] to true during development to force the dialog to show.
  Upgrader get upgrader {
    _upgrader ??= Upgrader(
      // debugDisplayOnce: true,
      // Show the dialog at most once every 3 days.
      durationUntilAlertAgain: const Duration(days: 3),
      // Set to true during development to always show the dialog.
      debugLogging: false,
    );
    return _upgrader!;
  }

  /// Clears the stored upgrade state (useful for testing).
  Future<void> clearSavedState() async {
    await Upgrader.clearSavedSettings();
  }
}
