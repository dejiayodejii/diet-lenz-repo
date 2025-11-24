import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/diet-prefernce.dart';
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
    const Color accentColor = AppColors.primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () {
                // Handle back navigation
              },
            ),
          ),
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
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // -- Scrollable List of Options --
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: _activityOptions.length,
              separatorBuilder: (context, index) => const SizedBox(height: 16),
              itemBuilder: (context, index) {
                final option = _activityOptions[index];
                final isSelected = _selectedIndex == index;

                return _ActivityOptionItem(
                  title: option['title']!,
                  subtitle: option['subtitle']!,
                  isSelected: isSelected,
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
                  final activityLevels = [
                    'SEDENTARY',
                    'LIGHTLY_ACTIVE',
                    'MODERATELY_ACTIVE',
                    'VERY_ACTIVE',
                    'EXTRA_ACTIVE'
                  ];
                  ref
                      .read(onboardingProfileProvider.notifier)
                      .updateActivityLevel(activityLevels[_selectedIndex]);
                  NavigationService.push(child: const DietPreferenceScreen());
                }),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

// -- Custom Widget for a Single Activity Option --
class _ActivityOptionItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _ActivityOptionItem({
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFEF6C35);

    // We use a Stack to position the Checkmark icon on top of the border
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior:
            Clip.none, // Allows the icon to stick out slightly if needed
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: isSelected
                  ? Border.all(color: accentColor, width: 1.5)
                  : Border.all(color: Colors.transparent, width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          // The Checkmark Icon (Only visible when selected)
          if (isSelected)
            Positioned(
              top: -10,
              right: -8,
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black, // Small border effect around the icon
                ),
                padding: const EdgeInsets.all(2),
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: accentColor,
                  ),
                  padding: const EdgeInsets.all(4),
                  child: const Icon(
                    Icons.check,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
