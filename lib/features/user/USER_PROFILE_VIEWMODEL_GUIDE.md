# User Profile ViewModel - Usage Guide

## Overview

The `UserProfileViewModel` manages all user profile operations including getting and updating profile data. It follows the same pattern as the `AuthViewModel`.

## Provider

```dart
final userProfileViewModelProvider =
    StateNotifierProvider<UserProfileViewModel, UserProfileState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return UserProfileViewModel(apiService);
});
```

## State

```dart
class UserProfileState {
  final bool isLoading;
  final UserProfile? userProfile;
  final String? errorMessage;
  final bool hasProfile;
}
```

## Basic Usage Examples

### 1. Get User Profile

```dart
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileViewModelProvider);
    final profileViewModel = ref.read(userProfileViewModelProvider.notifier);

    // Load profile on mount
    useEffect(() {
      profileViewModel.getUserProfile();
      return null;
    }, []);

    if (profileState.isLoading) {
      return const CircularProgressIndicator();
    }

    if (profileState.errorMessage != null) {
      return Text('Error: ${profileState.errorMessage}');
    }

    final profile = profileState.userProfile;
    if (profile == null) {
      return const Text('No profile found');
    }

    return Column(
      children: [
        Text('Weight: ${profile.currentWeight} ${profile.currentWeightUnit}'),
        Text('Height: ${profile.height} ${profile.heightUnit}'),
        Text('Age: ${profile.age}'),
      ],
    );
  }
}
```

### 2. Update Weight from MeasurementSelectionScreen

```dart
class SelectWeightScreen extends ConsumerWidget {
  const SelectWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      title: "What is your weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 50.0,
      nextScreen: const SelectHeightScreen(),
      onContinue: (value, unit, isLeftUnit) async {
        final viewModel = ref.read(userProfileViewModelProvider.notifier);
        
        // Update the weight in the backend
        final success = await viewModel.updateWeight(
          weight: value,
          unit: unit,
        );

        if (!success) {
          // Show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                ref.read(userProfileViewModelProvider).errorMessage ?? 
                'Failed to update weight'
              ),
            ),
          );
        }
      },
    );
  }
}
```

### 3. Update Height

```dart
class SelectHeightScreen extends ConsumerWidget {
  const SelectHeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      title: "What is your height?",
      leftUnit: "ft",
      rightUnit: "cm",
      minValue: 0,
      maxValue: 250,
      initialValue: 140.0,
      nextScreen: const SelectAgeScreen(),
      onContinue: (value, unit, isLeftUnit) async {
        final viewModel = ref.read(userProfileViewModelProvider.notifier);
        
        final success = await viewModel.updateHeight(
          height: value,
          unit: unit,
        );

        if (success) {
          print('Height updated successfully!');
        }
      },
    );
  }
}
```

### 4. Update Desired Weight

```dart
class DesiredWeightScreen extends ConsumerWidget {
  const DesiredWeightScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MeasurementSelectionScreen(
      title: "What is your \ndesired weight?",
      leftUnit: "kg",
      rightUnit: "lbs",
      minValue: 0,
      maxValue: 500,
      initialValue: 65.0,
      nextScreen: const DietPreferenceScreen(),
      onContinue: (value, unit, isLeftUnit) async {
        final viewModel = ref.read(userProfileViewModelProvider.notifier);
        
        await viewModel.updateDesiredWeight(
          weight: value,
          unit: unit,
        );
      },
    );
  }
}
```

### 5. Update Full Profile (All Fields at Once)

