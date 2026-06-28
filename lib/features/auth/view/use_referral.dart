import 'package:openapi/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/select_goal.dart';
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

  @override
  void dispose() {
    _referralController.dispose();
    super.dispose();
  }

  void _navigateToNextScreen() {
    final referralCode = _referralController.text.trim();
    if (referralCode.isNotEmpty) {
      ref
          .read(onboardingProfileProvider.notifier)
          .updateReferralCode(referralCode);
    }
    NavigationService.push(child: const SelectGoalScreen());
  }

  Future<void> _applyReferral() async {
    NavigationService.push(child: const SelectGoalScreen());
    return;
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
    return BlurryModalProgressHUD(
      inAsyncCall: _isLoading,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const PersonalizationStepper(
            currentStep: 2,
          ),
        ),
        bottomSheet: SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
                16, 0, 16, MediaQuery.of(context).padding.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomYafButton(
                  fontSize: 16,
                  weight: FontWeight.w600,
                  iconPositionLeft: false,
                  text: _isLoading ? "Applying..." : "Continue",
                  onPressed: _isLoading ? () {} : _applyReferral,
                  iconWidget: SvgPicture.asset(AppImages.arrowRight),
                ),
                const SizedBox(height: 5),
                TextButton(
                  onPressed: _isLoading ? null : _navigateToNextScreen,
                  child: const Text("Skip"),
                ),
              ],
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Do you have a \nreferral code?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          letterSpacing: 0,
                          color: AppColors.white,
                          fontWeight: FontWeight.w600)),
                  const SizedBox(height: 100),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: LabelTextFormField(
                      hintText: "Referral Code",
                      controller: _referralController,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
