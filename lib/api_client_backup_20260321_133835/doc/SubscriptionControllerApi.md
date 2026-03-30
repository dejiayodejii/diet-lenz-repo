# openapi.api.SubscriptionControllerApi

## Load the API package
```dart
import 'package:openapi/api.dart';
```

All URIs are relative to *https://diet-lenz-stagingapi-d3mbl.ondigitalocean.app*

Method | HTTP request | Description
------------- | ------------- | -------------
[**applyReferral**](SubscriptionControllerApi.md#applyreferral) | **POST** /api/v1/referrals/apply | 
[**cancelSubscription**](SubscriptionControllerApi.md#cancelsubscription) | **POST** /api/v1/subscriptions/{subscriptionId}/cancel | 
[**getMySubscription**](SubscriptionControllerApi.md#getmysubscription) | **GET** /api/v1/users/me/subscription | 
[**getPlans**](SubscriptionControllerApi.md#getplans) | **GET** /api/v1/plans | 
[**getPricing**](SubscriptionControllerApi.md#getpricing) | **GET** /api/v1/subscriptions/pricing | 
[**getReferralEarnings**](SubscriptionControllerApi.md#getreferralearnings) | **GET** /api/v1/referrals/earnings | 
[**getReferralHistory**](SubscriptionControllerApi.md#getreferralhistory) | **GET** /api/v1/referrals/history | 
[**verifyAppleSubscription**](SubscriptionControllerApi.md#verifyapplesubscription) | **POST** /api/v1/subscriptions/verify/apple | 
[**verifyGoogleSubscription**](SubscriptionControllerApi.md#verifygooglesubscription) | **POST** /api/v1/subscriptions/verify/google | 


# **applyReferral**
> Object applyReferral(requestBody)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SubscriptionControllerApi();
final requestBody = Map<String, String>(); // Map<String, String> | 

try {
    final result = api_instance.applyReferral(requestBody);
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->applyReferral: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestBody** | [**Map<String, String>**](String.md)|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelSubscription**
> Object cancelSubscription(subscriptionId)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SubscriptionControllerApi();
final subscriptionId = 38400000-8cf0-11bd-b23e-10b96e4ef00d; // String | 

try {
    final result = api_instance.cancelSubscription(subscriptionId);
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->cancelSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subscriptionId** | **String**|  | 

### Return type

[**Object**](Object.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMySubscription**
> Object getMySubscription()



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SubscriptionControllerApi();

try {
    final result = api_instance.getMySubscription();
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->getMySubscription: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Object**](Object.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPlans**
> List<SubscriptionPlanDto> getPlans(country)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SubscriptionControllerApi();
final country = country_example; // String | 

try {
    final result = api_instance.getPlans(country);
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->getPlans: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **country** | **String**|  | [optional] [default to 'US']

### Return type

[**List<SubscriptionPlanDto>**](SubscriptionPlanDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getPricing**
> PricingResponse getPricing()



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SubscriptionControllerApi();

try {
    final result = api_instance.getPricing();
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->getPricing: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**PricingResponse**](PricingResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getReferralEarnings**
> ReferralEarningsResponse getReferralEarnings()



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SubscriptionControllerApi();

try {
    final result = api_instance.getReferralEarnings();
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->getReferralEarnings: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ReferralEarningsResponse**](ReferralEarningsResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getReferralHistory**
> List<ReferralHistoryResponse> getReferralHistory()



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SubscriptionControllerApi();

try {
    final result = api_instance.getReferralHistory();
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->getReferralHistory: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**List<ReferralHistoryResponse>**](ReferralHistoryResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyAppleSubscription**
> UserSubscriptionDto verifyAppleSubscription(requestBody)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SubscriptionControllerApi();
final requestBody = Map<String, String>(); // Map<String, String> | 

try {
    final result = api_instance.verifyAppleSubscription(requestBody);
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->verifyAppleSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestBody** | [**Map<String, String>**](String.md)|  | 

### Return type

[**UserSubscriptionDto**](UserSubscriptionDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyGoogleSubscription**
> UserSubscriptionDto verifyGoogleSubscription(requestBody)



### Example
```dart
import 'package:openapi/api.dart';
// TODO Configure HTTP Bearer authorization: bearerAuth
// Case 1. Use String Token
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken('YOUR_ACCESS_TOKEN');
// Case 2. Use Function which generate token.
// String yourTokenGeneratorFunction() { ... }
//defaultApiClient.getAuthentication<HttpBearerAuth>('bearerAuth').setAccessToken(yourTokenGeneratorFunction);

final api_instance = SubscriptionControllerApi();
final requestBody = Map<String, String>(); // Map<String, String> | 

try {
    final result = api_instance.verifyGoogleSubscription(requestBody);
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->verifyGoogleSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestBody** | [**Map<String, String>**](String.md)|  | 

### Return type

[**UserSubscriptionDto**](UserSubscriptionDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

