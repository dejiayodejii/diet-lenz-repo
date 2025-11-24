import 'dart:developer';

import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/select_payment.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
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

      // Map goal string to enum
      ProfileRequestDtoDesiredGoalEnum? goalEnum;
      if (profileData.goal != null) {
        if (profileData.goal!.toLowerCase().contains('lose')) {
          goalEnum = ProfileRequestDtoDesiredGoalEnum.LOSE_WEIGHT;
        } else if (profileData.goal!.toLowerCase().contains('gain')) {
          goalEnum = ProfileRequestDtoDesiredGoalEnum.GAIN_WEIGHT;
        } else if (profileData.goal!.toLowerCase().contains('maintain')) {
          goalEnum = ProfileRequestDtoDesiredGoalEnum.MAINTAIN_WEIGHT;
        } else {
          goalEnum = ProfileRequestDtoDesiredGoalEnum.NOTHING;
        }
      }

      // Create profile request with all collected data
      final profileRequest = ProfileRequestDto(
        gender: profileData.gender != null
            ? (profileData.gender == 'MALE'
                ? ProfileRequestDtoGenderEnum.MALE
                : ProfileRequestDtoGenderEnum.FEMALE)
            : null,
        currentWeight: profileData.weight?.toInt(),
        currentWeightUnit: profileData.weightUnit?.toLowerCase() == 'kg'
            ? ProfileRequestDtoCurrentWeightUnitEnum.KG
            : ProfileRequestDtoCurrentWeightUnitEnum.POUNDS,
        height: profileData.height?.toInt(),
        heightUnit: profileData.heightUnit?.toLowerCase() == 'cm'
            ? ProfileRequestDtoHeightUnitEnum.CM
            : ProfileRequestDtoHeightUnitEnum.FT,
        dateOfBirth: profileData.dateOfBirth,
        desiredGoal: goalEnum,
        desiredWeight: profileData.desiredWeight?.toInt(),
        desiredWeightUnit: profileData.desiredWeightUnit?.toLowerCase() == 'kg'
            ? ProfileRequestDtoDesiredWeightUnitEnum.KG
            : ProfileRequestDtoDesiredWeightUnitEnum.POUNDS,
        dietaryPreference: profileData.dietaryPreference != null
            ? _mapDietaryPreference(profileData.dietaryPreference!)
            : null,
        activityLevel: profileData.activityLevel != null
            ? _mapActivityLevel(profileData.activityLevel!)
            : null,
        allergies: profileData.allergies ?? [],
        country: profileData.country,
      );

      log(profileRequest.toString());
      return;

      // Submit the profile
      final success = await profileViewModel.updateUserProfile(profileRequest);

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });

        if (success) {
          // Clear onboarding data
          ref.read(onboardingProfileProvider.notifier).reset();
          // Navigate to next screen
          NavigationService.push(child: const SelectPaymentScreen());
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ref.read(userProfileViewModelProvider).errorMessage ??
                    'Failed to save profile',
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  ProfileRequestDtoDietaryPreferenceEnum _mapDietaryPreference(String pref) {
    switch (pref.toUpperCase()) {
      case 'VEGAN':
        return ProfileRequestDtoDietaryPreferenceEnum.VEGAN;
      case 'VEGETARIAN':
        return ProfileRequestDtoDietaryPreferenceEnum.VEGETARIAN;
      case 'KETO':
        return ProfileRequestDtoDietaryPreferenceEnum.KETO;
      case 'PALEO':
        return ProfileRequestDtoDietaryPreferenceEnum.PALEO;
      default:
        return ProfileRequestDtoDietaryPreferenceEnum.NONE;
    }
  }

  ProfileRequestDtoActivityLevelEnum _mapActivityLevel(String level) {
    switch (level.toUpperCase()) {
      case 'SEDENTARY':
        return ProfileRequestDtoActivityLevelEnum.SEDENTARY;
      case 'LIGHTLY_ACTIVE':
        return ProfileRequestDtoActivityLevelEnum.LIGHTLY_ACTIVE;
      case 'MODERATELY_ACTIVE':
        return ProfileRequestDtoActivityLevelEnum.MODERATELY_ACTIVE;
      case 'VERY_ACTIVE':
        return ProfileRequestDtoActivityLevelEnum.VERY_ACTIVE;
      case 'EXTRA_ACTIVE':
        return ProfileRequestDtoActivityLevelEnum.EXTRA_ACTIVE;
      default:
        return ProfileRequestDtoActivityLevelEnum.SEDENTARY;
    }
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
                isLoading: _isSubmitting,
                fontSize: 16,
                weight: FontWeight.w600,
                text: "Let's Start",
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
