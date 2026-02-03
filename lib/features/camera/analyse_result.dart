import 'dart:convert';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/widgets/calorie_badge.dart';
import 'package:diet_lenz/widgets/macro_progress_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AnalyseResultDetail extends ConsumerStatefulWidget {
  const AnalyseResultDetail(this.analysis, {super.key});
  final FoodAnalysisDto analysis;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FoodLogDetailState();
}

class _FoodLogDetailState extends ConsumerState<AnalyseResultDetail> {
  final TextEditingController mealTypeController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  double get protein => widget.analysis.totalMacros?.protein?.value ?? 0.0;
  double get carbs => widget.analysis.totalMacros?.carbs?.value ?? 0.0;
  double get fat => widget.analysis.totalMacros?.fat?.value ?? 0.0;
  double get fiber => widget.analysis.totalMacros?.fiber?.value ?? 0.0;

  // Calculate the maximum macro value for relative comparison
  double get maxMacroValue {
    final values = [protein, carbs, fat, fiber];
    return values.reduce((a, b) => a > b ? a : b);
  }

  // Calculate relative progress for each macro (0.0 to 1.0)
  double getRelativeProgress(double value) {
    if (maxMacroValue == 0) return 0.0;
    return (value / maxMacroValue).clamp(0.0, 1.0);
  }

  LogMealRequestDtoMealTypeEnum? _selectedMealType;

  String _calculateTotalMacros() {
    final total = protein + carbs + fat + fiber;
    return total.toStringAsFixed(1);
  }

  Future<void> _handleAddToLog() async {
    final foodLoggingVM = ref.read(foodLoggingViewModelProvider.notifier);

    // Validate meal type
    if (_selectedMealType == null) {
      ref.read(toastProvider).showError(
            'Please select a meal type (Breakfast, Lunch, Dinner, or Snack)',
          );

      return;
    }

    // Create log meal request
    final request = LogMealRequestDto(
      foodAnalysis: widget.analysis,
      mealType: _selectedMealType!,
      notes: noteController.text.trim().isEmpty
          ? null
          : noteController.text.trim(),
      servingMultiplier: 1.0, // Default serving size
    );

    // Log the meal
    final result = await foodLoggingVM.logMeal(request);

    // Check for errors
    final state = ref.read(foodLoggingViewModelProvider);
    if (!result) {
      if (mounted) {
        ref.read(toastProvider).showError(
              'Failed to log meal: ${state.errorMessage}',
            );
      }
    } else {
      // Success
      if (mounted) {
        ref.read(toastProvider).showSuccess(
              'Meal logged successfully!',
            );
        NavigationService.pushAndRemoveUntil(child: BottomNavScreen());
      }
    }
  }

  Widget _buildMealTypeSelector() {
    final mealTypes = LogMealRequestDtoMealTypeEnum.values;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Meal Type",
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12.0,
          runSpacing: 12.0,
          children: mealTypes.map((type) {
            final isSelected = _selectedMealType == type;
            // Format name: BREAKFAST -> Breakfast
            final typeValue = type.value;
            final name = typeValue[0] + typeValue.substring(1).toLowerCase();

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMealType = type;
                });
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primaryColor
                      : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primaryColor
                        : Colors.grey.shade700,
                  ),
                ),
                child: Text(
                  name,
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.w400,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(foodLoggingViewModelProvider);
    return BlurryModalProgressHUD(
      inAsyncCall: state.isLoading,
      child: Scaffold(
        extendBody: false,
        backgroundColor: Colors.black,
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 350,
                  width: double.infinity,
                  child: widget.analysis.imageBase64 != null
                      ? Image.memory(
                          base64Decode(widget.analysis.imageBase64!),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          AppImages.salad,
                          scale: 2,
                          fit: BoxFit.cover,
                        ),
                ),
                Positioned(
                  top: 40.0,
                  left: 15,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                decoration: const BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.analysis.foodName ?? "Unknown Food",
                              style: const TextStyle(
                                fontFamily: AppFonts.lato,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          CalorieBadge(
                            text: '${_calculateTotalMacros()}g',
                          ),
                        ],
                      ),
                      CalorieBadge(
                        text:
                            '${widget.analysis.totalMacros?.calories?.toStringAsFixed(0) ?? "0"} cal',
                      ),
                      const SizedBox(height: 15),
                      const SizedBox(height: 20),
                      Text(
                        widget.analysis.description ??
                            "No description available",
                        style: const TextStyle(
                          fontFamily: AppFonts.lato,
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 20),
                      MacroProgressItem(
                        label: 'Protein',
                        currentValue:
                            '${protein.toStringAsFixed(1)}${widget.analysis.totalMacros?.protein?.unit ?? "g"}',
                        targetValue: '',
                        progress: getRelativeProgress(protein),
                      ),
                      const SizedBox(height: 20),
                      MacroProgressItem(
                        label: 'Carbs',
                        currentValue:
                            '${carbs.toStringAsFixed(1)}${widget.analysis.totalMacros?.carbs?.unit ?? "g"}',
                        targetValue: '',
                        progress: getRelativeProgress(carbs),
                      ),
                      const SizedBox(height: 20),
                      MacroProgressItem(
                        label: 'Fat',
                        currentValue:
                            '${fat.toStringAsFixed(1)}${widget.analysis.totalMacros?.fat?.unit ?? "g"}',
                        targetValue: '',
                        progress: getRelativeProgress(fat),
                      ),
                      const SizedBox(height: 20),
                      MacroProgressItem(
                        label: 'Fiber',
                        currentValue:
                            '${fiber.toStringAsFixed(1)}${widget.analysis.totalMacros?.fiber?.unit ?? "g"}',
                        targetValue: '',
                        progress: getRelativeProgress(fiber),
                      ),
                      const SizedBox(height: 20),
                      _buildMealTypeSelector(),
                      const SizedBox(height: 20),
                      LabelTextFormField(
                        hintText: "Note about meal",
                        controller: noteController,
                      ),
                      const SizedBox(height: 20),
                      CustomYafButton(
                        text: "Add to Log",
                        onPressed: _handleAddToLog,
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
