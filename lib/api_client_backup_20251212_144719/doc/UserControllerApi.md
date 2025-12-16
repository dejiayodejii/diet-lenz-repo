# diet_lenz_api.api.UserControllerApi

## Load the API package
```dart
import 'package:diet_lenz_api/api.dart';
```

All URIs are relative to *https://diet-lenz-api.onrender.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**getUserProfile**](UserControllerApi.md#getuserprofile) | **GET** /api/v1/users/profile | 
[**updateUserProfile**](UserControllerApi.md#updateuserprofile) | **PUT** /api/v1/users/profile | 


# **getUserProfile**
> UserProfile getUserProfile()



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserControllerApi();

try {
    final result = api_instance.getUserProfile();
    print(result);
} catch (e) {
    print('Exception when calling UserControllerApi->getUserProfile: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserProfile**](UserProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserProfile**
> UserProfile updateUserProfile(profileRequestDto)



### Example
```dart
import 'package:diet_lenz_api/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserControllerApi();
final profileRequestDto = ProfileRequestDto(); // ProfileRequestDto | 

try {
    final result = api_instance.updateUserProfile(profileRequestDto);
    print(result);
} catch (e) {
    print('Exception when calling UserControllerApi->updateUserProfile: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **profileRequestDto** | [**ProfileRequestDto**](ProfileRequestDto.md)|  | 

### Return type

[**UserProfile**](UserProfile.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

