import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/allergies.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class DietPreferenceScreen extends ConsumerStatefulWidget {
  const DietPreferenceScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<DietPreferenceScreen> {
  int selectedIndex = 0; // default selection: first goal
  final List<Map<String, String>> goals = const [
    {AppImages.one: "Vegan"},
    {AppImages.two: "Vegetarian"},
    {AppImages.three: "Classic"},
    {AppImages.four: "Pescatarian"},
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              GestureDetector(
                  onTap: () {
                    NavigationService.pop();
                  },
                  child: SvgPicture.asset(AppImages.backButton)),
            ],
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("What is your \ndietary preference?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...List.generate(goals.length, (index) {
                  final bool isSelected = selectedIndex == index;
                  final goal = goals[index];
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    child: Column(
                      children: [
                        Container(
                          height: 75,
                          width: 75,
                          decoration: BoxDecoration(
                            border: !isSelected
                                ? null
                                : Border.all(
                                    color: AppColors.primaryColor, width: 4),
                            shape: BoxShape.circle,
                            color: isSelected
                                ? Colors.white
                                : AppColors.primaryColor,
                          ),
                          child: Center(
                            child: Image.asset(
                              goal.entries.first.key,
                              color: isSelected ? Colors.black : Colors.white,
                              scale: 2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          goal.entries.first.value,
                          style: const TextStyle(
                              letterSpacing: 0,
                              fontSize: 16,
                              fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  );
                }),
              ],
            ),
            const SizedBox(height: 5),
            CustomYafButton(
                iconPositionLeft: false,
                text: "Continue",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  // Save dietary preference (map index to value)
                  final preferences = [
                    'VEGAN',
                    'VEGETARIAN',
                    'NONE',
                    'PESCATARIAN'
                  ];
                  ref
                      .read(onboardingProfileProvider.notifier)
                      .updateDietaryPreference(preferences[selectedIndex]);
                  NavigationService.push(child: const AllegiesScreen());
                }),
            // const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
