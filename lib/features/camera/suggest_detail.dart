import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/toast_service.dart';
import 'package:diet_lenz/core/utils/functions.dart';
import 'package:diet_lenz/core/utils/loader.dart';
import 'package:diet_lenz/features/bottom_nav/bottom.dart';
import 'package:diet_lenz/features/camera/edit_suggest.dart';
import 'package:diet_lenz/features/camera/edit_recipe_steps.dart';
import 'package:diet_lenz/component/custom_textfield.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/recipe/controller/recipe_viewmodel.dart';
import 'package:diet_lenz/widgets/pulsating_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../constants/app_fonts.dart';
import '../../widgets/calorie_badge.dart';

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

  @override
  void initState() {
    super.initState();
    // Create a mutable copy of the ingredients list
    ingredients = List.from(widget.suggestion.ingredients);
    // Create a mutable copy of the recipe steps list
    recipeSteps = List.from(widget.suggestion.recipeSteps);
  }

  @override
  void dispose() {
    _reanalyseController.dispose();
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

  LogMealRequestDtoMealTypeEnum? _selectedMealType;

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

  Future<void> _handleAddToLog() async {
    final foodLoggingVM = ref.read(foodLoggingViewModelProvider.notifier);

    // Validate meal type
    if (_selectedMealType == null) {
      ref.read(toastProvider).showError(
            'Please select a meal type (Breakfast, Lunch, Dinner, or Snack)',
          );
      return;
    }

    // Convert SuggestedFoodAnalysis to FoodAnalysisDto (use re-analyzed result if available)
    final foodAnalysis = _reAnalyzedResult ??
        FoodAnalysisDto(
          foodName: widget.suggestion.foodName,
          description: widget.suggestion.description,
          // ingredients: ingredients,
          totalMacros: widget.suggestion.totalMacros,
          // imageBase64: widget.suggestion.imageBase64,
        );

    // Create log meal request
    final request = LogMealRequestDto(
      foodAnalysis: foodAnalysis,
      mealType: _selectedMealType!,
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
          _reanalyseController.clear();
        });
        ref.read(toastProvider).showSuccess('Analysis updated!');
      }
    } else {
      final error = ref.read(recipeViewModelProvider).errorMessage;
      ref.read(toastProvider).showError(error ?? 'Re-analysis failed');
    }
  }

  String _calculateTotalMacros() {
    final total = protein + carbs + fat + fiber;
    return total.toStringAsFixed(1);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(foodLoggingViewModelProvider);
    final recipeState = ref.watch(recipeViewModelProvider);
    return BlurryModalProgressHUD(
        inAsyncCall: state.isLoading || recipeState.isLoading,
        child: Scaffold(
          backgroundColor: Colors.black,
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Image Section
                    Stack(
                      children: [
                        // widget.suggestion.suggestedImage != null
                        //     ? Image.network(
                        //         widget.suggestion.suggestedImage!,
                        //         height: 350,
                        //         width: double.infinity,
                        //         fit: BoxFit.cover,
                        //         errorBuilder: (ctx, err, st) => Image.asset(
                        //           AppImages.salad,
                        //           scale: 2,
                        //           height: 350,
                        //           width: double.infinity,
                        //           fit: BoxFit.cover,
                        //         ),
                        //       )
                        //     :
                        widget.headerImage ??
                            Image.asset(
                              AppImages.salad,
                              scale: 2,
                              height: 350,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                        SafeArea(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black45,
                                  child: IconButton(
                                    icon: const Icon(Icons.arrow_back_ios_new,
                                        color: Colors.white, size: 18),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                              CalorieBadge(
                                text: '${_calculateTotalMacros()}g',
                              ),
                            ],
                          ),
                          CalorieBadge(
                            text:
                                '${(_reAnalyzedResult?.totalMacros?.calories ?? widget.suggestion.totalMacros?.calories)?.toStringAsFixed(0) ?? "0"} cal',
                          ),
                          const SizedBox(height: 25),
                          _buildMacroBar(
                            "Protein",
                            "${protein.toStringAsFixed(1)}${(_reAnalyzedResult?.totalMacros?.protein?.unit ?? widget.suggestion.totalMacros?.protein?.unit) ?? "g"}",
                            getRelativeProgress(protein),
                          ),
                          const SizedBox(height: 15),
                          _buildMacroBar(
                            "Carbs",
                            "${carbs.toStringAsFixed(1)}${(_reAnalyzedResult?.totalMacros?.carbs?.unit ?? widget.suggestion.totalMacros?.carbs?.unit) ?? "g"}",
                            getRelativeProgress(carbs),
                          ),
                          const SizedBox(height: 15),
                          _buildMacroBar(
                            "Fats",
                            "${fat.toStringAsFixed(1)}${(_reAnalyzedResult?.totalMacros?.fat?.unit ?? widget.suggestion.totalMacros?.fat?.unit) ?? "g"}",
                            getRelativeProgress(fat),
                          ),
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
                          ],
                        PulsatingBorder(
                        borderWidth: 3,
                        color: AppColors.primaryColor,
                        child: LabelTextFormField(
                          noBorder: true,
                          suffixIcon: GestureDetector(
                            onTap: _handleReAnalyze,
                            child: const Icon(Icons.send,
                                size: 20, color: AppColors.primaryColor),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    final updatedIngredients = await Navigator
                                        .push<List<IngredientDto>>(
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    "Edit",
                                    style: TextStyle(color: Color(0xFFFF6B35)),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ...ingredients.map(
                              (ingredient) => Padding(
                                padding: const EdgeInsets.only(bottom: 12.0),
                                child: _buildIngredientCard(ingredient),
                              ),
                            ),
                          ],
                          if (recipeSteps.isNotEmpty) ...[
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                  child: const Text(
                                    "Edit",
                                    style: TextStyle(color: Color(0xFFFF6B35)),
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
                          const SizedBox(height: 100), // Space for button
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 20 + MediaQuery.of(context).padding.bottom,
                left: 20,
                right: 20,
                child: CustomYafButton(
                  text: "Add to Log",
                  onPressed: _handleAddToLog,
                ),
              ),
            ],
          ),
        ));
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
                  color: isSelected ? AppColors.primaryColor : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color:
                        isSelected ? AppColors.primaryColor : Colors.grey.shade700,
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

  Widget _buildMacroBar(String label, String value, double progress) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey[800],
            color: AppColors.primaryColor,
            minHeight: 6,
          ),
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
