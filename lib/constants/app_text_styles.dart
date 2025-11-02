import 'package:flutter/material.dart';
import 'app_fonts.dart';

/// App text styles using the custom fonts
///
/// This class provides pre-configured text styles for common use cases.
/// All styles use the app's custom font families.
class AppTextStyles {
  AppTextStyles._(); // Private constructor to prevent instantiation

  // Lato styles
  static const TextStyle latoHeading = TextStyle(
    fontFamily: AppFonts.lato,
    fontWeight: FontWeight.w700, // Bold
    fontSize: 24,
  );

  static const TextStyle latoSubheading = TextStyle(
    fontFamily: AppFonts.lato,
    fontWeight: FontWeight.w600,
    fontSize: 18,
  );

  static const TextStyle latoBody = TextStyle(
    fontFamily: AppFonts.lato,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 16,
  );

  static const TextStyle latoCaption = TextStyle(
    fontFamily: AppFonts.lato,
    fontWeight: FontWeight.w300, // Light
    fontSize: 12,
  );

  // Space Grotesk styles (great for modern, tech-focused text)
  static const TextStyle spaceGroteskTitle = TextStyle(
    fontFamily: AppFonts.spaceGrotesk,
    fontWeight: FontWeight.w700, // Bold
    fontSize: 28,
  );

  static const TextStyle spaceGroteskSubtitle = TextStyle(
    fontFamily: AppFonts.spaceGrotesk,
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 20,
  );

  static const TextStyle spaceGroteskBody = TextStyle(
    fontFamily: AppFonts.spaceGrotesk,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 16,
  );

  // Work Sans styles (excellent for body text and UI elements)
  static const TextStyle workSansHeading = TextStyle(
    fontFamily: AppFonts.workSans,
    fontWeight: FontWeight.w700, // Bold
    fontSize: 24,
  );

  static const TextStyle workSansSubheading = TextStyle(
    fontFamily: AppFonts.workSans,
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 18,
  );

  static const TextStyle workSansBody = TextStyle(
    fontFamily: AppFonts.workSans,
    fontWeight: FontWeight.w400, // Regular
    fontSize: 16,
  );

  static const TextStyle workSansBodyMedium = TextStyle(
    fontFamily: AppFonts.workSans,
    fontWeight: FontWeight.w500, // Medium
    fontSize: 16,
  );

  static const TextStyle workSansCaption = TextStyle(
    fontFamily: AppFonts.workSans,
    fontWeight: FontWeight.w300, // Light
    fontSize: 12,
  );

  static const TextStyle workSansButton = TextStyle(
    fontFamily: AppFonts.workSans,
    fontWeight: FontWeight.w600, // SemiBold
    fontSize: 14,
  );
}
