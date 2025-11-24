import 'package:diet_lenz/component/measurement_selection_screen.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/activity_level.dart';
import 'package:diet_lenz/features/auth/view/personization/diet-prefernce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DesiredWeightScreen extends ConsumerWidget {
  const DesiredWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      title: "What is your \ndesired weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 65.0,
      nextScreen: const ActivityLevelScreen(),
      onContinue: (value, unit, isLeftUnit) {
        // Save desired weight
        ref
            .read(onboardingProfileProvider.notifier)
            .updateDesiredWeight(value, unit);
      },
    );
  }
}
