import 'package:openapi/api.dart';
import 'package:diet_lenz/constants/app_assets.dart';
import 'package:diet_lenz/constants/app_colors.dart';
import 'package:diet_lenz/constants/app_fonts.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/food_logging/controller/food_logging_viewmodel.dart';
import 'package:diet_lenz/features/home/views/food_log_detail.dart';
import 'package:diet_lenz/features/home/views/widgets/meal_log_result_tile.dart';
import 'package:diet_lenz/widgets/food_log_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FoodLogsScreen extends ConsumerStatefulWidget {
  const FoodLogsScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FoodLogsScreenState();
}

class _FoodLogsScreenState extends ConsumerState<FoodLogsScreen> {
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Fetch all recipes (unfiltered) and favorites on screen load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(foodLoggingViewModelProvider.notifier).getAllRecipes();
      ref.read(foodLoggingViewModelProvider.notifier).getFavorites();
    });
  }

  Future<void> _refreshRecipes() async {
    // Clear cached allRecipes so it refetches
    ref.read(foodLoggingViewModelProvider.notifier).clearAllRecipes();
    await ref.read(foodLoggingViewModelProvider.notifier).getAllRecipes();
  }

  Future<void> _refreshFavorites() async {
    await ref.read(foodLoggingViewModelProvider.notifier).getFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Food Logs'),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            SegmentedToggle(
              options: const ['All', 'Favourite'],
              selectedIndex: selectedIndex,
              onChanged: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            ),
            const SizedBox(height: 35),
            Expanded(
              child: _buildContentForSelectedTab(),
            ),
          ],
        ),
      ),
    );
  }

  // Build content based on selected toggle
  Widget _buildContentForSelectedTab() {
    final foodLoggingState = ref.watch(foodLoggingViewModelProvider);

    switch (selectedIndex) {
      case 0: // All
        if (foodLoggingState.isLoading && foodLoggingState.allRecipes == null) {
          // Show shimmer loading
          return SingleChildScrollView(
            child: Column(
              children: List.generate(3, (index) => const FoodLogShimmer()),
            ),
          );
        }

        if (foodLoggingState.allRecipesError != null &&
            foodLoggingState.allRecipes == null) {
          // Show error message
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                foodLoggingState.allRecipesError!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final recipes = foodLoggingState.allRecipes;

        if (recipes == null || recipes.isEmpty) {
          // Show empty state
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
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

        // Show all recipes
        return RefreshIndicator(
          onRefresh: _refreshRecipes,
          color: AppColors.primaryColor,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: recipes
                .map((mealLog) => MealLogResultTile(mealLog: mealLog))
                .toList(),
          ),
        );

      case 1: // Favourite
        if (foodLoggingState.isLoading && foodLoggingState.favorites == null) {
          // Show shimmer loading
          return Column(
            children: List.generate(3, (index) => const FoodLogShimmer()),
          );
        }

        if (foodLoggingState.favoritesError != null &&
            foodLoggingState.favorites == null) {
          // Show error message
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                foodLoggingState.favoritesError!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final favorites = foodLoggingState.favorites;

        if (favorites == null || favorites.isEmpty) {
          // Show empty state
          return Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * 0.25),
                  Icon(Icons.hourglass_empty, size: 50),
                  SizedBox(height: 15),
                  Text(
                    'No favorites yet. Tap the heart icon on any food to favorite it!',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          );
        }

        // Show favorite recipes
        return RefreshIndicator(
          onRefresh: _refreshFavorites,
          color: AppColors.primaryColor,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: favorites
                .map((favorite) => FavouriteFood(favorite: favorite))
                .toList(),
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}

class FavouriteFood extends StatelessWidget {
  final FavoriteRecipeResponseDto favorite;

  const FavouriteFood({
    super.key,
    required this.favorite,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        NavigationService.push(
          child: FoodLogDetail(
            favorite: favorite,
            fromFavorite: true,
          ),
        );
      },
      child: Column(
        children: [
          Row(
            children: [
              // Display image from URL or fallback to default
              favorite.imageUrl != null && favorite.imageUrl!.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        favorite.imageUrl!,
                        height: 80,
                        width: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            AppImages.salad,
                            scale: 2,
                            height: 80,
                            width: 80,
                          );
                        },
                      ),
                    )
                  : SizedBox.shrink(),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favorite.foodName ?? "Unknown Food",
                      style: const TextStyle(
                        fontSize: 16,
                        letterSpacing: 0,
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${favorite.macros?.calories?.toStringAsFixed(0) ?? "0"} cal',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryColor,
                size: 20,
              ),
              const SizedBox(width: 10),
            ],
          ),
          const SizedBox(height: 35)
        ],
      ),
    );
  }
}

// Reusable Segmented Toggle Widget
class SegmentedToggle extends StatelessWidget {
  final List<String> options;
  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final Color? selectedColor;
  final Color? unselectedColor;
  final Color? selectedTextColor;
  final Color? unselectedTextColor;
  final double? height;

  const SegmentedToggle({
    super.key,
    required this.options,
    required this.selectedIndex,
    required this.onChanged,
    this.selectedColor,
    this.unselectedColor,
    this.selectedTextColor,
    this.unselectedTextColor,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height ?? 49,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: unselectedColor ?? Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: List.generate(
          options.length,
          (index) => Expanded(
            child: GestureDetector(
              onTap: () => onChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                height: 37,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: selectedIndex == index
                      ? (selectedColor ?? AppColors.primaryColor)
                      : Colors.transparent,
                ),
                child: Center(
                  child: Text(
                    options[index],
                    style: TextStyle(
                      color: selectedIndex == index
                          ? (selectedTextColor ?? Colors.white)
                          : (unselectedTextColor ?? Colors.black),
                      fontWeight: FontWeight.w400,
                      fontSize: 17,
                      fontFamily: AppFonts.workSans,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
