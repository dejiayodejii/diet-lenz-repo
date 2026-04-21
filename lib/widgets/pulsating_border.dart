import 'package:flutter/material.dart';

/// Wraps [child] with a pulsating border that fades in and out continuously.
/// Useful for drawing attention to an input field.
class PulsatingBorder extends StatefulWidget {
  final Widget child;
  final Color color;
  final double borderRadius;
  final double borderWidth;
  final Duration duration;

  const PulsatingBorder({
    super.key,
    required this.child,
    required this.color,
    this.borderRadius = 12.0,
    this.borderWidth = 1.5,
    this.duration = const Duration(milliseconds: 1200),
  });

  @override
  State<PulsatingBorder> createState() => _PulsatingBorderState();
}

class _PulsatingBorderState extends State<PulsatingBorder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat(reverse: true);
    _opacity = Tween<double>(begin: 0.25, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _opacity,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.color.withOpacity(_opacity.value),
              width: widget.borderWidth,
            ),
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
