import 'package:diet_lenz/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const CalorieTrackerScreen(),
    );
  }
}

class CalorieTrackerScreen extends StatelessWidget {
  const CalorieTrackerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1A),
      body: Center(
        child: CalorieProgressCard(
          currentCalories: 1250,
          targetCalories: 1800,
          date: 'Thursday, June 06',
          streakDays: 5,
        ),
      ),
    );
  }
}

class CalorieProgressCard extends StatefulWidget {
  final int currentCalories;
  final int targetCalories;
  final String date;
  final int streakDays;
  final bool animate;
  final Duration animationDuration;

  const CalorieProgressCard({
    Key? key,
    required this.currentCalories,
    required this.targetCalories,
    required this.date,
    required this.streakDays,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 1500),
  }) : super(key: key);

  @override
  State<CalorieProgressCard> createState() => _CalorieProgressCardState();
}

class _CalorieProgressCardState extends State<CalorieProgressCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );

    final targetProgress = widget.currentCalories / widget.targetCalories;
    _animation = Tween<double>(
      begin: 0.0,
      end: targetProgress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(CalorieProgressCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.currentCalories != widget.currentCalories ||
        oldWidget.targetCalories != widget.targetCalories) {
      final targetProgress = widget.currentCalories / widget.targetCalories;
      _animation = Tween<double>(
        begin: _animation.value,
        end: targetProgress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = widget.currentCalories / widget.targetCalories;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2A2A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.date,
                style: const TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                ),
              ),
              Row(
                children: [
                  Text(
                    '${widget.streakDays} Day Streak',
                    style: const TextStyle(
                      color: Color(0xFFFF6B35),
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  ...List.generate(
                    5,
                    (index) => Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Icon(
                        Icons.circle,
                        size: 8,
                        color: index < widget.streakDays
                            ? const Color(0xFFFF6B35)
                            : Colors.white24,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Semi-circle progress
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return SizedBox(
                width: 248,
                height: 124,
                child: CustomPaint(
                  size: const Size(248, 124),
                  painter: SemiCircleProgressPainter(
                    progress: widget.animate
                        ? _animation.value.clamp(0.0, 1.0)
                        : progress.clamp(0.0, 1.0),
                    strokeWidth: 20,
                    width: 248,
                    height: 124,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        // Flame icon
                        const Icon(
                          Icons.local_fire_department,
                          color: Color(0xFFFF6B35),
                          size: 28,
                        ),

                        // Calorie count
                        Text(
                          '${widget.currentCalories} cal',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'of ${widget.targetCalories}',
                          style: const TextStyle(
                            color: Colors.white38,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SemiCircleProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final double width;
  final double height;

  SemiCircleProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.width,
    required this.height,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Use custom width/height instead of size parameter
    final center = Offset(width / 2, height);
    final radius = width / 2 - strokeWidth / 2;

    // Background arc (gray)
    final backgroundPaint = Paint()
      ..color = const Color(0xFF3A3A3A)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Straight ends

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start at left (180 degrees)
      math.pi, // Sweep 180 degrees
      false,
      backgroundPaint,
    );

    // Progress arc (orange)
    final progressPaint = Paint()
      ..color = AppColors.primaryColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.butt; // Straight ends

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi, // Start at left (180 degrees)
      math.pi * progress, // Sweep based on progress
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(SemiCircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.width != width ||
        oldDelegate.height != height;
  }
}
