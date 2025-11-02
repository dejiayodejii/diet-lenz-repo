import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/referral.dart';
import 'package:diet_lenz/features/auth/view/widgets/social_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const SizedBox(height: 50),
                  SvgPicture.asset(AppImages.dietLenzLogoAlt),
                  const SizedBox(height: 20),
                  const Text(
                    "Sign Up",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  const LabelTextFormField(
                    hintText: "Username",
                  ),
                  const LabelTextFormField(
                    hintText: "Email",
                  ),
                  LabelTextFormField(
                    hintText: "Enter Password",
                    suffixIcon: SizedBox(
                        height: 12,
                        width: 12,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            AppImages.eyeShow,
                            fit: BoxFit.contain,
                          ),
                        )),
                  ),
                  LabelTextFormField(
                    hintText: "Confirm Password",
                    suffixIcon: SizedBox(
                        height: 12,
                        width: 12,
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: SvgPicture.asset(
                            AppImages.eyeShow,
                            fit: BoxFit.contain,
                          ),
                        )),
                  ),
                  const SizedBox(height: 20),
                  CustomYafButton(
                      text: "Sign Up",
                      onPressed: () {
                        NavigationService.push(child: const ReferralScreen());
                      }),
                ],
              ),
              const SocialSignUp(),
            ],
          ),
        ),
      ),
    );
  }
}