```dart
class CompleteProfileScreen extends ConsumerWidget {
  const CompleteProfileScreen({super.key});

  Future<void> _submitProfile(WidgetRef ref) async {
    final viewModel = ref.read(userProfileViewModelProvider.notifier);

    final profileRequest = ProfileRequestDto(
      gender: ProfileRequestDtoGenderEnum.MALE,
      currentWeight: 70,
      currentWeightUnit: ProfileRequestDtoCurrentWeightUnitEnum.KG,
      height: 175,
      heightUnit: ProfileRequestDtoHeightUnitEnum.CM,
      dateOfBirth: DateTime(1990, 1, 1),
      desiredGoal: ProfileRequestDtoDesiredGoalEnum.WEIGHT_LOSS,
      desiredWeight: 65,
      desiredWeightUnit: ProfileRequestDtoDesiredWeightUnitEnum.KG,
      dietaryPreference: ProfileRequestDtoDietaryPreferenceEnum.VEGETARIAN,
      activityLevel: ProfileRequestDtoActivityLevelEnum.MODERATELY_ACTIVE,
      macroTarget: ProfileRequestDtoMacroTargetEnum.BALANCED,
      allergies: ['peanuts', 'shellfish'],
      country: 'USA',
    );

    final success = await viewModel.updateUserProfile(profileRequest);
    
    if (success) {
      print('Profile updated successfully!');
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: ElevatedButton(
        onPressed: () => _submitProfile(ref),
        child: const Text('Complete Profile'),
      ),
    );
  }
}
```

### 6. Update Specific Fields Only

```dart
// Update dietary preference
final viewModel = ref.read(userProfileViewModelProvider.notifier);

await viewModel.updateDietaryPreference(
  ProfileRequestDtoDietaryPreferenceEnum.VEGAN
);

// Update activity level
await viewModel.updateActivityLevel(
  ProfileRequestDtoActivityLevelEnum.VERY_ACTIVE
);

// Update gender
await viewModel.updateGender(
  ProfileRequestDtoGenderEnum.FEMALE
);

// Update date of birth
await viewModel.updateDateOfBirth(
  DateTime(1995, 5, 15)
);

// Update allergies
await viewModel.updateAllergies(['gluten', 'dairy']);

// Update country
await viewModel.updateCountry('Canada');
```

### 7. Watch for Loading State

```dart
class ProfileFormScreen extends ConsumerWidget {
  const ProfileFormScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(userProfileViewModelProvider);
    final viewModel = ref.read(userProfileViewModelProvider.notifier);

    return Stack(
      children: [
        // Your form widgets
        ProfileForm(
          onSubmit: (data) async {
            await viewModel.updateProfileFields(
              currentWeight: data.weight,
              height: data.height,
            );
          },
        ),
        
        // Show loading overlay
        if (profileState.isLoading)
          const Center(
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}
```

### 8. Handle Errors

```dart
class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileViewModelProvider);

    // Listen to errors
    ref.listen<UserProfileState>(
      userProfileViewModelProvider,
      (previous, next) {
        if (next.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(next.errorMessage!),
              backgroundColor: Colors.red,
            ),
          );
          
          // Clear error after showing
          ref.read(userProfileViewModelProvider.notifier).clearError();
        }
      },
    );

    return Scaffold(
      body: Center(
        child: Text('Profile Screen'),
      ),
    );
  }
}
```

## Available Methods

### Core Methods
- `getUserProfile()` - Fetch user profile from backend
- `updateUserProfile(ProfileRequestDto)` - Update complete profile
- `updateProfileFields({...})` - Update specific fields only

### Convenience Methods
- `updateWeight({weight, unit})` - Update current weight
- `updateHeight({height, unit})` - Update height
- `updateDesiredWeight({weight, unit})` - Update desired weight
- `updateDietaryPreference(preference)` - Update dietary preference
- `updateActivityLevel(level)` - Update activity level
- `updateGender(gender)` - Update gender
- `updateDateOfBirth(date)` - Update date of birth
- `updateDesiredGoal(goal)` - Update desired goal
- `updateMacroTarget(target)` - Update macro target
- `updateAllergies(allergies)` - Update allergies list
- `updateCountry(country)` - Update country

### Utility Methods
- `clearProfile()` - Clear profile state
- `clearError()` - Clear error message

## Enum Values

