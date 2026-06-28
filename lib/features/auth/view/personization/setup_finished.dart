import 'dart:developer';
import 'dart:ui' as ui;

import 'package:openapi/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/store_front_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
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
  bool _isSubmitting = false;

  Future<void> _submitProfile() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      final profileData = ref.read(onboardingProfileProvider);
      final profileViewModel = ref.read(userProfileViewModelProvider.notifier);
      final missingField = _firstMissingRequiredField(profileData);

      if (missingField != null) {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
          });
          ref.read(toastProvider).showError(
                'Please complete your $missingField before continuing.',
              );
        }
        return;
      }
      final timeZone = await _detectTimeZone();
      final countryCode = await _detectCountryCode(profileData);

      final surveyRequest = OnboardingSurveyRequest(
        hearAboutUs: _mapHearAboutUs(profileData.hearAboutUs),
        referralCode: profileData.referralCode,
        desiredGoal: _mapDesiredGoal(profileData.goal!),
        gender: _mapGender(profileData.gender!),
        dateOfBirth: profileData.dateOfBirth!,
        height: profileData.height!,
        heightUnit: _mapHeightUnit(profileData.heightUnit!),
        currentWeight: profileData.weight!.round(),
        currentWeightUnit: _mapCurrentWeightUnit(profileData.weightUnit!),
        activityLevel: _mapActivityLevel(profileData.activityLevel!),
        allergenExclusions: profileData.allergies ?? const [],
        targetEvent: _mapTargetEvent(profileData.targetEvent),
        targetEventDate: _targetEventDate(profileData),
        desiredWeight: profileData.desiredWeight!.round(),
        desiredWeightUnit:
            _mapDesiredWeightUnit(profileData.desiredWeightUnit!),
        goalPace: _mapGoalPace(profileData.goalPace!),
        biggestChallenge: _mapBiggestChallenge(profileData.biggestChallenge),
        notificationsEnabled: profileData.notificationsEnabled,
        mealRemindersEnabled: profileData.mealRemindersEnabled,
        healthSyncSettings: _defaultHealthSyncSettings(),
        timeZone: timeZone,
        countryCode: countryCode,
      );

      log(surveyRequest.toString());

      final success =
          await profileViewModel.submitOnboardingSurvey(surveyRequest);

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        if (success) {
          // Clear onboarding data
          ref.read(onboardingProfileProvider.notifier).reset();
          NavigationService.pushAndRemoveUntil(child: const BottomNavScreen());
        } else {
          ref.read(toastProvider).showError(
                ref.read(userProfileViewModelProvider).errorMessage ??
                    'Failed to save profile',
              );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        ref.read(toastProvider).showError(
              'Error: ${e.toString()}',
            );
      }
    }
  }

  HealthSyncSettingsDto _defaultHealthSyncSettings() {
    return HealthSyncSettingsDto(
      readSteps: false,
      readActiveCalories: false,
      readWeight: false,
      readHeartRate: false,
      readSleep: false,
      writeDietaryEnergy: false,
      writeProtein: false,
      writeCarbohydrate: false,
      writeFat: false,
    );
  }

  Future<String> _detectTimeZone() async {
    try {
      return await FlutterTimezone.getLocalTimezone();
    } catch (_) {
      return DateTime.now().timeZoneName;
    }
  }

  Future<String?> _detectCountryCode(OnboardingProfileData profileData) async {
    final selectedCountryCode = _cleanCountryCode(profileData.countryCode);
    if (selectedCountryCode != null) return selectedCountryCode;

    final storefrontCountryCode =
        _cleanCountryCode(await StorefrontService.getCountryCode());
    if (storefrontCountryCode != null) return storefrontCountryCode;

    return _cleanCountryCode(ui.PlatformDispatcher.instance.locale.countryCode);
  }

  String? _cleanCountryCode(String? countryCode) {
    final value = countryCode?.trim().toUpperCase();
    return value == null || value.isEmpty ? null : value;
  }

  String? _firstMissingRequiredField(OnboardingProfileData data) {
    final requiredFields = <String, Object?>{
      'goal': data.goal,
      'gender': data.gender,
      'date of birth': data.dateOfBirth,
      'height': data.height,
      'height unit': data.heightUnit,
      'current weight': data.weight,
      'current weight unit': data.weightUnit,
      'activity level': data.activityLevel,
      'target weight': data.desiredWeight,
      'target weight unit': data.desiredWeightUnit,
      'goal pace': data.goalPace,
    };

    for (final entry in requiredFields.entries) {
      final value = entry.value;
      if (value == null || (value is String && value.trim().isEmpty)) {
        return entry.key;
      }
    }
    return null;
  }

  OnboardingSurveyRequestHearAboutUsEnum? _mapHearAboutUs(String? source) {
    final value = _normalized(source);
    switch (value) {
      case 'FROM_AN_INFLUENCER':
        return OnboardingSurveyRequestHearAboutUsEnum.FROM_INFLUENCER;
      case 'INSTAGRAM':
        return OnboardingSurveyRequestHearAboutUsEnum.INSTAGRAM;
      case 'TIKTOK':
        return OnboardingSurveyRequestHearAboutUsEnum.TIKTOK;
      case 'YOUTUBE':
        return OnboardingSurveyRequestHearAboutUsEnum.YOUTUBE;
      case 'APP_STORE_SEARCH':
        return OnboardingSurveyRequestHearAboutUsEnum.APP_STORE_SEARCH;
      case 'FRIENDS_FAMILY':
        return OnboardingSurveyRequestHearAboutUsEnum.FRIEND_FAMILY;
      default:
        return source == null
            ? null
            : OnboardingSurveyRequestHearAboutUsEnum.OTHER;
    }
  }

  OnboardingSurveyRequestDesiredGoalEnum _mapDesiredGoal(String goal) {
    final value = goal.toLowerCase();
    if (value.contains('lose')) {
      return OnboardingSurveyRequestDesiredGoalEnum.LOSE_WEIGHT;
    }
    if (value.contains('gain')) {
      return OnboardingSurveyRequestDesiredGoalEnum.GAIN_WEIGHT;
    }
    if (value.contains('maintain')) {
      return OnboardingSurveyRequestDesiredGoalEnum.MAINTAIN_WEIGHT;
    }
    return OnboardingSurveyRequestDesiredGoalEnum.NOTHING;
  }

  OnboardingSurveyRequestGenderEnum _mapGender(String gender) {
    switch (gender.toUpperCase()) {
      case 'MALE':
        return OnboardingSurveyRequestGenderEnum.MALE;
      case 'FEMALE':
        return OnboardingSurveyRequestGenderEnum.FEMALE;
      default:
        return OnboardingSurveyRequestGenderEnum.OTHER;
    }
  }

  OnboardingSurveyRequestHeightUnitEnum _mapHeightUnit(String unit) {
    return unit.toLowerCase() == 'cm'
        ? OnboardingSurveyRequestHeightUnitEnum.CM
        : OnboardingSurveyRequestHeightUnitEnum.FT;
  }

  OnboardingSurveyRequestCurrentWeightUnitEnum _mapCurrentWeightUnit(
      String unit) {
    return unit.toLowerCase() == 'kg'
        ? OnboardingSurveyRequestCurrentWeightUnitEnum.KG
        : OnboardingSurveyRequestCurrentWeightUnitEnum.POUNDS;
  }

  OnboardingSurveyRequestDesiredWeightUnitEnum _mapDesiredWeightUnit(
      String unit) {
    return unit.toLowerCase() == 'kg'
        ? OnboardingSurveyRequestDesiredWeightUnitEnum.KG
        : OnboardingSurveyRequestDesiredWeightUnitEnum.POUNDS;
  }

  OnboardingSurveyRequestActivityLevelEnum _mapActivityLevel(String level) {
    switch (_normalized(level)) {
      case 'LIGHTLY_ACTIVE':
        return OnboardingSurveyRequestActivityLevelEnum.LIGHTLY_ACTIVE;
      case 'MODERATELY_ACTIVE':
        return OnboardingSurveyRequestActivityLevelEnum.MODERATELY_ACTIVE;
      case 'VERY_ACTIVE':
        return OnboardingSurveyRequestActivityLevelEnum.VERY_ACTIVE;
      case 'EXTRA_ACTIVE':
        return OnboardingSurveyRequestActivityLevelEnum.EXTRA_ACTIVE;
      default:
        return OnboardingSurveyRequestActivityLevelEnum.SEDENTARY;
    }
  }

  OnboardingSurveyRequestTargetEventEnum? _mapTargetEvent(String? event) {
    switch (_normalized(event)) {
      case 'VACATION':
        return OnboardingSurveyRequestTargetEventEnum.VACATION;
      case 'WEDDING':
        return OnboardingSurveyRequestTargetEventEnum.WEDDING;
      case 'BIRTHDAY':
        return OnboardingSurveyRequestTargetEventEnum.BIRTHDAY;
      case 'PERSONAL_MILESTONE':
        return OnboardingSurveyRequestTargetEventEnum.PERSONAL_MILESTONE;
      case 'NONE':
        return OnboardingSurveyRequestTargetEventEnum.NONE;
      default:
        return null;
    }
  }

  DateTime? _targetEventDate(OnboardingProfileData data) {
    return _normalized(data.targetEvent) == 'NONE'
        ? null
        : data.targetEventDate;
  }

  OnboardingSurveyRequestGoalPaceEnum _mapGoalPace(String pace) {
    switch (_normalized(pace)) {
      case 'SLOW':
        return OnboardingSurveyRequestGoalPaceEnum.SLOW;
      case 'FAST':
        return OnboardingSurveyRequestGoalPaceEnum.FAST;
      default:
        return OnboardingSurveyRequestGoalPaceEnum.OPTIMAL;
    }
  }

  OnboardingSurveyRequestBiggestChallengeEnum? _mapBiggestChallenge(
      String? challenge) {
    final value = challenge?.toLowerCase() ?? '';
    if (value.contains('consistency')) {
      return OnboardingSurveyRequestBiggestChallengeEnum.CONSISTENCY;
    }
    if (value.contains('cravings')) {
      return OnboardingSurveyRequestBiggestChallengeEnum.CRAVINGS;
    }
    if (value.contains('motivation')) {
      return OnboardingSurveyRequestBiggestChallengeEnum.MOTIVATION;
    }
    if (value.contains('emotion') || value.contains('stress')) {
      return OnboardingSurveyRequestBiggestChallengeEnum.EMOTIONAL_EATING;
    }
    if (value.contains('know')) {
      return OnboardingSurveyRequestBiggestChallengeEnum.LACK_OF_KNOWLEDGE;
    }
    if (value.contains('faster') || value.contains('easier')) {
      return OnboardingSurveyRequestBiggestChallengeEnum.NEED_EASIER_TOOL;
    }
    return null;
  }

  String _normalized(String? value) {
    return (value ?? '')
        .trim()
        .toUpperCase()
        .replaceAll(RegExp(r'[^A-Z0-9]+'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome to",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 25),
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
                width: double.infinity,
                isLoading: _isSubmitting,
                fontSize: 16,
                weight: FontWeight.w600,
                text: "Continue",
                onPressed: _submitProfile,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
