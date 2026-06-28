import 'package:diet_lenz/component/measurement_selection_screen.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/activity_level.dart';
import 'package:diet_lenz/pace.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DesiredWeightScreen extends ConsumerWidget {
  const DesiredWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      currentStep: 10,
      title: "What is your \ntarget weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 65.0,
      nextScreen: const ActivityLevelScreen(),
      onContinue: (value, unit, isLeftUnit) {
        ref
            .read(onboardingProfileProvider.notifier)
            .updateDesiredWeight(value, unit);
        NavigationService.push(
            child: GoalPaceScreen(
          targetWeightKg: value,
        ));
      },
    );
  }
}
