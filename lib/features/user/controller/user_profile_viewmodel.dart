import 'dart:convert';

import 'package:openapi/api.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show MultipartFile;

/// User Profile state to track loading, success, error states
class UserProfileState {
  final bool isLoading;
  final UserProfile? userProfile;
  final String? errorMessage;
  final bool hasProfile;
  final PagedModelUserNotification? notifications;
  final String? successMessage;
  final WeightProgressResponse? weightProgress;
  final bool isWeightProgressLoading;
  final bool isWeightLogSubmitting;
  final MacroCompositionResponse? macroComposition;
  final bool isMacroCompositionLoading;
  final EnergyBalanceResponse? energyBalance;
  final bool isEnergyBalanceLoading;
  final bool isMacroCompositionStale;
  final bool isEnergyBalanceStale;

  UserProfileState({
    this.isLoading = false,
    this.userProfile,
    this.errorMessage,
    this.hasProfile = false,
    this.notifications,
    this.successMessage,
    this.weightProgress,
    this.isWeightProgressLoading = false,
    this.isWeightLogSubmitting = false,
    this.macroComposition,
    this.isMacroCompositionLoading = false,
    this.energyBalance,
    this.isEnergyBalanceLoading = false,
    this.isMacroCompositionStale = false,
    this.isEnergyBalanceStale = false,
  });

  UserProfileState copyWith({
    bool? isLoading,
    UserProfile? userProfile,
    String? errorMessage,
    bool? hasProfile,
    PagedModelUserNotification? notifications,
    String? successMessage,
    WeightProgressResponse? weightProgress,
    bool? isWeightProgressLoading,
    bool? isWeightLogSubmitting,
    MacroCompositionResponse? macroComposition,
    bool? isMacroCompositionLoading,
    EnergyBalanceResponse? energyBalance,
    bool? isEnergyBalanceLoading,
    bool? isMacroCompositionStale,
    bool? isEnergyBalanceStale,
  }) {
    return UserProfileState(
      isLoading: isLoading ?? this.isLoading,
      userProfile: userProfile ?? this.userProfile,
      errorMessage: errorMessage,
      hasProfile: hasProfile ?? this.hasProfile,
      notifications: notifications ?? this.notifications,
      successMessage: successMessage,
      weightProgress: weightProgress ?? this.weightProgress,
      isWeightProgressLoading:
          isWeightProgressLoading ?? this.isWeightProgressLoading,
      isWeightLogSubmitting:
          isWeightLogSubmitting ?? this.isWeightLogSubmitting,
      macroComposition: macroComposition ?? this.macroComposition,
      isMacroCompositionLoading:
          isMacroCompositionLoading ?? this.isMacroCompositionLoading,
      energyBalance: energyBalance ?? this.energyBalance,
      isEnergyBalanceLoading:
          isEnergyBalanceLoading ?? this.isEnergyBalanceLoading,
      isMacroCompositionStale:
          isMacroCompositionStale ?? this.isMacroCompositionStale,
      isEnergyBalanceStale: isEnergyBalanceStale ?? this.isEnergyBalanceStale,
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
  final Map<String, WeightProgressResponse> _weightProgressCache = {};
  final Map<String, MacroCompositionResponse> _macroCompositionCache = {};
  final Map<String, EnergyBalanceResponse> _energyBalanceCache = {};

  String _weightProgressCacheKey(String filter) => filter.toLowerCase().trim();
  String _macroCompositionCacheKey(String filter) =>
      filter.toLowerCase().trim();
  String _energyBalanceCacheKey(String filter) => filter.toLowerCase().trim();

  /// Food logs affect macro composition and energy intake. Keep current UI data
  /// visible, but force those sections to refresh the next time they are shown.
  void invalidateFoodDependentProgressCaches() {
    _macroCompositionCache.clear();
    _energyBalanceCache.clear();
    state = state.copyWith(
      isMacroCompositionStale: true,
      isEnergyBalanceStale: true,
    );
  }

  /// Get user profile
  Future<bool> getUserProfile() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.userApi.getUserProfile();

      if (response != null) {
        // Save profile to local storage
        try {
          await _apiService.saveUserProfile(json.encode(response.toJson()));
        } catch (_) {}
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
      // Check if it's a deserialization error (Swagger spec mismatch)
      if (e.message != null && e.message!.contains('FormatException')) {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'API response format mismatch. The backend may have changed. Please contact support.',
          hasProfile: false,
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _parseApiError(e),
          hasProfile: false,
        );
      }
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
      // Check if it's a deserialization error (Swagger spec mismatch)
      if (e.message != null && e.message!.contains('FormatException')) {
        state = state.copyWith(
          isLoading: false,
          errorMessage:
              'API response format mismatch. The backend may have changed. Please contact support.',
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: _parseApiError(e),
        );
      }
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
      return false;
    }
  }

