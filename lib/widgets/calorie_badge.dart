import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:flutter/material.dart';

class CalorieBadge extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final double fontSize;
  final double width;
  final FontWeight fontWeight;

  const CalorieBadge({
    Key? key,
    required this.text,
    this.backgroundColor = const Color.fromRGBO(246, 111, 30, 1),
    this.textColor = Colors.black,
    this.padding = const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
    this.borderRadius = 20.0,
    this.fontSize = 14,
    this.width = 60,
    this.fontWeight = FontWeight.w600,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontFamily: AppFonts.lato,
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
