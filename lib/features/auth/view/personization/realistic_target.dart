import 'dart:math' as math;

import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/biggest_challenge.dart';
import 'package:diet_lenz/features/auth/view/personization/select_gender.dart';
import 'package:diet_lenz/pace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class RealisticTargetScreen extends ConsumerStatefulWidget {
  const RealisticTargetScreen({super.key});

  @override
  ConsumerState<RealisticTargetScreen> createState() =>
      _RealisticTargetScreenState();
}

class _RealisticTargetScreenState extends ConsumerState<RealisticTargetScreen> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // Future<void>.delayed(const Duration(seconds: 3), _continue);
  }

  void _continue() {
    if (!mounted || _hasNavigated) return;
    _hasNavigated = true;
    final projection = _projectionFrom(ref.read(onboardingProfileProvider));
    NavigationService.push(
      child: GoalPaceScreen(targetWeightKg: projection.targetWeightKg),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projection = _projectionFrom(ref.watch(onboardingProfileProvider));

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Column(
          children: [
            Expanded(
              child: Column(
                children: [
                  const Spacer(flex: 2),
                  _PredictionHeader(projection: projection),
                  const SizedBox(height: 72),
                  SizedBox(
                    height: 360,
                    width: double.infinity,
                    child: _ProjectionChart(projection: projection),
                  ),
                  const Spacer(flex: 2),
                  Text(
                    'By ${projection.midpointMonth}, you will be '
                    '${projection.midpointWeightKg.round()}kg',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textGrey,
                      fontSize: 17,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0,
                    ),
                  ),
                  const Spacer(flex: 3),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomYafButton(
                iconPositionLeft: false,
                text: "Continue",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  NavigationService.push(child: BiggestChallengeScreen());
                }),
            SizedBox(height: 15 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

class _PredictionHeader extends StatelessWidget {
  const _PredictionHeader({required this.projection});

  final _WeightProjection projection;

  @override
  Widget build(BuildContext context) {
    final action = projection.changeKg > 0 ? 'Losing' : 'Gaining';

    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 28,
              fontWeight: FontWeight.w600,
              height: 1.45,
              letterSpacing: 0,
            ),
            children: [
              TextSpan(text: '$action '),
              TextSpan(
                text: '${projection.changeKg.abs().round()}kg',
                style: const TextStyle(color: AppColors.primaryColor),
              ),
              const TextSpan(text: ' is a\nrealistic target'),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'We predict that by ${projection.targetDateLabel}\n'
          'You will reach your goal of\n'
          '${projection.targetWeightKg.round()}kg.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textGrey,
            fontSize: 17,
            fontWeight: FontWeight.w400,
            height: 1.15,
            letterSpacing: 0,
          ),
        ),
      ],
    );
  }
}

class _ProjectionChart extends StatelessWidget {
  const _ProjectionChart({required this.projection});

  final _WeightProjection projection;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _ProjectionChartPainter(projection),
      size: Size.infinite,
    );
  }
}

class _ProjectionChartPainter extends CustomPainter {
  _ProjectionChartPainter(this.projection);

  final _WeightProjection projection;

  static const _leftInset = 56.0;
  static const _rightInset = 24.0;
  static const _topInset = 36.0;
  static const _bottomInset = 48.0;

  @override
  void paint(Canvas canvas, Size size) {
    final chartWidth = size.width - _leftInset - _rightInset;
    final chartHeight = size.height - _topInset - _bottomInset;
    const chartLeft = _leftInset;
    const chartTop = _topInset;
    final chartBottom = chartTop + chartHeight;
    final chartRight = chartLeft + chartWidth;

    final minY = projection.chartMinKg;
    final maxY = projection.chartMaxKg;
    final rangeY = math.max(1, maxY - minY);

    double xFor(double progress) => chartLeft + chartWidth * progress;
    double yFor(double weight) =>
        chartBottom - ((weight - minY) / rangeY) * chartHeight;

    final points = _buildCurvePoints(xFor, yFor);
    final curve = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final previous = points[i - 1];
      final point = points[i];
      final midX = (previous.dx + point.dx) / 2;
      curve.cubicTo(midX, previous.dy, midX, point.dy, point.dx, point.dy);
    }

