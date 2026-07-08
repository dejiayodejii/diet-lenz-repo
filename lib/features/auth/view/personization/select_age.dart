import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/component/snapping_calendar_picker.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/select_height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class SelectAgeScreen extends ConsumerStatefulWidget {
  const SelectAgeScreen({super.key});

  @override
  ConsumerState<SelectAgeScreen> createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends ConsumerState<SelectAgeScreen> {
  static const _startYear = 1900;
  static const _minimumAge = 14;

  late DateTime _selectedDate;

  int get _latestAllowedBirthYear => DateTime.now().year - _minimumAge;

  int get _yearCount => _latestAllowedBirthYear - _startYear + 1;

  int get _selectedAge => _calculateAge(_selectedDate);

  @override
  void initState() {
    super.initState();
    final savedDate = ref.read(onboardingProfileProvider).dateOfBirth;
    _selectedDate = savedDate ?? DateTime(DateTime.now().year - 18);
  }

  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    var age = today.year - birthDate.year;
    final birthdayThisYear = DateTime(
      today.year,
      birthDate.month,
      birthDate.day,
    );

    if (birthdayThisYear.isAfter(today)) {
      age -= 1;
    }

    return age;
  }

  void _continue() {
    ref
        .read(onboardingProfileProvider.notifier)
        .updateDateOfBirth(_selectedDate);
    NavigationService.push(child: const SelectHeightScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(currentStep: 6),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            const Text(
              "When is your \nbirthday?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "Your age shapes your metabolic rate.",
              style: TextStyle(
                fontSize: 15,
                letterSpacing: 0,
                color: AppColors.white,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
            SnappingCalendarPicker(
              initialDate: _selectedDate,
              startYear: _startYear,
              yearCount: _yearCount,
              onDateChanged: (date) {
                setState(() => _selectedDate = date);
              },
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.all(11),
              decoration: BoxDecoration(
                color: const Color(0xff393C43),
                borderRadius: BorderRadius.circular(13),
              ),
              child: Text(
                "You are $_selectedAge ${_selectedAge == 1 ? 'year' : 'years'} old",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
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
