import 'package:openapi/api.dart';
import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' show MultipartFile;

/// Recipe state to track loading, data, and error states
class RecipeState {
  final bool isLoading;
  final FoodAnalysisDto? analyzedRecipe;
  final List<SuggestedFoodAnalysis>? suggestedRecipes;
  final List<String>? dietaryPreferences;
  final List<String>? goals;
  final List<String>? macroTargets;
  final List<FoodAnalysisDto>? searchResults;
  final String searchQuery;
  final String? errorMessage;

  RecipeState({
    this.isLoading = false,
    this.analyzedRecipe,
    this.suggestedRecipes,
    this.dietaryPreferences,
    this.goals,
    this.macroTargets,
    this.searchResults,
    this.searchQuery = '',
    this.errorMessage,
  });

  RecipeState copyWith({
    bool? isLoading,
    FoodAnalysisDto? analyzedRecipe,
    List<SuggestedFoodAnalysis>? suggestedRecipes,
    List<String>? dietaryPreferences,
    List<String>? goals,
    List<String>? macroTargets,
    List<FoodAnalysisDto>? searchResults,
    String? searchQuery,
    String? errorMessage,
  }) {
    return RecipeState(
      isLoading: isLoading ?? this.isLoading,
      analyzedRecipe: analyzedRecipe ?? this.analyzedRecipe,
      suggestedRecipes: suggestedRecipes ?? this.suggestedRecipes,
      dietaryPreferences: dietaryPreferences ?? this.dietaryPreferences,
      goals: goals ?? this.goals,
      macroTargets: macroTargets ?? this.macroTargets,
      searchResults: searchResults ?? this.searchResults,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  RecipeState clearError() {
    return copyWith(errorMessage: '');
  }
}

/// Recipe ViewModel provider
final recipeViewModelProvider =
    StateNotifierProvider<RecipeViewModel, RecipeState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return RecipeViewModel(apiService);
});

/// Recipe ViewModel with all recipe-related methods
class RecipeViewModel extends StateNotifier<RecipeState> {
  RecipeViewModel(this._apiService) : super(RecipeState());

  final ApiService _apiService;

  /// Analyze a recipe from an image
  /// Returns true if successful, false otherwise
  Future<bool> analyzeRecipe(MultipartFile image) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, analyzedRecipe: null);

    try {
      final response = await _apiService.recipeApi.analyzeRecipe(image);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          analyzedRecipe: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to analyze recipe',
        );
        return false;
      }
    } on ApiException catch (e) {
      debugPrint(e.toString());
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

  /// Analyze a nutrition label from an image
  /// Returns true if successful, false otherwise
  Future<bool> analyzeNutritionLabel(MultipartFile image) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, analyzedRecipe: null);

    try {
      final response = await _apiService.recipeApi.analyzeNutritionLabel(image);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          analyzedRecipe: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to analyze nutrition label',
        );
        return false;
      }
    } on ApiException catch (e) {
      debugPrint(e.toString());
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

  /// Suggest and analyze a recipe from an image
  /// Returns true if successful, false otherwise
  Future<bool> suggestAndAnalyze(MultipartFile image) async {
    state = state.copyWith(
        isLoading: true,
        errorMessage: null,
        analyzedRecipe: null,
        suggestedRecipes: null);

    try {
      final response = await _apiService.recipeApi.suggestAndAnalyze(image);

      if (response != null && response.isNotEmpty) {
        state = state.copyWith(
          isLoading: false,
          suggestedRecipes: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'No recipes suggested',
        );
        return false;
      }
    } on ApiException catch (e) {
      debugPrint(e.toString());
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

  /// Analyze a product by barcode
  /// Returns true if successful, false otherwise
  Future<bool> analyzeByBarcode(String barcode) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, analyzedRecipe: null);

    try {
      final response = await _apiService.recipeApi.analyzeByBarcode(barcode);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          analyzedRecipe: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to analyze barcode',
        );
        return false;
      }
    } on ApiException catch (e) {
      debugPrint(e.toString());
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

  /// Get dietary preferences
  Future<bool> getDietaryPreferences() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.recipeApi.getDietaryPreferences();

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          dietaryPreferences: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to get dietary preferences',
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

  /// Get goals
  Future<bool> getGoals() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.recipeApi.getGoals();

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          goals: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to get goals',
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

  /// Get macro targets
  Future<bool> getMacroTargets() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final response = await _apiService.recipeApi.getMacroTargets();

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          macroTargets: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to get macro targets',
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

  /// Re-analyze a recipe with an updated FoodAnalysisDto
  /// Returns true if successful, false otherwise
  Future<bool> reAnalyzeRecipe(FoodAnalysisDto foodAnalysis) async {
    state = state.copyWith(
        isLoading: true, errorMessage: null, analyzedRecipe: null);

    try {
      final response =
          await _apiService.recipeApi.reAnalyzeRecipe(foodAnalysis);

      if (response != null) {
        state = state.copyWith(
          isLoading: false,
          analyzedRecipe: response,
          errorMessage: null,
        );
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to re-analyze recipe',
        );
        return false;
      }
    } on ApiException catch (e) {
      debugPrint(e.toString());
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

  /// Search foods from the recipe database.
  /// Returns true if the request completed, false if it failed.
  Future<bool> searchFood(String query) async {
    final trimmedQuery = query.trim();

    if (trimmedQuery.isEmpty) {
      state = state.copyWith(
        isLoading: false,
        searchResults: [],
        searchQuery: '',
        errorMessage: null,
      );
      return true;
    }

    state = state.copyWith(
      isLoading: true,
      searchResults: [],
      searchQuery: trimmedQuery,
      errorMessage: null,
    );

    try {
      final response = await _apiService.recipeApi.searchFood(trimmedQuery);
      state = state.copyWith(
        isLoading: false,
        searchResults: response ?? [],
        searchQuery: trimmedQuery,
        errorMessage: null,
      );
      return true;
    } on ApiException catch (e) {
      state = state.copyWith(
        isLoading: false,
        searchResults: [],
        searchQuery: trimmedQuery,
        errorMessage: _parseApiError(e),
      );
      return false;
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        searchResults: [],
        searchQuery: trimmedQuery,
        errorMessage: 'An unexpected error occurred',
      );
      return false;
    }
  }

  void clearSearchResults() {
    state = state.copyWith(
      isLoading: false,
      searchResults: [],
      searchQuery: '',
      errorMessage: null,
    );
  }

  /// Clear the analyzed recipe
  void clearAnalyzedRecipe() {
    state = state.copyWith(analyzedRecipe: null);
  }

  /// Clear suggested recipes
  void clearSuggestedRecipes() {
    state = state.copyWith(suggestedRecipes: null);
  }

  /// Clear error message
  void clearError() {
    state = state.clearError();
  }

  /// Parse API error into user-friendly message
  String _parseApiError(ApiException error) {
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
        return error.message ?? 'An error occurred';
    }
  }
}
