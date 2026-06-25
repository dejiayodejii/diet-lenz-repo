import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/component/selectable_option_tile.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/personization/from_where.dart';
import 'package:diet_lenz/features/auth/view/personization/select_age.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class GenderScreen extends ConsumerStatefulWidget {
  const GenderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<GenderScreen> {
  bool isMale = true;
  @override
  void initState() {
    super.initState();
    // Fetch goals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // ref.read(recipeViewModelProvider.notifier).getDietaryPreferences();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(
          currentStep: 5,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(height: 80),
            const Column(
              children: [
                Text("Select you biological sex",
                    style: TextStyle(
                        fontSize: 28,
                        letterSpacing: 0,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 40),
                Text("We use this to calculate your unique calorie needs",
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0,
                        color: AppColors.white,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 100),
                  SelectableOptionTile(
                    label: "Male",
                    leading: SvgPicture.asset(AppImages.male),
                    isSelected: isMale,
                    onTap: () {
                      setState(() {
                        isMale = true;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  SelectableOptionTile(
                    label: "Female",
                    leading: SvgPicture.asset(AppImages.female),
                    isSelected: !isMale,
                    onTap: () {
                      setState(() {
                        isMale = false;
                      });
                    },
                  ),
                ],
              ),
            ),
            const Column(
              children: [
                Icon(Icons.lock_outline_rounded),
                Text(
                    "We use this modifier exclusively to estimate your resting metabolic rate based on body composition. Choose the baseline that best fits your current physiology.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        letterSpacing: 0,
                        color: AppColors.white,
                        fontWeight: FontWeight.w400)),
              ],
            ),
            const SizedBox(height: 60),
            CustomYafButton(
                fontSize: 16,
                weight: FontWeight.w600,
                iconPositionLeft: false,
                text: "Continue",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  NavigationService.push(child: const SelectAgeScreen());
                }),
            SizedBox(height: 5 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
