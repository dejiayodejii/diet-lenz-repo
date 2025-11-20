import 'package:diet_lenz/constants/app_fonts.dart';
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
    this.progressColor = const Color.fromRGBO(246, 111, 30, 1),
    this.backgroundColor = const Color.fromRGBO(18, 18, 18, 1),
    this.minHeight = 6.0,
    this.borderRadius = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              "- $currentValue/$targetValue ",
              style: const TextStyle(
                fontFamily: AppFonts.lato,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          minHeight: minHeight,
          value: progress.clamp(0.0, 1.0),
          borderRadius: BorderRadius.circular(borderRadius),
          backgroundColor: backgroundColor,
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        ),
      ],
    );
  }
}
