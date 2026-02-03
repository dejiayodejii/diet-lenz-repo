import 'package:diet_lenz/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MeasurementValueDisplay extends StatelessWidget {
  final double value;
  final String unit;

  const MeasurementValueDisplay({
    super.key,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    // Format value based on unit.
    // If unit is 'ft', show 1 decimal place. Otherwise show as integer.
    final displayValue =
        (unit == 'ft') ? value.toStringAsFixed(1) : value.round().toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          displayValue,
          style: const TextStyle(
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: AppColors.white,
            letterSpacing: -2,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          unit,
          style: const TextStyle(
            color: Color.fromRGBO(158, 160, 165, 1),
            fontSize: 24,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
