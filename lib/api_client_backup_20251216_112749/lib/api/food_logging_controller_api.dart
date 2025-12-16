//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class FoodLoggingControllerApi {
  FoodLoggingControllerApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'GET /api/v1/food/streaks' operation and returns the [Response].
  Future<Response> getCurrentStreakWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/streaks';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<StreakInfoDto?> getCurrentStreak() async {
    final response = await getCurrentStreakWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'StreakInfoDto',) as StreakInfoDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/food/dashboard' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [DateTime] date:
  Future<Response> getDashboardWithHttpInfo({ DateTime? date, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/dashboard';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (date != null) {
      queryParams.addAll(_queryParams('', 'date', date));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [DateTime] date:
  Future<DashboardResponseDto?> getDashboard({ DateTime? date, }) async {
    final response = await getDashboardWithHttpInfo( date: date, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'DashboardResponseDto',) as DashboardResponseDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/food/favorites' operation and returns the [Response].
  Future<Response> getFavoritesWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/favorites';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<List<FavoriteRecipeResponseDto>?> getFavorites() async {
    final response = await getFavoritesWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<FavoriteRecipeResponseDto>') as List)
        .cast<FavoriteRecipeResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/food/recipes/ingredients/stats' operation and returns the [Response].
  Future<Response> getIngredientStatsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/recipes/ingredients/stats';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<Map<String, int>?> getIngredientStats() async {
    final response = await getIngredientStatsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return Map<String, int>.from(await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Map<String, int>'),);

    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/food/recipes/{recipeId}' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] recipeId (required):
  Future<Response> getRecipeByIdWithHttpInfo(String recipeId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/recipes/{recipeId}'
      .replaceAll('{recipeId}', recipeId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] recipeId (required):
  Future<RecipeResponseDto?> getRecipeById(String recipeId,) async {
    final response = await getRecipeByIdWithHttpInfo(recipeId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'RecipeResponseDto',) as RecipeResponseDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/food/recipes/recommendations' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] macroTarget:
  ///
  /// * [int] limit:
  Future<Response> getRecommendationsWithHttpInfo({ String? macroTarget, int? limit, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/recipes/recommendations';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (macroTarget != null) {
      queryParams.addAll(_queryParams('', 'macroTarget', macroTarget));
    }
    if (limit != null) {
      queryParams.addAll(_queryParams('', 'limit', limit));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] macroTarget:
  ///
  /// * [int] limit:
  Future<List<RecipeResponseDto>?> getRecommendations({ String? macroTarget, int? limit, }) async {
    final response = await getRecommendationsWithHttpInfo( macroTarget: macroTarget, limit: limit, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<RecipeResponseDto>') as List)
        .cast<RecipeResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/food/recipes' operation and returns the [Response].
  Future<Response> getUserRecipesWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/recipes';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  Future<List<RecipeResponseDto>?> getUserRecipes() async {
    final response = await getUserRecipesWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<RecipeResponseDto>') as List)
        .cast<RecipeResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/food/trends/weekly' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [DateTime] startDate:
  Future<Response> getWeeklyTrendWithHttpInfo({ DateTime? startDate, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/trends/weekly';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (startDate != null) {
      queryParams.addAll(_queryParams('', 'startDate', startDate));
    }

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [DateTime] startDate:
  Future<WeeklyTrendDto?> getWeeklyTrend({ DateTime? startDate, }) async {
    final response = await getWeeklyTrendWithHttpInfo( startDate: startDate, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WeeklyTrendDto',) as WeeklyTrendDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/food/log-meal' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [LogMealRequestDto] logMealRequestDto (required):
  Future<Response> logMealWithHttpInfo(LogMealRequestDto logMealRequestDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/log-meal';

    // ignore: prefer_final_locals
    Object? postBody = logMealRequestDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [LogMealRequestDto] logMealRequestDto (required):
  Future<MealLogResponseDto?> logMeal(LogMealRequestDto logMealRequestDto,) async {
    final response = await logMealWithHttpInfo(logMealRequestDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MealLogResponseDto',) as MealLogResponseDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/food/recipes/search/by-ingredient' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] ingredient (required):
  Future<Response> searchByIngredientWithHttpInfo(String ingredient,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/recipes/search/by-ingredient';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'ingredient', ingredient));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] ingredient (required):
  Future<List<RecipeResponseDto>?> searchByIngredient(String ingredient,) async {
    final response = await searchByIngredientWithHttpInfo(ingredient,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<RecipeResponseDto>') as List)
        .cast<RecipeResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/food/recipes/search' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] query (required):
  Future<Response> searchRecipesWithHttpInfo(String query,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/recipes/search';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'query', query));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'GET',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] query (required):
  Future<List<RecipeResponseDto>?> searchRecipes(String query,) async {
    final response = await searchRecipesWithHttpInfo(query,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<RecipeResponseDto>') as List)
        .cast<RecipeResponseDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/food/favorites/{recipeId}/toggle' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] recipeId (required):
  Future<Response> toggleFavoriteWithHttpInfo(String recipeId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/food/favorites/{recipeId}/toggle'
      .replaceAll('{recipeId}', recipeId);

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'POST',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] recipeId (required):
  Future<void> toggleFavorite(String recipeId,) async {
    final response = await toggleFavoriteWithHttpInfo(recipeId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }
}
