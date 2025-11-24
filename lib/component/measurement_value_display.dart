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
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: "${value.toInt()}",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 96,
                  fontWeight: FontWeight.w800,
                ),
              ),
              TextSpan(
                text: unit,
                style: const TextStyle(
                  color: Color.fromRGBO(158, 160, 165, 1),
                  fontSize: 36,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
