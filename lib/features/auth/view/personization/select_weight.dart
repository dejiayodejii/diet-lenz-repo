import 'package:diet_lenz/component/measurement_selection_screen.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/select_height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectWeightScreen extends ConsumerWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      title: "What is your weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 50.0,
      nextScreen: const SelectHeightScreen(),
      onContinue: (value, unit, isLeftUnit) {
        // Save weight data
        ref.read(onboardingProfileProvider.notifier).updateWeight(value, unit);
      },
    );
  }
}