  /// Submit onboarding survey answers collected before registration.
  Future<bool> submitOnboardingSurvey(
      OnboardingSurveyRequest onboardingSurveyRequest) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _apiService.userApi.submitOnboardingSurvey(onboardingSurveyRequest);
      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
        hasProfile: true,
      );
      return true;
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
      gender: gender ??
          ProfileRequestDtoGenderEnum.fromJson(
            state.userProfile?.gender?.value,
          ) ??
          ProfileRequestDtoGenderEnum.OTHER,
      currentWeight: currentWeight ?? state.userProfile?.currentWeight?.toInt(),
      currentWeightUnit: currentWeightUnit ??
          (state.userProfile?.currentWeightUnit
              as ProfileRequestDtoCurrentWeightUnitEnum?),
      height: height ?? state.userProfile?.height?.toInt(),
      heightUnit: heightUnit ??
          (state.userProfile?.heightUnit as ProfileRequestDtoHeightUnitEnum?),
      dateOfBirth:
          dateOfBirth ?? state.userProfile?.dateOfBirth ?? DateTime.now(),
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

  /// Get weight progress data
  Future<bool> getWeightProgress({
    String filter = 'daily',
    bool refresh = false,
  }) async {
    final cacheKey = _weightProgressCacheKey(filter);

    if (!refresh && _weightProgressCache.containsKey(cacheKey)) {
      state = state.copyWith(
        isWeightProgressLoading: false,
        weightProgress: _weightProgressCache[cacheKey],
        errorMessage: null,
      );
      return true;
    }

    state = state.copyWith(
      isWeightProgressLoading: true,
      errorMessage: null,
    );

    try {
      final response =
          await _apiService.userApi.getWeightProgress(filter: filter);

      if (response != null) {
        _weightProgressCache[cacheKey] = response;
        state = state.copyWith(
          isWeightProgressLoading: false,
          weightProgress: response,
          errorMessage: null,
        );
        return true;
      }

      state = state.copyWith(
        isWeightProgressLoading: false,
        errorMessage: 'Failed to load weight progress',
      );
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(
        isWeightProgressLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isWeightProgressLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
      return false;
    }
  }

  /// Get macro composition data
  Future<bool> getMacroComposition({
    String filter = 'daily',
    bool refresh = false,
  }) async {
    final cacheKey = _macroCompositionCacheKey(filter);

    if (!refresh &&
        !state.isMacroCompositionStale &&
        _macroCompositionCache.containsKey(cacheKey)) {
      state = state.copyWith(
        isMacroCompositionLoading: false,
        macroComposition: _macroCompositionCache[cacheKey],
        errorMessage: null,
      );
      return true;
    }

    state = state.copyWith(
      isMacroCompositionLoading: true,
      errorMessage: null,
    );

    try {
      final response =
          await _apiService.userApi.getMacroComposition(filter: filter);

      if (response != null) {
        _macroCompositionCache[cacheKey] = response;
        state = state.copyWith(
          isMacroCompositionLoading: false,
          macroComposition: response,
          isMacroCompositionStale: false,
          errorMessage: null,
        );
        return true;
      }

      state = state.copyWith(
        isMacroCompositionLoading: false,
        errorMessage: 'Failed to load macro composition',
      );
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(
        isMacroCompositionLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isMacroCompositionLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
      return false;
    }
  }

  /// Get energy balance data
  Future<bool> getEnergyBalance({
    String filter = 'daily',
    bool refresh = false,
  }) async {
    final cacheKey = _energyBalanceCacheKey(filter);

    if (!refresh &&
        !state.isEnergyBalanceStale &&
        _energyBalanceCache.containsKey(cacheKey)) {
      state = state.copyWith(
        isEnergyBalanceLoading: false,
        energyBalance: _energyBalanceCache[cacheKey],
        errorMessage: null,
      );
      return true;
    }

    state = state.copyWith(
      isEnergyBalanceLoading: true,
      errorMessage: null,
    );

    try {
      final response =
          await _apiService.userApi.getEnergyBalance(filter: filter);

      if (response != null) {
        _energyBalanceCache[cacheKey] = response;
        state = state.copyWith(
          isEnergyBalanceLoading: false,
          energyBalance: response,
          isEnergyBalanceStale: false,
          errorMessage: null,
        );
        return true;
      }

      state = state.copyWith(
        isEnergyBalanceLoading: false,
        errorMessage: 'Failed to load energy balance',
      );
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(
        isEnergyBalanceLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isEnergyBalanceLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
      return false;
    }
  }

  /// Log a new weight entry
  Future<bool> logWeight({
    required double weight,
    required String unit,
    DateTime? date,
    String refreshFilter = 'daily',
  }) async {
    state = state.copyWith(
      isWeightLogSubmitting: true,
      errorMessage: null,
      successMessage: null,
    );

    final weightUnit = unit.toLowerCase() == 'kg'
        ? WeightLogRequestUnitEnum.KG
        : WeightLogRequestUnitEnum.POUNDS;

    try {
      final request = WeightLogRequest(
        value: weight,
        unit: weightUnit,
        date: date,
      );

      final response = await _apiService.userApi.logWeight(request);

      if (response != null) {
        state = state.copyWith(
          isWeightLogSubmitting: false,
          successMessage: 'Weight logged successfully',
          errorMessage: null,
        );
        await Future.wait([
          getWeightProgress(filter: refreshFilter, refresh: true),
          getUserProfile(),
        ]);
        return true;
      }

      state = state.copyWith(
        isWeightLogSubmitting: false,
        errorMessage: 'Failed to log weight',
      );
      return false;
    } on ApiException catch (e) {
      state = state.copyWith(
        isWeightLogSubmitting: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isWeightLogSubmitting: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
      return false;
    }
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
    _apiService.clearUserProfile();
    state = UserProfileState();
  }

  /// Delete user account
  Future<bool> deleteAccount({required String password}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final request = DeleteAccountRequest(password: password);
      await _apiService.userApi.deleteAccount(request);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Account deleted successfully',
        errorMessage: null,
      );
      return true;
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

  /// Parse API error messages
  String _parseApiError(ApiException e) {
    final message = e.message;

    if (message != null && message.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(message);
        if (decoded is Map<String, dynamic>) {
          final apiMessage = decoded['message'];
          if (apiMessage is String && apiMessage.trim().isNotEmpty) {
            return apiMessage;
          }
        }
      } catch (_) {
        return message;
      }

      return message;
    }

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

  /// Clear success message
  void clearSuccess() {
    state = state.copyWith(successMessage: null);
  }

  /// Change password
  Future<bool> changePassword({
    required String oldPassword,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final request = ChangePasswordRequest(
        currentPassword: oldPassword,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      final response = await _apiService.userApi.changePassword(request);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          successMessage: response.message ?? 'Password changed successfully',
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to change password',
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

  /// Request password reset
  Future<bool> requestPasswordReset(String email) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final request = ForgotPasswordRequest(email: email);
      await _apiService.clearAuthToken();
      final message = await _apiService.authApi.requestPasswordReset(request);

      state = state.copyWith(
        isLoading: false,
        successMessage: message ?? 'Password reset email sent',
        errorMessage: null,
      );
      return true;
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

  /// Reset password with OTP
  Future<bool> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final request = ResetPasswordRequest(
        email: email,
        otp: otp,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      await _apiService.authApi.resetPassword(request);

      state = state.copyWith(
        isLoading: false,
        successMessage: 'Password reset successfully',
        errorMessage: null,
      );
      return true;
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

  /// Get user notifications
  Future<bool> getUserNotifications(int pageNumber) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response =
          await _apiService.userApi.getUserNotifications(pageNumber);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          notifications: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load notifications',
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

  /// Mark notification as read
  Future<bool> markNotificationAsRead(String notificationId) async {
    try {
      await _apiService.userApi.markNotificationAsRead(notificationId);
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(errorMessage: _parseApiError(e));
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
      return false;
    }
  }

  /// Update user profile photo
  Future<String?> updateUserProfilePhoto(MultipartFile image) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.userApi.updateUserProfilePhoto(image);

      if (response != null && response.imageUrl != null) {
        state = state.copyWith(
          isLoading: false,
          successMessage: 'Profile photo updated successfully',
          errorMessage: null,
        );
        // Refresh profile to get updated photo URL
        await getUserProfile();

        return response.imageUrl;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to update profile photo',
        );
        return null;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return null;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred: ${e.toString()}',
      );
      return null;
    }
  }
}
