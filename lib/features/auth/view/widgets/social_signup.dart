import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:diet_lenz/features/auth/view/register.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SocialSignUp extends ConsumerStatefulWidget {
  const SocialSignUp({
    super.key,
    this.isLogin = false,
  });
  final bool isLogin;

  @override
  ConsumerState<SocialSignUp> createState() => _SocialSignUpState();
}

class _SocialSignUpState extends ConsumerState<SocialSignUp> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Row(
          children: [
            Expanded(
                child: Divider(
              color: AppColors.surfaceGrey,
            )),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.0),
              child: Text("Or",
                  style: TextStyle(
                      fontFamily: AppFonts.spaceGrotesk,
                      fontSize: 12,
                      fontWeight: FontWeight.w400)),
            ),
            Expanded(
                child: Divider(
              color: AppColors.surfaceGrey,
            )),
          ],
        ),
        const SizedBox(height: 25),
        CustomYafButton(
            color: AppColors.surfaceColor,
            iconWidget: SvgPicture.asset(
              AppImages.googleIcon,
            ),
            text: "Continue with Google",
            onPressed: () {}),
        const SizedBox(height: 15),
        CustomYafButton(
          color: AppColors.surfaceColor,
          iconWidget: SvgPicture.asset(
            AppImages.appleIcon,
          ),
          text: "Continue with Apple",
          onPressed: () {},
        ),
        const SizedBox(height: 15),
        InkWell(
          onTap: () {
            if (widget.isLogin) {
              // Navigate to Sign Up
              NavigationService.push(child: const SignUpScreen());
            } else {
              // Navigate to Log In
              NavigationService.push(child: const LoginScreen());
            }
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  widget.isLogin
                      ? "Don’t have an account? "
                      : "Already have an account? ",
                  style: TextStyle(
                      letterSpacing: -0.5,
                      fontFamily: AppFonts.workSans,
                      fontSize: 13,
                      fontWeight: FontWeight.w400)),
              Text(widget.isLogin ? "Sign Up" : "Log In",
                  style: TextStyle(
                      letterSpacing: -0.5,
                      color: AppColors.primaryColor,
                      fontFamily: AppFonts.workSans,
                      fontSize: 13,
                      fontWeight: FontWeight.w400)),
            ],
          ),
        ),
      ],
    );
  }
}
