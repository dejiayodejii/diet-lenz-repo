import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(title: const Text('Border Progress Container')),
        body: const BorderProgressDemo(),
      ),
    );
  }
}

class BorderProgressDemo extends StatefulWidget {
  const BorderProgressDemo({super.key});

  @override
  State<BorderProgressDemo> createState() => _BorderProgressDemoState();
}

class _BorderProgressDemoState extends State<BorderProgressDemo> {
  double _progress = 0.5;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BorderProgressContainer(
            progress: _progress,
            width: 300,
            height: 200,
            borderWidth: 6,
            progressColor: Colors.blue,
            backgroundColor: Colors.grey[300]!,
            borderRadius: 20, // Add rounded corners!
            child: Center(
              child: Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Slider(
              value: _progress,
              onChanged: (value) {
                setState(() {
                  _progress = value;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}

class BorderProgressContainer extends StatefulWidget {
  final double progress; // 0.0 to 1.0
  final double width;
  final double height;
  final double borderWidth;
  final double borderRadius;
  final Color progressColor;
  final Color backgroundColor;
  final Widget? child;
  final bool animate;
  final Duration animationDuration;

  const BorderProgressContainer({
    super.key,
    required this.progress,
    required this.width,
    required this.height,
    this.borderWidth = 4,
    this.borderRadius = 0,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.child,
    this.animate = true,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<BorderProgressContainer> createState() =>
      _BorderProgressContainerState();
}

class _BorderProgressContainerState extends State<BorderProgressContainer>
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

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    if (widget.animate) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(BorderProgressContainer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.progress != widget.progress) {
      _animation = Tween<double>(
        begin: _animation.value,
        end: widget.progress,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ));
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return CustomPaint(
          painter: BorderProgressPainter(
            progress: widget.animate
                ? _animation.value.clamp(0.0, 1.0)
                : widget.progress.clamp(0.0, 1.0),
            borderWidth: widget.borderWidth,
            borderRadius: widget.borderRadius,
            progressColor: widget.progressColor,
            backgroundColor: widget.backgroundColor,
          ),
          child: Container(
            width: widget.width,
            height: widget.height,
            padding: EdgeInsets.all(widget.borderWidth),
            child: widget.child,
          ),
        );
      },
    );
  }
}

class BorderProgressPainter extends CustomPainter {
  final double progress;
  final double borderWidth;
  final double borderRadius;
  final Color progressColor;
  final Color backgroundColor;

  BorderProgressPainter({
    required this.progress,
    required this.borderWidth,
    required this.borderRadius,
    required this.progressColor,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(
      borderWidth / 2,
      borderWidth / 2,
      size.width - borderWidth,
      size.height - borderWidth,
    );

    final rrect = RRect.fromRectAndRadius(
      rect,
      Radius.circular(borderRadius),
    );

    // Draw background border (rounded)
    final bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawRRect(rrect, bgPaint);

    // Calculate total perimeter (approximate for rounded rect)
    final perimeter = 2 * (size.width + size.height) - 4 * borderWidth;
    final progressLength = perimeter * progress;

    // Draw progress border (rounded)
    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..strokeCap = StrokeCap.round;

    // Create path following the rounded rectangle border
    final path = Path();
    double currentLength = 0;

    // We'll trace around the rounded rectangle's perimeter
    // Top edge (left to right, accounting for corner radius)
    final topLength = size.width - borderWidth - 2 * borderRadius;
    if (progressLength > currentLength) {
      final segmentProgress =
          ((progressLength - currentLength) / topLength).clamp(0.0, 1.0);
      path.moveTo(borderWidth / 2 + borderRadius, borderWidth / 2);
      path.lineTo(borderWidth / 2 + borderRadius + topLength * segmentProgress,
          borderWidth / 2);
    }
    currentLength += topLength;

    // Top-right corner arc
    final cornerArcLength = (borderRadius * 3.14159 / 2);
    if (progressLength > currentLength) {
      final segmentProgress =
          ((progressLength - currentLength) / cornerArcLength).clamp(0.0, 1.0);
      final sweepAngle = (3.14159 / 2) * segmentProgress;
      path.arcTo(
        Rect.fromLTWH(
          size.width - borderWidth / 2 - borderRadius * 2,
          borderWidth / 2,
          borderRadius * 2,
          borderRadius * 2,
        ),
        -3.14159 / 2, // start angle (top)
        sweepAngle,
        false,
      );
    }
    currentLength += cornerArcLength;

    // Right edge (top to bottom)
    final rightLength = size.height - borderWidth - 2 * borderRadius;
    if (progressLength > currentLength) {
      final segmentProgress =
          ((progressLength - currentLength) / rightLength).clamp(0.0, 1.0);
      if (path.getBounds().isEmpty) {
        path.moveTo(
            size.width - borderWidth / 2, borderWidth / 2 + borderRadius);
      }
      path.lineTo(size.width - borderWidth / 2,
          borderWidth / 2 + borderRadius + rightLength * segmentProgress);
    }
    currentLength += rightLength;

    // Bottom-right corner arc
    if (progressLength > currentLength) {
      final segmentProgress =
          ((progressLength - currentLength) / cornerArcLength).clamp(0.0, 1.0);
      final sweepAngle = (3.14159 / 2) * segmentProgress;
      path.arcTo(
        Rect.fromLTWH(
          size.width - borderWidth / 2 - borderRadius * 2,
          size.height - borderWidth / 2 - borderRadius * 2,
          borderRadius * 2,
          borderRadius * 2,
        ),
        0, // start angle (right)
        sweepAngle,
        false,
      );
    }
    currentLength += cornerArcLength;

    // Bottom edge (right to left)
    final bottomLength = size.width - borderWidth - 2 * borderRadius;
    if (progressLength > currentLength) {
      final segmentProgress =
          ((progressLength - currentLength) / bottomLength).clamp(0.0, 1.0);
      if (path.getBounds().isEmpty) {
        path.moveTo(size.width - borderWidth / 2 - borderRadius,
            size.height - borderWidth / 2);
      }
      path.lineTo(
          size.width -
              borderWidth / 2 -
              borderRadius -
              bottomLength * segmentProgress,
          size.height - borderWidth / 2);
    }
    currentLength += bottomLength;

    // Bottom-left corner arc
    if (progressLength > currentLength) {
      final segmentProgress =
          ((progressLength - currentLength) / cornerArcLength).clamp(0.0, 1.0);
      final sweepAngle = (3.14159 / 2) * segmentProgress;
      path.arcTo(
        Rect.fromLTWH(
          borderWidth / 2,
          size.height - borderWidth / 2 - borderRadius * 2,
          borderRadius * 2,
          borderRadius * 2,
        ),
        3.14159 / 2, // start angle (bottom)
        sweepAngle,
        false,
      );
    }
    currentLength += cornerArcLength;

    // Left edge (bottom to top)
    final leftLength = size.height - borderWidth - 2 * borderRadius;
    if (progressLength > currentLength) {
      final segmentProgress =
          ((progressLength - currentLength) / leftLength).clamp(0.0, 1.0);
      if (path.getBounds().isEmpty) {
        path.moveTo(
            borderWidth / 2, size.height - borderWidth / 2 - borderRadius);
      }
      path.lineTo(
          borderWidth / 2,
          size.height -
              borderWidth / 2 -
              borderRadius -
              leftLength * segmentProgress);
    }
    currentLength += leftLength;

    // Top-left corner arc (final corner to complete the loop)
    if (progressLength > currentLength) {
      final segmentProgress =
          ((progressLength - currentLength) / cornerArcLength).clamp(0.0, 1.0);
      final sweepAngle = (3.14159 / 2) * segmentProgress;
      path.arcTo(
        Rect.fromLTWH(
          borderWidth / 2,
          borderWidth / 2,
          borderRadius * 2,
          borderRadius * 2,
        ),
        3.14159, // start angle (left)
        sweepAngle,
        false,
      );
    }

    canvas.drawPath(path, progressPaint);
  }

  @override
  bool shouldRepaint(BorderProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.borderWidth != borderWidth ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.backgroundColor != backgroundColor;
  }
}
