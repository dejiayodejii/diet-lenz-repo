import 'dart:math' as math;

import 'package:openapi/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/biggest_challenge.dart';
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
  late Future<_WeightProjection> _projectionFuture;

  @override
  void initState() {
    super.initState();
    _projectionFuture = _loadProjection();
  }

  Future<_WeightProjection> _loadProjection() async {
    final profile = ref.read(onboardingProfileProvider);
    try {
      final request = _projectionRequest(profile);
      final response = await ref
          .read(apiServiceProvider)
          .onboardingCalculatorApi
          .calculateProjection(request);

      if (response == null) {
        throw StateError('Projection response was empty');
      }

      return _WeightProjection.fromResponse(response);
    } catch (_) {
      return _projectionFrom(profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(onboardingProfileProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28),
        child: FutureBuilder<_WeightProjection>(
          future: _projectionFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryColor,
                ),
              );
            }

            final projection = snapshot.data!;

            return Column(
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
                        '${projection.formatWeight(projection.midpointWeightKg)}',
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
                      NavigationService.push(
                          child: const BiggestChallengeScreen());
                    }),
                SizedBox(height: 15 + MediaQuery.of(context).padding.bottom),
              ],
            );
          },
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
    final description = projection.headline.isNotEmpty
        ? projection.headline
        : 'We predict that by ${projection.targetDateLabel}\n'
            'You will reach your goal of\n'
            '${projection.formatWeight(projection.targetWeightKg)}.';

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
                text: projection.formatWeight(projection.changeKg.abs()),
                style: const TextStyle(color: AppColors.primaryColor),
              ),
              const TextSpan(text: ' is a\nrealistic target'),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          description,
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
      label: projection.formatWeight(projection.midpointWeightKg),
      labelColor: const Color.fromRGBO(18, 28, 55, 1),
      bubbleColor: AppColors.white,
      lineBottom: chartBottom,
    );
    _drawMarker(
      canvas,
      position: Offset(xFor(1), yFor(projection.targetWeightKg)),
      label: projection.formatWeight(projection.targetWeightKg),
      labelColor: AppColors.white,
      bubbleColor: AppColors.primaryColor,
      lineBottom: chartBottom,
    );
  }

  List<Offset> _buildCurvePoints(
    double Function(double progress) xFor,
    double Function(double weight) yFor,
  ) {
    final points = projection.points;
    return List.generate(points.length, (index) {
      final progress = points.length == 1 ? 0.0 : index / (points.length - 1);
      return Offset(xFor(progress), yFor(points[index].weightKg));
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
    required this.points,
    required this.headline,
    required this.unitLabel,
  });

  factory _WeightProjection.fromResponse(ProjectionResponse response) {
    final points = response.points.map(_ProjectionPoint.fromResponse).toList();
    final currentWeight = response.currentWeight?.toDouble() ?? 0;
    final targetWeight = response.targetWeight?.toDouble() ?? currentWeight;
    final targetDate = response.projectedGoalDate ?? DateTime.now();
    final safePoints = points.isEmpty
        ? [
            _ProjectionPoint(date: DateTime.now(), weightKg: currentWeight),
            _ProjectionPoint(date: targetDate, weightKg: targetWeight),
          ]
        : points;
    final midpointPoint = safePoints[safePoints.length ~/ 2];

    return _WeightProjection(
      currentWeightKg: currentWeight,
      targetWeightKg: targetWeight,
      targetDate: targetDate,
      midpointDate: midpointPoint.date,
      midpointWeightKg: midpointPoint.weightKg,
      monthLabels: _monthLabelsFromPoints(safePoints),
      points: safePoints,
      headline: response.headline ?? '',
      unitLabel: _unitLabel(response.unit),
    );
  }

  final double currentWeightKg;
  final double targetWeightKg;
  final DateTime targetDate;
  final DateTime midpointDate;
  final double midpointWeightKg;
  final List<String> monthLabels;
  final List<_ProjectionPoint> points;
  final String headline;
  final String unitLabel;

  double get changeKg => currentWeightKg - targetWeightKg;
  double get chartMinKg => ((_minPointWeight - 10) / 10).floorToDouble() * 10;
  double get chartMaxKg => ((_maxPointWeight + 10) / 10).ceilToDouble() * 10;

  double get _minPointWeight {
    return points
        .map((point) => point.weightKg)
        .fold(math.min(currentWeightKg, targetWeightKg), math.min);
  }

  double get _maxPointWeight {
    return points
        .map((point) => point.weightKg)
        .fold(math.max(currentWeightKg, targetWeightKg), math.max);
  }

  double get midpointProgress {
    final totalDays = targetDate.difference(DateTime.now()).inDays;
    final midpointDays = midpointDate.difference(DateTime.now()).inDays;
    if (totalDays <= 0) return 0.5;
    return (midpointDays / totalDays).clamp(0.35, 0.75);
  }

  String get targetDateLabel =>
      '${_monthName(targetDate.month)} ${targetDate.day}';
  String get midpointMonth => _monthName(midpointDate.month);

  String formatWeight(double value) => '${value.round()}$unitLabel';
}

