# diet_lenz_api.api.RecipeControllersApi

## Load the API package
```dart
import 'package:diet_lenz_api/api.dart';
```

All URIs are relative to *https://diet-lenz-api.onrender.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**analyzeRecipe**](RecipeControllersApi.md#analyzerecipe) | **POST** /api/v1/recipe/analyze | 
[**getDietaryPreferences**](RecipeControllersApi.md#getdietarypreferences) | **GET** /api/v1/recipe/dietary-preferences | 
[**getGoals**](RecipeControllersApi.md#getgoals) | **GET** /api/v1/recipe/goals | 
[**getMacroTargets**](RecipeControllersApi.md#getmacrotargets) | **GET** /api/v1/recipe/macro-targets | 
[**health**](RecipeControllersApi.md#health) | **GET** /api/v1/recipe/health | 
[**hello**](RecipeControllersApi.md#hello) | **GET** /api/v1/recipe/hello | 
[**suggestAndAnalyze**](RecipeControllersApi.md#suggestandanalyze) | **POST** /api/v1/recipe/suggest | 


# **analyzeRecipe**
> FoodAnalysisDto analyzeRecipe(image)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RecipeControllersApi();
final image = BINARY_DATA_HERE; // MultipartFile | 

try {
    final result = api_instance.analyzeRecipe(image);
    print(result);
} catch (e) {
    print('Exception when calling RecipeControllersApi->analyzeRecipe: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **image** | **MultipartFile**|  | 

### Return type

[**FoodAnalysisDto**](FoodAnalysisDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getDietaryPreferences**
> List<String> getDietaryPreferences()



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RecipeControllersApi();

try {
    final result = api_instance.getDietaryPreferences();
    print(result);
} catch (e) {
    print('Exception when calling RecipeControllersApi->getDietaryPreferences: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**List<String>**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getGoals**
> List<String> getGoals()



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RecipeControllersApi();

try {
    final result = api_instance.getGoals();
    print(result);
} catch (e) {
    print('Exception when calling RecipeControllersApi->getGoals: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**List<String>**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMacroTargets**
> List<String> getMacroTargets()



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RecipeControllersApi();

try {
    final result = api_instance.getMacroTargets();
    print(result);
} catch (e) {
    print('Exception when calling RecipeControllersApi->getMacroTargets: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**List<String>**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **health**
> String health()



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RecipeControllersApi();

try {
    final result = api_instance.health();
    print(result);
} catch (e) {
    print('Exception when calling RecipeControllersApi->health: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**String**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **hello**
> String hello()



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RecipeControllersApi();

try {
    final result = api_instance.hello();
    print(result);
} catch (e) {
    print('Exception when calling RecipeControllersApi->hello: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

**String**

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **suggestAndAnalyze**
> List<SuggestedFoodAnalysis> suggestAndAnalyze(image)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = RecipeControllersApi();
final image = BINARY_DATA_HERE; // MultipartFile | 

try {
    final result = api_instance.suggestAndAnalyze(image);
    print(result);
} catch (e) {
    print('Exception when calling RecipeControllersApi->suggestAndAnalyze: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **image** | **MultipartFile**|  | 

### Return type

[**List<SuggestedFoodAnalysis>**](SuggestedFoodAnalysis.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

