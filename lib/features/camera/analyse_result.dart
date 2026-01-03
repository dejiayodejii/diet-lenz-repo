import 'dart:convert';

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

  String _calculateTotalMacros() {
    final total = protein + carbs + fat + fiber;
    return total.toStringAsFixed(1);
  }

  LogMealRequestDtoMealTypeEnum? _parseMealType(String input) {
    final normalizedInput = input.trim().toUpperCase();
    switch (normalizedInput) {
      case 'BREAKFAST':
        return LogMealRequestDtoMealTypeEnum.BREAKFAST;
      case 'LUNCH':
        return LogMealRequestDtoMealTypeEnum.LUNCH;
      case 'DINNER':
        return LogMealRequestDtoMealTypeEnum.DINNER;
      case 'SNACK':
        return LogMealRequestDtoMealTypeEnum.SNACK;
      default:
        return null;
    }
  }

  Future<void> _handleAddToLog() async {
    final foodLoggingVM = ref.read(foodLoggingViewModelProvider.notifier);

    // Validate meal type
    final mealTypeInput = mealTypeController.text.trim();
    if (mealTypeInput.isEmpty) {
      ref.read(toastProvider).showError(
            'Please enter a meal type (Breakfast, Lunch, Dinner, or Snack)',
          );

      return;
    }

    final mealType = _parseMealType(mealTypeInput);
    if (mealType == null) {
      ref.read(toastProvider).showError(
            'Invalid meal type. Please use: Breakfast, Lunch, Dinner, or Snack',
          );

      return;
    }

    // Create log meal request
    final request = LogMealRequestDto(
      foodAnalysis: widget.analysis,
      mealType: mealType,
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

        // Navigate back after a short delay
        // Future.delayed(const Duration(milliseconds: 500), () {
        //   if (mounted) {
        //     Navigator.of(context).pop();
        //   }
        // });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(foodLoggingViewModelProvider);
    return BlurryModalProgressHUD(
      inAsyncCall: state.isLoading,
      child: Scaffold(
        extendBody: false,
        // backgroundColor: Colors.black,
        // appBar: AppBar(
        //   centerTitle: false,
        //   title: const Text(''),
        // ),
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
                      //

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

                          //total calori
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

                      // Total macros in grams

                      const SizedBox(height: 10),

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
                            '${widget.analysis.totalMacros?.protein?.value?.toStringAsFixed(1) ?? "0"}${widget.analysis.totalMacros?.protein?.unit ?? "g"}',
                        targetValue:
                            '', // Target values would come from user profile
                        progress: 0.0, // Calculate based on user's daily target
                      ),

                      const SizedBox(height: 20),
                      MacroProgressItem(
                        label: 'Carbs',
                        currentValue:
                            '${widget.analysis.totalMacros?.carbs?.value?.toStringAsFixed(1) ?? "0"}${widget.analysis.totalMacros?.carbs?.unit ?? "g"}',
                        targetValue: '',
                        progress: 0.0,
                      ),

                      const SizedBox(height: 20),
                      MacroProgressItem(
                        label: 'Fat',
                        currentValue:
                            '${widget.analysis.totalMacros?.fat?.value?.toStringAsFixed(1) ?? "0"}${widget.analysis.totalMacros?.fat?.unit ?? "g"}',
                        targetValue: '',
                        progress: 0.0,
                      ),
                      const SizedBox(height: 10),
                      MacroProgressItem(
                        label: 'Fiber',
                        currentValue:
                            '${widget.analysis.totalMacros?.fiber?.value?.toStringAsFixed(1) ?? "0"}${widget.analysis.totalMacros?.fiber?.unit ?? "g"}',
                        targetValue: '',
                        progress: 0.0,
                      ),
                      const SizedBox(height: 20),
                      LabelTextFormField(
                        hintText: "Enter meal type (e.g Breakfast, Lunch etc)",
                        controller: mealTypeController,
                      ),
                      LabelTextFormField(
                        hintText: "Note about meal",
                        controller: noteController,
                      ),
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
