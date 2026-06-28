import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/views/widgets/meal_log_result_tile.dart';
import 'package:diet_lenz/widgets/food_log_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeFoodLogsList extends ConsumerWidget {
  const HomeFoodLogsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);
    final recipes = foodLoggingState.userRecipes;

    if (foodLoggingState.isLoading) {
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
      children: displayRecipes
          .map((mealLog) => MealLogResultTile(mealLog: mealLog))
          .toList(),
    );
  }
}
