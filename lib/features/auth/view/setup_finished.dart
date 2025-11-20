import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/select_gender.dart';
import 'package:diet_lenz/features/auth/view/select_payment.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class PlanFinishedScreen extends ConsumerStatefulWidget {
  const PlanFinishedScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PlanSetUpScreenState();
}

class _PlanSetUpScreenState extends ConsumerState<PlanFinishedScreen> {
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppImages.dietLenzLogoAlt),
                    const SizedBox(height: 60),
                    SvgPicture.asset(AppImages.text6),
                    const SizedBox(height: 25),
                    SvgPicture.asset(AppImages.text7),
                    const SizedBox(height: 25),
                    SvgPicture.asset(AppImages.text8),
                  ],
                ),
              ),
              CustomYafButton(
                  fontSize: 16,
                  weight: FontWeight.w600,
                  text: "Let’s Start",
                  onPressed: () {
                    NavigationService.push(child: const SelectPaymentScreen());
                  }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
