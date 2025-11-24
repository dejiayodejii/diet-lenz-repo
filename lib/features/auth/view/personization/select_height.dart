import 'package:diet_lenz/component/measurement_selection_screen.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/select_age.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectHeightScreen extends ConsumerWidget {
  const SelectHeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      title: "What is your height?",
      leftUnit: "ft",
      rightUnit: "cm",
      minValue: 0,
      maxValue: 250,
      initialValue: 140.0,
      nextScreen: const SelectAgeScreen(),
      onContinue: (value, unit, isLeftUnit) {
        // Save height data
        ref.read(onboardingProfileProvider.notifier).updateHeight(value, unit);
      },
    );
  }
}
