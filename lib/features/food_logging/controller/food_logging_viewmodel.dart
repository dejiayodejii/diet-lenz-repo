import 'dart:convert';
import 'dart:developer';

import 'package:openapi/api.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Food Logging state to track loading, data, and error states
class FoodLoggingState {
  final bool isLoading;
  final DashboardResponseDto? dashboard;
  final StreakInfoDto? streak;
  final WeeklyTrendDto? weeklyTrend;
  final List<RecipeResponseDto>? userRecipes;
  final List<RecipeResponseDto>? allRecipes;
  final List<RecipeResponseDto>? searchResults;
  final List<RecipeResponseDto>? recommendations;
  final List<FavoriteRecipeResponseDto>? favorites;
  final RecipeResponseDto? selectedRecipe;
  final MealLogResponseDto? loggedMeal;
  final Map<String, int>? ingredientStats;
  final String? errorMessage;
  final String? recipesError;
  final String? allRecipesError;
  final String? favoritesError;

  FoodLoggingState({
    this.isLoading = false,
    this.dashboard,
    this.streak,
    this.weeklyTrend,
    this.userRecipes,
    this.allRecipes,
    this.searchResults,
    this.recommendations,
    this.favorites,
    this.selectedRecipe,
    this.loggedMeal,
    this.ingredientStats,
    this.errorMessage,
    this.recipesError,
    this.allRecipesError,
    this.favoritesError,
  });

  FoodLoggingState copyWith({
    bool? isLoading,
    DashboardResponseDto? dashboard,
    StreakInfoDto? streak,
    WeeklyTrendDto? weeklyTrend,
    List<RecipeResponseDto>? userRecipes,
    List<RecipeResponseDto>? allRecipes,
    List<RecipeResponseDto>? searchResults,
    List<RecipeResponseDto>? recommendations,
    List<FavoriteRecipeResponseDto>? favorites,
    RecipeResponseDto? selectedRecipe,
    MealLogResponseDto? loggedMeal,
    Map<String, int>? ingredientStats,
    String? errorMessage,
    String? recipesError,
    String? allRecipesError,
    String? favoritesError,
  }) {
    return FoodLoggingState(
      isLoading: isLoading ?? this.isLoading,
      dashboard: dashboard ?? this.dashboard,
      streak: streak ?? this.streak,
      weeklyTrend: weeklyTrend ?? this.weeklyTrend,
      userRecipes: userRecipes ?? this.userRecipes,
      allRecipes: allRecipes ?? this.allRecipes,
      searchResults: searchResults ?? this.searchResults,
      recommendations: recommendations ?? this.recommendations,
      favorites: favorites ?? this.favorites,
      selectedRecipe: selectedRecipe ?? this.selectedRecipe,
      loggedMeal: loggedMeal ?? this.loggedMeal,
      ingredientStats: ingredientStats ?? this.ingredientStats,
      errorMessage: errorMessage,
      recipesError: recipesError,
      allRecipesError: allRecipesError,
      favoritesError: favoritesError,
    );
  }

  FoodLoggingState clearError() {
    return copyWith(errorMessage: '');
  }
}

/// Food Logging ViewModel provider
final foodLoggingViewModelProvider =
    StateNotifierProvider<FoodLoggingViewModel, FoodLoggingState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return FoodLoggingViewModel(apiService, ref);
});

/// Food Logging ViewModel with all food logging methods
class FoodLoggingViewModel extends StateNotifier<FoodLoggingState> {
  FoodLoggingViewModel(this._apiService, this._ref) : super(FoodLoggingState());

  final ApiService _apiService;
  final Ref _ref;

  /// In-memory caches keyed by date string (yyyy-MM-dd)
  final Map<String, List<RecipeResponseDto>> _recipesCache = {};
  final Map<String, DashboardResponseDto> _dashboardCache = {};

