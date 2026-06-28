import 'package:diet_lenz/constants/app_colors.dart';
import 'package:flutter/material.dart';

const _bmiColors = [
  Color(0xFF3B82F6),
  Color(0xFF22C55E),
  Color(0xFF86EFAC),
  Color(0xFFFFD700),
  Color(0xFFF97316),
  Color(0xFFEF4444),
];

class BmiColorScheme extends StatelessWidget {
  const BmiColorScheme({
    super.key,
    required this.weightKg,
    required this.heightMeters,
    this.label = 'BMI',
  });

  final double weightKg;
  final double heightMeters;
  final String label;

  double get _bmi {
    if (weightKg <= 0 || heightMeters <= 0) return 0;
    return weightKg / (heightMeters * heightMeters);
  }

  String get _category {
    if (_bmi <= 0) return 'Unknown';
    if (_bmi < 18.5) return 'Underweight';
    if (_bmi < 25) return 'Healthy Range';
    if (_bmi < 30) return 'Overweight';
    return 'Obese';
  }

  double get _progress {
    const min = 15.0;
    const max = 40.0;
    return ((_bmi - min) / (max - min)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final markerX = _progress * constraints.maxWidth;

            return Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 10,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    gradient: const LinearGradient(colors: _bmiColors),
                  ),
                ),
                Positioned(
                  top: -24,
                  left: (markerX - 32).clamp(0, constraints.maxWidth - 64),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      _category == 'Healthy Range' ? 'Normal' : _category,
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.backgroundColor,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  left: (markerX - 5).clamp(0, constraints.maxWidth - 10),
                  child: CustomPaint(
                    size: const Size(10, 6),
                    painter: _TrianglePainter(),
                  ),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          '$label: ${_bmi.toStringAsFixed(1)} - $_category',
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white;
    final path = Path()
      ..moveTo(size.width / 2, 0)
      ..lineTo(0, size.height)
      ..lineTo(size.width, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
