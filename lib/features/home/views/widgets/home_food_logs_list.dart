import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/database/widgets/food_search_result_tile.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/views/food_log_detail.dart';
import 'package:diet_lenz/features/home/views/widgets/food_logged_preview.dart';
import 'package:diet_lenz/widgets/food_log_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:openapi/api.dart';

class HomeFoodLogsList extends ConsumerWidget {
  const HomeFoodLogsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    final recipes = foodLoggingState.userRecipes;

    if (foodLoggingState.isLoading && recipes == null) {
      return Column(
        children: List.generate(3, (index) => const FoodLogShimmer()),
      );
    }

    if (foodLoggingState.recipesError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            foodLoggingState.recipesError!,
            style: const TextStyle(color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (recipes == null || recipes.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Icon(Icons.hourglass_empty, size: 50),
              SizedBox(height: 15),
              Text(
                'No food logs yet. Start by scanning your first meal!',
                style: TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final displayRecipes = recipes.take(6).toList();
    return Column(
      children: displayRecipes.map(_buildFoodLogPreview).toList(),
    );
  }

  Widget _buildFoodLogPreview(RecipeResponseDto recipe) {
    if (recipe.imageUrl?.trim().isNotEmpty == true) {
      return FoodLoggedPreview(recipe: recipe);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: FoodSearchResultTile(
        food: _recipeToFoodAnalysis(recipe),
        onTap: () {
          NavigationService.push(
            child: FoodLogDetail(recipe: recipe),
          );
        },
      ),
    );
  }

  FoodAnalysisDto _recipeToFoodAnalysis(RecipeResponseDto recipe) {
    return FoodAnalysisDto(
      foodName: recipe.foodName,
      description: recipe.description,
      totalMacros: MacroNutrientsDto(
        calories: recipe.macros?.calories,
        protein: QuantityDto(
          value: recipe.macros?.proteinGrams,
          unit: 'g',
        ),
        carbs: QuantityDto(
          value: recipe.macros?.carbsGrams,
          unit: 'g',
        ),
        fat: QuantityDto(
          value: recipe.macros?.fatGrams,
          unit: 'g',
        ),
        fiber: QuantityDto(
          value: recipe.macros?.fiberGrams,
          unit: 'g',
        ),
      ),
    );
  }
}
