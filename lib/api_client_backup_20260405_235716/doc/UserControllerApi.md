# openapi.api.UserControllerApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://diet-lenz-stagingapi-d3mbl.ondigitalocean.app*

Method | HTTP request | Description
------------- | ------------- | -------------
[**changePassword**](UserControllerApi.md#changepassword) | **POST** /api/v1/users/password/change | 
[**deleteAccount**](UserControllerApi.md#deleteaccount) | **DELETE** /api/v1/users/me | 
[**getUserNotifications**](UserControllerApi.md#getusernotifications) | **GET** /api/v1/users/notifications/all | 
[**getUserProfile**](UserControllerApi.md#getuserprofile) | **GET** /api/v1/users/profile | 
[**markNotificationAsRead**](UserControllerApi.md#marknotificationasread) | **PUT** /api/v1/users/notifications/all | 
[**updateUserProfile**](UserControllerApi.md#updateuserprofile) | **PUT** /api/v1/users/profile | 
[**updateUserProfilePhoto**](UserControllerApi.md#updateuserprofilephoto) | **PUT** /api/v1/users/profile-photo | 


# **changePassword**
> PasswordChangedResponse changePassword(changePasswordRequest)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserControllerApi();
final changePasswordRequest = ChangePasswordRequest(); // ChangePasswordRequest | 

try {
    final result = api_instance.changePassword(changePasswordRequest);
    print(result);
} catch (e) {
    print('Exception when calling UserControllerApi->changePassword: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **changePasswordRequest** | [**ChangePasswordRequest**](ChangePasswordRequest.md)|  | 

### Return type

[**PasswordChangedResponse**](PasswordChangedResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **deleteAccount**
> deleteAccount(deleteAccountRequest)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserControllerApi();
final deleteAccountRequest = DeleteAccountRequest(); // DeleteAccountRequest | 

try {
    api_instance.deleteAccount(deleteAccountRequest);
} catch (e) {
    print('Exception when calling UserControllerApi->deleteAccount: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **deleteAccountRequest** | [**DeleteAccountRequest**](DeleteAccountRequest.md)|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserNotifications**
> PageUserNotification getUserNotifications(pageNumber)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserControllerApi();
final pageNumber = 56; // int | 

try {
    final result = api_instance.getUserNotifications(pageNumber);
    print(result);
} catch (e) {
    print('Exception when calling UserControllerApi->getUserNotifications: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **pageNumber** | **int**|  | 

### Return type

[**PageUserNotification**](PageUserNotification.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getUserProfile**
> UserProfile getUserProfile()



### Example
```dart
import 'package:openapi/api.dart';
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

# **markNotificationAsRead**
> markNotificationAsRead(notificationId)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserControllerApi();
final notificationId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    api_instance.markNotificationAsRead(notificationId);
} catch (e) {
    print('Exception when calling UserControllerApi->markNotificationAsRead: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **notificationId** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **updateUserProfile**
> UserProfile updateUserProfile(profileRequestDto)



### Example
```dart
import 'package:openapi/api.dart';
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

# **updateUserProfilePhoto**
> ImageUploadResponse updateUserProfilePhoto(image)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = UserControllerApi();
final image = BINARY_DATA_HERE; // MultipartFile | 

try {
    final result = api_instance.updateUserProfilePhoto(image);
    print(result);
} catch (e) {
    print('Exception when calling UserControllerApi->updateUserProfilePhoto: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **image** | **MultipartFile**|  | 

### Return type

[**ImageUploadResponse**](ImageUploadResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: multipart/form-data
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

