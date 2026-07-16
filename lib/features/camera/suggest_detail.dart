import 'dart:math' as math;

import 'package:openapi/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/functions.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/camera/database_result.dart';
import 'package:diet_lenz/features/camera/edit_suggest.dart';
import 'package:diet_lenz/features/camera/edit_recipe_steps.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/recipe/controller/recipe_viewmodel.dart';
import 'package:diet_lenz/widgets/pulsating_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_fonts.dart';

class SuggestMealDetailScreen extends ConsumerStatefulWidget {
  final SuggestedFoodAnalysis suggestion;
  final Widget? headerImage;

  const SuggestMealDetailScreen({
    super.key,
    required this.suggestion,
    this.headerImage,
  });

  @override
  ConsumerState<SuggestMealDetailScreen> createState() =>
      _SuggestMealDetailScreenState();
}

class _SuggestMealDetailScreenState
    extends ConsumerState<SuggestMealDetailScreen> {
  late List<IngredientDto> ingredients;
  late List<String> recipeSteps;
  FoodAnalysisDto? _reAnalyzedResult;
  final TextEditingController _reanalyseController = TextEditingController();
  late final TextEditingController _amountController;
  List<MeasureDto> _measures = [];
  MeasureDto? _selectedMeasure;

  @override
  void initState() {
    super.initState();
    // Create a mutable copy of the ingredients list
    ingredients = List.from(widget.suggestion.ingredients);
    // Create a mutable copy of the recipe steps list
    recipeSteps = List.from(widget.suggestion.recipeSteps);
    _amountController = TextEditingController(text: '1')
      ..addListener(_onAmountChanged);
  }

  @override
  void dispose() {
    _reanalyseController.dispose();
    _amountController
      ..removeListener(_onAmountChanged)
      ..dispose();
    super.dispose();
  }

  double get protein =>
      _reAnalyzedResult?.totalMacros?.protein?.value ??
      widget.suggestion.totalMacros?.protein?.value ??
      0.0;
  double get carbs =>
      _reAnalyzedResult?.totalMacros?.carbs?.value ??
      widget.suggestion.totalMacros?.carbs?.value ??
      0.0;
  double get fat =>
      _reAnalyzedResult?.totalMacros?.fat?.value ??
      widget.suggestion.totalMacros?.fat?.value ??
      0.0;
  double get fiber =>
      _reAnalyzedResult?.totalMacros?.fiber?.value ??
      widget.suggestion.totalMacros?.fiber?.value ??
      0.0;
  double get calories =>
      _reAnalyzedResult?.totalMacros?.calories ??
      widget.suggestion.totalMacros?.calories ??
      0.0;

  double get _amount =>
      math.max(0, double.tryParse(_amountController.text.trim()) ?? 1);

  double get _servingMultiplier {
    final selectedMeasure = _selectedMeasure;
    if (selectedMeasure == null) return _amount;
    final totalWeightGrams = _amount * (selectedMeasure.weightGrams ?? 0);
    return math.max(0, totalWeightGrams / 100);
  }

  double _scaled(double value) => value * _servingMultiplier;

  double get _scaledCalories => _scaled(calories);
  double get _scaledProtein => _scaled(protein);
  double get _scaledCarbs => _scaled(carbs);
  double get _scaledFat => _scaled(fat);
  double get _scaledFiber => _scaled(fiber);

  LogMealRequestDtoMealTypeEnum? _selectedMealType;

  Future<void> _handleAddToLog() async {
    final foodLoggingVM = ref.read(foodLoggingViewModelProvider.notifier);

    if (_amount <= 0 || _servingMultiplier <= 0) {
      ref.read(toastProvider).showError('Enter an amount greater than zero');
      return;
    }

    // Validate meal type
    if (_selectedMealType == null) {
      ref.read(toastProvider).showError(
            'Please select a meal type (Breakfast, Lunch, Dinner, or Snack)',
          );
      return;
    }

    final activeMacros =
        _reAnalyzedResult?.totalMacros ?? widget.suggestion.totalMacros;
    final foodAnalysis = FoodAnalysisDto(
      foodName: _reAnalyzedResult?.foodName ?? widget.suggestion.foodName,
      description:
          _reAnalyzedResult?.description ?? widget.suggestion.description,
      imageBase64: _reAnalyzedResult?.imageBase64,
       measures: _selectedMeasure != null ? [_selectedMeasure!] : [],
      totalMacros: MacroNutrientsDto(
        calories: _scaledCalories,
        protein: QuantityDto(
          value: _scaledProtein,
          unit: activeMacros?.protein?.unit ?? 'g',
        ),
        carbs: QuantityDto(
          value: _scaledCarbs,
          unit: activeMacros?.carbs?.unit ?? 'g',
        ),
        fat: QuantityDto(
          value: _scaledFat,
          unit: activeMacros?.fat?.unit ?? 'g',
        ),
        fiber: QuantityDto(
          value: _scaledFiber,
          unit: activeMacros?.fiber?.unit ?? 'g',
        ),
      ),
    );

    // Create log meal request
    final request = LogMealRequestDto(
      foodAnalysis: foodAnalysis,
      mealType: _selectedMealType!,
      // The analysis already contains the totals displayed in the UI.
      // Keep this at one so the backend does not scale them a second time.
      servingMultiplier: _amount,
       source_: LogMealRequestDtoSource_Enum.AI_IMAGE
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
        final date = DateTime.now();
        ref
            .read(foodLoggingViewModelProvider.notifier)
            .getUserRecipes(date: date, refresh: true);
        ref
            .read(foodLoggingViewModelProvider.notifier)
            .getDashboard(date: date, refresh: true);
        NavigationService.pushAndRemoveUntil(child: const BottomNavScreen());
      }
    }
  }

  Future<void> _handleReAnalyze() async {
    final text = _reanalyseController.text.trim();
    if (text.isEmpty) return;

    final updatedAnalysis = FoodAnalysisDto(
      foodName: _reAnalyzedResult?.foodName ?? widget.suggestion.foodName,
      description: text,
      totalMacros: MacroNutrientsDto(
        calories: _reAnalyzedResult?.totalMacros?.calories ??
            widget.suggestion.totalMacros?.calories ??
            0.0,
        protein: QuantityDto(
          value: protein,
          unit: widget.suggestion.totalMacros?.protein?.unit ?? 'g',
        ),
        carbs: QuantityDto(
          value: carbs,
          unit: widget.suggestion.totalMacros?.carbs?.unit ?? 'g',
        ),
        fat: QuantityDto(
          value: fat,
          unit: widget.suggestion.totalMacros?.fat?.unit ?? 'g',
        ),
        fiber: QuantityDto(
          value: fiber,
          unit: widget.suggestion.totalMacros?.fiber?.unit ?? 'g',
        ),
      ),
    );

    final recipeVM = ref.read(recipeViewModelProvider.notifier);
    final success = await recipeVM.reAnalyzeRecipe(updatedAnalysis);

    if (!mounted) return;

    if (success) {
      final result = ref.read(recipeViewModelProvider).analyzedRecipe;
      if (result != null) {
        setState(() {
          _reAnalyzedResult = result;
          _setMeasures(result.measures);
          _reanalyseController.clear();
        });
        ref.read(toastProvider).showSuccess('Analysis updated!');
      }
    } else {
      final error = ref.read(recipeViewModelProvider).errorMessage;
      ref.read(toastProvider).showError(error ?? 'Re-analysis failed');
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(foodLoggingViewModelProvider);
    final recipeState = ref.watch(recipeViewModelProvider);
    return BlurryModalProgressHUD(
        inAsyncCall: state.isLoading || recipeState.isLoading,
        child: Scaffold(
          // backgroundColor: Colors.black,
          extendBody: true,
          body: Stack(
            fit: StackFit.expand,
            children: [
              Stack(
                children: [
                  widget.headerImage ??
                      Image.asset(
                        AppImages.salad,
                        scale: 2,
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
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
              Positioned(
                top: 250,
                bottom: 0,
                right: 0,
                left: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
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
                        // Top Image Section

                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      _reAnalyzedResult?.foodName ??
                                          widget.suggestion.foodName ??
                                          "Unknown Food",
                                      style: const TextStyle(
                                        fontFamily: AppFonts.lato,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  // CalorieBadge(
                                  //   text: '${_calculateTotalMacros()}g',
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                (_reAnalyzedResult?.description ??
                                    widget.suggestion.description)!,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 20),
                              NutritionReadout(
                                value: _formatNutritionValue(_scaledCalories),
                                unit: 'Kcal',
                              ),
                              const SizedBox(height: 20),
                              if (_measures.isNotEmpty) ...[
                                const Text(
                                  'Measurement',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: AppFonts.spaceGrotesk,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                _buildMeasureSelector(),
                                const SizedBox(height: 20),
                              ],
                              const Text(
                                'Portion',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: AppFonts.spaceGrotesk,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 12),
                              _buildAmountField(),
                              const SizedBox(height: 24),
                              _buildMacroCards(),
                              const SizedBox(height: 20),
                              if ((_reAnalyzedResult?.description ??
                                          widget.suggestion.description) !=
                                      null &&
                                  (_reAnalyzedResult?.description ??
                                          widget.suggestion.description)!
                                      .isNotEmpty) ...[
                                const Text(
                                  "Description",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                              PulsatingBorder(
                                borderWidth: 3,
                                color: AppColors.primaryColor,
                                child: LabelTextFormField(
                                  noBorder: true,
                                  suffixIcon: GestureDetector(
                                    onTap: _handleReAnalyze,
                                    child: const Icon(Icons.send,
                                        size: 20,
                                        color: AppColors.primaryColor),
                                  ),
                                  maxLines: 2,
                                  controller: _reanalyseController,
                                  hintText:
                                      "Anything missing? (e.g., 'fried in oil' or 'large size')",
                                ),
                              ),
                              const SizedBox(height: 20),
                              if (ingredients.isNotEmpty) ...[
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Ingredients",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final updatedIngredients =
                                            await Navigator.push<
                                                List<IngredientDto>>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditIngredientScreen(
                                              suggestion: widget.suggestion,
                                            ),
                                          ),
                                        );

                                        // Update the ingredients list if user updated them
                                        if (updatedIngredients != null) {
                                          setState(() {
                                            ingredients = updatedIngredients;
                                          });
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color(0xFFFF6B35)
                                            .withOpacity(0.1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
                                        "Edit",
                                        style:
                                            TextStyle(color: Color(0xFFFF6B35)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ...ingredients.map(
                                  (ingredient) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: _buildIngredientCard(ingredient),
                                  ),
                                ),
                              ],
                              if (recipeSteps.isNotEmpty) ...[
                                const SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Recipe Steps",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final updatedSteps =
                                            await Navigator.push<List<String>>(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                EditRecipeStepsScreen(
                                              suggestion: widget.suggestion,
                                              recipeSteps: recipeSteps,
                                            ),
                                          ),
                                        );

                                        // Update the recipe steps list if user updated them
                                        if (updatedSteps != null) {
                                          setState(() {
                                            recipeSteps = updatedSteps;
                                          });
                                        }
                                      },
                                      style: TextButton.styleFrom(
                                        backgroundColor: const Color(0xFFFF6B35)
                                            .withOpacity(0.1),
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                      ),
                                      child: const Text(
                                        "Edit",
                                        style:
                                            TextStyle(color: Color(0xFFFF6B35)),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                ...recipeSteps.asMap().entries.map(
                                      (entry) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 12.0),
                                        child: _buildRecipeStepCard(
                                          entry.key + 1,
                                          entry.value,
                                        ),
                                      ),
                                    ),
                              ],
                              const SizedBox(height: 20),
                              _buildMealTypeSelector(),
                              const SizedBox(height: 20),
                              CustomYafButton(
                                text: "Add to Log",
                                onPressed: _handleAddToLog,
                              ),
                              const SizedBox(height: 40), // Space for button
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  void _onAmountChanged() {
    if (mounted) setState(() {});
  }

  Widget _buildAmountField() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: LabelTextFormField(
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,3}')),
        ],
        controller: _amountController,
        suffixIcon: _selectedMeasure == null
            ? const Padding(
                padding: EdgeInsets.all(8),
                child: SizedBox(height: 20, width: 20, child: Icon(Icons.edit)),
              )
            : Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  _amountUnit(_selectedMeasure!),
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
              ),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
      ),
    );
  }

  Widget _buildMeasureSelector() {
    return SizedBox(
      height: 42,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _measures.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final measure = _measures[index];
          final isSelected = identical(measure, _selectedMeasure);
          return GestureDetector(
            onTap: () => setState(() => _selectedMeasure = measure),
            child: Container(
              width: 124,
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected
                      ? AppColors.primaryColor
                      : const Color(0xFF5A5A5A),
                  width: isSelected ? 1.4 : 1.2,
                ),
              ),
              child: Text(
                _displayMeasureLabel(measure),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
          );
        },
      ),
    );
  }

  void _setMeasures(List<MeasureDto> measures) {
    _measures = _prepareMeasures(measures);
    _selectedMeasure = _measures.isEmpty
        ? null
        : _measures.firstWhere(
            (measure) => _normalizedMeasureLabel(measure) == 'gram',
            orElse: () => _measures.first,
          );
  }

  List<MeasureDto> _prepareMeasures(List<MeasureDto> measures) {
    final usableMeasures = measures
        .where(
          (measure) =>
              measure.label?.trim().isNotEmpty == true &&
              (measure.weightGrams ?? 0) > 0,
        )
        .toList();
    const preferredOrder = {
      'cup': 0,
      'ounce': 1,
      'gram': 2,
      'serving': 3,
      'pound': 4,
      'kilogram': 5,
    };
    usableMeasures.sort((first, second) {
      final firstOrder = preferredOrder[_normalizedMeasureLabel(first)] ?? 100;
      final secondOrder =
          preferredOrder[_normalizedMeasureLabel(second)] ?? 100;
      return firstOrder.compareTo(secondOrder);
    });
    return usableMeasures;
  }

  String _normalizedMeasureLabel(MeasureDto measure) =>
      measure.label?.trim().toLowerCase() ?? '';

  String _displayMeasureLabel(MeasureDto measure) {
    switch (_normalizedMeasureLabel(measure)) {
      case 'ounce':
        return 'Oz';
      case 'pound':
        return 'Lb';
      case 'kilogram':
        return 'Kg';
      default:
        return measure.label?.trim() ?? 'Measure';
    }
  }

  String _amountUnit(MeasureDto measure) {
    switch (_normalizedMeasureLabel(measure)) {
      case 'gram':
        return 'g';
      case 'ounce':
        return 'oz';
      case 'pound':
        return 'lb';
      case 'kilogram':
        return 'kg';
      default:
        return measure.label?.trim().toLowerCase() ?? '';
    }
  }

  String _formatNutritionValue(double value) {
    if ((value - value.round()).abs() < 0.05) {
      return value.round().toString();
    }
    return value.toStringAsFixed(1);
  }

  Widget _buildMacroCards() {
    final maxValue = math.max(
      _scaledCarbs,
      math.max(_scaledProtein, math.max(_scaledFat, _scaledFiber)),
    );
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: MacroCard(
                label: 'Carb',
                value: _scaledCarbs,
                progress: maxValue == 0 ? 0 : _scaledCarbs / maxValue,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: MacroCard(
                label: 'Protein',
                value: _scaledProtein,
                progress: maxValue == 0 ? 0 : _scaledProtein / maxValue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: MacroCard(
                label: 'Fat',
                value: _scaledFat,
                progress: maxValue == 0 ? 0 : _scaledFat / maxValue,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: MacroCard(
                label: 'Fiber',
                value: _scaledFiber,
                progress: maxValue == 0 ? 0 : _scaledFiber / maxValue,
              ),
            ),
          ],
        ),
      ],
    );
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

  Widget _buildIngredientCard(IngredientDto ingredient) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            ingredient.name?.capitalize ?? "Unknown Ingredient",
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMacroInfo(
                  "${ingredient.macros?.calories?.toStringAsFixed(0) ?? "0"} kcal"),
              _buildMacroInfo(
                  "Protein: ${ingredient.macros?.protein?.value?.toStringAsFixed(0) ?? "0"}g"),
              _buildMacroInfo(
                  "Carbs: ${ingredient.macros?.carbs?.value?.toStringAsFixed(0) ?? "0"}g"),
              _buildMacroInfo(
                  "Fat: ${ingredient.macros?.fat?.value?.toStringAsFixed(0) ?? "0"}g"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMacroInfo(String text) {
    return Text(
      text,
      style: const TextStyle(color: Colors.grey, fontSize: 12),
    );
  }

  Widget _buildRecipeStepCard(int stepNumber, String step) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                stepNumber.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
