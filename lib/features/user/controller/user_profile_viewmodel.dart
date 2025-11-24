import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// User Profile state to track loading, success, error states
class UserProfileState {
  final bool isLoading;
  final UserProfile? userProfile;
  final String? errorMessage;
  final bool hasProfile;

  UserProfileState({
    this.isLoading = false,
    this.userProfile,
    this.errorMessage,
    this.hasProfile = false,
  });

  UserProfileState copyWith({
    bool? isLoading,
    UserProfile? userProfile,
    String? errorMessage,
    bool? hasProfile,
  }) {
    return UserProfileState(
      isLoading: isLoading ?? this.isLoading,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage,
      hasProfile: hasProfile ?? this.hasProfile,
    );
  }
}

/// User Profile ViewModel provider
final userProfileViewModelProvider =
    StateNotifierProvider<UserProfileViewModel, UserProfileState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserProfileViewModel(apiService);
});

/// User Profile ViewModel with all profile management methods
class UserProfileViewModel extends StateNotifier<UserProfileState> {
  UserProfileViewModel(this._apiService) : super(UserProfileState());

  final ApiService _apiService;

  /// Get user profile
  Future<bool> getUserProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.userApi.getUserProfile();

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          userProfile: response,
          hasProfile: true,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load profile',
          hasProfile: false,
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
        hasProfile: false,
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
        hasProfile: false,
      );
      return false;
    }
  }

  /// Update user profile
  Future<bool> updateUserProfile(ProfileRequestDto profileRequest) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response =
          await _apiService.userApi.updateUserProfile(profileRequest);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          userProfile: response,
          hasProfile: true,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update profile',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update specific profile fields (helper method for convenience)
  Future<bool> updateProfileFields({
    ProfileRequestDtoGenderEnum? gender,
    int? currentWeight,
    ProfileRequestDtoCurrentWeightUnitEnum? currentWeightUnit,
    int? height,
    ProfileRequestDtoHeightUnitEnum? heightUnit,
    DateTime? dateOfBirth,
    ProfileRequestDtoDesiredGoalEnum? desiredGoal,
    int? desiredWeight,
    ProfileRequestDtoDesiredWeightUnitEnum? desiredWeightUnit,
    ProfileRequestDtoDietaryPreferenceEnum? dietaryPreference,
    ProfileRequestDtoActivityLevelEnum? activityLevel,
    ProfileRequestDtoMacroTargetEnum? macroTarget,
    List<String>? allergies,
    String? country,
  }) async {
    // Create a profile request with only the fields that are provided
    final profileRequest = ProfileRequestDto(
      gender:
          gender ?? (state.userProfile?.gender as ProfileRequestDtoGenderEnum?),
      currentWeight: currentWeight ?? state.userProfile?.currentWeight?.toInt(),
      currentWeightUnit: currentWeightUnit ??
          (state.userProfile?.currentWeightUnit
              as ProfileRequestDtoCurrentWeightUnitEnum?),
      height: height ?? state.userProfile?.height?.toInt(),
      heightUnit: heightUnit ??
          (state.userProfile?.heightUnit as ProfileRequestDtoHeightUnitEnum?),
      dateOfBirth: dateOfBirth ?? state.userProfile?.dateOfBirth,
      desiredGoal: desiredGoal ??
          (state.userProfile?.desiredGoal as ProfileRequestDtoDesiredGoalEnum?),
      desiredWeight: desiredWeight ?? state.userProfile?.desiredWeight?.toInt(),
      desiredWeightUnit: desiredWeightUnit ??
          (state.userProfile?.desiredWeightUnit
              as ProfileRequestDtoDesiredWeightUnitEnum?),
      dietaryPreference: dietaryPreference ??
          (state.userProfile?.dietaryPreference
              as ProfileRequestDtoDietaryPreferenceEnum?),
      activityLevel: activityLevel ??
          (state.userProfile?.activityLevel
              as ProfileRequestDtoActivityLevelEnum?),
      macroTarget: macroTarget ??
          (state.userProfile?.macroTarget as ProfileRequestDtoMacroTargetEnum?),
      allergies:
          allergies ?? (state.userProfile?.allergenExclusions.toList() ?? []),
      country: country ?? state.userProfile?.country,
    );

    return await updateUserProfile(profileRequest);
  }

  /// Update weight
  Future<bool> updateWeight({
    required double weight,
    required String unit, // "kg" or "lbs"/"pounds"
  }) async {
    final weightUnit = unit.toLowerCase() == 'kg'
        ? ProfileRequestDtoCurrentWeightUnitEnum.KG
        : ProfileRequestDtoCurrentWeightUnitEnum.POUNDS;

    return await updateProfileFields(
      currentWeight: weight.toInt(),
      currentWeightUnit: weightUnit,
    );
  }

  /// Update height
  Future<bool> updateHeight({
    required double height,
    required String unit, // "cm" or "ft"
  }) async {
    final heightUnit = unit.toLowerCase() == 'cm'
        ? ProfileRequestDtoHeightUnitEnum.CM
        : ProfileRequestDtoHeightUnitEnum.FT;

    return await updateProfileFields(
      height: height.toInt(),
      heightUnit: heightUnit,
    );
  }

  /// Update desired weight
  Future<bool> updateDesiredWeight({
    required double weight,
    required String unit, // "kg" or "lbs"/"pounds"
  }) async {
    final weightUnit = unit.toLowerCase() == 'kg'
        ? ProfileRequestDtoDesiredWeightUnitEnum.KG
        : ProfileRequestDtoDesiredWeightUnitEnum.POUNDS;

    return await updateProfileFields(
      desiredWeight: weight.toInt(),
      desiredWeightUnit: weightUnit,
    );
  }

  /// Update dietary preference
  Future<bool> updateDietaryPreference(
      ProfileRequestDtoDietaryPreferenceEnum preference) async {
    return await updateProfileFields(dietaryPreference: preference);
  }

  /// Update activity level
  Future<bool> updateActivityLevel(
      ProfileRequestDtoActivityLevelEnum activityLevel) async {
    return await updateProfileFields(activityLevel: activityLevel);
  }

  /// Update gender
  Future<bool> updateGender(ProfileRequestDtoGenderEnum gender) async {
    return await updateProfileFields(gender: gender);
  }

  /// Update date of birth
  Future<bool> updateDateOfBirth(DateTime dateOfBirth) async {
    return await updateProfileFields(dateOfBirth: dateOfBirth);
  }

  /// Update desired goal
  Future<bool> updateDesiredGoal(ProfileRequestDtoDesiredGoalEnum goal) async {
    return await updateProfileFields(desiredGoal: goal);
  }

  /// Update macro target
  Future<bool> updateMacroTarget(
      ProfileRequestDtoMacroTargetEnum macroTarget) async {
    return await updateProfileFields(macroTarget: macroTarget);
  }

  /// Update allergies
  Future<bool> updateAllergies(List<String> allergies) async {
    return await updateProfileFields(allergies: allergies);
  }

  /// Update country
  Future<bool> updateCountry(String country) async {
    return await updateProfileFields(country: country);
  }

  /// Clear profile data
  void clearProfile() {
    state = UserProfileState();
  }

  /// Parse API error messages
  String _parseApiError(ApiException e) {
    final message = e.message;

    switch (e.code) {
      case 400:
        return 'Invalid profile data: $message';
      case 401:
        return 'Unauthorized. Please login again';
      case 403:
        return 'Access forbidden';
      case 404:
        return 'Profile not found';
      case 500:
        return 'Server error. Please try again later';
      default:
        return message ?? 'An error occurred. Please try again';
    }
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(errorMessage: null);
  }
}
