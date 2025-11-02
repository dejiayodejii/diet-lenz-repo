import 'dart:ui';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:flutter/material.dart';

/// Custom dialog with blurred background
///
/// This dialog provides a modern look with:
/// - Blurred background effect
/// - Custom title and subtitle
/// - Elevated button with fixed width of 250
class BlurredDialog extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonText;
  final VoidCallback onButtonPressed;
  final Color? backgroundColor;
  final Color? buttonColor;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  const BlurredDialog({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonText,
    required this.onButtonPressed,
    this.backgroundColor,
    this.buttonColor,
    this.titleStyle,
    this.subtitleStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Blurred background
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(color: Color.fromRGBO(0, 0, 0, 0.5)),
          ),
        ),
        // Dialog content
        Center(
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 15),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.borderColor,
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: titleStyle ??
                        Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.w600, fontSize: 24),
                  ),
                  const SizedBox(height: 15),

                  // Subtitle
                  Text(
                    subtitle,
                    textAlign: TextAlign.center,
                    style: subtitleStyle ??
                        Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontSize: 15,
                            fontFamily: AppFonts.spaceGrotesk,
                            fontWeight: FontWeight.w400,
                            color: AppColors.white),
                  ),
                  const SizedBox(height: 32),

                  // Button with fixed width of 250
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: onButtonPressed,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor ??
                            Theme.of(context).colorScheme.primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// Show the blurred dialog
  static Future<void> show({
    required BuildContext context,
    required String title,
    required String subtitle,
    required String buttonText,
    required VoidCallback onButtonPressed,
    Color? backgroundColor,
    Color? buttonColor,
    TextStyle? titleStyle,
    TextStyle? subtitleStyle,
    bool barrierDismissible = true,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: barrierDismissible,
      barrierColor:
          Colors.transparent, // Make barrier transparent since we handle blur
      builder: (context) => BlurredDialog(
        title: title,
        subtitle: subtitle,
        buttonText: buttonText,
        onButtonPressed: onButtonPressed,
        backgroundColor: backgroundColor,
        buttonColor: buttonColor,
        titleStyle: titleStyle,
        subtitleStyle: subtitleStyle,
      ),
    );
  }
}
