//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class SubscriptionControllerApi {
  SubscriptionControllerApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v1/referrals/apply' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [ReferralApplyRequest] referralApplyRequest (required):
  Future<Response> applyReferralWithHttpInfo(ReferralApplyRequest referralApplyRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/referrals/apply';

    // ignore: prefer_final_locals
    Object? postBody = referralApplyRequest;

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
  /// * [ReferralApplyRequest] referralApplyRequest (required):
  Future<Object?> applyReferral(ReferralApplyRequest referralApplyRequest,) async {
    final response = await applyReferralWithHttpInfo(referralApplyRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/subscriptions/{subscriptionId}/cancel' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] subscriptionId (required):
  Future<Response> cancelSubscriptionWithHttpInfo(String subscriptionId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/subscriptions/{subscriptionId}/cancel'
      .replaceAll('{subscriptionId}', subscriptionId);

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
  /// * [String] subscriptionId (required):
  Future<Object?> cancelSubscription(String subscriptionId,) async {
    final response = await cancelSubscriptionWithHttpInfo(subscriptionId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/users/me/subscription' operation and returns the [Response].
  Future<Response> getMySubscriptionWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/me/subscription';

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

  Future<Object?> getMySubscription() async {
    final response = await getMySubscriptionWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'Object',) as Object;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/plans' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] country:
  Future<Response> getPlansWithHttpInfo({ String? country, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/plans';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (country != null) {
      queryParams.addAll(_queryParams('', 'country', country));
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
  /// * [String] country:
  Future<List<SubscriptionPlanDto>?> getPlans({ String? country, }) async {
    final response = await getPlansWithHttpInfo( country: country, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<SubscriptionPlanDto>') as List)
        .cast<SubscriptionPlanDto>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/subscriptions/pricing' operation and returns the [Response].
  Future<Response> getPricingWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/subscriptions/pricing';

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

  Future<PricingResponse?> getPricing() async {
    final response = await getPricingWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PricingResponse',) as PricingResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/referrals/earnings' operation and returns the [Response].
  Future<Response> getReferralEarningsWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/referrals/earnings';

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

  Future<ReferralEarningsResponse?> getReferralEarnings() async {
    final response = await getReferralEarningsWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ReferralEarningsResponse',) as ReferralEarningsResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/referrals/history' operation and returns the [Response].
  Future<Response> getReferralHistoryWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/referrals/history';

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

  Future<List<ReferralHistoryResponse>?> getReferralHistory() async {
    final response = await getReferralHistoryWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      final responseBody = await _decodeBodyBytes(response);
      return (await apiClient.deserializeAsync(responseBody, 'List<ReferralHistoryResponse>') as List)
        .cast<ReferralHistoryResponse>()
        .toList(growable: false);

    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/subscriptions/verify/apple' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [AppleSubscriptionVerifyRequest] appleSubscriptionVerifyRequest (required):
  Future<Response> verifyAppleSubscriptionWithHttpInfo(AppleSubscriptionVerifyRequest appleSubscriptionVerifyRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/subscriptions/verify/apple';

    // ignore: prefer_final_locals
    Object? postBody = appleSubscriptionVerifyRequest;

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
  /// * [AppleSubscriptionVerifyRequest] appleSubscriptionVerifyRequest (required):
  Future<UserSubscriptionDto?> verifyAppleSubscription(AppleSubscriptionVerifyRequest appleSubscriptionVerifyRequest,) async {
    final response = await verifyAppleSubscriptionWithHttpInfo(appleSubscriptionVerifyRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserSubscriptionDto',) as UserSubscriptionDto;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/subscriptions/verify/google' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [GoogleSubscriptionVerifyRequest] googleSubscriptionVerifyRequest (required):
  Future<Response> verifyGoogleSubscriptionWithHttpInfo(GoogleSubscriptionVerifyRequest googleSubscriptionVerifyRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/subscriptions/verify/google';

    // ignore: prefer_final_locals
    Object? postBody = googleSubscriptionVerifyRequest;

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
  /// * [GoogleSubscriptionVerifyRequest] googleSubscriptionVerifyRequest (required):
  Future<UserSubscriptionDto?> verifyGoogleSubscription(GoogleSubscriptionVerifyRequest googleSubscriptionVerifyRequest,) async {
    final response = await verifyGoogleSubscriptionWithHttpInfo(googleSubscriptionVerifyRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserSubscriptionDto',) as UserSubscriptionDto;
    
    }
    return null;
  }
}
