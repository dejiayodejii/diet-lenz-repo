import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Temporary storage for profile data during onboarding flow
class OnboardingProfileData {
  String? gender; // "MALE" or "FEMALE"
  double? weight;
  String? weightUnit; // "kg" or "lbs"
  double? height;
  String? heightUnit; // "cm" or "ft"
  DateTime? dateOfBirth;
  String? goal; // Goal selected from the list
  double? desiredWeight;
  String? desiredWeightUnit; // "kg" or "lbs"
  String? activityLevel; // Activity level selected
  String? dietaryPreference; // Dietary preference selected
  List<String>? allergies;
  String? country;

  OnboardingProfileData({
    this.gender,
    this.weight,
    this.weightUnit,
    this.height,
    this.heightUnit,
    this.dateOfBirth,
    this.goal,
    this.desiredWeight,
    this.desiredWeightUnit,
    this.activityLevel,
    this.dietaryPreference,
    this.allergies,
    this.country,
  });

  OnboardingProfileData copyWith({
    String? gender,
    double? weight,
    String? weightUnit,
    double? height,
    String? heightUnit,
    DateTime? dateOfBirth,
    String? goal,
    double? desiredWeight,
    String? desiredWeightUnit,
    String? activityLevel,
    String? dietaryPreference,
    List<String>? allergies,
    String? country,
  }) {
    return OnboardingProfileData(
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      height: height ?? this.height,
      heightUnit: heightUnit ?? this.heightUnit,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      goal: goal ?? this.goal,
      desiredWeight: desiredWeight ?? this.desiredWeight,
      desiredWeightUnit: desiredWeightUnit ?? this.desiredWeightUnit,
      activityLevel: activityLevel ?? this.activityLevel,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      allergies: allergies ?? this.allergies,
      country: country ?? this.country,
    );
  }
}

/// Provider to store onboarding profile data
final onboardingProfileProvider =
    StateNotifierProvider<OnboardingProfileNotifier, OnboardingProfileData>(
        (ref) {
  return OnboardingProfileNotifier();
});

class OnboardingProfileNotifier extends StateNotifier<OnboardingProfileData> {
  OnboardingProfileNotifier() : super(OnboardingProfileData());

  void updateGender(String gender) {
    state = state.copyWith(gender: gender);
  }

  void updateWeight(double weight, String unit) {
    state = state.copyWith(weight: weight, weightUnit: unit);
  }

  void updateHeight(double height, String unit) {
    state = state.copyWith(height: height, heightUnit: unit);
  }

  void updateDateOfBirth(DateTime dateOfBirth) {
    state = state.copyWith(dateOfBirth: dateOfBirth);
  }

  void updateGoal(String goal) {
    state = state.copyWith(goal: goal);
  }

  void updateDesiredWeight(double weight, String unit) {
    state = state.copyWith(desiredWeight: weight, desiredWeightUnit: unit);
  }

  void updateActivityLevel(String activityLevel) {
    state = state.copyWith(activityLevel: activityLevel);
  }

  void updateDietaryPreference(String preference) {
    state = state.copyWith(dietaryPreference: preference);
  }

  void updateAllergies(List<String> allergies) {
    state = state.copyWith(allergies: allergies);
  }

  void updateCountry(String country) {
    state = state.copyWith(country: country);
  }

  void reset() {
    state = OnboardingProfileData();
  }
}