### Gender
- `ProfileRequestDtoGenderEnum.MALE`
- `ProfileRequestDtoGenderEnum.FEMALE`

### Weight Unit
- `ProfileRequestDtoCurrentWeightUnitEnum.KG`
- `ProfileRequestDtoCurrentWeightUnitEnum.POUNDS`

### Height Unit
- `ProfileRequestDtoHeightUnitEnum.CM`
- `ProfileRequestDtoHeightUnitEnum.FT`

### Desired Goal
- `ProfileRequestDtoDesiredGoalEnum.WEIGHT_LOSS`
- `ProfileRequestDtoDesiredGoalEnum.WEIGHT_GAIN`
- `ProfileRequestDtoDesiredGoalEnum.MAINTAIN`

### Dietary Preference
- `ProfileRequestDtoDietaryPreferenceEnum.NONE`
- `ProfileRequestDtoDietaryPreferenceEnum.VEGETARIAN`
- `ProfileRequestDtoDietaryPreferenceEnum.VEGAN`
- `ProfileRequestDtoDietaryPreferenceEnum.PESCATARIAN`
- `ProfileRequestDtoDietaryPreferenceEnum.KETO`
- `ProfileRequestDtoDietaryPreferenceEnum.PALEO`
- `ProfileRequestDtoDietaryPreferenceEnum.GLUTEN_FREE`
- `ProfileRequestDtoDietaryPreferenceEnum.DAIRY_FREE`

### Activity Level
- `ProfileRequestDtoActivityLevelEnum.SEDENTARY`
- `ProfileRequestDtoActivityLevelEnum.LIGHTLY_ACTIVE`
- `ProfileRequestDtoActivityLevelEnum.MODERATELY_ACTIVE`
- `ProfileRequestDtoActivityLevelEnum.VERY_ACTIVE`
- `ProfileRequestDtoActivityLevelEnum.EXTRA_ACTIVE`

### Macro Target
- `ProfileRequestDtoMacroTargetEnum.BALANCED`
- `ProfileRequestDtoMacroTargetEnum.HIGH_PROTEIN`
- `ProfileRequestDtoMacroTargetEnum.LOW_CARB`
- `ProfileRequestDtoMacroTargetEnum.LOW_FAT`
- `ProfileRequestDtoMacroTargetEnum.HIGH_FIBER`

## Integration with Personalization Flow

For a complete onboarding flow that saves all data:

```dart
class PersonalizationFlow extends ConsumerStatefulWidget {
  const PersonalizationFlow({super.key});

  @override
  ConsumerState<PersonalizationFlow> createState() => _PersonalizationFlowState();
}

class _PersonalizationFlowState extends ConsumerState<PersonalizationFlow> {
  // Store temporary values during flow
  double? weight;
  String? weightUnit;
  double? height;
  String? heightUnit;
  double? desiredWeight;
  String? desiredWeightUnit;

  Future<void> _saveAllData() async {
    final viewModel = ref.read(userProfileViewModelProvider.notifier);
    
    // Save all collected data at once
    final success = await viewModel.updateProfileFields(
      currentWeight: weight?.toInt(),
      currentWeightUnit: weightUnit == 'kg' 
          ? ProfileRequestDtoCurrentWeightUnitEnum.KG 
          : ProfileRequestDtoCurrentWeightUnitEnum.POUNDS,
      height: height?.toInt(),
      heightUnit: heightUnit == 'cm'
          ? ProfileRequestDtoHeightUnitEnum.CM
          : ProfileRequestDtoHeightUnitEnum.FT,
      desiredWeight: desiredWeight?.toInt(),
      desiredWeightUnit: desiredWeightUnit == 'kg'
          ? ProfileRequestDtoDesiredWeightUnitEnum.KG
          : ProfileRequestDtoDesiredWeightUnitEnum.POUNDS,
    );

    if (success) {
      // Navigate to home
      NavigationService.pushReplacement(child: const HomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    // Your flow implementation
    return Container();
  }
}
```
