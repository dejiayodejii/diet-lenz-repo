import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/forgot_password.dart';
import 'package:diet_lenz/features/auth/view/select_gender.dart';
import 'package:diet_lenz/features/auth/view/verify_otp.dart';
import 'package:diet_lenz/features/auth/view/widgets/social_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class PlanSetUpScreen extends ConsumerStatefulWidget {
  const PlanSetUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlanSetUpScreenState();
}

class _PlanSetUpScreenState extends ConsumerState<PlanSetUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(height: 50),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppImages.dietLenzLogoAlt),
                    const SizedBox(height: 60),
                    SvgPicture.asset(AppImages.text1),
                    const SizedBox(height: 25),
                    SvgPicture.asset(AppImages.text2),
                    const SizedBox(height: 25),
                    SvgPicture.asset(AppImages.text3),
                  ],
                ),
              ),
              CustomYafButton(
                  text: "Let’s Start",
                  onPressed: () {
                    NavigationService.push(child: const GenderScreen());
                  }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
