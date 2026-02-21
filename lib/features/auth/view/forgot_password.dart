import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/auth/view/reset_password.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

import '../../../core/services/toast_service.dart';

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  Future<void> _sendResetLink() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final viewModel = ref.read(userProfileViewModelProvider.notifier);
    final success =
        await viewModel.requestPasswordReset(_emailController.text.trim());

    if (!mounted) return;

    if (success) {
      ref.read(toastProvider).showSuccess('Reset code sent to your email');

      NavigationService.push(
        child: ResetPasswordScreen(email: _emailController.text.trim()),
      );
    } else {
      final error = ref.read(userProfileViewModelProvider).errorMessage;
      ref.read(toastProvider).showError(error ?? 'Failed to send reset link');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(
      //     content: Text(error ?? 'Failed to send reset link'),
      //     backgroundColor: Colors.red,
      //   ),
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileViewModelProvider);
    final isLoading = profileState.isLoading;

    return BlurryModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                    onTap: isLoading
                        ? null
                        : () {
                            NavigationService.pop();
                          },
                    child: SvgPicture.asset(AppImages.backButton)),
              ],
            )),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 40),
                      const Text(
                        "Forgot Your Password?",
                        style:
                            TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
                      ),
                      const Text(
                        "No worries! Enter your email, and we'll \nsend you a reset code",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFonts.spaceGrotesk),
                      ),
                      const SizedBox(height: 60),
                      LabelTextFormField(
                        controller: _emailController,
                        radius: 12,
                        hintText: "Enter Email",
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        enabled: !isLoading,
                      )
                    ],
                  ),
                ),
                CustomYafButton(
                    text: isLoading ? "Sending..." : "Send",
                    onPressed: isLoading ? null : _sendResetLink),
                TextButton(
                  onPressed: isLoading
                      ? null
                      : () {
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
        ),
      ),
    );
  }
}
