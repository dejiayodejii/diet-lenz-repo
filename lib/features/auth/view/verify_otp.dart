import 'dart:async';

import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_otp.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/auth/view/personization/plan_setup.dart';
import 'package:diet_lenz/features/auth/view/personization/setup_finished.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:diet_lenz/core/utils/loader.dart';

class VerifyOTPScreen extends ConsumerStatefulWidget {
  final String email;
  const VerifyOTPScreen({super.key, required this.email});

  @override
  ConsumerState<VerifyOTPScreen> createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends ConsumerState<VerifyOTPScreen> {
  final TextEditingController otpController = TextEditingController();
  Timer? _resendTimer;
  int _resendCountdown = 60; // 60 seconds countdown
  bool _canResend = false;

  @override
  void initState() {
    super.initState();
    otpController.addListener(() {
      setState(() {});
    });
    _startResendTimer();
  }

  void _startResendTimer() {
    setState(() {
      _resendCountdown = 60;
      _canResend = false;
    });

    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_resendCountdown > 0) {
          _resendCountdown--;
        } else {
          _canResend = true;
          timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authViewModelProvider);

    return BlurryModalProgressHUD(
      inAsyncCall: authState.isLoading,
      child: Scaffold(
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      //
                      const SizedBox(height: 40),
                      Text(
                        "Enter the code sent to \n${widget.email}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            letterSpacing: 0,
                            fontSize: 17,
                            fontWeight: FontWeight.w400,
                            fontFamily: AppFonts.spaceGrotesk),
                      ),
                      const SizedBox(height: 60),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: CustomPinBoxes(
                          isOtpCorrect:
                              true, // This logic might need refinement based on validation
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
                      if (!_canResend)
                        Text(
                          "Resend code in ${_resendCountdown}s",
                          style: const TextStyle(
                              letterSpacing: 0,
                              fontFamily: AppFonts.spaceGrotesk,
                              fontWeight: FontWeight.w400,
                              fontSize: 17,
                              color: AppColors.primaryColor),
                        )
                      else
                        GestureDetector(
                          onTap: () async {
                            final success = await ref
                                .read(authViewModelProvider.notifier)
                                .resendOtp(email: widget.email);
                            if (success) {
                              _startResendTimer();
                              ref
                                  .read(toastProvider)
                                  .showSuccess("OTP resent successfully.");
                            } else {
                              ref.read(toastProvider).showError(
                                  "Failed to resend OTP. Please try again.");
                            }
                          },
                          child: const Text(
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
                        ),
                    ],
                  ),
                ),
                CustomYafButton(
                    isDisabled:
                        authState.isLoading || otpController.text.length < 6,
                    fontSize: 16,
                    weight: FontWeight.w600,
                    text: "Verify",
                    onPressed: () async {
                      if (otpController.text.length < 6) {
                        ref
                            .read(toastProvider)
                            .showError("Please enter the 6-digit OTP code.");
                        return;
                      }

                      final success = await ref
                          .read(authViewModelProvider.notifier)
                          .verifyEmail(
                            email: widget.email,
                            otp: otpController.text,
                          );

                      if (success) {
                        NavigationService.push(child: const PlanFinishedScreen());
                      } else {
                        ref.read(toastProvider).showError(
                            ref.read(authViewModelProvider).errorMessage ??
                                "OTP verification failed.");
                      }
                    }),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