class _ProjectionPoint {
  const _ProjectionPoint({
    required this.date,
    required this.weightKg,
  });

  final DateTime date;
  final double weightKg;

  factory _ProjectionPoint.fromResponse(ProjectionPoint point) {
    return _ProjectionPoint(
      date: point.date ?? DateTime.now(),
      weightKg: point.weight?.toDouble() ?? 0,
    );
  }
}

MacroPreviewRequest _projectionRequest(OnboardingProfileData profile) {
  final missingField = _firstMissingProjectionField(profile);
  if (missingField != null) {
    throw StateError('Missing $missingField');
  }

  final targetEvent = _targetEvent(profile.targetEvent);
  return MacroPreviewRequest(
    gender: _gender(profile.gender!),
    dateOfBirth: profile.dateOfBirth!,
    height: profile.height!,
    heightUnit: _heightUnit(profile.heightUnit!),
    currentWeight: profile.weight!.round(),
    currentWeightUnit: _currentWeightUnit(profile.weightUnit!),
    activityLevel: _activityLevel(profile.activityLevel!),
    desiredGoal: _desiredGoal(profile.goal!),
    desiredWeight: profile.desiredWeight!.round(),
    desiredWeightUnit: _desiredWeightUnit(profile.desiredWeightUnit!),
    goalPace: _goalPace(profile.goalPace!),
    macroTarget: _macroTarget(profile.macroTarget),
    targetEvent: targetEvent,
    targetEventDate: targetEvent != null &&
            targetEvent != MacroPreviewRequestTargetEventEnum.NONE
        ? profile.targetEventDate
        : null,
  );
}

String? _firstMissingProjectionField(OnboardingProfileData data) {
  final requiredFields = <String, Object?>{
    'gender': data.gender,
    'date of birth': data.dateOfBirth,
    'height': data.height,
    'height unit': data.heightUnit,
    'current weight': data.weight,
    'current weight unit': data.weightUnit,
    'activity level': data.activityLevel,
    'goal': data.goal,
    'target weight': data.desiredWeight,
    'target weight unit': data.desiredWeightUnit,
    'goal pace': data.goalPace,
  };

  for (final entry in requiredFields.entries) {
    final value = entry.value;
    if (value == null || (value is String && value.trim().isEmpty)) {
      return entry.key;
    }
  }
  return null;
}

MacroPreviewRequestGenderEnum _gender(String value) {
  switch (_normalized(value)) {
    case 'MALE':
      return MacroPreviewRequestGenderEnum.MALE;
    case 'FEMALE':
      return MacroPreviewRequestGenderEnum.FEMALE;
    default:
      return MacroPreviewRequestGenderEnum.OTHER;
  }
}

MacroPreviewRequestHeightUnitEnum _heightUnit(String value) {
  return _normalized(value) == 'CM'
      ? MacroPreviewRequestHeightUnitEnum.CM
      : MacroPreviewRequestHeightUnitEnum.FT;
}

MacroPreviewRequestCurrentWeightUnitEnum _currentWeightUnit(String value) {
  return _normalized(value) == 'KG'
      ? MacroPreviewRequestCurrentWeightUnitEnum.KG
      : MacroPreviewRequestCurrentWeightUnitEnum.POUNDS;
}

MacroPreviewRequestDesiredWeightUnitEnum _desiredWeightUnit(String value) {
  return _normalized(value) == 'KG'
      ? MacroPreviewRequestDesiredWeightUnitEnum.KG
      : MacroPreviewRequestDesiredWeightUnitEnum.POUNDS;
}

