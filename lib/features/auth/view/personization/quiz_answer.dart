import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/component/selectable_option_tile.dart';
import 'package:diet_lenz/core/utils/functions.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/personization/select_gender.dart';
import 'package:diet_lenz/features/auth/view/personization/select_macro_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class QuizAnswerScreen extends ConsumerStatefulWidget {
  const QuizAnswerScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<QuizAnswerScreen> {
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
    'B. 350 - 450 kcal',
    'C. 500 - 650 kcal',
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
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text("Most people \nunderestimated that",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 24,
                            letterSpacing: 0,
                            color: AppColors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Answer",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 22,
                              letterSpacing: 0,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 40),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: const Color.fromRGBO(57, 60, 67, 1)),
                            child: const Text("C. 500 - 650 kcal",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 22,
                                    letterSpacing: 0,
                                    color: AppColors.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                          const SizedBox(height: 25),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(
                                  text: '550',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 60,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                TextSpan(
                                  text: ' kcal',
                                  style: TextStyle(
                                    color: Color.fromRGBO(158, 160, 165, 1),
                                    fontSize: 30,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 60),
                          const Text("Most Common Answer:\n350-450kcal",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ],
                  ),
                  const Text(
                      "Studies show people underestimate meal \ncalories by 40% on average - causing \nunintentional overeating every single day",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 15,
                          letterSpacing: 0,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400)),
                ],
              ),
            ),
            const SizedBox(height: 25),
            CustomYafButton(
                iconPositionLeft: false,
                text: "Build My Plan",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  NavigationService.push(child: GenderScreen());
                }),
            SizedBox(height: 5 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
