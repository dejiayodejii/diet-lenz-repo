import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/component/selectable_option_tile.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/allergies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ActivityLevelScreen extends ConsumerStatefulWidget {
  const ActivityLevelScreen({super.key});

  @override
  ConsumerState<ActivityLevelScreen> createState() =>
      _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends ConsumerState<ActivityLevelScreen> {
  // Track which option is selected. 0 is the default (Sedentary).
  int _selectedIndex = 0;

  // The data for the options
  final List<Map<String, String>> _activityOptions = [
    {
      "title": "SEDENTARY",
      "subtitle": "Little or no exercise",
    },
    {
      "title": "LIGHTLY ACTIVE",
      "subtitle": "Light exercise/ sports 1-3 days/week",
    },
    {
      "title": "MODERATELY ACTIVE",
      "subtitle": "Moderate exercise/sports 3-5 days/week",
    },
    {
      "title": "VERY ACTIVE",
      "subtitle": "Hard exercise/sports 6-7 days/week",
    },
    {
      "title": "EXTRA ACTIVE",
      "subtitle": "Very hard exercise/sports & physical",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(
          currentStep: 7,
        ),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          // -- Header Section --
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                const SizedBox(height: 30),
                const Text(
                  "What is your\nActivity Level?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "How active are you on a typical week?",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 70),

          // -- Scrollable List of Options --
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _activityOptions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final option = _activityOptions[index];
                return SelectableOptionTile(
                  label: option['title']!,
                  subtitle: option['subtitle']!,
                  height: 72,
                  isSelected: _selectedIndex == index,
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                );
              },
            ),
          ),

          // -- Bottom Button --
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: CustomYafButton(
                text: "Continue",
                onPressed: () {
                  // Save activity level (map index to enum value)
                  // final activityLevels = [
                  //   'SEDENTARY',
                  //   'LIGHTLY_ACTIVE',
                  //   'MODERATELY_ACTIVE',
                  //   'VERY_ACTIVE',
                  //   'EXTRA_ACTIVE'
                  // ];
                  // ref
                  //     .read(onboardingProfileProvider.notifier)
                  //     .updateActivityLevel(activityLevels[_selectedIndex]);
                  NavigationService.push(child: const AllegiesScreen());
                }),
          ),
          SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
        ],
      ),
    );
  }
}
