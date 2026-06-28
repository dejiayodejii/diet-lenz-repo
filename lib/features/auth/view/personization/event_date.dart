import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/component/snapping_calendar_picker.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/desired_weight.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SelectEventDateScreen extends ConsumerStatefulWidget {
  const SelectEventDateScreen({super.key});

  @override
  ConsumerState<SelectEventDateScreen> createState() =>
      _SelectEventDateScreenState();
}

class _SelectEventDateScreenState extends ConsumerState<SelectEventDateScreen> {
  late DateTime _selectedDate;

  int get _startYear => DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
  }

  void _continue() {
    ref
        .read(onboardingProfileProvider.notifier)
        .updateTargetEventDate(_selectedDate);
    NavigationService.push(child: const DesiredWeightScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(currentStep: 9),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            const Text(
              "When is your \nwedding?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 56),
            SnappingCalendarPicker(
              initialDate: _selectedDate,
              startYear: _startYear,
              yearCount: 20,
              onDateChanged: (date) => _selectedDate = date,
            ),
            const Spacer(),
            CustomYafButton(
              fontSize: 16,
              weight: FontWeight.w600,
              iconPositionLeft: false,
              text: "Continue",
              color: AppColors.primaryColor,
              iconWidget: SvgPicture.asset(AppImages.arrowRight),
              onPressed: _continue,
            ),
            SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}
