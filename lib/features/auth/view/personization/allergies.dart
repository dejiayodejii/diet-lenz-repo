import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/component/personalization_stepper.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/target_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';

class AllegiesScreen extends ConsumerStatefulWidget {
  const AllegiesScreen({super.key});

  @override
  ConsumerState<AllegiesScreen> createState() => _AllergiesScreenState();
}

class _AllergiesScreenState extends ConsumerState<AllegiesScreen> {
  static const String _noneAllergy = 'None';
  static const List<String> _commonAllergies = [
    _noneAllergy,
    "Peanuts",
    "Tree Nuts",
    "Milk",
    "Eggs",
    "Fish",
    "Shellfish",
    "Soy",
    "Wheat",
    "Gluten",
    "Sesame",
    "Lactose",
    "Mustard",
  ];

  final TextEditingController _otherAllergyController = TextEditingController();
  final Set<String> _selectedAllergies = {};

  @override
  void initState() {
    super.initState();
    final savedAllergies = ref.read(onboardingProfileProvider).allergies ?? [];
    _selectedAllergies.addAll(savedAllergies.map(_displayValue));
  }

  @override
  void dispose() {
    _otherAllergyController.dispose();
    super.dispose();
  }

  String _displayValue(String value) {
    return value
        .trim()
        .split(RegExp(r'\s+'))
        .where((word) => word.isNotEmpty)
        .map(
          (word) =>
              '${word.substring(0, 1).toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      if (allergy == _noneAllergy) {
        if (_selectedAllergies.contains(_noneAllergy)) {
          _selectedAllergies.remove(_noneAllergy);
        } else {
          _selectedAllergies
            ..clear()
            ..add(_noneAllergy);
        }
        return;
      }

      _selectedAllergies.remove(_noneAllergy);
      if (!_selectedAllergies.add(allergy)) {
        _selectedAllergies.remove(allergy);
      }
    });
  }

  void _addOtherAllergy() {
    final value = _displayValue(_otherAllergyController.text);
    if (value.isEmpty) return;

    final existingValue = _selectedAllergies.cast<String?>().firstWhere(
          (allergy) => allergy!.toLowerCase() == value.toLowerCase(),
          orElse: () => null,
        );

    if (existingValue == null) {
      setState(() {
        _selectedAllergies.remove(_noneAllergy);
        _selectedAllergies.add(value);
      });
    }

    _otherAllergyController.clear();
    FocusScope.of(context).unfocus();
  }

  void _continue() {
    final allergies = _selectedAllergies
        .where((allergy) => allergy != _noneAllergy)
        .map((allergy) => allergy.toLowerCase())
        .toList()
      ..sort();

    ref.read(onboardingProfileProvider.notifier).updateAllergies(allergies);
    NavigationService.push(child: const TargetEventScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const PersonalizationStepper(currentStep: 8),
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        minimum: EdgeInsets.fromLTRB(
            16, 8, 16, 20 + MediaQuery.of(context).padding.bottom),
        child: CustomYafButton(
          fontSize: 16,
          weight: FontWeight.w600,
          iconPositionLeft: false,
          text: 'Continue',
          iconWidget: SvgPicture.asset(AppImages.arrowRight),
          onPressed: _continue,
        ),
      ),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          padding: const EdgeInsets.fromLTRB(25, 30, 25, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Any allergies?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 28,
                    color: AppColors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 80),
              // const Center(
              //   child: Text(
              //     'Select all that apply, or continue without selecting any.',
              //     textAlign: TextAlign.center,
              //     style: TextStyle(
              //       fontSize: 14,
              //       color: AppColors.textGrey,
              //       fontWeight: FontWeight.w400,
              //     ),
              //   ),
              // ),
              // const SizedBox(height: 28),
              SizedBox(
                width: double.infinity,
                // color: Colors.red,
                child: Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 12,
                  children: _commonAllergies.map((allergy) {
                    final isSelected = _selectedAllergies.contains(allergy);

                    return _AllergyOptionChip(
                      label: allergy,
                      isSelected: isSelected,
                      onTap: () => _toggleAllergy(allergy),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 60),
              LabelTextFormField(
                labelText: 'Others',
                hintText: 'Type another allergy',
                controller: _otherAllergyController,
                textInputAction: TextInputAction.done,
                onEditingComplete: _addOtherAllergy,
                suffixIcon: IconButton(
                  tooltip: 'Add allergy',
                  onPressed: _addOtherAllergy,
                  icon: const Icon(
                    Icons.add_circle,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
              if (_selectedAllergies.isNotEmpty) ...[
                const SizedBox(height: 28),
                const Text(
                  'Selected',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _selectedAllergies.map((allergy) {
                    return InputChip(
                      label: Text(allergy),
                      onDeleted: () {
                        setState(() {
                          _selectedAllergies.remove(allergy);
                        });
                      },
                      deleteIcon: const Icon(Icons.close, size: 18),
                      backgroundColor: const Color.fromRGBO(255, 90, 22, 0.22),
                      deleteIconColor: AppColors.white,
                      labelStyle: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      side: BorderSide.none,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AllergyOptionChip extends StatelessWidget {
  const _AllergyOptionChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      button: true,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            color: isSelected
                ? const Color(0xFF393C43)
                : const Color.fromRGBO(36, 38, 43, 1),
            boxShadow: isSelected
                ? const [
                    BoxShadow(
                      color: Color.fromRGBO(129, 133, 141, 0.25),
                      spreadRadius: 4,
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
      ),
    );
  }
}
