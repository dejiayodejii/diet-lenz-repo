import 'package:diet_lenz/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class PersonalizationStepper extends StatelessWidget {
  const PersonalizationStepper({
    super.key,
    required this.currentStep,
    this.totalSteps = 12,
    this.activeColor = AppColors.primary,
    this.inactiveColor = const Color(0xFFD1D1D1),
    this.width = 13,
    this.height = 3,
    this.spacing = 4,
  })  : assert(totalSteps > 0),
        assert(currentStep > 0),
        assert(currentStep <= totalSteps);

  /// The active step, using a 1-based index.
  final int currentStep;
  final int totalSteps;
  final Color activeColor;
  final Color inactiveColor;
  final double width;
  final double height;
  final double spacing;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Step $currentStep of $totalSteps',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalSteps, (index) {
          final isActive = index < currentStep;

          return Container(
            width: width,
            height: height,
            margin: EdgeInsets.only(
              right: index == totalSteps - 1 ? 0 : spacing,
            ),
            decoration: BoxDecoration(
              color: isActive ? activeColor : inactiveColor,
              borderRadius: BorderRadius.circular(height),
            ),
          );
        }),
      ),
    );
  }
}
