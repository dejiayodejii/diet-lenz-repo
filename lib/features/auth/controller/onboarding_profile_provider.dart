import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Temporary storage for profile data during onboarding flow
class OnboardingProfileData {
  String? hearAboutUs;
  String? referralCode;
  String? gender; // "MALE" or "FEMALE"
  double? weight;
  String? weightUnit; // "kg" or "lbs"
  double? height;
  String? heightUnit; // "cm" or "ft"
  DateTime? dateOfBirth;
  String? goal; // Goal selected from the list
  String? macroTarget; // Macro target selected from the list
  double? desiredWeight;
  String? desiredWeightUnit; // "kg" or "lbs"
  String? goalPace;
  String? activityLevel; // Activity level selected
  String? dietaryPreference; // Dietary preference selected
  List<String>? allergies;
  String? targetEvent;
  DateTime? targetEventDate;
  String? biggestChallenge;
  bool? notificationsEnabled;
  bool? mealRemindersEnabled;
  String? country;
  String? countryCode;

  OnboardingProfileData({
    this.hearAboutUs,
    this.referralCode,
    this.macroTarget,
    this.gender,
    this.weight,
    this.weightUnit,
    this.height,
    this.heightUnit,
    this.dateOfBirth,
    this.goal,
    this.desiredWeight,
    this.desiredWeightUnit,
    this.goalPace,
    this.activityLevel,
    this.dietaryPreference,
    this.allergies,
    this.targetEvent,
    this.targetEventDate,
    this.biggestChallenge,
    this.notificationsEnabled,
    this.mealRemindersEnabled,
    this.country,
    this.countryCode,
  });

  OnboardingProfileData copyWith({
    String? hearAboutUs,
    String? referralCode,
    String? gender,
    double? weight,
    String? weightUnit,
    double? height,
    String? heightUnit,
    DateTime? dateOfBirth,
    String? goal,
    String? macroTarget,
    double? desiredWeight,
    String? desiredWeightUnit,
    String? goalPace,
    String? activityLevel,
    String? dietaryPreference,
    List<String>? allergies,
    String? targetEvent,
    DateTime? targetEventDate,
    String? biggestChallenge,
    bool? notificationsEnabled,
    bool? mealRemindersEnabled,
    String? country,
    String? countryCode,
  }) {
    return OnboardingProfileData(
      hearAboutUs: hearAboutUs ?? this.hearAboutUs,
      referralCode: referralCode ?? this.referralCode,
      macroTarget: macroTarget ?? this.macroTarget,
      gender: gender ?? this.gender,
      weight: weight ?? this.weight,
      weightUnit: weightUnit ?? this.weightUnit,
      height: height ?? this.height,
      heightUnit: heightUnit ?? this.heightUnit,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      goal: goal ?? this.goal,
      desiredWeight: desiredWeight ?? this.desiredWeight,
      desiredWeightUnit: desiredWeightUnit ?? this.desiredWeightUnit,
      goalPace: goalPace ?? this.goalPace,
      activityLevel: activityLevel ?? this.activityLevel,
      dietaryPreference: dietaryPreference ?? this.dietaryPreference,
      allergies: allergies ?? this.allergies,
      targetEvent: targetEvent ?? this.targetEvent,
      targetEventDate: targetEventDate ?? this.targetEventDate,
      biggestChallenge: biggestChallenge ?? this.biggestChallenge,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      mealRemindersEnabled: mealRemindersEnabled ?? this.mealRemindersEnabled,
      country: country ?? this.country,
      countryCode: countryCode ?? this.countryCode,
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

  void updateHearAboutUs(String hearAboutUs) {
    state = state.copyWith(hearAboutUs: hearAboutUs);
  }

  void updateReferralCode(String referralCode) {
    state = state.copyWith(referralCode: referralCode);
  }

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

  void updateMacroTarget(String macroTarget) {
    state = state.copyWith(macroTarget: macroTarget);
  }

  void updateDesiredWeight(double weight, String unit) {
    state = state.copyWith(desiredWeight: weight, desiredWeightUnit: unit);
  }

  void updateGoalPace(String goalPace) {
    state = state.copyWith(goalPace: goalPace);
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

  void updateTargetEvent(String targetEvent) {
    state = state.copyWith(targetEvent: targetEvent);
  }

  void updateTargetEventDate(DateTime targetEventDate) {
    state = state.copyWith(targetEventDate: targetEventDate);
  }

  void updateBiggestChallenge(String biggestChallenge) {
    state = state.copyWith(biggestChallenge: biggestChallenge);
  }

  void updateNotifications({
    required bool notificationsEnabled,
    bool? mealRemindersEnabled,
  }) {
    state = state.copyWith(
      notificationsEnabled: notificationsEnabled,
      mealRemindersEnabled: mealRemindersEnabled,
    );
  }

  void updateCountry(String country, {String? countryCode}) {
    state = state.copyWith(country: country, countryCode: countryCode);
  }

  void reset() {
    state = OnboardingProfileData();
  }
}
