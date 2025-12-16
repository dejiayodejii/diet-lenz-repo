import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MacroProgressItem extends StatelessWidget {
  final String label;
  final String currentValue;
  final String targetValue;
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double minHeight;
  final double borderRadius;

  const MacroProgressItem({
    Key? key,
    required this.label,
    required this.currentValue,
    required this.targetValue,
    required this.progress,
    this.progressColor = AppColors.primary,
    this.backgroundColor = const Color.fromRGBO(18, 18, 18, 1),
    this.minHeight = 6.0,
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final hasTarget = targetValue.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              "$label ",
              style: const TextStyle(
                fontFamily: AppFonts.lato,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              hasTarget ? "- $currentValue/$targetValue " : "- $currentValue",
              style: const TextStyle(
                fontFamily: AppFonts.lato,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Show progress bar (with relative comparison if no target, or actual progress if target exists)
        LinearProgressIndicator(
          minHeight: minHeight,
          value: progress.clamp(0.0, 1.0),
          borderRadius: BorderRadius.circular(borderRadius),
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(
            hasTarget ? progressColor : progressColor.withOpacity(0.7),
          ),
        ),
      ],
    );
  }
}
