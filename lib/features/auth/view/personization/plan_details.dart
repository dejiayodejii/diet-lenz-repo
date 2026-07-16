import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:openapi/api.dart';

class PlanDetailsScreen extends ConsumerStatefulWidget {
  const PlanDetailsScreen({super.key});

  @override
  ConsumerState<PlanDetailsScreen> createState() => _PlanDetailsScreenState();
}

class _PlanDetailsScreenState extends ConsumerState<PlanDetailsScreen> {
  late Future<_PlanDetailsData> _planFuture;

  @override
  void initState() {
    super.initState();
    _planFuture = _loadPlan();
  }

  Future<_PlanDetailsData> _loadPlan() async {
    final profile = ref.read(onboardingProfileProvider);
    try {
      final response = await ref
          .read(apiServiceProvider)
          .onboardingCalculatorApi
          .calculatePlan(_planRequest(profile));
      if (response == null) throw StateError('Plan response was empty');
      return _PlanDetailsData.fromResponse(response, profile);
    } catch (_) {
      return _PlanDetailsData.fromProfile(profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: FutureBuilder<_PlanDetailsData>(
            future: _planFuture,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryColor,
                  ),
                );
              }

              return _PlanContent(plan: snapshot.data!);
            },
          ),
        ),
      ),
    );
  }
}

class _PlanContent extends StatelessWidget {
  const _PlanContent({required this.plan});

  final _PlanDetailsData plan;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final contentWidth = math.min(constraints.maxWidth, 520.0);
        return Center(
          child: SizedBox(
            width: contentWidth,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _ConfettiPainter()),
                  ),
                ),
                SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    16,
                    56,
                    16,
                    24 + MediaQuery.paddingOf(context).bottom,
                  ),
                  child: Column(
                    children: [
                      const Text(
                        'Your personalized plan is',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontFamily: AppFonts.lato,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const Text(
                        'Ready',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontFamily: AppFonts.lato,
                          fontSize: 70,
                          height: 1.04,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Your plan is built around your goal,\n'
                        'lifestyle, and preference',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.white,
                          fontFamily: AppFonts.lato,
                          fontSize: 14,
                          height: 1.25,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 28),
                      _CaloriesCard(calories: plan.dailyCalories),
                      const SizedBox(height: 17),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Your macros',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontFamily: AppFonts.lato,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      _MacrosCard(plan: plan),
                      const SizedBox(height: 34),
                      _GoalsCard(plan: plan),
                      const SizedBox(height: 30),
                      CustomYafButton(
                        text: "Continue",
                        onPressed: () {
                          NavigationService.push(
                            child: const SignUpScreen(),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CaloriesCard extends StatelessWidget {
  const _CaloriesCard({required this.calories});

  final int calories;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 127,
      decoration: BoxDecoration(
        color: const Color(0xFF080A0B),
        border: Border.all(color: AppColors.primaryColor),
        borderRadius: BorderRadius.circular(34),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFF8A2E0E),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.local_fire_department_outlined,
                  color: AppColors.white,
                  size: 19,
                ),
                SizedBox(width: 4),
                Text(
                  'Daily Calories',
                  style: TextStyle(
                    color: AppColors.white,
                    fontFamily: AppFonts.lato,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '$calories',
            style: const TextStyle(
              color: AppColors.white,
              fontFamily: AppFonts.lato,
              fontSize: 54,
              height: 0.96,
              fontWeight: FontWeight.w700,
              letterSpacing: 1,
            ),
          ),
          const Text(
            'kcal/day',
            style: TextStyle(
              color: AppColors.textGrey,
              fontFamily: AppFonts.lato,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _MacrosCard extends StatelessWidget {
  const _MacrosCard({required this.plan});

  final _PlanDetailsData plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 107,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFF6D6D70)),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        children: [
          _MacroLegend(
            color: const Color(0xFFA9A9AB),
            title: 'Carbs',
            grams: plan.carbs,
          ),
          const Spacer(),
          SizedBox(
            width: 78,
            height: 78,
            child: CustomPaint(
              painter: _MacroChartPainter(
                carbs: plan.carbs.toDouble(),
                protein: plan.protein.toDouble(),
                fat: plan.fat.toDouble(),
              ),
            ),
          ),
          const Spacer(),
          _MacroLegend(
            color: AppColors.primaryColor,
            title: 'Protein',
            grams: plan.protein,
          ),
          const SizedBox(width: 8),
          _MacroLegend(
            color: AppColors.white,
            title: 'Fats',
            grams: plan.fat,
          ),
        ],
      ),
    );
  }
}

class _MacroLegend extends StatelessWidget {
  const _MacroLegend({
    required this.color,
    required this.title,
    required this.grams,
  });

  final Color color;
  final String title;
  final int grams;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(5),
          ),
        ),
        const SizedBox(height: 3),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.white,
            fontFamily: AppFonts.lato,
            fontSize: 16,
            height: 1.05,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${grams}g',
          style: const TextStyle(
            color: AppColors.white,
            fontFamily: AppFonts.lato,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class _GoalsCard extends StatelessWidget {
  const _GoalsCard({required this.plan});

  final _PlanDetailsData plan;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 242,
      padding: const EdgeInsets.fromLTRB(24, 18, 22, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF080A0B),
        border: Border.all(color: const Color(0xFF6D6D70)),
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _GoalWeights(plan: plan),
          Image.asset(AppImages.siho, scale: 2),
          // CustomPaint(painter: _BodyOutlinePainter()),

          _Milestone(plan: plan),
        ],
      ),
    );
  }
}