MacroPreviewRequestActivityLevelEnum _activityLevel(String value) {
  switch (_normalized(value)) {
    case 'LIGHTLY_ACTIVE':
      return MacroPreviewRequestActivityLevelEnum.LIGHTLY_ACTIVE;
    case 'MODERATELY_ACTIVE':
      return MacroPreviewRequestActivityLevelEnum.MODERATELY_ACTIVE;
    case 'VERY_ACTIVE':
      return MacroPreviewRequestActivityLevelEnum.VERY_ACTIVE;
    case 'EXTRA_ACTIVE':
      return MacroPreviewRequestActivityLevelEnum.EXTRA_ACTIVE;
    default:
      return MacroPreviewRequestActivityLevelEnum.SEDENTARY;
  }
}

MacroPreviewRequestDesiredGoalEnum _desiredGoal(String value) {
  final normalized = _normalized(value);
  if (normalized.contains('LOSE')) {
    return MacroPreviewRequestDesiredGoalEnum.LOSE_WEIGHT;
  }
  if (normalized.contains('GAIN')) {
    return MacroPreviewRequestDesiredGoalEnum.GAIN_WEIGHT;
  }
  if (normalized.contains('MAINTAIN')) {
    return MacroPreviewRequestDesiredGoalEnum.MAINTAIN_WEIGHT;
  }
  return MacroPreviewRequestDesiredGoalEnum.NOTHING;
}

MacroPreviewRequestGoalPaceEnum _goalPace(String value) {
  switch (_normalized(value)) {
    case 'SLOW':
      return MacroPreviewRequestGoalPaceEnum.SLOW;
    case 'FAST':
      return MacroPreviewRequestGoalPaceEnum.FAST;
    default:
      return MacroPreviewRequestGoalPaceEnum.OPTIMAL;
  }
}

MacroPreviewRequestMacroTargetEnum _macroTarget(String? value) {
  switch (_normalized(value)) {
    case 'HIGH_PROTEIN':
      return MacroPreviewRequestMacroTargetEnum.HIGH_PROTEIN;
    case 'LOW_CARB':
      return MacroPreviewRequestMacroTargetEnum.LOW_CARB;
    case 'LOW_FAT':
      return MacroPreviewRequestMacroTargetEnum.LOW_FAT;
    case 'HIGH_FIBER':
      return MacroPreviewRequestMacroTargetEnum.HIGH_FIBER;
    default:
      return MacroPreviewRequestMacroTargetEnum.BALANCED;
  }
}

MacroPreviewRequestTargetEventEnum? _targetEvent(String? value) {
  switch (_normalized(value)) {
    case 'VACATION':
      return MacroPreviewRequestTargetEventEnum.VACATION;
    case 'WEDDING':
      return MacroPreviewRequestTargetEventEnum.WEDDING;
    case 'BIRTHDAY':
      return MacroPreviewRequestTargetEventEnum.BIRTHDAY;
    case 'PERSONAL_MILESTONE':
      return MacroPreviewRequestTargetEventEnum.PERSONAL_MILESTONE;
    case 'NONE':
      return MacroPreviewRequestTargetEventEnum.NONE;
    default:
      return null;
  }
}

String _normalized(String? value) {
  return (value ?? '')
      .trim()
      .toUpperCase()
      .replaceAll(RegExp(r'[^A-Z0-9]+'), '_')
      .replaceAll(RegExp(r'_+'), '_')
      .replaceAll(RegExp(r'^_|_$'), '');
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
  final points = List.generate(8, (index) {
    final progress = index / 7;
    final date = now.add(Duration(days: (weeks * 7 * progress).round()));
    final weight =
        currentWeightKg + ((targetWeightKg - currentWeightKg) * progress);
    return _ProjectionPoint(date: date, weightKg: weight);
  });

  return _WeightProjection(
    currentWeightKg: currentWeightKg,
    targetWeightKg: targetWeightKg,
    targetDate: targetDate,
    midpointDate: midpointDate,
    midpointWeightKg: midpointWeightKg,
    monthLabels: _monthLabels(now, targetDate),
    points: points,
    headline: '',
    unitLabel: 'kg',
  );
}

String _unitLabel(String? value) {
  return _normalized(value) == 'POUNDS' ? 'lbs' : 'kg';
}

List<String> _monthLabelsFromPoints(List<_ProjectionPoint> points) {
  if (points.isEmpty) return _monthLabels(DateTime.now(), DateTime.now());

  final labels = <String>[];
  final step = math.max(1, (points.length / 5).ceil());
  for (var i = 0; i < points.length && labels.length < 6; i += step) {
    labels.add(_monthShortName(points[i].date.month));
  }
  if (labels.last != _monthShortName(points.last.date.month)) {
    labels.add(_monthShortName(points.last.date.month));
  }
  return labels.take(6).toList();
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
