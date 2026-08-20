import 'dart:math' as math;

import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/personization/plan_details.dart';
import 'package:diet_lenz/features/auth/view/register.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PlanLoadingScreen extends StatefulWidget {
  const PlanLoadingScreen({super.key});

  @override
  State<PlanLoadingScreen> createState() => _PlanLoadingScreenState();
}

class _PlanLoadingScreenState extends State<PlanLoadingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && mounted) {
          // NavigationService.pushReplacement(child: const PlanDetailsScreen());
          NavigationService.push(
            child: const SignUpScreen(),
          );
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, _) {
              final progress = _controller.value;
              final percent = (progress * 100).clamp(0, 100).round();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34),
                child: Column(
                  children: [
                    const Spacer(flex: 5),
                    SizedBox(
                      width: 260,
                      height: 260,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          CustomPaint(
                            size: const Size.square(260),
                            painter: _PlanProgressPainter(progress: progress),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '$percent%',
                                style: const TextStyle(
                                  color: AppColors.white,
                                  fontFamily: AppFonts.lato,
                                  fontSize: 50,
                                  fontWeight: FontWeight.w700,
                                  height: 0.95,
                                  letterSpacing: 0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              const Text(
                                'Building your plan',
                                style: TextStyle(
                                  color: AppColors.white,
                                  fontFamily: AppFonts.lato,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 4),
                    _LoadingTaskRow(
                      title: 'Personalizing macros',
                      done: progress >= 0.28,
                    ),
                    const SizedBox(height: 14),
                    _LoadingTaskRow(
                      title: 'Analyzing culinary skill',
                      done: progress >= 0.58,
                    ),
                    const SizedBox(height: 14),
                    // _LoadingTaskRow(
                    //   title: 'Syncing with Health Kit',
                    //   done: progress >= 0.96,
                    // ),
                    const Spacer(flex: 5),
                    const Text(
                      'This only takes a moment',
                      style: TextStyle(
                        color: AppColors.white,
                        fontFamily: AppFonts.lato,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0,
                      ),
                    ),
                    SizedBox(
                        height: 30 + MediaQuery.of(context).padding.bottom),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _LoadingTaskRow extends StatelessWidget {
  const _LoadingTaskRow({
    required this.title,
    required this.done,
  });

  final String title;
  final bool done;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 46,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(43, 49, 58, 1),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
          const SizedBox(width: 14),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 180),
            child: Text(
              done ? 'Done' : 'In Progress...',
              key: ValueKey(done),
              maxLines: 1,
              style: TextStyle(
                color: done ? AppColors.primaryColor : AppColors.white,
                fontFamily: AppFonts.lato,
                fontSize: 13,
                fontWeight: FontWeight.w900,
                letterSpacing: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanProgressPainter extends CustomPainter {
  const _PlanProgressPainter({required this.progress});

  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = size.width * 0.14;
    final rect = Offset(strokeWidth / 2, strokeWidth / 2) &
        Size(size.width - strokeWidth, size.height - strokeWidth);

    final trackPaint = Paint()
      ..color = const Color.fromRGBO(93, 93, 93, 1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final progressPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const startAngle = -math.pi / 2;
    const trackGap = math.pi * 0.2;
    final sweep = (math.pi * 2 - trackGap) * progress.clamp(0, 1);

    canvas.drawArc(
        rect, startAngle + trackGap, math.pi * 2 - trackGap, false, trackPaint);
    canvas.drawArc(rect, startAngle, sweep, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _PlanProgressPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
