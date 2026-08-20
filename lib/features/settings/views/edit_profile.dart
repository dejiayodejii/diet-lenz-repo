import 'package:openapi/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/auth_viewmodel.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  // Controllers for text fields
  late TextEditingController _nameController;
  late TextEditingController _emailController;

  // Profile values
  DateTime? _selectedDate;
  double? _height;
  String _heightUnit = 'cm';
  double? _weight;
  String _weightUnit = 'kg';
  String? _selectedGender;

  // Additional profile fields
  double? _desiredWeight;
  String _desiredWeightUnit = 'kg';
  String? _selectedGoal;
  String? _selectedActivityLevel;
  String? _selectedDietaryPreference;
  String? _selectedMacroTarget;
  String? _selectedCountry;
  List<String> _selectedAllergies = [];

  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _initializeFromProfile(UserProfile? profile, dynamic authState) {
    if (_isInitialized) return;

    // Get name from auth state
    final firstName = authState?.firstName ?? '';
    final lastName = authState?.lastName ?? '';
    _nameController.text = '$firstName $lastName'.trim();
    _emailController.text = authState?.email ?? '';

    if (profile != null) {
      _selectedDate = profile.dateOfBirth;
      _height = profile.height?.toDouble();
      _heightUnit = profile.heightUnit?.value ?? 'cm';
      _weight = profile.currentWeight?.toDouble();
      _weightUnit = profile.currentWeightUnit?.value ?? 'kg';
      _selectedGender = profile.gender?.value;

      // Additional fields
      _desiredWeight = profile.desiredWeight?.toDouble();
      _desiredWeightUnit = profile.desiredWeightUnit?.value ?? 'kg';
      _selectedGoal = profile.desiredGoal?.value;
      _selectedActivityLevel = profile.activityLevel?.value;
      _selectedDietaryPreference = profile.dietaryPreference?.value;
      _selectedMacroTarget = profile.macroTarget?.value;
      _selectedCountry = profile.country;
      _selectedAllergies = profile.allergenExclusions.toList();

      // Only mark as initialized once profile data is available
      _isInitialized = true;
    }
  }

  int? _calculateAge() {
    if (_selectedDate == null) return null;
    final now = DateTime.now();
    int age = now.year - _selectedDate!.year;
    if (now.month < _selectedDate!.month ||
        (now.month == _selectedDate!.month && now.day < _selectedDate!.day)) {
      age--;
    }
    return age;
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: AppColors.primaryColor,
              onPrimary: Colors.white,
              surface: Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
            dialogBackgroundColor: const Color(0xFF101010),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _showHeightPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MeasurementPickerSheet(
        title: 'Select Height',
        initialValue: _height ?? 170,
        minValue: 0,
        maxValue: 300,
        minLeftValue: 100,
        maxLeftValue: 300,
        minRightValue: 3.0,
        maxRightValue: 9.0,
        leftUnit: 'cm',
        rightUnit: 'ft',
        initialUnit: _heightUnit,
        leftToRightConverter: (val) => val / 30.48,
        rightToLeftConverter: (val) => val * 30.48,
        leftStep: 1.0,
        rightStep: 0.1,
        onSave: (value, unit) {
          setState(() {
            _height = value;
            _heightUnit = unit;
          });
        },
      ),
    );
  }

  void _showWeightPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MeasurementPickerSheet(
        title: 'Select Weight',
        initialValue: _weight ?? 70,
        minValue: 20,
        maxValue: 300,
        minLeftValue: 20,
        maxLeftValue: 300,
        minRightValue: 44,
        maxRightValue: 660,
        leftUnit: 'kg',
        rightUnit: 'lbs',
        initialUnit: _weightUnit,
        leftToRightConverter: (val) => val * 2.20462,
        rightToLeftConverter: (val) => val / 2.20462,
        onSave: (value, unit) {
          setState(() {
            _weight = value;
            _weightUnit = unit;
          });
        },
      ),
    );
  }

  void _showGenderPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _GenderPickerSheet(
        selectedGender: _selectedGender,
        onSave: (gender) {
          setState(() {
            _selectedGender = gender;
          });
        },
      ),
    );
  }

  void _showDesiredWeightPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _MeasurementPickerSheet(
        title: 'Select Desired Weight',
        initialValue: _desiredWeight ?? 70,
        minValue: 20,
        maxValue: 300,
        minLeftValue: 20,
        maxLeftValue: 300,
        minRightValue: 44,
        maxRightValue: 660,
        leftUnit: 'kg',
        rightUnit: 'lbs',
        initialUnit: _desiredWeightUnit,
        leftToRightConverter: (val) => val * 2.20462,
        rightToLeftConverter: (val) => val / 2.20462,
        onSave: (value, unit) {
          setState(() {
            _desiredWeight = value;
            _desiredWeightUnit = unit;
          });
        },
      ),
    );
  }

  void _showGoalPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SelectionPickerSheet(
        title: 'Select Your Goal',
        options: const [
          {'value': 'LOSE_WEIGHT', 'label': 'Lose Weight'},
          {'value': 'MAINTAIN_WEIGHT', 'label': 'Maintain Weight'},
          {'value': 'GAIN_WEIGHT', 'label': 'Gain Weight'},
          {'value': 'NOTHING', 'label': 'Just exploring'},
        ],
        selectedValue: _selectedGoal,
        onSave: (value) {
          setState(() {
            _selectedGoal = value;
          });
        },
      ),
    );
  }

  void _showActivityLevelPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SelectionPickerSheet(
        title: 'Select Activity Level',
        options: const [
          {
            'value': 'SEDENTARY',
            'label': 'Sedentary',
            'subtitle': 'Little or no exercise'
          },
          {
            'value': 'LIGHTLY_ACTIVE',
            'label': 'Lightly Active',
            'subtitle': 'Light exercise 1-3 days/week'
          },
          {
            'value': 'MODERATELY_ACTIVE',
            'label': 'Moderately Active',
            'subtitle': 'Moderate exercise 3-5 days/week'
          },
          {
            'value': 'VERY_ACTIVE',
            'label': 'Very Active',
            'subtitle': 'Hard exercise 6-7 days/week'
          },
          {
            'value': 'EXTRA_ACTIVE',
            'label': 'Extra Active',
            'subtitle': 'Very hard exercise & physical job'
          },
        ],
        selectedValue: _selectedActivityLevel,
        onSave: (value) {
          setState(() {
            _selectedActivityLevel = value;
          });
        },
      ),
    );
  }

  void _showDietaryPreferencePicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SelectionPickerSheet(
        title: 'Select Dietary Preference',
        options: const [
          {'value': 'NONE', 'label': 'None'},
          {'value': 'VEGETARIAN', 'label': 'Vegetarian'},
          {'value': 'VEGAN', 'label': 'Vegan'},
          {'value': 'KETO', 'label': 'Keto'},
          {'value': 'PALEO', 'label': 'Paleo'},
          {'value': 'GLUTEN_FREE', 'label': 'Gluten Free'},
          {'value': 'DAIRY_FREE', 'label': 'Dairy Free'},
        ],
        selectedValue: _selectedDietaryPreference,
        onSave: (value) {
          setState(() {
            _selectedDietaryPreference = value;
          });
        },
      ),
    );
  }

  void _showMacroTargetPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _SelectionPickerSheet(
        title: 'Select Macro Target',
        options: const [
          {'value': 'BALANCED', 'label': 'Balanced'},
          {'value': 'HIGH_PROTEIN', 'label': 'High Protein'},
          {'value': 'LOW_CARB', 'label': 'Low Carb'},
          {'value': 'LOW_FAT', 'label': 'Low Fat'},
          {'value': 'HIGH_FIBER', 'label': 'High Fiber'},
        ],
        selectedValue: _selectedMacroTarget,
        onSave: (value) {
          setState(() {
            _selectedMacroTarget = value;
          });
        },
      ),
    );
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _CountryPickerSheet(
        selectedCountry: _selectedCountry,
        onSave: (country) {
          setState(() {
            _selectedCountry = country;
          });
        },
      ),
    );
  }

  void _showAllergiesPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E1E1E),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _AllergiesPickerSheet(
        selectedAllergies: _selectedAllergies,
        onSave: (allergies) {
          setState(() {
            _selectedAllergies = allergies;
          });
        },
      ),
    );
  }

  Future<void> _saveProfile() async {
    final viewModel = ref.read(userProfileViewModelProvider.notifier);

    // Map string values to enum values
    ProfileRequestDtoGenderEnum? genderEnum;
    if (_selectedGender != null) {
      genderEnum = _selectedGender == 'MALE'
          ? ProfileRequestDtoGenderEnum.MALE
          : ProfileRequestDtoGenderEnum.FEMALE;
    }

    ProfileRequestDtoHeightUnitEnum? heightUnitEnum;
    if (_heightUnit.toLowerCase() == 'cm') {
      heightUnitEnum = ProfileRequestDtoHeightUnitEnum.CM;
    } else {
      heightUnitEnum = ProfileRequestDtoHeightUnitEnum.FT;
    }

    ProfileRequestDtoCurrentWeightUnitEnum? weightUnitEnum;
    if (_weightUnit.toLowerCase() == 'kg') {
      weightUnitEnum = ProfileRequestDtoCurrentWeightUnitEnum.KG;
    } else {
      weightUnitEnum = ProfileRequestDtoCurrentWeightUnitEnum.POUNDS;
    }

    // Map additional enum values
    ProfileRequestDtoDesiredWeightUnitEnum? desiredWeightUnitEnum;
    if (_desiredWeightUnit.toLowerCase() == 'kg') {
      desiredWeightUnitEnum = ProfileRequestDtoDesiredWeightUnitEnum.KG;
    } else {
      desiredWeightUnitEnum = ProfileRequestDtoDesiredWeightUnitEnum.POUNDS;
    }

    ProfileRequestDtoDesiredGoalEnum? goalEnum;
    if (_selectedGoal != null) {
      goalEnum = _mapToGoalEnum(_selectedGoal!);
    }

    ProfileRequestDtoActivityLevelEnum? activityLevelEnum;
    if (_selectedActivityLevel != null) {
      activityLevelEnum = _mapToActivityLevelEnum(_selectedActivityLevel!);
    }

    ProfileRequestDtoDietaryPreferenceEnum? dietaryPreferenceEnum;
    if (_selectedDietaryPreference != null) {
      dietaryPreferenceEnum =
          _mapToDietaryPreferenceEnum(_selectedDietaryPreference!);
    }

    ProfileRequestDtoMacroTargetEnum? macroTargetEnum;
    if (_selectedMacroTarget != null) {
      macroTargetEnum = _mapToMacroTargetEnum(_selectedMacroTarget!);
    }

    final success = await viewModel.updateProfileFields(
      gender: genderEnum,
      height: _height?.toInt(),
      heightUnit: heightUnitEnum,
      currentWeight: _weight?.toInt(),
      currentWeightUnit: weightUnitEnum,
      dateOfBirth: _selectedDate,
      desiredWeight: _desiredWeight?.toInt(),
      desiredWeightUnit: desiredWeightUnitEnum,
      desiredGoal: goalEnum,
      activityLevel: activityLevelEnum,
      dietaryPreference: dietaryPreferenceEnum,
      macroTarget: macroTargetEnum,
      country: _selectedCountry,
      allergies: _selectedAllergies,
    );
    final date = DateTime.now();
    await ref
        .read(foodLoggingViewModelProvider.notifier)
        .getDashboard(date: date, refresh: true);

    if (mounted) {
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        NavigationService.pop();
      } else {
        final error = ref.read(userProfileViewModelProvider).errorMessage;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error ?? 'Failed to update profile'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  ProfileRequestDtoDesiredGoalEnum? _mapToGoalEnum(String value) {
    switch (value) {
      case 'LOSE_WEIGHT':
        return ProfileRequestDtoDesiredGoalEnum.LOSE_WEIGHT;
      case 'MAINTAIN_WEIGHT':
        return ProfileRequestDtoDesiredGoalEnum.MAINTAIN_WEIGHT;
      case 'GAIN_WEIGHT':
        return ProfileRequestDtoDesiredGoalEnum.GAIN_WEIGHT;
      case 'NOTHING':
        return ProfileRequestDtoDesiredGoalEnum.NOTHING;
      default:
        return null;
    }
  }

  ProfileRequestDtoActivityLevelEnum? _mapToActivityLevelEnum(String value) {
    switch (value) {
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
        return null;
    }
  }

  ProfileRequestDtoDietaryPreferenceEnum? _mapToDietaryPreferenceEnum(
      String value) {
    switch (value) {
      case 'NONE':
        return ProfileRequestDtoDietaryPreferenceEnum.NONE;
      case 'VEGETARIAN':
        return ProfileRequestDtoDietaryPreferenceEnum.VEGETARIAN;
      case 'VEGAN':
        return ProfileRequestDtoDietaryPreferenceEnum.VEGAN;
      case 'KETO':
        return ProfileRequestDtoDietaryPreferenceEnum.KETO;
      case 'PALEO':
        return ProfileRequestDtoDietaryPreferenceEnum.PALEO;
      case 'GLUTEN_FREE':
        return ProfileRequestDtoDietaryPreferenceEnum.GLUTEN_FREE;
      case 'DAIRY_FREE':
        return ProfileRequestDtoDietaryPreferenceEnum.DAIRY_FREE;
      default:
        return null;
    }
  }

  ProfileRequestDtoMacroTargetEnum? _mapToMacroTargetEnum(String value) {
    switch (value) {
      case 'BALANCED':
        return ProfileRequestDtoMacroTargetEnum.BALANCED;
      case 'HIGH_PROTEIN':
        return ProfileRequestDtoMacroTargetEnum.HIGH_PROTEIN;
      case 'LOW_CARB':
        return ProfileRequestDtoMacroTargetEnum.LOW_CARB;
      case 'LOW_FAT':
        return ProfileRequestDtoMacroTargetEnum.LOW_FAT;
      case 'HIGH_FIBER':
        return ProfileRequestDtoMacroTargetEnum.HIGH_FIBER;
      default:
        return null;
    }
  }

  String _formatEnumValue(String? value) {
    if (value == null) return 'Not set';
    return value.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(userProfileViewModelProvider);
    final authState = ref.watch(authViewModelProvider).authResponse;

    // Initialize values from profile
    _initializeFromProfile(profileState.userProfile, authState);

    final age = _calculateAge();

    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Field (read-only for now)
                    _ProfileField(
                      label: 'Name',
                      value: _nameController.text.isNotEmpty
                          ? _nameController.text
                          : 'Not set',
                      isEditable: false,
                    ),
                    const SizedBox(height: 16),

                    // Email Field (read-only)
                    _ProfileField(
                      label: 'Email',
                      value: _emailController.text.isNotEmpty
                          ? _emailController.text
                          : 'Not set',
                      isEditable: false,
                    ),
                    const SizedBox(height: 16),

                    // Gender Field
                    _ProfileField(
                      label: 'Gender',
                      value: _formatEnumValue(_selectedGender),
                      onTap: _showGenderPicker,
                    ),
                    const SizedBox(height: 16),

                    // DOB and Age Row
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileField(
                            label: 'Date of Birth',
                            value: _selectedDate != null
                                ? DateFormat('dd/MM/yyyy')
                                    .format(_selectedDate!)
                                : 'Not set',
                            onTap: _pickDate,
                            suffixIcon: const Icon(
                              Icons.calendar_today,
                              color: AppColors.primaryColor,
                              size: 20,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _ProfileField(
                            label: 'Age',
                            value: age != null ? '$age years' : 'Not set',
                            isEditable: false,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Height and Weight Row
                    Row(
                      children: [
                        Expanded(
                          child: _ProfileField(
                            label: 'Height',
                            value: _height != null
                                ? '${_height!.toString()} $_heightUnit'
                                : 'Not set',
                            onTap: _showHeightPicker,
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: _ProfileField(
                            label: 'Weight',
                            value: _weight != null
                                ? '${_weight!.toString()} $_weightUnit'
                                : 'Not set',
                            onTap: _showWeightPicker,
                            suffixIcon: const Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Section Header - Goals & Preferences
                    const Text(
                      'Goals & Preferences',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: AppFonts.lato,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Goal Field
                    _ProfileField(
                      label: 'Goal',
                      value: _formatEnumValue(_selectedGoal),
                      onTap: _showGoalPicker,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Desired Weight
                    _ProfileField(
                      label: 'Desired Weight',
                      value: _desiredWeight != null
                          ? '${_desiredWeight!.toString()} $_desiredWeightUnit'
                          : 'Not set',
                      onTap: _showDesiredWeightPicker,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Activity Level
                    _ProfileField(
                      label: 'Activity Level',
                      value: _formatEnumValue(_selectedActivityLevel),
                      onTap: _showActivityLevelPicker,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section Header - Diet & Nutrition
                    const Text(
                      'Diet & Nutrition',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: AppFonts.lato,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Dietary Preference
                    _ProfileField(
                      label: 'Dietary Preference',
                      value: _formatEnumValue(_selectedDietaryPreference),
                      onTap: _showDietaryPreferencePicker,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Macro Target
                    _ProfileField(
                      label: 'Macro Target',
                      value: _formatEnumValue(_selectedMacroTarget),
                      onTap: _showMacroTargetPicker,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Allergies
                    _ProfileField(
                      label: 'Allergies',
                      value: _selectedAllergies.isNotEmpty
                          ? _selectedAllergies.join(', ')
                          : 'None',
                      onTap: _showAllergiesPicker,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Section Header - Location
                    const Text(
                      'Location',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: AppFonts.lato,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Country
                    _ProfileField(
                      label: 'Country',
                      value: _selectedCountry ?? 'Not set',
                      onTap: _showCountryPicker,
                      suffixIcon: const Icon(
                        Icons.keyboard_arrow_down,
                        color: AppColors.primaryColor,
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            CustomYafButton(
              text: profileState.isLoading ? "Saving..." : "Save",
              onPressed: profileState.isLoading ? null : _saveProfile,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

// Profile Field Widget
class _ProfileField extends StatelessWidget {
  final String label;
  final String value;
  final VoidCallback? onTap;
  final Widget? suffixIcon;
  final bool isEditable;

  const _ProfileField({
    required this.label,
    required this.value,
    this.onTap,
    this.suffixIcon,
    this.isEditable = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF9E9E9E),
            fontFamily: AppFonts.lato,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: isEditable ? onTap : null,
          child: Container(
            height: 56,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: const Color.fromRGBO(36, 38, 43, 1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color.fromRGBO(57, 60, 67, 1),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isEditable ? Colors.white : Colors.grey,
                      fontFamily: AppFonts.lato,
                    ),
                  ),
                ),
                if (suffixIcon != null && isEditable) suffixIcon!,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// Measurement Picker Bottom Sheet
class _MeasurementPickerSheet extends StatefulWidget {
  final String title;
  final double initialValue;
  final double minValue;
  final double maxValue;
  final String leftUnit;
  final String rightUnit;
  final String initialUnit;
  final Function(double value, String unit) onSave;

  // Optional overrides for specific units
  final double? minLeftValue;
  final double? maxLeftValue;
  final double? minRightValue;
  final double? maxRightValue;
  final double Function(double)? leftToRightConverter;
  final double Function(double)? rightToLeftConverter;
  final double? leftStep;
  final double? rightStep;

  const _MeasurementPickerSheet({
    required this.title,
    required this.initialValue,
    required this.minValue,
    required this.maxValue,
    required this.leftUnit,
    required this.rightUnit,
    required this.initialUnit,
    required this.onSave,
    this.minLeftValue,
    this.maxLeftValue,
    this.minRightValue,
    this.maxRightValue,
    this.leftToRightConverter,
    this.rightToLeftConverter,
    this.leftStep,
    this.rightStep,
  });

  @override
  State<_MeasurementPickerSheet> createState() =>
      _MeasurementPickerSheetState();
}

class _MeasurementPickerSheetState extends State<_MeasurementPickerSheet> {
  late double _value;
  late bool _isLeftUnit;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
    _isLeftUnit =
        widget.initialUnit.toLowerCase() == widget.leftUnit.toLowerCase();
  }

  String get _currentUnit => _isLeftUnit ? widget.leftUnit : widget.rightUnit;

  double get _currentMin => _isLeftUnit
      ? (widget.minLeftValue ?? widget.minValue)
      : (widget.minRightValue ?? widget.minValue);

  double get _currentMax => _isLeftUnit
      ? (widget.maxLeftValue ?? widget.maxValue)
      : (widget.maxRightValue ?? widget.maxValue);

  double get _currentStep =>
      _isLeftUnit ? (widget.leftStep ?? 1.0) : (widget.rightStep ?? 1.0);

  void _switchUnit(bool toLeft) {
    if (_isLeftUnit == toLeft) return;

    setState(() {
      final bool switchingToLeft = toLeft;
      if (switchingToLeft) {
        // Switching from right to left (e.g., ft to cm)
        if (widget.rightToLeftConverter != null) {
          _value = widget.rightToLeftConverter!(_value);
        }
      } else {
        // Switching from left to right (e.g., cm to ft)
        if (widget.leftToRightConverter != null) {
          _value = widget.leftToRightConverter!(_value);
        }
      }
      _isLeftUnit = toLeft;

      // Ensure value is within new bounds
      _value = _value.clamp(_currentMin, _currentMax);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),

          // Unit Toggle
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _UnitButton(
                label: widget.leftUnit,
                isSelected: _isLeftUnit,
                onTap: () => _switchUnit(true),
              ),
              const SizedBox(width: 16),
              _UnitButton(
                label: widget.rightUnit,
                isSelected: !_isLeftUnit,
                onTap: () => _switchUnit(false),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Value Display
          Text(
            '${_value.toStringAsFixed(_currentStep < 1.0 ? 1 : 0)} $_currentUnit',
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
          ),
          const SizedBox(height: 16),

          // Slider
          Slider(
            value: _value.clamp(_currentMin, _currentMax),
            min: _currentMin,
            max: _currentMax,
            divisions: ((_currentMax - _currentMin) / _currentStep).round(),
            activeColor: AppColors.primaryColor,
            inactiveColor: Colors.grey[700],
            onChanged: (value) {
              setState(() {
                _value = value;
              });
            },
          ),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: CustomYafButton(
              text: 'Save',
              onPressed: () {
                widget.onSave(_value, _currentUnit);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Unit Toggle Button
class _UnitButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _UnitButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryColor
              : const Color.fromRGBO(57, 60, 67, 1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isSelected ? Colors.white : Colors.grey,
          ),
        ),
      ),
    );
  }
}

// Gender Picker Bottom Sheet
class _GenderPickerSheet extends StatefulWidget {
  final String? selectedGender;
  final Function(String gender) onSave;

  const _GenderPickerSheet({
    this.selectedGender,
    required this.onSave,
  });

  @override
  State<_GenderPickerSheet> createState() => _GenderPickerSheetState();
}

class _GenderPickerSheetState extends State<_GenderPickerSheet> {
  late String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = widget.selectedGender;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Gender',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),

          // Gender Options
          _GenderOption(
            label: 'Male',
            isSelected: _selectedGender == 'MALE',
            onTap: () => setState(() => _selectedGender = 'MALE'),
          ),
          const SizedBox(height: 16),
          _GenderOption(
            label: 'Female',
            isSelected: _selectedGender == 'FEMALE',
            onTap: () => setState(() => _selectedGender = 'FEMALE'),
          ),
          const SizedBox(height: 24),

          // Save Button
          SizedBox(
            width: double.infinity,
            child: CustomYafButton(
              text: 'Save',
              onPressed: () {
                if (_selectedGender != null) {
                  widget.onSave(_selectedGender!);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Gender Option Widget
class _GenderOption extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _GenderOption({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(36, 38, 43, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : const Color.fromRGBO(57, 60, 67, 1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Color.fromRGBO(249, 115, 22, 0.25),
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primaryColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// Selection Picker Bottom Sheet (for Goal, Activity Level, Dietary Preference, Macro Target)
class _SelectionPickerSheet extends StatefulWidget {
  final String title;
  final List<Map<String, String>> options;
  final String? selectedValue;
  final Function(String value) onSave;

  const _SelectionPickerSheet({
    required this.title,
    required this.options,
    this.selectedValue,
    required this.onSave,
  });

  @override
  State<_SelectionPickerSheet> createState() => _SelectionPickerSheetState();
}

class _SelectionPickerSheetState extends State<_SelectionPickerSheet> {
  late String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.selectedValue;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: widget.options.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final option = widget.options[index];
                final isSelected = _selectedValue == option['value'];
                return _SelectionOption(
                  label: option['label']!,
                  subtitle: option['subtitle'],
                  isSelected: isSelected,
                  onTap: () => setState(() => _selectedValue = option['value']),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: CustomYafButton(
              text: 'Save',
              onPressed: () {
                if (_selectedValue != null) {
                  widget.onSave(_selectedValue!);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Selection Option Widget
class _SelectionOption extends StatelessWidget {
  final String label;
  final String? subtitle;
  final bool isSelected;
  final VoidCallback onTap;

  const _SelectionOption({
    required this.label,
    this.subtitle,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(36, 38, 43, 1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? AppColors.primaryColor
                : const Color.fromRGBO(57, 60, 67, 1),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  const BoxShadow(
                    color: Color.fromRGBO(249, 115, 22, 0.25),
                    spreadRadius: 2,
                  )
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ],
              ),
            ),
            Icon(
              isSelected ? Icons.check_circle : Icons.circle_outlined,
              color: isSelected ? AppColors.primaryColor : Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}

// Country Picker Bottom Sheet
class _CountryPickerSheet extends StatefulWidget {
  final String? selectedCountry;
  final Function(String country) onSave;

  const _CountryPickerSheet({
    this.selectedCountry,
    required this.onSave,
  });

  @override
  State<_CountryPickerSheet> createState() => _CountryPickerSheetState();
}

class _CountryPickerSheetState extends State<_CountryPickerSheet> {
  late String? _selectedCountry;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  static const List<String> _countries = [
    'Afghanistan',
    'Albania',
    'Algeria',
    'Argentina',
    'Australia',
    'Austria',
    'Bangladesh',
    'Belgium',
    'Brazil',
    'Canada',
    'Chile',
    'China',
    'Colombia',
    'Denmark',
    'Egypt',
    'Finland',
    'France',
    'Germany',
    'Ghana',
    'Greece',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Japan',
    'Kenya',
    'Malaysia',
    'Mexico',
    'Morocco',
    'Netherlands',
    'New Zealand',
    'Nigeria',
    'Norway',
    'Pakistan',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Romania',
    'Russia',
    'Saudi Arabia',
    'Singapore',
    'South Africa',
    'South Korea',
    'Spain',
    'Sweden',
    'Switzerland',
    'Thailand',
    'Turkey',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom',
    'United States',
    'Venezuela',
    'Vietnam',
    'Zimbabwe',
  ];

  @override
  void initState() {
    super.initState();
    _selectedCountry = widget.selectedCountry;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<String> get _filteredCountries {
    if (_searchQuery.isEmpty) return _countries;
    return _countries
        .where((c) => c.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Country',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          // Search Field
          TextField(
            controller: _searchController,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Search country...',
              hintStyle: TextStyle(color: Colors.grey[500]),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              filled: true,
              fillColor: const Color.fromRGBO(36, 38, 43, 1),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 16),
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _filteredCountries.length,
              separatorBuilder: (context, index) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = _selectedCountry == country;
                return GestureDetector(
                  onTap: () => setState(() => _selectedCountry = country),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color.fromRGBO(36, 38, 43, 1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : const Color.fromRGBO(57, 60, 67, 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          country,
                          style: const TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        if (isSelected)
                          const Icon(
                            Icons.check_circle,
                            color: AppColors.primaryColor,
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: CustomYafButton(
              text: 'Save',
              onPressed: () {
                if (_selectedCountry != null) {
                  widget.onSave(_selectedCountry!);
                }
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Allergies Picker Bottom Sheet
class _AllergiesPickerSheet extends StatefulWidget {
  final List<String> selectedAllergies;
  final Function(List<String> allergies) onSave;

  const _AllergiesPickerSheet({
    required this.selectedAllergies,
    required this.onSave,
  });

  @override
  State<_AllergiesPickerSheet> createState() => _AllergiesPickerSheetState();
}

class _AllergiesPickerSheetState extends State<_AllergiesPickerSheet> {
  late List<String> _selectedAllergies;

  static const List<String> _commonAllergies = [
    'Peanuts',
    'Tree Nuts',
    'Milk',
    'Eggs',
    'Wheat',
    'Soy',
    'Fish',
    'Shellfish',
    'Sesame',
    'Gluten',
    'Lactose',
    'Corn',
    'Sulfites',
  ];

  @override
  void initState() {
    super.initState();
    _selectedAllergies = List.from(widget.selectedAllergies);
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      if (_selectedAllergies.contains(allergy)) {
        _selectedAllergies.remove(allergy);
      } else {
        _selectedAllergies.add(allergy);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Select Allergies',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select all that apply',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 24),
          Flexible(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: _commonAllergies.map((allergy) {
                  final isSelected = _selectedAllergies.contains(allergy);
                  return GestureDetector(
                    onTap: () => _toggleAllergy(allergy),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryColor
                            : const Color.fromRGBO(36, 38, 43, 1),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primaryColor
                              : const Color.fromRGBO(57, 60, 67, 1),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            allergy,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color:
                                  isSelected ? Colors.white : Colors.grey[300],
                            ),
                          ),
                          if (isSelected) ...[
                            const SizedBox(width: 6),
                            const Icon(
                              Icons.check,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: CustomYafButton(
              text: 'Save',
              onPressed: () {
                widget.onSave(_selectedAllergies);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
