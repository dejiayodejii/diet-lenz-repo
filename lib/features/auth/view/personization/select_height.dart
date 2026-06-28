import 'package:diet_lenz/component/measurement_selection_screen.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/select_age.dart';
import 'package:diet_lenz/features/auth/view/personization/select_weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectHeightScreen extends ConsumerWidget {
  const SelectHeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      currentStep: 6,
      title: "What is your height?",
      leftUnit: "ft",
      rightUnit: "cm",
      minValue: 0,
      maxValue: 300,
      minLeftValue: 2,
      maxLeftValue: 9,
      initialValue: 180.0,
      initialLeftUnitSelected: false, // Start with CM
      leftToRightConverter: (val) => val * 30.48,
      rightToLeftConverter: (val) => val / 30.48,
      leftStep: 0.1,
      useCompoundLeftUnit: true,
      nextScreen: const SelectAgeScreen(),
      onContinue: (value, unit, isLeftUnit) {
        ref.read(onboardingProfileProvider.notifier).updateHeight(value, unit);
        NavigationService.push(child: const SelectWeightScreen());
      },
    );
  }
}
