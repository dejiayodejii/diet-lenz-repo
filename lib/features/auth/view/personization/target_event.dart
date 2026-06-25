import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/component/selectable_option_tile.dart';
import 'package:diet_lenz/core/utils/functions.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/personization/event_date.dart';
import 'package:diet_lenz/features/auth/view/personization/quiz_screen.dart';
import 'package:diet_lenz/features/auth/view/personization/select_macro_target.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class TargetEventScreen extends ConsumerStatefulWidget {
  const TargetEventScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<TargetEventScreen> {
  int selectedIndex = 0; // default selection: first goal

  @override
  void initState() {
    super.initState();
    // Fetch goals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(recipeViewModelProvider.notifier).getGoals();
    });
  }

  final goals = ['Vacation', 'Wedding', 'Birthday', "Personal Milestone"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(
          currentStep: 8,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 25),
            const Text("What is your target event?",
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
                  const SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("I don’t have a specific event",
                          style: TextStyle(
                              fontSize: 16,
                              color: AppColors.primaryColor,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
            ),
            CustomYafButton(
                iconPositionLeft: false,
                text: "Continue",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  NavigationService.push(child: const SelectEventDateScreen());
                }),
            SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
