import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_otp.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/plan_setup.dart';
import 'package:diet_lenz/features/auth/view/reset_password.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class VerifyOTPScreen extends StatefulWidget {
  const VerifyOTPScreen({super.key});

  @override
  State<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController otpController = TextEditingController();
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //
                  const SizedBox(height: 40),
                  const Text(
                    "Enter the code sent to \njohndoe@gmail.com",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        letterSpacing: 0,
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                        fontFamily: AppFonts.spaceGrotesk),
                  ),
                  const SizedBox(height: 60),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: CustomPinBoxes(
                      isOtpCorrect: true,
                      controller: otpController,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Didn’t receive code?",
                    style: TextStyle(
                        letterSpacing: 0,
                        fontFamily: AppFonts.spaceGrotesk,
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: AppColors.white),
                  ),
                  const Text(
                    "Resend code",
                    style: TextStyle(
                        letterSpacing: 0,
                        fontFamily: AppFonts.spaceGrotesk,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.primaryColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 17,
                        color: AppColors.primaryColor),
                  ),
                ],
              ),
            ),
            CustomYafButton(
                text: "Verify",
                onPressed: () {
                  NavigationService.push(child: PlanSetUpScreen());
                }),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
