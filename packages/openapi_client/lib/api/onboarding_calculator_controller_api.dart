//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OnboardingCalculatorControllerApi {
  OnboardingCalculatorControllerApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v1/onboarding/plan' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [MacroPreviewRequest] macroPreviewRequest (required):
  Future<Response> calculatePlanWithHttpInfo(
    MacroPreviewRequest macroPreviewRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/onboarding/plan';

    // ignore: prefer_final_locals
    Object? postBody = macroPreviewRequest;

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
  /// * [MacroPreviewRequest] macroPreviewRequest (required):
  Future<MacroPreviewResponse?> calculatePlan(
    MacroPreviewRequest macroPreviewRequest,
  ) async {
    final response = await calculatePlanWithHttpInfo(
      macroPreviewRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'MacroPreviewResponse',
      ) as MacroPreviewResponse;
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/onboarding/projection' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [MacroPreviewRequest] macroPreviewRequest (required):
  ///
  /// * [String] bucket:
  Future<Response> calculateProjectionWithHttpInfo(
    MacroPreviewRequest macroPreviewRequest, {
    String? bucket,
  }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/onboarding/projection';

    // ignore: prefer_final_locals
    Object? postBody = macroPreviewRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (bucket != null) {
      queryParams.addAll(_queryParams('', 'bucket', bucket));
    }

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
  /// * [MacroPreviewRequest] macroPreviewRequest (required):
  ///
  /// * [String] bucket:
  Future<ProjectionResponse?> calculateProjection(
    MacroPreviewRequest macroPreviewRequest, {
    String? bucket,
  }) async {
    final response = await calculateProjectionWithHttpInfo(
      macroPreviewRequest,
      bucket: bucket,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty &&
        response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(
        await _decodeBodyBytes(response),
        'ProjectionResponse',
      ) as ProjectionResponse;
    }
    return null;
  }
}
