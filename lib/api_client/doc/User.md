# openapi.model.User

## Load the model package
```dart
import 'package:openapi/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** |  | [optional] 
**createdAt** | [**DateTime**](DateTime.md) |  | [optional] 
**updatedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**email** | **String** |  | [optional] 
**password** | **String** |  | [optional] 
**firstName** | **String** |  | [optional] 
**lastName** | **String** |  | [optional] 
**provider** | **String** |  | [optional] 
**providerId** | **String** |  | [optional] 
**emailVerified** | **bool** |  | [optional] 
**enabled** | **bool** |  | [optional] 
**deletedAt** | [**DateTime**](DateTime.md) |  | [optional] 
**profile** | [**UserProfile**](UserProfile.md) |  | [optional] 
**timeZone** | **String** |  | [optional] 
**profilePhotoUrl** | **String** |  | [optional] 
**referralCode** | **String** |  | [optional] 
**firstPromoterReferralCode** | **String** |  | [optional] 
**firstPromoterReferralLink** | **String** |  | [optional] 
**firstPromoterAuthToken** | **String** |  | [optional] 
**referredByCode** | **String** |  | [optional] 
**referrer** | [**User**](User.md) |  | [optional] 
**premiumExpiresAt** | [**DateTime**](DateTime.md) |  | [optional] 
**hasCancelledBefore** | **bool** |  | [optional] 
**countryCode** | **String** |  | [optional] 
**notifications** | [**Set<UserNotification>**](UserNotification.md) |  | [optional] [default to const {}]

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


