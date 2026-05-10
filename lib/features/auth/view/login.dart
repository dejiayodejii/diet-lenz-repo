import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/push_notification_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/core/widgets/biometric_setup_dialog.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/forgot_password.dart';
import 'package:diet_lenz/features/auth/view/use_referral.dart';
import 'package:diet_lenz/features/auth/view/widgets/social_signup.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController =
      TextEditingController(text: kDebugMode ? "max1@yopmail.com" : "");
  final TextEditingController passwordController =
      TextEditingController(text: kDebugMode ? "Ayanbunmi3@" : "");

  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    final authController = ref.watch(authViewModelProvider.notifier);
    final authState = ref.watch(authViewModelProvider);
    return BlurryModalProgressHUD(
      inAsyncCall: authState.isLoading,
      child: Scaffold(
        backgroundColor: const Color.fromRGBO(18, 18, 18, 1),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 50),
                        SvgPicture.asset(AppImages.dietLenzLogoAlt),
                        const SizedBox(height: 20),
                        const Text(
                          "Welcome back",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 50),
                        LabelTextFormField(
                          hintText: "Enter Email",
                          controller: emailController,
                        ),
                        const SizedBox(height: 20),
                        LabelTextFormField(
                          obscureText: _obscurePassword,
                          hintText: "Enter Password",
                          controller: passwordController,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                            child: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.grey,
                            ),
                          ),
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
                        CustomYafButton(
                            text: "Login",
                            onPressed: () async {
                              // NavigationService.push(
                              //     child: const PaywallScreen());
                              // return;
                              final response = await authController.login(
                                  email: emailController.text,
                                  deviceId: '',
                                  deviceName: '',
                                  password: passwordController.text);

                              if (response) {
                                if (ref
                                        .read(authViewModelProvider)
                                        .authResponse!
                                        .emailVerified ==
                                    false) {
                                  ref
                                      .read(authViewModelProvider.notifier)
                                      .resendOtp(
                                        email: emailController.text,
                                      );
                                  NavigationService.push(
                                    child: ReferralScreen(
                                        email: emailController.text,
                                        isSocialLogin: false),
                                  );
                                } else {
                                  final hasProfile = await ref
                                      .read(
                                          userProfileViewModelProvider.notifier)
                                      .getUserProfile();

                                  if (hasProfile) {
                                    // Prompt biometric setup before navigating
                                    if (context.mounted) {
                                      await showBiometricSetupDialog(
                                          context, ref);
                                    }
                                    NavigationService.pushAndRemoveUntil(
                                        child: const BottomNavScreen());
                                  } else {
                                    NavigationService.push(
                                      child: ReferralScreen(
                                          email: emailController.text,
                                          isSocialLogin: true),
                                    );
                                  }
                                }
                              } else {
                                final currentError = ref
                                    .read(authViewModelProvider)
                                    .errorMessage;
                                ref.read(toastProvider).showError(currentError);
                              }
                            }),
                        const SizedBox(height: 40),
                        const SocialSignUp(isLogin: true),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
