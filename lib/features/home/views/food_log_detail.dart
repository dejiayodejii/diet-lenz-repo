import 'package:diet_lenz/api_client/lib/api.dart';
import 'package:diet_lenz/component/custom_button.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
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

class FoodLogDetail extends ConsumerStatefulWidget {
  final RecipeResponseDto? recipe;
  final FavoriteRecipeResponseDto? favorite;
  final bool fromFavorite;

  const FoodLogDetail({
    super.key,
    this.recipe,
    this.favorite,
    this.fromFavorite = false,
  }) : assert(recipe != null || favorite != null,
            'Either recipe or favorite must be provided');

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FoodLogDetailState();
}

class _FoodLogDetailState extends ConsumerState<FoodLogDetail> {
  LogMealRequestDtoMealTypeEnum? _selectedMealType =
      LogMealRequestDtoMealTypeEnum.DINNER;

  // Helper getters to extract data from either recipe or favorite
  String get foodName =>
      widget.recipe?.foodName ?? widget.favorite?.foodName ?? "Unknown Food";

  String get description =>
      widget.recipe?.description ??
      widget.favorite?.description ??
      "No description available";

  String? get imageUrl => widget.recipe?.imageUrl ?? widget.favorite?.imageUrl;

  MacroInfoDto? get macros => widget.recipe?.macros ?? widget.favorite?.macros;

  double get calories => macros?.calories ?? 0.0;
  double get protein => macros?.proteinGrams ?? 0.0;
  double get carbs => macros?.carbsGrams ?? 0.0;
  double get fat => macros?.fatGrams ?? 0.0;
  double get fiber => macros?.fiberGrams ?? 0.0;

  double get totalWeight => protein + carbs + fat + fiber;

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

  String? get _recipeId => widget.recipe?.id ?? widget.favorite?.recipeId;

  FoodAnalysisDto _buildFoodAnalysis() {
    return FoodAnalysisDto(
      foodName: foodName,
      description: description,
      totalMacros: MacroNutrientsDto(
        calories: calories,
        protein: QuantityDto(value: protein, unit: 'g'),
        carbs: QuantityDto(value: carbs, unit: 'g'),
        fat: QuantityDto(value: fat, unit: 'g'),
        fiber: QuantityDto(value: fiber, unit: 'g'),
      ),
    );
  }

  Future<void> _handleRelog() async {
    if (_selectedMealType == null) {
      ref.read(toastProvider).showError(
            'Please select a meal type',
          );
      return;
    }

    final foodLoggingVM = ref.read(foodLoggingViewModelProvider.notifier);

    final request = LogMealRequestDto(
      existingRecipeId: _recipeId,
      foodAnalysis: _recipeId == null ? _buildFoodAnalysis() : null,
      mealType: _selectedMealType!,
      servingMultiplier: 1.0,
    );

    final result = await foodLoggingVM.logMeal(request);

    if (!result) {
      if (mounted) {
        final errorMsg = ref.read(foodLoggingViewModelProvider).errorMessage;
        ref.read(toastProvider).showError(
              'Failed to log meal: $errorMsg',
            );
      }
    } else {
      if (mounted) {
        ref.read(toastProvider).showSuccess('Meal logged successfully!');
        NavigationService.pushAndRemoveUntil(child: const BottomNavScreen());
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
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    return BlurryModalProgressHUD(
      inAsyncCall: foodLoggingState.isLoading,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: const Text(''),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display image from URL or fallback to default
                imageUrl != null && imageUrl!.isNotEmpty
                    ? Image.network(
                        imageUrl!,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            AppImages.chicken,
                            scale: 2,
                          );
                        },
                      )
                    : Image.asset(
                        AppImages.chicken,
                        scale: 2,
                      ),
                const SizedBox(height: 20),
                Text(
                  foodName,
                  style: const TextStyle(
                    fontFamily: AppFonts.lato,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    CalorieBadge(
                      text: '${calories.toStringAsFixed(0)} cal',
                    ),
                    const SizedBox(width: 15),
                    CalorieBadge(
                      text: '${totalWeight.toStringAsFixed(0)}g',
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  description,
                  style: const TextStyle(
                    fontFamily: AppFonts.lato,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 20),
                MacroProgressItem(
                  label: 'Protein',
                  currentValue: '${protein.toStringAsFixed(1)}g',
                  targetValue: '',
                  progress: getRelativeProgress(protein),
                ),
                const SizedBox(height: 20),
                MacroProgressItem(
                  label: 'Carbs',
                  currentValue: '${carbs.toStringAsFixed(1)}g',
                  targetValue: '',
                  progress: getRelativeProgress(carbs),
                ),
                const SizedBox(height: 20),
                MacroProgressItem(
                  label: 'Fat',
                  currentValue: '${fat.toStringAsFixed(1)}g',
                  targetValue: '',
                  progress: getRelativeProgress(fat),
                ),
                const SizedBox(height: 20),
                MacroProgressItem(
                  label: 'Fiber',
                  currentValue: '${fiber.toStringAsFixed(1)}g',
                  targetValue: '',
                  progress: getRelativeProgress(fiber),
                ),
                const SizedBox(height: 30),

                // _buildMealTypeSelector(),
                // const SizedBox(height: 30),

                widget.fromFavorite
                    ? CustomYafButton(
                        text: "Relog Food",
                        onPressed: _handleRelog,
                      )
                    : SizedBox.shrink(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
