/// App font family constants
///
/// This class contains all the font family names used in the app.
/// Use these constants instead of hardcoding font family strings.
class AppFonts {
  AppFonts._(); // Private constructor to prevent instantiation

  /// Lato font family
  /// Available weights: 100 (Thin), 300 (Light), 400 (Regular), 700 (Bold), 900 (Black)
  /// Supports italic variants for all weights
  static const String lato = 'Lato';

  /// Space Grotesk font family
  /// Available weights: 300 (Light), 400 (Regular), 500 (Medium), 600 (SemiBold), 700 (Bold)
  /// No italic variants available
  static const String spaceGrotesk = 'SpaceGrotesk';

  /// Work Sans font family
  /// Available weights: 100 (Thin), 200 (ExtraLight), 300 (Light), 400 (Regular),
  /// 500 (Medium), 600 (SemiBold), 700 (Bold), 800 (ExtraBold), 900 (Black)
  /// Supports italic variants for all weights
  static const String workSans = 'WorkSans';
}
