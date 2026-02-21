import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/auth/view/verify_otp.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ReferralScreen extends ConsumerStatefulWidget {
  final String email;
  const ReferralScreen({super.key, required this.email});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<ReferralScreen> {
  final TextEditingController _referralController = TextEditingController();
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(AppImages.dietLenzLogoAlt),
                    LabelTextFormField(
                      hintText: "Referral Code",
                      controller: _referralController,
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              CustomYafButton(
                  text: "Continue",
                  onPressed: () {
                    NavigationService.push(
                        child: VerifyOTPScreen(email: widget.email));
                    // if (_referralController.text.isNotEmpty) {
                    //   NavigationService.push(
                    //       child: VerifyOTPScreen(email: widget.email));
                    // } else {
                    //   ref.read(toastProvider).showError(
                    //       "Please enter a referral code or skip to continue.");
                    // }
                  }),
              const SizedBox(height: 10),
              Align(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    NavigationService.push(
                        child: VerifyOTPScreen(email: widget.email));
                  },
                  child: const Text("Skip",
                      style: TextStyle(
                          fontFamily: AppFonts.spaceGrotesk,
                          fontSize: 13,
                          color: AppColors.white,
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
