# openapi.api.AuthControllerApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://diet-lenz-api.onrender.com*

Method | HTTP request | Description
------------- | ------------- | -------------
[**appleLogin**](AuthControllerApi.md#applelogin) | **POST** /api/v1/auth/apple | 
[**googleLogin**](AuthControllerApi.md#googlelogin) | **POST** /api/v1/auth/google | 
[**login**](AuthControllerApi.md#login) | **POST** /api/v1/auth/authenticate | 
[**refresh**](AuthControllerApi.md#refresh) | **POST** /api/v1/auth/refresh | 
[**register**](AuthControllerApi.md#register) | **POST** /api/v1/auth/register | 
[**verifyEmail**](AuthControllerApi.md#verifyemail) | **GET** /api/v1/auth/verify-email | 


# **appleLogin**
> AuthResponse appleLogin(socialLoginRequest)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AuthControllerApi();
final socialLoginRequest = SocialLoginRequest(); // SocialLoginRequest | 

try {
    final result = api_instance.appleLogin(socialLoginRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthControllerApi->appleLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **socialLoginRequest** | [**SocialLoginRequest**](SocialLoginRequest.md)|  | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **googleLogin**
> AuthResponse googleLogin(socialLoginRequest)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AuthControllerApi();
final socialLoginRequest = SocialLoginRequest(); // SocialLoginRequest | 

try {
    final result = api_instance.googleLogin(socialLoginRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthControllerApi->googleLogin: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **socialLoginRequest** | [**SocialLoginRequest**](SocialLoginRequest.md)|  | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **login**
> AuthResponse login(loginWithDeviceRequest)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AuthControllerApi();
final loginWithDeviceRequest = LoginWithDeviceRequest(); // LoginWithDeviceRequest | 

try {
    final result = api_instance.login(loginWithDeviceRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthControllerApi->login: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **loginWithDeviceRequest** | [**LoginWithDeviceRequest**](LoginWithDeviceRequest.md)|  | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **refresh**
> AuthResponse refresh(refreshTokenRequest)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AuthControllerApi();
final refreshTokenRequest = RefreshTokenRequest(); // RefreshTokenRequest | 

try {
    final result = api_instance.refresh(refreshTokenRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthControllerApi->refresh: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **refreshTokenRequest** | [**RefreshTokenRequest**](RefreshTokenRequest.md)|  | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **register**
> AuthResponse register(registerRequest)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AuthControllerApi();
final registerRequest = RegisterRequest(); // RegisterRequest | 

try {
    final result = api_instance.register(registerRequest);
    print(result);
} catch (e) {
    print('Exception when calling AuthControllerApi->register: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **registerRequest** | [**RegisterRequest**](RegisterRequest.md)|  | 

### Return type

[**AuthResponse**](AuthResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyEmail**
> verifyEmail(token)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = AuthControllerApi();
final token = token_example; // String | 

try {
    api_instance.verifyEmail(token);
} catch (e) {
    print('Exception when calling AuthControllerApi->verifyEmail: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**|  | 

### Return type

void (empty response body)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

