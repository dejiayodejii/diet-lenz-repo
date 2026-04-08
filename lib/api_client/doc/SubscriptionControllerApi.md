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
[**simulatePurchase**](SubscriptionControllerApi.md#simulatepurchase) | **POST** /api/v1/subscriptions/simulate-purchase | 
[**verifyAppleSubscription**](SubscriptionControllerApi.md#verifyapplesubscription) | **POST** /api/v1/subscriptions/verify/apple | 
[**verifyGoogleSubscription**](SubscriptionControllerApi.md#verifygooglesubscription) | **POST** /api/v1/subscriptions/verify/google | 
[**verifyRevenueCatSubscription**](SubscriptionControllerApi.md#verifyrevenuecatsubscription) | **POST** /api/v1/subscriptions/verify/revenuecat | 


# **applyReferral**
> MessageResponse applyReferral(referralApplyRequest)



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
final referralApplyRequest = ReferralApplyRequest(); // ReferralApplyRequest | 

try {
    final result = api_instance.applyReferral(referralApplyRequest);
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->applyReferral: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **referralApplyRequest** | [**ReferralApplyRequest**](ReferralApplyRequest.md)|  | 

### Return type

[**MessageResponse**](MessageResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **cancelSubscription**
> MessageResponse cancelSubscription(subscriptionId)



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

[**MessageResponse**](MessageResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getMySubscription**
> UserSubscriptionStatusResponse getMySubscription()



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

[**UserSubscriptionStatusResponse**](UserSubscriptionStatusResponse.md)

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

# **simulatePurchase**
> MessageResponse simulatePurchase()



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
    final result = api_instance.simulatePurchase();
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->simulatePurchase: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**MessageResponse**](MessageResponse.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyAppleSubscription**
> UserSubscriptionDto verifyAppleSubscription(appleSubscriptionVerifyRequest)



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
final appleSubscriptionVerifyRequest = AppleSubscriptionVerifyRequest(); // AppleSubscriptionVerifyRequest | 

try {
    final result = api_instance.verifyAppleSubscription(appleSubscriptionVerifyRequest);
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->verifyAppleSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **appleSubscriptionVerifyRequest** | [**AppleSubscriptionVerifyRequest**](AppleSubscriptionVerifyRequest.md)|  | 

### Return type

[**UserSubscriptionDto**](UserSubscriptionDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyGoogleSubscription**
> UserSubscriptionDto verifyGoogleSubscription(googleSubscriptionVerifyRequest)



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
final googleSubscriptionVerifyRequest = GoogleSubscriptionVerifyRequest(); // GoogleSubscriptionVerifyRequest | 

try {
    final result = api_instance.verifyGoogleSubscription(googleSubscriptionVerifyRequest);
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->verifyGoogleSubscription: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **googleSubscriptionVerifyRequest** | [**GoogleSubscriptionVerifyRequest**](GoogleSubscriptionVerifyRequest.md)|  | 

### Return type

[**UserSubscriptionDto**](UserSubscriptionDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **verifyRevenueCatSubscription**
> UserSubscriptionDto verifyRevenueCatSubscription()



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
    final result = api_instance.verifyRevenueCatSubscription();
    print(result);
} catch (e) {
    print('Exception when calling SubscriptionControllerApi->verifyRevenueCatSubscription: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**UserSubscriptionDto**](UserSubscriptionDto.md)

### Authorization

[bearerAuth](../README.md#bearerAuth)

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: */*

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

