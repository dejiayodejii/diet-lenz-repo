import 'package:diet_lenz/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'app_fonts.dart';

/// App theme configuration
///
/// This class provides the dark theme configuration for the Diet Lenz app.
/// Uses Lato as the default font family and customizes all Material components.
class AppTheme {
  AppTheme._(); // Private constructor to prevent instantiation

  // Color scheme for dark theme
  static const ColorScheme _darkColorScheme = ColorScheme.dark(
    brightness: Brightness.dark,
    primary: AppColors.primaryColor, // Purple
    onPrimary: Colors.white,
    primaryContainer: Color.fromRGBO(75, 68, 199, 1),
    onPrimaryContainer: Color.fromRGBO(225, 221, 255, 1),
    secondary: AppColors.secondaryColor, // Teal
    onSecondary: Color.fromRGBO(0, 0, 0, 1),
    secondaryContainer: Color.fromRGBO(0, 80, 72, 1),
    onSecondaryContainer: Color.fromRGBO(127, 242, 231, 1),
    error: Color.fromRGBO(207, 102, 121, 1),
    onError: Color.fromRGBO(0, 0, 0, 1),
    errorContainer: Color.fromRGBO(176, 0, 32, 1),
    onErrorContainer: Color.fromRGBO(255, 218, 214, 1),
    surface: Color.fromRGBO(18, 18, 18, 1),
    onSurface: Color.fromRGBO(255, 255, 255, 1),
    surfaceVariant: Color.fromRGBO(30, 30, 30, 1),
    onSurfaceVariant: Color.fromRGBO(202, 202, 202, 1),
    outline: Color.fromRGBO(121, 116, 126, 1),
    background: AppColors.backgroundColor,
    onBackground: Color.fromRGBO(255, 255, 255, 1),
  );

  /// Main dark theme for the app
  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: _darkColorScheme,

      // Set Lato as the default font family
      fontFamily: AppFonts.lato,

      // Text theme using Lato
      textTheme: const TextTheme(
        // Display styles
        displayLarge: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w300,
          fontSize: 57,
        ),
        displayMedium: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 45,
        ),
        displaySmall: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 36,
        ),

        // Headline styles
        headlineLarge: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 32,
        ),
        headlineMedium: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 28,
        ),
        headlineSmall: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 24,
        ),

        // Title styles
        titleLarge: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 22,
        ),
        titleMedium: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w500,
          fontSize: 16,
        ),
        titleSmall: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),

        // Body styles
        bodyLarge: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),

        // Label styles
        labelLarge: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        labelMedium: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
        labelSmall: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w500,
          fontSize: 11,
        ),
      ),

      // AppBar theme
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.backgroundColor,
        foregroundColor: Color(0xFFFFFFFF),
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: Color(0xFFFFFFFF),
        ),
        iconTheme: IconThemeData(
          color: Color(0xFFFFFFFF),
        ),
      ),

      // Scaffold theme
      scaffoldBackgroundColor: AppColors.backgroundColor,

      // Elevated button theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _darkColorScheme.primary,
          foregroundColor: _darkColorScheme.onPrimary,
          textStyle: const TextStyle(
            fontFamily: AppFonts.lato,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text button theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: _darkColorScheme.primary,
          textStyle: const TextStyle(
            fontFamily: AppFonts.lato,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ),

      // Outlined button theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _darkColorScheme.primary,
          side: BorderSide(color: _darkColorScheme.primary),
          textStyle: const TextStyle(
            fontFamily: AppFonts.lato,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
      ),

      // Text field theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: _darkColorScheme.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkColorScheme.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkColorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkColorScheme.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: _darkColorScheme.error, width: 2),
        ),
        labelStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
        ),
        hintStyle: TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          color: _darkColorScheme.onSurfaceVariant.withOpacity(0.6),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),

      // Card theme
      cardTheme: CardTheme(
        color: _darkColorScheme.surface,
        surfaceTintColor: _darkColorScheme.surfaceVariant,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Bottom navigation bar theme
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: _darkColorScheme.surface,
        selectedItemColor: _darkColorScheme.primary,
        unselectedItemColor: _darkColorScheme.onSurfaceVariant,
        selectedLabelStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w600,
          fontSize: 12,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 12,
        ),
        type: BottomNavigationBarType.fixed,
      ),

      // Dialog theme
      dialogTheme: DialogTheme(
        backgroundColor: _darkColorScheme.surface,
        titleTextStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
        contentTextStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 16,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Chip theme
      chipTheme: ChipThemeData(
        backgroundColor: _darkColorScheme.surfaceVariant,
        selectedColor: _darkColorScheme.primary,
        labelStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),

      // Switch theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _darkColorScheme.primary;
          }
          return _darkColorScheme.outline;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _darkColorScheme.primary.withOpacity(0.5);
          }
          return _darkColorScheme.surfaceVariant;
        }),
      ),

      // Checkbox theme
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _darkColorScheme.primary;
          }
          return Colors.transparent;
        }),
        checkColor: MaterialStateProperty.all(_darkColorScheme.onPrimary),
      ),

      // Radio theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return _darkColorScheme.primary;
          }
          return _darkColorScheme.outline;
        }),
      ),

      // FloatingActionButton theme
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: _darkColorScheme.primary,
        foregroundColor: _darkColorScheme.onPrimary,
        shape: const CircleBorder(),
      ),

      // SnackBar theme
      snackBarTheme: SnackBarThemeData(
        backgroundColor: _darkColorScheme.surfaceVariant,
        contentTextStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        actionTextColor: _darkColorScheme.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // Tab bar theme
      tabBarTheme: TabBarTheme(
        labelColor: _darkColorScheme.primary,
        unselectedLabelColor: _darkColorScheme.onSurfaceVariant,
        labelStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
        unselectedLabelStyle: const TextStyle(
          fontFamily: AppFonts.lato,
          fontWeight: FontWeight.w400,
          fontSize: 14,
        ),
        indicator: UnderlineTabIndicator(
          borderSide: BorderSide(
            color: _darkColorScheme.primary,
            width: 2,
          ),
        ),
      ),
    );
  }
}

extension ThemeExtension on BuildContext {
  ColorScheme get colors => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
