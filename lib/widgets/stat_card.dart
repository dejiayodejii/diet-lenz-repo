import 'package:flutter/material.dart';

class StatCard extends StatelessWidget {
  final Widget? leading;
  final String value;
  final String label;
  final double padding;
  final Color backgroundColor;
  final double radius;
  final TextStyle? valueStyle;
  final TextStyle? labelStyle;

  const StatCard({
    Key? key,
    this.leading,
    required this.value,
    required this.label,
    this.padding = 12.0,
    this.backgroundColor = const Color.fromRGBO(42, 47, 55, 1),
    this.radius = 16.0,
    this.valueStyle,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 128,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        color: backgroundColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 2),
          if (leading != null) leading!,
          const SizedBox(height: 8),
          Column(
            children: [
              Text(
                value,
                style: valueStyle ??
                    const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: labelStyle ??
                    const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(162, 166, 171, 1)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
