import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/forgot_password.dart';
import 'package:diet_lenz/features/auth/view/widgets/social_signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
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
                    "Welcome back",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 50),
                  const LabelTextFormField(
                    hintText: "Enter Email",
                  ),
                  const SizedBox(height: 20),
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
                  Align(
                    alignment: Alignment.topRight,
                    child: GestureDetector(
                      onTap: () {
                        NavigationService.push(
                            child: const ForgotPasswordScreen());
                      },
                      child: const Text("Forgot Password?",
                          style: TextStyle(
                              fontFamily: AppFonts.spaceGrotesk,
                              fontSize: 12,
                              color: AppColors.white,
                              fontWeight: FontWeight.w400)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  CustomYafButton(text: "Login", onPressed: () {}),
                ],
              ),
              const SocialSignUp(isLogin: true),
            ],
          ),
        ),
      ),
    );
  }
}
