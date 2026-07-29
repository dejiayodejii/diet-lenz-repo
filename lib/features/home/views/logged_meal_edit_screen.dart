import 'package:diet_lenz/features/camera/analyse_result.dart';
import 'package:diet_lenz/features/camera/database_result.dart';
import 'package:diet_lenz/features/camera/suggest_detail.dart';
import 'package:diet_lenz/features/database/views/manual_log_screen.dart';
import 'package:flutter/material.dart';
import 'package:openapi/api.dart';

Widget? buildLoggedMealEditScreen(MealLogResponseDto loggedMeal) {
  final analysis = loggedMeal.foodAnalysis ?? _analysisFrom(loggedMeal);
  final source = loggedMeal.foodSource;
  final hasImage = loggedMeal.imageUrl?.trim().isNotEmpty == true ||
      analysis.imageBase64?.trim().isNotEmpty == true;

  if (source == MealLogResponseDtoFoodSourceEnum.MANUAL) {
    return ManualLogScreen(loggedMeal: loggedMeal);
  }
  if (source == MealLogResponseDtoFoodSourceEnum.SEARCH) {
    return DatabaseResultDetail(analysis, loggedMeal: loggedMeal);
  }
  if (source == MealLogResponseDtoFoodSourceEnum.AI_IMAGE && !hasImage) {
    return SuggestMealDetailScreen(
      suggestion: SuggestedFoodAnalysis(
        foodName: analysis.foodName,
        description: analysis.description,
        totalMacros: analysis.totalMacros,
      ),
      loggedMeal: loggedMeal,
    );
  }
  if (source == MealLogResponseDtoFoodSourceEnum.AI_IMAGE) {
    return AnalyseResultDetail(
      analysis,
      loggedMeal: loggedMeal,
      headerImageUrl: loggedMeal.imageUrl,
    );
  }
  return null;
}

FoodAnalysisDto _analysisFrom(MealLogResponseDto meal) {
  final macros = meal.consumedMacros;
  return FoodAnalysisDto(
    foodName: meal.foodName,
    description: meal.notes,
    totalMacros: MacroNutrientsDto(
      calories: macros?.calories,
      protein: QuantityDto(value: macros?.proteinGrams, unit: 'g'),
      carbs: QuantityDto(value: macros?.carbsGrams, unit: 'g'),
      fat: QuantityDto(value: macros?.fatGrams, unit: 'g'),
      fiber: QuantityDto(value: macros?.fiberGrams, unit: 'g'),
    ),
  );
}