    final fillPath = Path.from(curve)
      ..lineTo(chartRight, chartBottom)
      ..lineTo(chartLeft, chartBottom)
      ..close();

    final fillPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color.fromRGBO(20, 111, 111, 0.28),
          Color.fromRGBO(20, 111, 111, 0.02),
        ],
      ).createShader(
          Rect.fromLTRB(chartLeft, chartTop, chartRight, chartBottom));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = const Color.fromRGBO(218, 241, 241, 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(curve, linePaint);

    _drawAxisLabels(canvas, size, xFor, yFor);
    _drawMarker(
      canvas,
      position: Offset(
          xFor(projection.midpointProgress), yFor(projection.midpointWeightKg)),
      label: '${projection.midpointWeightKg.round()}kg',
      labelColor: const Color.fromRGBO(18, 28, 55, 1),
      bubbleColor: AppColors.white,
      lineBottom: chartBottom,
    );
    _drawMarker(
      canvas,
      position: Offset(xFor(1), yFor(projection.targetWeightKg)),
      label: '${projection.targetWeightKg.round()}kg',
      labelColor: AppColors.white,
      bubbleColor: AppColors.primaryColor,
      lineBottom: chartBottom,
    );
  }

  List<Offset> _buildCurvePoints(
    double Function(double progress) xFor,
    double Function(double weight) yFor,
  ) {
    final start = projection.currentWeightKg;
    final end = projection.targetWeightKg;
    final loss = start > end;
    final delta = end - start;
    final weights = <double>[
      start,
      start + delta * 0.04,
      start + delta * 0.18,
      start + delta * 0.38,
      start + delta * 0.54,
      start + delta * 0.70,
      start + delta * 0.86,
      end,
    ];

    for (var i = 1; i < weights.length - 1; i++) {
      final wave = math.sin(i * math.pi / 2) * 0.65;
      weights[i] += loss ? wave : -wave;
    }

    return List.generate(weights.length, (index) {
      final progress = index / (weights.length - 1);
      return Offset(xFor(progress), yFor(weights[index]));
    });
  }

  void _drawAxisLabels(
    Canvas canvas,
    Size size,
    double Function(double progress) xFor,
    double Function(double weight) yFor,
  ) {
    final yLabels = <int>[];
    for (var value = projection.chartMaxKg.round();
        value >= projection.chartMinKg.round();
        value -= 10) {
      yLabels.add(value);
    }

    for (final value in yLabels) {
      _drawText(
        canvas,
        value.toString(),
        Offset(0, yFor(value.toDouble()) - 9),
        color: const Color.fromRGBO(113, 113, 118, 1),
        fontSize: 15,
      );
    }

    final monthLabels = projection.monthLabels;
    for (var i = 0; i < monthLabels.length; i++) {
      final progress =
          monthLabels.length == 1 ? 0.0 : i / (monthLabels.length - 1);
      final textSize = _measureText(monthLabels[i], 15, FontWeight.w400);
      _drawText(
        canvas,
        monthLabels[i],
        Offset(xFor(progress) - textSize.width / 2, size.height - 25),
        color: const Color.fromRGBO(151, 151, 154, 1),
        fontSize: 15,
      );
    }
  }

  void _drawMarker(
    Canvas canvas, {
    required Offset position,
    required String label,
    required Color labelColor,
    required Color bubbleColor,
    required double lineBottom,
  }) {
    final markerLinePaint = Paint()
      ..color = const Color.fromRGBO(255, 249, 163, 1)
      ..strokeWidth = 1.5;
    canvas.drawLine(
      Offset(position.dx, position.dy + 16),
      Offset(position.dx, lineBottom + 10),
      markerLinePaint,
    );

    canvas.drawCircle(
      position,
      12,
      Paint()..color = const Color.fromRGBO(255, 249, 163, 1),
    );
    canvas.drawCircle(position, 8, Paint()..color = AppColors.white);

    final textSize = _measureText(label, 12, FontWeight.w700);
    final bubbleRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        position.dx - textSize.width / 2 - 16,
        position.dy - 62,
        textSize.width + 32,
        38,
      ),
      const Radius.circular(6),
    );
    canvas.drawRRect(bubbleRect, Paint()..color = bubbleColor);

    final notch = Path()
      ..moveTo(position.dx - 7, bubbleRect.bottom - 1)
      ..lineTo(position.dx, bubbleRect.bottom + 8)
      ..lineTo(position.dx + 7, bubbleRect.bottom - 1)
      ..close();
    canvas.drawPath(notch, Paint()..color = bubbleColor);

    _drawText(
      canvas,
      label,
      Offset(position.dx - textSize.width / 2, bubbleRect.top + 12),
      color: labelColor,
      fontSize: 12,
      fontWeight: FontWeight.w700,
    );
  }

  Size _measureText(String text, double fontSize, FontWeight fontWeight) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(fontSize: fontSize, fontWeight: fontWeight),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.size;
  }

  void _drawText(
    Canvas canvas,
    String text,
    Offset offset, {
    required Color color,
    required double fontSize,
    FontWeight fontWeight = FontWeight.w400,
  }) {
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: fontWeight,
          letterSpacing: 0,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _ProjectionChartPainter oldDelegate) {
    return oldDelegate.projection != projection;
  }
}