  /// Helper to format a date key for caching
  String _dateKey(DateTime? date) {
    if (date == null) return 'all';
    return '${date.year.toString().padLeft(4, '0')}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  /// Invalidate cache for a specific date (e.g. after logging a meal)
  void invalidateCache({DateTime? date}) {
    if (date != null) {
      final key = _dateKey(date);
      _recipesCache.remove(key);
      _dashboardCache.remove(key);
    } else {
      _recipesCache.clear();
      _dashboardCache.clear();
    }
  }

  /// Get dashboard data for a specific date
  Future<bool> getDashboard({DateTime? date, bool refresh = false}) async {
    final key = _dateKey(date);

    // Serve from cache if available (no loading state)
    if (!refresh && _dashboardCache.containsKey(key)) {
      state = state.copyWith(
        isLoading: false,
        dashboard: _dashboardCache[key],
        errorMessage: null,
      );
      return true;
    }

    state =
        state.copyWith(isLoading: true, dashboard: null, errorMessage: null);

    try {
      final response =
          await _apiService.foodLoggingApi.getDashboard(date: date);

      if (response != null) {
        _dashboardCache[key] = response;
        state = state.copyWith(
          isLoading: false,
          dashboard: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load dashboard',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Get current streak information
  Future<bool> getCurrentStreak() async {
    state = state.copyWith(
        isLoading: state.streak != null ? false : true, errorMessage: null);

    try {
      final response = await _apiService.foodLoggingApi.getCurrentStreak();

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          streak: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load streak',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Get weekly trend data
  Future<bool> getWeeklyTrend({DateTime? startDate}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response =
          await _apiService.foodLoggingApi.getWeeklyTrend(startDate: startDate);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          weeklyTrend: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load weekly trend',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Log a meal
  Future<bool> logMeal(LogMealRequestDto mealRequest) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.foodLoggingApi.logMeal(mealRequest);

      if (response != null) {
        invalidateCache(date: mealRequest.loggedDate ?? DateTime.now());
        _ref
            .read(userProfileViewModelProvider.notifier)
            .invalidateFoodDependentProgressCaches();

        state = state.copyWith(
          isLoading: false,
          loggedMeal: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to log meal',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Edit a logged meal
  Future<bool> editMealLog({
    required String id,
    required LogMealRequestDto mealRequest,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response =
          await _apiService.foodLoggingApi.editMealLog(id, mealRequest);

      invalidateCache(date: mealRequest.loggedDate ?? DateTime.now());
      _ref
          .read(userProfileViewModelProvider.notifier)
          .invalidateFoodDependentProgressCaches();

      state = state.copyWith(
        isLoading: false,
        loggedMeal: response,
        errorMessage: null,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Delete a logged meal
  Future<bool> deleteMealLog({
    required String id,
    DateTime? loggedDate,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      await _apiService.foodLoggingApi.deleteMealLog(id);

      invalidateCache(date: loggedDate ?? DateTime.now());
      _ref
          .read(userProfileViewModelProvider.notifier)
          .invalidateFoodDependentProgressCaches();

      state = state.copyWith(
        isLoading: false,
        errorMessage: null,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Get all user recipes
  Future<bool> getUserRecipes({DateTime? date, bool refresh = false}) async {
    final key = _dateKey(date);

    // Serve from cache if available (no loading state)
    if (!refresh && _recipesCache.containsKey(key)) {
      state = state.copyWith(
        isLoading: false,
        userRecipes: _recipesCache[key],
        recipesError: null,
      );
      return true;
    }

    state =
        state.copyWith(isLoading: true, userRecipes: null, recipesError: null);

    try {
      final response =
          await _apiService.foodLoggingApi.getUserRecipes(date: date);

      if (response != null) {
        _recipesCache[key] = response;
        state = state.copyWith(
          isLoading: false,
          userRecipes: response,
          recipesError: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          recipesError: 'Failed to load recipes',
        );
        return false;
      }
    } on ApiException catch (e) {
      print(e.toString());
      state = state.copyWith(
        isLoading: false,
        recipesError: _parseApiError(e),
      );
      return false;
    } catch (e) {
      print(e.toString());
      state = state.copyWith(
        isLoading: false,
        recipesError: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Get all user recipes (no date filter) — used by "See All" screen
  Future<bool> getAllRecipes() async {
    // Don't refetch if we already have all recipes loaded
    if (state.allRecipes != null && state.allRecipes!.isNotEmpty) {
      return true;
    }

    state = state.copyWith(isLoading: true, allRecipesError: null);

    try {
      final response = await _apiService.foodLoggingApi.getUserRecipes();

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          allRecipes: response,
          allRecipesError: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          allRecipesError: 'Failed to load recipes',
        );
        return false;
      }
    } on ApiException catch (e) {
      print(e.toString());
      state = state.copyWith(
        isLoading: false,
        allRecipesError: _parseApiError(e),
      );
      return false;
    } catch (e) {
      print(e.toString());
      state = state.copyWith(
        isLoading: false,
        allRecipesError: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Get recipe by ID
  Future<bool> getRecipeById(String recipeId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.foodLoggingApi.getRecipeById(recipeId);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          selectedRecipe: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Recipe not found',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Search recipes by query
  Future<bool> searchRecipes(String query) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response =
          await _apiService.foodLoggingApi.searchByIngredient(query);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          searchResults: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No recipes found',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Search recipes by ingredient
  Future<bool> searchByIngredient(String ingredient) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response =
          await _apiService.foodLoggingApi.searchByIngredient(ingredient);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          searchResults: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No recipes found',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Get recipe recommendations
  Future<bool> getRecommendations({String? macroTarget, int? limit}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.foodLoggingApi.getRecommendations(
        macroTarget: macroTarget,
        limit: limit,
      );

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          recommendations: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load recommendations',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Get favorite recipes
  Future<bool> getFavorites() async {
    state = state.copyWith(
        isLoading: state.favorites != null && state.favorites!.isNotEmpty
            ? false
            : true,
        favoritesError: null);

    try {
      final response = await _apiService.foodLoggingApi.getFavorites();

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          favorites: response,
          favoritesError: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          favoritesError: 'Failed to load favorites',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        favoritesError: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        favoritesError: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Toggle favorite status for a recipe
  Future<bool> toggleFavorite(String recipeId) async {
    try {
      await _apiService.foodLoggingApi.toggleFavorite(recipeId);

      // Refresh favorites list after toggling
      await getFavorites();

      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        errorMessage: 'Failed to update favorite',
      );
      return false;
    }
  }

  /// Toggle favorite status locally for a recipe in userRecipes, allRecipes and favorites
  Future<bool> toggleFavoriteLocally(String recipeId) async {
    RecipeResponseDto? targetRecipe;

    // Find the recipe in userRecipes first, then fall back to allRecipes
    if (state.userRecipes != null) {
      final found = state.userRecipes!.firstWhere(
        (recipe) => recipe.id == recipeId,
        orElse: () => RecipeResponseDto(),
      );
      if (found.id != null) targetRecipe = found;
    }
    if (targetRecipe == null && state.allRecipes != null) {
      final found = state.allRecipes!.firstWhere(
        (recipe) => recipe.id == recipeId,
        orElse: () => RecipeResponseDto(),
      );
      if (found.id != null) targetRecipe = found;
    }
    log("Found recipe $recipeId: ${targetRecipe?.foodName}");

    RecipeResponseDto _toggled(RecipeResponseDto recipe) => RecipeResponseDto(
          id: recipe.id,
          foodName: recipe.foodName,
          description: recipe.description,
          macros: recipe.macros,
          imageUrl: recipe.imageUrl,
          usageCount: recipe.usageCount,
          isFavorite: !(recipe.isFavorite ?? false),
          createdAt: recipe.createdAt,
        );

    // Optimistically update userRecipes
    List<RecipeResponseDto>? updatedUserRecipes;
    if (state.userRecipes != null) {
      updatedUserRecipes = state.userRecipes!
          .map((r) => r.id == recipeId ? _toggled(r) : r)
          .toList();
    }

    // Optimistically update allRecipes
    List<RecipeResponseDto>? updatedAllRecipes;
    if (state.allRecipes != null) {
      updatedAllRecipes = state.allRecipes!
          .map((r) => r.id == recipeId ? _toggled(r) : r)
          .toList();
    }

    // Optimistically update favorites list
    List<FavoriteRecipeResponseDto>? updatedFavorites = state.favorites;
    final isFavorite = targetRecipe?.isFavorite ?? false;

    if (!isFavorite && targetRecipe?.id != null) {
      // Adding to favorites
      final newFavorite = FavoriteRecipeResponseDto(
        recipeId: targetRecipe!.id,
        foodName: targetRecipe.foodName,
        description: targetRecipe.description,
        macros: targetRecipe.macros,
        imageUrl: targetRecipe.imageUrl,
        usageCount: targetRecipe.usageCount,
        favoritedAt: DateTime.now(),
      );
      updatedFavorites = [...?state.favorites, newFavorite];
    } else {
      // Removing from favorites
      updatedFavorites =
          state.favorites?.where((fav) => fav.recipeId != recipeId).toList();
    }

    state = state.copyWith(
      userRecipes: updatedUserRecipes,
      allRecipes: updatedAllRecipes,
      favorites: updatedFavorites,
    );

    // Call API in background
    try {
      await _apiService.foodLoggingApi.toggleFavorite(recipeId);
      return true;
    } catch (e) {
      // Revert all updates on error
      List<RecipeResponseDto>? revertedUserRecipes;
      if (state.userRecipes != null) {
        revertedUserRecipes = state.userRecipes!
            .map((r) => r.id == recipeId ? _toggled(r) : r)
            .toList();
      }

      List<RecipeResponseDto>? revertedAllRecipes;
      if (state.allRecipes != null) {
        revertedAllRecipes = state.allRecipes!
            .map((r) => r.id == recipeId ? _toggled(r) : r)
            .toList();
      }

      // Revert favorites list
      List<FavoriteRecipeResponseDto>? revertedFavorites = state.favorites;
      if (isFavorite) {
        // Was removing, add it back
        final newFavorite = FavoriteRecipeResponseDto(
          recipeId: targetRecipe!.id,
          foodName: targetRecipe.foodName,
          description: targetRecipe.description,
          macros: targetRecipe.macros,
          imageUrl: targetRecipe.imageUrl,
          usageCount: targetRecipe.usageCount,
          favoritedAt: DateTime.now(),
        );
        revertedFavorites = [...?state.favorites, newFavorite];
      } else {
        // Was adding, remove it
        revertedFavorites =
            state.favorites?.where((fav) => fav.recipeId != recipeId).toList();
      }

      state = state.copyWith(
        userRecipes: revertedUserRecipes,
        allRecipes: revertedAllRecipes,
        favorites: revertedFavorites,
      );
      return false;
    }
  }

  /// Get ingredient statistics
  Future<bool> getIngredientStats() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.foodLoggingApi.getIngredientStats();

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          ingredientStats: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load ingredient stats',
        );
        return false;
      }
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  /// Clear search results
  void clearSearchResults() {
    state = state.copyWith(searchResults: []);
  }

  /// Clear all recipes (used before refreshing See All screen)
  void clearAllRecipes() {
    state = state.copyWith(allRecipes: []);
  }

  /// Clear selected recipe
  void clearSelectedRecipe() {
    state = state.copyWith(selectedRecipe: null);
  }

  /// Clear logged meal
  void clearLoggedMeal() {
    state = state.copyWith(loggedMeal: null);
  }

  /// Clear error message
  void clearError() {
    state = state.clearError();
  }

  /// Parse API error into user-friendly message
  String _parseApiError(ApiException error) {
    final message = error.message;
    if (message != null && message.trim().isNotEmpty) {
      try {
        final decoded = jsonDecode(message);
        if (decoded is Map<String, dynamic>) {
          final apiMessage = decoded['message'];
          if (apiMessage is String && apiMessage.trim().isNotEmpty) {
            return apiMessage;
          }
        }
      } catch (_) {
        return message;
      }
    }

    switch (error.code) {
      case 400:
        return 'Invalid request. Please check your input.';
      case 401:
        return 'Unauthorized. Please log in again.';
      case 403:
        return 'Access denied.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return message ?? 'An error occurred';
    }
  }
}
