import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/auth/view/personization/plan_setup.dart';
import 'package:diet_lenz/features/auth/view/verify_otp.dart';
import 'package:diet_lenz/features/subscription/controller/subscription_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class ReferralScreen extends ConsumerStatefulWidget {
  final String email;
  final bool isSocialLogin;
  const ReferralScreen(
      {super.key, required this.email, this.isSocialLogin = false});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<ReferralScreen> {
  final TextEditingController _referralController = TextEditingController();
  bool _isLoading = false;

  void _navigateToNextScreen() {
    if (widget.isSocialLogin) {
      NavigationService.push(child: const PlanSetUpScreen());
    } else {
      NavigationService.push(child: VerifyOTPScreen(email: widget.email));
    }
  }

  Future<void> _applyReferral() async {
    if (_referralController.text.isEmpty) {
      ref
          .read(toastProvider)
          .showError("Please enter a referral code or skip to continue.");
      return;
    }

    setState(() => _isLoading = true);

    final success = await ref
        .read(subscriptionViewModelProvider.notifier)
        .applyReferral(
            ReferralApplyRequest(code: _referralController.text.trim()));

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (success) {
      ref.read(toastProvider).showSuccess("Referral code applied!");
      _navigateToNextScreen();
    } else {
      final error = ref.read(subscriptionViewModelProvider).errorMessage;
      ref.read(toastProvider).showError(error ?? "Invalid referral code");
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: BlurryModalProgressHUD(
        inAsyncCall: _isLoading,
        child: Scaffold(
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
                      text: _isLoading ? "Applying..." : "Continue",
                      onPressed: _isLoading ? () {} : _applyReferral),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: _navigateToNextScreen,
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
        ),
      ),
    );
  }
}
