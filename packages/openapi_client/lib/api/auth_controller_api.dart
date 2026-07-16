//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AuthControllerApi {
  AuthControllerApi([ApiClient? apiClient])
      : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v1/auth/apple' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [SocialLoginRequest] socialLoginRequest (required):
  Future<Response> appleLoginWithHttpInfo(
    SocialLoginRequest socialLoginRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/auth/apple';

    // ignore: prefer_final_locals
    Object? postBody = socialLoginRequest;

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
  /// * [SocialLoginRequest] socialLoginRequest (required):
  Future<AuthResponse?> appleLogin(
    SocialLoginRequest socialLoginRequest,
  ) async {
    final response = await appleLoginWithHttpInfo(
      socialLoginRequest,
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
        'AuthResponse',
      ) as AuthResponse;
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/auth/google' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [SocialLoginRequest] socialLoginRequest (required):
  Future<Response> googleLoginWithHttpInfo(
    SocialLoginRequest socialLoginRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/auth/google';

    // ignore: prefer_final_locals
    Object? postBody = socialLoginRequest;

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
  /// * [SocialLoginRequest] socialLoginRequest (required):
  Future<AuthResponse?> googleLogin(
    SocialLoginRequest socialLoginRequest,
  ) async {
    final response = await googleLoginWithHttpInfo(
      socialLoginRequest,
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
        'AuthResponse',
      ) as AuthResponse;
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/auth/authenticate' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [LoginWithDeviceRequest] loginWithDeviceRequest (required):
  Future<Response> loginWithHttpInfo(
    LoginWithDeviceRequest loginWithDeviceRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/auth/authenticate';

    // ignore: prefer_final_locals
    Object? postBody = loginWithDeviceRequest;

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
  /// * [LoginWithDeviceRequest] loginWithDeviceRequest (required):
  Future<AuthResponse?> login(
    LoginWithDeviceRequest loginWithDeviceRequest,
  ) async {
    final response = await loginWithHttpInfo(
      loginWithDeviceRequest,
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
        'AuthResponse',
      ) as AuthResponse;
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/auth/refresh' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [RefreshTokenRequest] refreshTokenRequest (required):
  Future<Response> refreshWithHttpInfo(
    RefreshTokenRequest refreshTokenRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/auth/refresh';

    // ignore: prefer_final_locals
    Object? postBody = refreshTokenRequest;

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
  /// * [RefreshTokenRequest] refreshTokenRequest (required):
  Future<AuthResponse?> refresh(
    RefreshTokenRequest refreshTokenRequest,
  ) async {
    final response = await refreshWithHttpInfo(
      refreshTokenRequest,
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
        'AuthResponse',
      ) as AuthResponse;
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/auth/register' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [RegisterRequest] registerRequest (required):
  Future<Response> registerWithHttpInfo(
    RegisterRequest registerRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/auth/register';

    // ignore: prefer_final_locals
    Object? postBody = registerRequest;

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
  /// * [RegisterRequest] registerRequest (required):
  Future<AuthResponse?> register(
    RegisterRequest registerRequest,
  ) async {
    final response = await registerWithHttpInfo(
      registerRequest,
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
        'AuthResponse',
      ) as AuthResponse;
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/auth/resend-otp' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [ForgotPasswordRequest] forgotPasswordRequest (required):
  Future<Response> requestOtpResendWithHttpInfo(
    ForgotPasswordRequest forgotPasswordRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/auth/resend-otp';

    // ignore: prefer_final_locals
    Object? postBody = forgotPasswordRequest;

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
  /// * [ForgotPasswordRequest] forgotPasswordRequest (required):
  Future<String?> requestOtpResend(
    ForgotPasswordRequest forgotPasswordRequest,
  ) async {
    final response = await requestOtpResendWithHttpInfo(
      forgotPasswordRequest,
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
        'String',
      ) as String;
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/auth/password/forgot' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [ForgotPasswordRequest] forgotPasswordRequest (required):
  Future<Response> requestPasswordResetWithHttpInfo(
    ForgotPasswordRequest forgotPasswordRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/auth/password/forgot';

    // ignore: prefer_final_locals
    Object? postBody = forgotPasswordRequest;

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
  /// * [ForgotPasswordRequest] forgotPasswordRequest (required):
  Future<String?> requestPasswordReset(
    ForgotPasswordRequest forgotPasswordRequest,
  ) async {
    final response = await requestPasswordResetWithHttpInfo(
      forgotPasswordRequest,
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
        'String',
      ) as String;
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/auth/password/reset' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [ResetPasswordRequest] resetPasswordRequest (required):
  Future<Response> resetPasswordWithHttpInfo(
    ResetPasswordRequest resetPasswordRequest,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/auth/password/reset';

    // ignore: prefer_final_locals
    Object? postBody = resetPasswordRequest;

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
  /// * [ResetPasswordRequest] resetPasswordRequest (required):
  Future<void> resetPassword(
    ResetPasswordRequest resetPasswordRequest,
  ) async {
    final response = await resetPasswordWithHttpInfo(
      resetPasswordRequest,
    );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'GET /api/v1/auth/verify-email' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] email (required):
  ///
  /// * [String] otp (required):
  Future<Response> verifyEmailWithHttpInfo(
    String email,
    String otp,
  ) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/auth/verify-email';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    queryParams.addAll(_queryParams('', 'email', email));
    queryParams.addAll(_queryParams('', 'otp', otp));

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
  /// * [String] email (required):
  ///
  /// * [String] otp (required):
  Future<String?> verifyEmail(
    String email,
    String otp,
  ) async {
    final response = await verifyEmailWithHttpInfo(
      email,
      otp,
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
        'String',
      ) as String;
    }
    return null;
  }
}
