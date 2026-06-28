import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/database/widgets/food_search_result_tile.dart';
import 'package:diet_lenz/features/home/views/food_log_detail.dart';
import 'package:diet_lenz/features/home/views/widgets/food_logged_preview.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

class MealLogResultTile extends StatelessWidget {
  const MealLogResultTile({
    super.key,
    required this.mealLog,
  });

  final MealLogResponseDto mealLog;

  @override
  Widget build(BuildContext context) {
    if (mealLog.imageUrl?.trim().isNotEmpty == true) {
      return FoodLoggedPreview(loggedMeal: mealLog);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: FoodSearchResultTile(
        food: _mealLogToFoodAnalysis(mealLog),
        onTap: () {
          NavigationService.push(
            child: FoodLogDetail(loggedMeal: mealLog),
          );
        },
      ),
    );
  }

  FoodAnalysisDto _mealLogToFoodAnalysis(MealLogResponseDto mealLog) {
    final macros = mealLog.consumedMacros;

    return FoodAnalysisDto(
      foodName: mealLog.foodName,
      description: mealLog.notes,
      totalMacros: MacroNutrientsDto(
        calories: macros?.calories,
        protein: QuantityDto(
          value: macros?.proteinGrams,
          unit: 'g',
        ),
        carbs: QuantityDto(
          value: macros?.carbsGrams,
          unit: 'g',
        ),
        fat: QuantityDto(
          value: macros?.fatGrams,
          unit: 'g',
        ),
        fiber: QuantityDto(
          value: macros?.fiberGrams,
          unit: 'g',
        ),
      ),
    );
  }
}
