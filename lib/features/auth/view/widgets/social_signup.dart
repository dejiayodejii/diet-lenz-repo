import 'dart:io';

import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/social_auth_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:diet_lenz/features/auth/view/personization/from_where.dart';
import 'package:diet_lenz/features/auth/view/personization/plan_details.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
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
  bool _isLoading = false;

  Future<void> _handleGoogleSignIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final socialAuth = ref.read(socialAuthServiceProvider);
      final idToken = await socialAuth.signInWithGoogle();

      if (!mounted) return;
      if (idToken == null) {
        setState(() => _isLoading = false);
        return; // User cancelled
      }

      final authController = ref.read(authViewModelProvider.notifier);
      final success = await authController.googleLogin(
          idToken: idToken, deviceId: "xyz", deviceName: "");

      if (!mounted) return;

      if (success) {
        await _handleSuccessfulSocialAuth();
      } else {
        setState(() => _isLoading = false);
        final error = ref.read(authViewModelProvider).errorMessage;
        ref.read(toastProvider).showError(error ?? 'Google sign-in failed');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ref.read(toastProvider).showError('Google sign-in failed');
      }
    }
  }

  Future<void> _handleAppleSignIn() async {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    try {
      final socialAuth = ref.read(socialAuthServiceProvider);
      final idToken = await socialAuth.signInWithApple();

      if (!mounted) return;
      if (idToken == null) {
        setState(() => _isLoading = false);
        return; // User cancelled
      }

      final authController = ref.read(authViewModelProvider.notifier);
      final success = await authController.appleLogin(idToken: idToken);

      if (!mounted) return;

      if (success) {
        await _handleSuccessfulSocialAuth();
      } else {
        setState(() => _isLoading = false);
        final error = ref.read(authViewModelProvider).errorMessage;
        ref.read(toastProvider).showError(error ?? 'Apple sign-in failed');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ref.read(toastProvider).showError('Apple sign-in failed');
      }
    }
  }

  Future<void> _handleSuccessfulSocialAuth() async {
    if (!widget.isLogin) {
      setState(() => _isLoading = false);

      // Social signup is already verified by the provider. Continue from the
      // same screen reached after email verification in the regular flow.
      NavigationService.push(child: const PlanDetailsScreen());
      return;
    }

    final hasProfile =
        await ref.read(userProfileViewModelProvider.notifier).getUserProfile();

    if (!mounted) return;

    if (hasProfile) {
      setState(() => _isLoading = false);
      NavigationService.pushAndRemoveUntil(child: const BottomNavScreen());
    } else {
      // Do not keep an authenticated session created through the login entry
      // point when the account has no completed profile.
      await ref.read(authViewModelProvider.notifier).logout();
      if (!mounted) return;

      setState(() => _isLoading = false);
      ref.read(toastProvider).showError('Account not found. Please sign up');
    }
  }

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
            text: _isLoading ? "Signing in..." : "Continue with Google",
            onPressed: _isLoading ? () {} : _handleGoogleSignIn),
        const SizedBox(height: 15),
        if (Platform.isIOS)
          CustomYafButton(
            color: AppColors.surfaceColor,
            iconWidget: SvgPicture.asset(
              AppImages.appleIcon,
            ),
            text: _isLoading ? "Signing in..." : "Continue with Apple",
            onPressed: _isLoading ? () {} : _handleAppleSignIn,
          ),
        if (Platform.isIOS) const SizedBox(height: 15),
        InkWell(
          onTap: () {
            if (widget.isLogin) {
              // Navigate to Sign Up
              NavigationService.push(child: const FromWhereScreen());
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
                  style: const TextStyle(
                      letterSpacing: -0.5,
                      fontFamily: AppFonts.workSans,
                      fontSize: 13,
                      fontWeight: FontWeight.w400)),
              Text(widget.isLogin ? "Sign Up" : "Log In",
                  style: const TextStyle(
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
