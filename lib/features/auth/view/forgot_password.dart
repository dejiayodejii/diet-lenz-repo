import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
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
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //
                  SizedBox(height: 40),
                  Text(
                    "Forgot Your Password?",
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    "No worries! Enter your email, and we’ll \nsend you a reset link",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFonts.spaceGrotesk),
                  ),
                  SizedBox(height: 60),
                  LabelTextFormField(
                    radius: 12,
                    hintText: "Enter Email",
                  )
                ],
              ),
            ),
            CustomYafButton(
                text: "Send Reset Link",
                onPressed: () {
                  NavigationService.push(child: const ResetPasswordScreen());
                }),
            TextButton(
              onPressed: () {
                NavigationService.pop();
              },
              child: const Text(
                "Back to Login",
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.primaryColor),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
