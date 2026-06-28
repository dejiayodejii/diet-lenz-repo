import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/component/selectable_option_tile.dart';
import 'package:diet_lenz/core/utils/functions.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/personization/quiz_answer.dart';
import 'package:diet_lenz/features/auth/view/personization/select_macro_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<QuizScreen> {
  int selectedIndex = 0; // default selection: first goal

  @override
  void initState() {
    super.initState();
    // Fetch goals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(recipeViewModelProvider.notifier).getGoals();
    });
  }

  final options = [
    'A. 250 - 300 kcal',
    'B. 400 - 500 kcal',
    'C. 600 - 700 kcal',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(
          currentStep: 4,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 25),
            const Text("Quick Challenge",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 22,
                    letterSpacing: 0,
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            const Text("How many calories are in \nthis meal?",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    letterSpacing: 0,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600)),
            const SizedBox(height: 40),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text(
                    "Take your best guess\nNo right or wrong answer",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: AppColors.white,
                        fontWeight: FontWeight.w400),
                  ),
                  const SizedBox(height: 20),
                  Image.asset(
                    AppImages.quiz,
                    scale: 2,
                    height: 250,
                  ),
                  const SizedBox(height: 40),
                  ...List.generate(options.length, (index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: SelectableOptionTile(
                        label: capitalizeFirstLetter(
                          removeUnderscores(options[index]),
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
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  NavigationService.push(child: const QuizAnswerScreen());
                }),
            SizedBox(height: 5 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