class _WeightProjection {
  const _WeightProjection({
    required this.currentWeightKg,
    required this.targetWeightKg,
    required this.targetDate,
    required this.midpointDate,
    required this.midpointWeightKg,
    required this.monthLabels,
  });

  final double currentWeightKg;
  final double targetWeightKg;
  final DateTime targetDate;
  final DateTime midpointDate;
  final double midpointWeightKg;
  final List<String> monthLabels;

  double get changeKg => currentWeightKg - targetWeightKg;
  double get chartMinKg =>
      ((math.min(currentWeightKg, targetWeightKg) - 10) / 10).floorToDouble() *
      10;
  double get chartMaxKg =>
      ((math.max(currentWeightKg, targetWeightKg) + 10) / 10).ceilToDouble() *
      10;
  double get midpointProgress {
    final totalDays = targetDate.difference(DateTime.now()).inDays;
    final midpointDays = midpointDate.difference(DateTime.now()).inDays;
    if (totalDays <= 0) return 0.5;
    return (midpointDays / totalDays).clamp(0.35, 0.75);
  }

  String get targetDateLabel =>
      '${_monthName(targetDate.month)} ${targetDate.day}';
  String get midpointMonth => _monthName(midpointDate.month);
}

_WeightProjection _projectionFrom(OnboardingProfileData profile) {
  final currentWeightKg = _toKg(profile.weight, profile.weightUnit) ?? 120;
  final targetWeightKg =
      _toKg(profile.desiredWeight, profile.desiredWeightUnit) ?? 100;
  final changeKg = (currentWeightKg - targetWeightKg).abs();
  final weeks = (changeKg / 1.25).ceil().clamp(8, 32);
  final now = DateTime.now();
  final targetDate = now.add(Duration(days: weeks * 7));
  final midpointDate = now.add(Duration(days: (weeks * 7 / 2).round()));
  final midpointWeightKg =
      currentWeightKg + (targetWeightKg - currentWeightKg) / 2;

  return _WeightProjection(
    currentWeightKg: currentWeightKg,
    targetWeightKg: targetWeightKg,
    targetDate: targetDate,
    midpointDate: midpointDate,
    midpointWeightKg: midpointWeightKg,
    monthLabels: _monthLabels(now, targetDate),
  );
}

double? _toKg(double? value, String? unit) {
  if (value == null) return null;
  if (unit?.toLowerCase() == 'lbs') {
    return value * 0.45359237;
  }
  return value;
}

List<String> _monthLabels(DateTime start, DateTime end) {
  final labels = <String>[];
  var cursor = DateTime(start.year, start.month);
  final last = DateTime(end.year, end.month);

  while (!cursor.isAfter(last) && labels.length < 6) {
    labels.add(_monthShortName(cursor.month));
    cursor = DateTime(cursor.year, cursor.month + 1);
  }

  while (labels.length < 6) {
    cursor = DateTime(cursor.year, cursor.month + 1);
    labels.add(_monthShortName(cursor.month));
  }

  return labels;
}

String _monthName(int month) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return months[(month - 1).clamp(0, 11)];
}

String _monthShortName(int month) {
  const months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'June',
    'July',
    'Aug',
    'Sept',
    'Oct',
    'Nov',
    'Dec',
  ];
  return months[(month - 1).clamp(0, 11)];
}
