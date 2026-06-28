import 'package:diet_lenz/component/measurement_selection_screen.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/activity_level.dart';
import 'package:diet_lenz/features/auth/view/personization/select_height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SelectWeightScreen extends ConsumerWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      currentStep: 7,
      title: "What is your weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 50.0,
      nextScreen: const SelectHeightScreen(),
      onContinue: (value, unit, isLeftUnit) {
        ref.read(onboardingProfileProvider.notifier).updateWeight(value, unit);
        NavigationService.push(child: const ActivityLevelScreen());
      },
    );
  }
}
