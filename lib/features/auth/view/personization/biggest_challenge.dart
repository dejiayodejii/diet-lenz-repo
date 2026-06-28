import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/component/selectable_option_tile.dart';
import 'package:diet_lenz/core/utils/functions.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/not_punishment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class BiggestChallengeScreen extends ConsumerStatefulWidget {
  const BiggestChallengeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<BiggestChallengeScreen> {
  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    // Fetch goals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(recipeViewModelProvider.notifier).getGoals();
    });
  }

  final goals = [
    'I struggle with consistency',
    'I give in to cravings',
    'I lose motivation',
    'I eat from emotions/stress',
    "I don't know what to do",
    'I just want a faster, easier tool',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(
          currentStep: 10,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 25),
            const Text("What’s been your \nbiggest challenge?",
                style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600)),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  ...List.generate(goals.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SelectableOptionTile(
                        label: capitalizeFirstLetter(
                          removeUnderscores(goals[index]),
                        ),
                        isSelected: selectedIndex == index,
                        onTap: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                      ),
                    );
                  }),
                ],
              ),
            ),
            CustomYafButton(
                iconPositionLeft: false,
                text: "Continue",
                isDisabled: selectedIndex == null,
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  ref
                      .read(onboardingProfileProvider.notifier)
                      .updateBiggestChallenge(goals[selectedIndex!]);
                  NavigationService.push(child: const NotPunishment());
                }),
            SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
