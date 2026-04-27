import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/core/utils/functions.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/desired_weight.dart';
import 'package:diet_lenz/features/auth/view/personization/select_macro_target.dart';
import 'package:diet_lenz/features/recipe/controller/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SelectGoalScreen extends ConsumerStatefulWidget {
  const SelectGoalScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SelectGoalScreen> {
  int selectedIndex = 0; // default selection: first goal

  @override
  void initState() {
    super.initState();
    // Fetch goals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(recipeViewModelProvider.notifier).getGoals();
    });
  }

  @override
  Widget build(BuildContext context) {
    final recipeState = ref.watch(recipeViewModelProvider);
    final goals = recipeState.goals ??
        [
          'I want to lose weight',
          'I want to maintain my weight',
          'I want to gain weight',
          'Just trying out the app!'
        ];
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 25),
            const Text("What is your goal?",
                style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600)),
            Expanded(
              child: recipeState.isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primaryColor,
                      ),
                    )
                  : recipeState.errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                recipeState.errorMessage!,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 16),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(recipeViewModelProvider.notifier)
                                      .getGoals();
                                },
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const SizedBox(height: 80),
                            ...List.generate(goals.length, (index) {
                              final bool isSelected = selectedIndex == index;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 16.0),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    height: 56,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(32),
                                      color: isSelected
                                          ? const Color.fromRGBO(57, 60, 67, 1)
                                          : const Color.fromRGBO(36, 38, 43, 1),
                                      boxShadow: isSelected
                                          ? const [
                                              BoxShadow(
                                                color: Color.fromRGBO(
                                                    129, 133, 141, 0.25),
                                                spreadRadius: 4,
                                              )
                                            ]
                                          : null,
                                      border: isSelected
                                          ? null
                                          : Border.all(
                                              color: const Color.fromRGBO(
                                                  57, 60, 67, 1),
                                              width: 1,
                                            ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          capitalizeFirstLetter(
                                              removeUnderscores(goals[index])),
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 16,
                                            fontFamily: AppFonts.workSans,
                                            color: AppColors.white,
                                          ),
                                        ),
                                        SvgPicture.asset(
                                          isSelected
                                              ? AppImages.selected
                                              : AppImages.unselected,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
            ),
            CustomYafButton(
                iconPositionLeft: false,
                text: "Continue",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  // Save selected goal
                  ref
                      .read(onboardingProfileProvider.notifier)
                      .updateGoal(goals[selectedIndex]);
                  NavigationService.push(
                      child: const SelectMacroTargetScreen());
                }),
            SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
