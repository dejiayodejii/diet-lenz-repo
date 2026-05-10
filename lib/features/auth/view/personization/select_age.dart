import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/controller/onboarding_profile_provider.dart';
import 'package:diet_lenz/features/auth/view/personization/select_goal.dart';
import 'package:diet_lenz/features/recipe/controller/recipe_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SelectAgeScreen extends ConsumerStatefulWidget {
  const SelectAgeScreen({super.key});

  @override
  ConsumerState<SelectAgeScreen> createState() => _SelectAgeScreenState();
}

class _SelectAgeScreenState extends ConsumerState<SelectAgeScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch goals when screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(recipeViewModelProvider.notifier).getGoals();
      ref.read(recipeViewModelProvider.notifier).getMacroTargets();
    });
  }

  // Variable to store the selected date
  DateTime? _selectedDate;

  final TextEditingController dobController = TextEditingController();

  // Helper to format numbers (e.g., turn 5 into 05)
  String _formatNumber(int number) {
    return number.toString().padLeft(2, '0');
  }

  // Function to trigger the Date Picker
  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ??
          DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now().subtract(const Duration(days: 365 * 14)),
      builder: (context, child) {
        // Customizing the Date Picker theme to match the app
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Color(0xFFEF6C35),
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
        dobController.text =
            "${_formatNumber(picked.month)}/${_formatNumber(picked.day)}/${picked.year}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define the Orange Color
    const Color accentColor = AppColors.primaryColor;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withOpacity(0.1),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new, size: 18),
              onPressed: () {
                // Handle back navigation
                Navigator.pop(context);
              },
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // -- Title --
            const Text(
              "When is your\nbirthday?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Colors.white,
                height: 1.3,
              ),
            ),

            const Spacer(),

            // -- Date Selectors (MM, DD, YYYY) --

            LabelTextFormField(
              onTap: _pickDate,
              hintText: "Select your date of birth",
              readOnly: true,
              controller: dobController,
              suffixIcon: Icon(
                Icons.calendar_month,
                color: Colors.grey,
              ),
            ),
            // Row(
            //   children: [
            //     // Month Selector
            //     Expanded(
            //       flex: 3,
            //       child: _DateSelectorBox(
            //         label: _selectedDate == null
            //             ? "YYYY"
            //             : _selectedDate!.year.toString(),
            //         onTap: _pickDate,
            //       ),
            //     ),
            //     Expanded(
            //       flex: 2,
            //       child: _DateSelectorBox(
            //         label: _selectedDate == null
            //             ? "MM"
            //             : _formatNumber(_selectedDate!.month),
            //         onTap: _pickDate,
            //       ),
            //     ),
            //     const SizedBox(width: 12),

            //     // Day Selector
            //     Expanded(
            //       flex: 2,
            //       child: _DateSelectorBox(
            //         label: _selectedDate == null
            //             ? "DD"
            //             : _formatNumber(_selectedDate!.day),
            //         onTap: _pickDate,
            //       ),
            //     ),
            //     const SizedBox(width: 12),

            //     // Year Selector
            //   ],
            // ),

            const Spacer(),
            const Spacer(),

            // -- Continue Button --

            CustomYafButton(
                isDisabled: _selectedDate == null,
                fontSize: 16,
                weight: FontWeight.w600,
                iconPositionLeft: false,
                text: "Continue",
                iconWidget: SvgPicture.asset(AppImages.arrowRight),
                onPressed: () {
                  if (_selectedDate != null) {
                    // Save date of birth
                    ref
                        .read(onboardingProfileProvider.notifier)
                        .updateDateOfBirth(_selectedDate!);
                    NavigationService.push(child: const SelectGoalScreen());
                  } else {
                    // Show error if no date is selected
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Please select your date of birth"),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }),
            SizedBox(height: 20 + MediaQuery.of(context).padding.bottom),
          ],
        ),
      ),
    );
  }
}

// -- Reusable Widget for the Date Boxes --
class _DateSelectorBox extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _DateSelectorBox({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const Color accentColor = Color(0xFFEF6C35);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF101010), // Background match
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: accentColor, // Orange Border
            width: 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const Icon(
              Icons.keyboard_arrow_down,
              color: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
