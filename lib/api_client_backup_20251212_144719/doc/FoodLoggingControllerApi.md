# diet_lenz_api.api.FoodLoggingControllerApi

## Load the API package
```dart
import 'package:diet_lenz_api/api.dart';
```

All URIs are relative to *https://diet-lenz-api.onrender.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getCurrentStreak**](FoodLoggingControllerApi.md#getcurrentstreak) | **GET** /api/v1/food/streaks | 
[**getDashboard**](FoodLoggingControllerApi.md#getdashboard) | **GET** /api/v1/food/dashboard | 
[**getFavorites**](FoodLoggingControllerApi.md#getfavorites) | **GET** /api/v1/food/favorites | 
[**getIngredientStats**](FoodLoggingControllerApi.md#getingredientstats) | **GET** /api/v1/food/recipes/ingredients/stats | 
[**getRecipeById**](FoodLoggingControllerApi.md#getrecipebyid) | **GET** /api/v1/food/recipes/{recipeId} | 
[**getRecommendations**](FoodLoggingControllerApi.md#getrecommendations) | **GET** /api/v1/food/recipes/recommendations | 
[**getUserRecipes**](FoodLoggingControllerApi.md#getuserrecipes) | **GET** /api/v1/food/recipes | 
[**getWeeklyTrend**](FoodLoggingControllerApi.md#getweeklytrend) | **GET** /api/v1/food/trends/weekly | 
[**logMeal**](FoodLoggingControllerApi.md#logmeal) | **POST** /api/v1/food/log-meal | 
[**searchByIngredient**](FoodLoggingControllerApi.md#searchbyingredient) | **GET** /api/v1/food/recipes/search/by-ingredient | 
[**searchRecipes**](FoodLoggingControllerApi.md#searchrecipes) | **GET** /api/v1/food/recipes/search | 
[**toggleFavorite**](FoodLoggingControllerApi.md#togglefavorite) | **POST** /api/v1/food/favorites/{recipeId}/toggle | 


# **getCurrentStreak**
> StreakInfoDto getCurrentStreak()



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();

try {
    final result = api_instance.getCurrentStreak();
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->getCurrentStreak: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**StreakInfoDto**](StreakInfoDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDashboard**
> DashboardResponseDto getDashboard(date)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();
final date = 2013-10-20; // DateTime | 

try {
    final result = api_instance.getDashboard(date);
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->getDashboard: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **date** | **DateTime**|  | [optional] 

### Return type

[**DashboardResponseDto**](DashboardResponseDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getFavorites**
> List<FavoriteRecipeResponseDto> getFavorites()



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();

try {
    final result = api_instance.getFavorites();
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->getFavorites: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<FavoriteRecipeResponseDto>**](FavoriteRecipeResponseDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getIngredientStats**
> Map<String, int> getIngredientStats()



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();

try {
    final result = api_instance.getIngredientStats();
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->getIngredientStats: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**Map<String, int>**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRecipeById**
> RecipeResponseDto getRecipeById(recipeId)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();
final recipeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.getRecipeById(recipeId);
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->getRecipeById: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **recipeId** | **String**|  | 

### Return type

[**RecipeResponseDto**](RecipeResponseDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getRecommendations**
> List<RecipeResponseDto> getRecommendations(macroTarget, limit)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();
final macroTarget = macroTarget_example; // String | 
final limit = 56; // int | 

try {
    final result = api_instance.getRecommendations(macroTarget, limit);
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->getRecommendations: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **macroTarget** | **String**|  | [optional] [default to 'BALANCED']
 **limit** | **int**|  | [optional] [default to 10]

### Return type

[**List<RecipeResponseDto>**](RecipeResponseDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserRecipes**
> List<RecipeResponseDto> getUserRecipes()



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();

try {
    final result = api_instance.getUserRecipes();
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->getUserRecipes: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<RecipeResponseDto>**](RecipeResponseDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getWeeklyTrend**
> WeeklyTrendDto getWeeklyTrend(startDate)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();
final startDate = 2013-10-20; // DateTime | 

try {
    final result = api_instance.getWeeklyTrend(startDate);
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->getWeeklyTrend: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **startDate** | **DateTime**|  | [optional] 

### Return type

[**WeeklyTrendDto**](WeeklyTrendDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logMeal**
> MealLogResponseDto logMeal(logMealRequestDto)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();
final logMealRequestDto = LogMealRequestDto(); // LogMealRequestDto | 

try {
    final result = api_instance.logMeal(logMealRequestDto);
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->logMeal: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **logMealRequestDto** | [**LogMealRequestDto**](LogMealRequestDto.md)|  | 

### Return type

[**MealLogResponseDto**](MealLogResponseDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchByIngredient**
> List<RecipeResponseDto> searchByIngredient(ingredient)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();
final ingredient = ingredient_example; // String | 

try {
    final result = api_instance.searchByIngredient(ingredient);
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->searchByIngredient: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ingredient** | **String**|  | 

### Return type

[**List<RecipeResponseDto>**](RecipeResponseDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **searchRecipes**
> List<RecipeResponseDto> searchRecipes(query)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();
final query = query_example; // String | 

try {
    final result = api_instance.searchRecipes(query);
    print(result);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->searchRecipes: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **query** | **String**|  | 

### Return type

[**List<RecipeResponseDto>**](RecipeResponseDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **toggleFavorite**
> toggleFavorite(recipeId)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = FoodLoggingControllerApi();
final recipeId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api_instance.toggleFavorite(recipeId);
} catch (e) {
    print('Exception when calling FoodLoggingControllerApi->toggleFavorite: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **recipeId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