class _GoalWeights extends StatelessWidget {
  const _GoalWeights({required this.plan});

  final _PlanDetailsData plan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Goals',
          style: TextStyle(
            color: AppColors.primaryColor,
            fontFamily: AppFonts.lato,
            fontSize: 16,
            fontWeight: FontWeight.w900,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Current Weight',
              style: TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 11,
              ),
            ),
            Text(
              plan.currentWeightLabel,
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 24,
                height: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        const Icon(
          Icons.south_outlined,
          color: AppColors.primaryColor,
          size: 24,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Target Weight',
              style: TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 11,
              ),
            ),
            Text(
              plan.targetWeightLabel,
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 24,
                height: 1,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _Milestone extends StatelessWidget {
  const _Milestone({required this.plan});

  final _PlanDetailsData plan;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              color: AppColors.primaryColor,
              size: 20,
            ),
            SizedBox(width: 7),
            Text(
              'Projected\nMilestone',
              style: TextStyle(
                color: AppColors.primaryColor,
                fontFamily: AppFonts.lato,
                fontSize: 14,
                height: 1.12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        Text(
          plan.targetWeightLabel,
          style: const TextStyle(
            color: AppColors.white,
            fontFamily: AppFonts.lato,
            fontSize: 28,
            height: 1,
            fontWeight: FontWeight.w700,
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'by',
              style: TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 9,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              plan.projectedDate,
              maxLines: 2,
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 12,
                height: 1.15,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.primaryColor),
            borderRadius: BorderRadius.circular(12),
          ),
          child: RichText(
            text: TextSpan(
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 15,
              ),
              children: [
                TextSpan(
                  text: plan.weightToGo,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const TextSpan(
                  text: ' to go',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _MacroChartPainter extends CustomPainter {
  const _MacroChartPainter({
    required this.carbs,
    required this.protein,
    required this.fat,
  });

  final double carbs;
  final double protein;
  final double fat;

  @override
  void paint(Canvas canvas, Size size) {
    final total = math.max(carbs + protein + fat, 1);
    final rect = Offset.zero & size;
    var start = -math.pi / 2;
    final entries = <(double, Color)>[
      (protein, AppColors.primaryColor),
      (fat, AppColors.white),
      (carbs, const Color(0xFFA9A9AB)),
    ];

    for (final entry in entries) {
      final sweep = math.pi * 2 * entry.$1 / total;
      canvas.drawArc(
        rect,
        start,
        sweep,
        true,
        Paint()..color = entry.$2,
      );
      start += sweep;
    }

    start = -math.pi / 2;
    for (final entry in entries) {
      final sweep = math.pi * 2 * entry.$1 / total;
      final angle = start + sweep / 2;
      final percentage = (entry.$1 / total * 100).round();
      final textPainter = TextPainter(
        text: TextSpan(
          text: '$percentage%',
          style: TextStyle(
            color: entry.$2 == AppColors.white
                ? const Color(0xFF1B1B1B)
                : AppColors.white,
            fontFamily: AppFonts.lato,
            fontSize: 6,
            fontWeight: FontWeight.w700,
          ),
        ),
        textDirection: ui.TextDirection.ltr,
      )..layout();
      final center = Offset(
        size.width / 2 + math.cos(angle) * size.width * 0.27,
        size.height / 2 + math.sin(angle) * size.height * 0.27,
      );
      textPainter.paint(
        canvas,
        center - Offset(textPainter.width / 2, textPainter.height / 2),
      );
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant _MacroChartPainter oldDelegate) {
    return oldDelegate.carbs != carbs ||
        oldDelegate.protein != protein ||
        oldDelegate.fat != fat;
  }
}

class _BodyOutlinePainter extends CustomPainter {
  const _BodyOutlinePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final sx = size.width / 112;
    final sy = size.height / 246;
    final path = Path()
      ..moveTo(55 * sx, 7 * sy)
      ..cubicTo(43 * sx, 7 * sy, 42 * sx, 20 * sy, 44 * sx, 30 * sy)
      ..cubicTo(39 * sx, 36 * sy, 44 * sx, 43 * sy, 48 * sx, 46 * sy)
      ..lineTo(47 * sx, 52 * sy)
      ..cubicTo(33 * sx, 56 * sy, 28 * sx, 61 * sy, 27 * sx, 76 * sy)
      ..lineTo(25 * sx, 115 * sy)
      ..lineTo(19 * sx, 135 * sy)
      ..lineTo(10 * sx, 151 * sy)
      ..lineTo(3 * sx, 157 * sy)
      ..lineTo(0 * sx, 167 * sy)
      ..lineTo(4 * sx, 169 * sy)
      ..lineTo(7 * sx, 165 * sy)
      ..lineTo(5 * sx, 173 * sy)
      ..lineTo(9 * sx, 174 * sy)
      ..lineTo(13 * sx, 166 * sy)
      ..lineTo(11 * sx, 175 * sy)
      ..lineTo(15 * sx, 176 * sy)
      ..lineTo(20 * sx, 164 * sy)
      ..lineTo(32 * sx, 148 * sy)
      ..lineTo(38 * sx, 128 * sy)
      ..lineTo(38 * sx, 171 * sy)
      ..lineTo(42 * sx, 207 * sy)
      ..lineTo(39 * sx, 232 * sy)
      ..lineTo(34 * sx, 242 * sy)
      ..cubicTo(40 * sx, 248 * sy, 50 * sx, 247 * sy, 51 * sx, 240 * sy)
      ..lineTo(55 * sx, 190 * sy)
      ..lineTo(58 * sx, 190 * sy)
      ..lineTo(62 * sx, 240 * sy)
      ..cubicTo(63 * sx, 247 * sy, 73 * sx, 248 * sy, 79 * sx, 242 * sy)
      ..lineTo(74 * sx, 232 * sy)
      ..lineTo(71 * sx, 207 * sy)
      ..lineTo(75 * sx, 171 * sy)
      ..lineTo(75 * sx, 128 * sy)
      ..lineTo(81 * sx, 148 * sy)
      ..lineTo(93 * sx, 164 * sy)
      ..lineTo(98 * sx, 176 * sy)
      ..lineTo(102 * sx, 175 * sy)
      ..lineTo(100 * sx, 166 * sy)
      ..lineTo(104 * sx, 174 * sy)
      ..lineTo(108 * sx, 173 * sy)
      ..lineTo(106 * sx, 165 * sy)
      ..lineTo(109 * sx, 169 * sy)
      ..lineTo(113 * sx, 167 * sy)
      ..lineTo(110 * sx, 157 * sy)
      ..lineTo(103 * sx, 151 * sy)
      ..lineTo(94 * sx, 135 * sy)
      ..lineTo(88 * sx, 115 * sy)
      ..lineTo(86 * sx, 76 * sy)
      ..cubicTo(85 * sx, 61 * sy, 80 * sx, 56 * sy, 66 * sx, 52 * sy)
      ..lineTo(65 * sx, 46 * sy)
      ..cubicTo(69 * sx, 43 * sy, 74 * sx, 36 * sy, 69 * sx, 30 * sy)
      ..cubicTo(71 * sx, 20 * sy, 69 * sx, 7 * sy, 55 * sx, 7 * sy)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = AppColors.primaryColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.15
        ..strokeJoin = StrokeJoin.round
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _ConfettiPainter extends CustomPainter {
  const _ConfettiPainter();

  @override
  void paint(Canvas canvas, Size size) {
    const pieces = <(double, double, double, Color)>[
      (0.03, 0.17, -0.5, Color(0xFF9B9B9D)),
      (0.17, 0.10, -0.25, Color(0xFFB87512)),
      (0.54, 0.06, -0.35, Color(0xFF99999B)),
      (0.69, 0.08, -0.2, Color(0xFFB87512)),
      (0.75, 0.065, 0.35, Color(0xFF9B9B9D)),
      (0.92, 0.14, 0.3, Color(0xFFC13A13)),
      (0.05, 0.21, 0.45, Color(0xFFC13A13)),
      (0.12, 0.25, -0.35, Color(0xFF9B9B9D)),
      (0.14, 0.27, 0.45, Color(0xFFB87512)),
      (0.93, 0.24, -0.1, Color(0xFFC13A13)),
      (0.08, 0.33, -0.45, Color(0xFFC13A13)),
      (0.13, 0.34, 0.6, Color(0xFFC13A13)),
      (0.73, 0.31, 0.55, Color(0xFFB87512)),
      (0.83, 0.33, 0.6, Color(0xFFB87512)),
      (0.91, 0.33, 1.05, Color(0xFFC13A13)),
      (0.98, 0.38, 0.55, Color(0xFF9B9B9D)),
      (0.97, 0.40, -1.05, Color(0xFFC13A13)),
    ];

    for (final piece in pieces) {
      final x = piece.$1 * size.width;
      final y = piece.$2 * size.height;
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(piece.$3);
      canvas.drawRect(
        const Rect.fromLTWH(-5, -2.5, 10, 5),
        Paint()..color = piece.$4,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PlanDetailsData {
  const _PlanDetailsData({
    required this.dailyCalories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.currentWeight,
    required this.targetWeight,
    required this.weightToGoValue,
    required this.weightUnit,
    required this.projectedGoalDate,
  });

  factory _PlanDetailsData.fromResponse(
    MacroPreviewResponse response,
    OnboardingProfileData profile,
  ) {
    final fallback = _PlanDetailsData.fromProfile(profile);
    final macros = response.macroResult;
    final goals = response.goals;
    return _PlanDetailsData(
      dailyCalories: macros?.dailyCalories?.round() ?? fallback.dailyCalories,
      protein: macros?.proteinGrams?.round() ?? fallback.protein,
      carbs: macros?.carbsGrams?.round() ?? fallback.carbs,
      fat: macros?.fatGrams?.round() ?? fallback.fat,
      currentWeight: goals?.currentWeight?.toDouble() ?? fallback.currentWeight,
      targetWeight: goals?.targetWeight?.toDouble() ?? fallback.targetWeight,
      weightToGoValue: goals?.kgToGo?.toDouble() ?? fallback.weightToGoValue,
      weightUnit: _displayUnit(goals?.weightUnit) ?? fallback.weightUnit,
      projectedGoalDate: goals?.projectedGoalDate ?? fallback.projectedGoalDate,
    );
  }

  factory _PlanDetailsData.fromProfile(OnboardingProfileData profile) {
    final currentWeight = profile.weight ?? 128;
    final targetWeight = profile.desiredWeight ?? 100;
    final unit = _displayUnit(profile.weightUnit) ?? 'kg';
    final calories = _fallbackCalories(profile);
    final projectedDate = profile.targetEventDate ??
        DateTime.now().add(
          Duration(
            days: ((currentWeight - targetWeight).abs() * 8.5)
                .round()
                .clamp(56, 240),
          ),
        );

    return _PlanDetailsData(
      dailyCalories: calories,
      protein: (calories * 0.22 / 4).round(),
      carbs: (calories * 0.45 / 4).round(),
      fat: (calories * 0.33 / 9).round(),
      currentWeight: currentWeight,
      targetWeight: targetWeight,
      weightToGoValue: (currentWeight - targetWeight).abs(),
      weightUnit: unit,
      projectedGoalDate: projectedDate,
    );
  }

  final int dailyCalories;
  final int protein;
  final int carbs;
  final int fat;
  final double currentWeight;
  final double targetWeight;
  final double weightToGoValue;
  final String weightUnit;
  final DateTime projectedGoalDate;

  String get currentWeightLabel => '${_number(currentWeight)}$weightUnit';
  String get targetWeightLabel => '${_number(targetWeight)}$weightUnit';
  String get weightToGo => '${_number(weightToGoValue)}$weightUnit';
  String get projectedDate =>
      DateFormat('MMMM d, yyyy').format(projectedGoalDate);
}

MacroPreviewRequest _planRequest(OnboardingProfileData profile) {
  final requiredValues = <Object?>[
    profile.gender,
    profile.dateOfBirth,
    profile.height,
    profile.heightUnit,
    profile.weight,
    profile.weightUnit,
    profile.activityLevel,
    profile.goal,
    profile.desiredWeight,
    profile.desiredWeightUnit,
    profile.goalPace,
  ];
  if (requiredValues.any((value) => value == null)) {
    throw StateError('Onboarding profile is incomplete');
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

String _normalized(String? value) => (value ?? '')
    .trim()
    .toUpperCase()
    .replaceAll(RegExp(r'[^A-Z0-9]+'), '_')
    .replaceAll(RegExp(r'_+'), '_')
    .replaceAll(RegExp(r'^_|_$'), '');

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

int _fallbackCalories(OnboardingProfileData profile) {
  final weightKg = _normalized(profile.weightUnit) == 'KG'
      ? profile.weight ?? 80
      : (profile.weight ?? 176) * 0.453592;
  final heightCm = _normalized(profile.heightUnit) == 'CM'
      ? profile.height ?? 175
      : (profile.height ?? 5.8) * 30.48;
  final birthday = profile.dateOfBirth;
  final age =
      birthday == null ? 30 : DateTime.now().difference(birthday).inDays ~/ 365;
  final genderOffset = _normalized(profile.gender) == 'FEMALE' ? -161 : 5;
  final base = 10 * weightKg + 6.25 * heightCm - 5 * age + genderOffset;
  final multiplier = switch (_normalized(profile.activityLevel)) {
    'LIGHTLY_ACTIVE' => 1.375,
    'MODERATELY_ACTIVE' => 1.55,
    'VERY_ACTIVE' => 1.725,
    'EXTRA_ACTIVE' => 1.9,
    _ => 1.2,
  };
  final goalAdjustment = switch (_normalized(profile.goal)) {
    String value when value.contains('LOSE') => -350,
    String value when value.contains('GAIN') => 350,
    _ => 0,
  };
  return (base * multiplier + goalAdjustment).round().clamp(1200, 4500);
}

String? _displayUnit(String? value) {
  switch (_normalized(value)) {
    case 'KG':
      return 'kg';
    case 'LB':
    case 'LBS':
    case 'POUND':
    case 'POUNDS':
      return 'lb';
    default:
      return null;
  }
}

String _number(double value) {
  return value == value.roundToDouble()
      ? value.round().toString()
      : value.toStringAsFixed(1);
}
