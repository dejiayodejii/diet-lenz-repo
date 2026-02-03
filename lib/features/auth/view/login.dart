import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/forgot_password.dart';
import 'package:diet_lenz/features/auth/view/personization/activity_level.dart';
import 'package:diet_lenz/features/auth/view/personization/select_country.dart';
import 'package:diet_lenz/features/auth/view/widgets/social_signup.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/home/views/home.dart';
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
      TextEditingController(text: kDebugMode ? "bank@yopmail.com" : "");
  final TextEditingController passwordController =
      TextEditingController(text: kDebugMode ? "Ayanbunmi3@" : "");
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
                          hintText: "Enter Password",
                          controller: passwordController,
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
                        CustomYafButton(
                            text: "Login",
                            onPressed: () async {
                              final response = await authController.login(
                                  email: emailController.text,
                                  deviceId: 'ggfhg',
                                  deviceName: 'hgjgj',
                                  password: passwordController.text);

                              if (response) {
                                NavigationService.push(
                                    child: const BottomNavScreen());
                              } else {
                                ref
                                    .read(toastProvider)
                                    .showError(authState.errorMessage);
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
