import 'package:diet_lenz/component/bmi_color_scheme.dart';
import 'package:diet_lenz/component/measurement_selection_screen.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/utils/weight_goal_validator.dart';
import 'package:diet_lenz/features/auth/view/personization/activity_level.dart';
import 'package:diet_lenz/pace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DesiredWeightScreen extends ConsumerWidget {
  const DesiredWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(onboardingProfileProvider);

    return MeasurementSelectionScreen(
      currentStep: 10,
      title: "What is your \ntarget weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 65.0,
      nextScreen: const ActivityLevelScreen(),
      extraBuilder: (context, value, unit, isLeftUnit) {
        return BmiColorScheme(
          label: 'Target BMI',
          weightKg: _weightToKg(value, unit),
          heightMeters: _heightToMeters(profile.height, profile.heightUnit),
        );
      },
      onContinue: (value, unit, isLeftUnit) {
        final validationError = validateDesiredWeightForGoal(
          goal: profile.goal,
          currentWeight: profile.weight,
          currentWeightUnit: profile.weightUnit,
          desiredWeight: value,
          desiredWeightUnit: unit,
        );

        if (validationError != null) {
          ref.read(toastProvider).showError(validationError);
          return;
        }

        ref
            .read(onboardingProfileProvider.notifier)
            .updateDesiredWeight(value, unit);
        NavigationService.push(
            child: GoalPaceScreen(
          targetWeightKg: _weightToKg(value, unit),
        ));
      },
    );
  }
}

double _weightToKg(double value, String unit) {
  return unit.toLowerCase() == 'lbs' ? value / 2.20462 : value;
}

double _heightToMeters(double? value, String? unit) {
  if (value == null || unit == null) return 1.72;
  return unit.toLowerCase() == 'cm' ? value / 100 : value * 0.3048;
}
