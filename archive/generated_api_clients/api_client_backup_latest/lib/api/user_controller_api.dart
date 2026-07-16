//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;


class UserControllerApi {
  UserControllerApi([ApiClient? apiClient]) : apiClient = apiClient ?? defaultApiClient;

  final ApiClient apiClient;

  /// Performs an HTTP 'POST /api/v1/users/password/change' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [ChangePasswordRequest] changePasswordRequest (required):
  Future<Response> changePasswordWithHttpInfo(ChangePasswordRequest changePasswordRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/password/change';

    // ignore: prefer_final_locals
    Object? postBody = changePasswordRequest;

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
  /// * [ChangePasswordRequest] changePasswordRequest (required):
  Future<PasswordChangedResponse?> changePassword(ChangePasswordRequest changePasswordRequest,) async {
    final response = await changePasswordWithHttpInfo(changePasswordRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PasswordChangedResponse',) as PasswordChangedResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'DELETE /api/v1/users/me' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [DeleteAccountRequest] deleteAccountRequest (required):
  Future<Response> deleteAccountWithHttpInfo(DeleteAccountRequest deleteAccountRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/me';

    // ignore: prefer_final_locals
    Object? postBody = deleteAccountRequest;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'DELETE',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [DeleteAccountRequest] deleteAccountRequest (required):
  Future<void> deleteAccount(DeleteAccountRequest deleteAccountRequest,) async {
    final response = await deleteAccountWithHttpInfo(deleteAccountRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'GET /api/v1/users/progress/calorie-tracker' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] filter:
  Future<Response> getCalorieTrackerWithHttpInfo({ String? filter, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/progress/calorie-tracker';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
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
  /// * [String] filter:
  Future<CalorieTrackerResponse?> getCalorieTracker({ String? filter, }) async {
    final response = await getCalorieTrackerWithHttpInfo( filter: filter, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'CalorieTrackerResponse',) as CalorieTrackerResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/users/progress/energy-balance' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] filter:
  Future<Response> getEnergyBalanceWithHttpInfo({ String? filter, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/progress/energy-balance';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
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
  /// * [String] filter:
  Future<EnergyBalanceResponse?> getEnergyBalance({ String? filter, }) async {
    final response = await getEnergyBalanceWithHttpInfo( filter: filter, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'EnergyBalanceResponse',) as EnergyBalanceResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/users/progress/macro-composition' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] filter:
  Future<Response> getMacroCompositionWithHttpInfo({ String? filter, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/progress/macro-composition';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
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
  /// * [String] filter:
  Future<MacroCompositionResponse?> getMacroComposition({ String? filter, }) async {
    final response = await getMacroCompositionWithHttpInfo( filter: filter, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'MacroCompositionResponse',) as MacroCompositionResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/users/notifications/all' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [int] pageNumber (required):
  Future<Response> getUserNotificationsWithHttpInfo(int pageNumber,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/notifications/all';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'pageNumber', pageNumber));

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
  /// * [int] pageNumber (required):
  Future<PagedModelUserNotification?> getUserNotifications(int pageNumber,) async {
    final response = await getUserNotificationsWithHttpInfo(pageNumber,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'PagedModelUserNotification',) as PagedModelUserNotification;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/users/profile' operation and returns the [Response].
  Future<Response> getUserProfileWithHttpInfo() async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/profile';

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

  Future<UserProfile?> getUserProfile() async {
    final response = await getUserProfileWithHttpInfo();
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserProfile',) as UserProfile;
    
    }
    return null;
  }

  /// Performs an HTTP 'GET /api/v1/users/weight/progress' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] filter:
  Future<Response> getWeightProgressWithHttpInfo({ String? filter, }) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/weight/progress';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    if (filter != null) {
      queryParams.addAll(_queryParams('', 'filter', filter));
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
  /// * [String] filter:
  Future<WeightProgressResponse?> getWeightProgress({ String? filter, }) async {
    final response = await getWeightProgressWithHttpInfo( filter: filter, );
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WeightProgressResponse',) as WeightProgressResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'POST /api/v1/users/weight' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [WeightLogRequest] weightLogRequest (required):
  Future<Response> logWeightWithHttpInfo(WeightLogRequest weightLogRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/weight';

    // ignore: prefer_final_locals
    Object? postBody = weightLogRequest;

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
  /// * [WeightLogRequest] weightLogRequest (required):
  Future<WeightEntry?> logWeight(WeightLogRequest weightLogRequest,) async {
    final response = await logWeightWithHttpInfo(weightLogRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'WeightEntry',) as WeightEntry;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /api/v1/users/notifications/all' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [String] notificationId (required):
  Future<Response> markNotificationAsReadWithHttpInfo(String notificationId,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/notifications/all';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

      queryParams.addAll(_queryParams('', 'notificationId', notificationId));

    const contentTypes = <String>[];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [String] notificationId (required):
  Future<void> markNotificationAsRead(String notificationId,) async {
    final response = await markNotificationAsReadWithHttpInfo(notificationId,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
  }

  /// Performs an HTTP 'POST /api/v1/users/onboarding-survey' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [OnboardingSurveyRequest] onboardingSurveyRequest (required):
  Future<Response> submitOnboardingSurveyWithHttpInfo(OnboardingSurveyRequest onboardingSurveyRequest,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/onboarding-survey';

    // ignore: prefer_final_locals
    Object? postBody = onboardingSurveyRequest;

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
  /// * [OnboardingSurveyRequest] onboardingSurveyRequest (required):
  Future<OnboardingSurveyResponse?> submitOnboardingSurvey(OnboardingSurveyRequest onboardingSurveyRequest,) async {
    final response = await submitOnboardingSurveyWithHttpInfo(onboardingSurveyRequest,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'OnboardingSurveyResponse',) as OnboardingSurveyResponse;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /api/v1/users/profile' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [ProfileRequestDto] profileRequestDto (required):
  Future<Response> updateUserProfileWithHttpInfo(ProfileRequestDto profileRequestDto,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/profile';

    // ignore: prefer_final_locals
    Object? postBody = profileRequestDto;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['application/json'];


    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [ProfileRequestDto] profileRequestDto (required):
  Future<UserProfile?> updateUserProfile(ProfileRequestDto profileRequestDto,) async {
    final response = await updateUserProfileWithHttpInfo(profileRequestDto,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'UserProfile',) as UserProfile;
    
    }
    return null;
  }

  /// Performs an HTTP 'PUT /api/v1/users/profile-photo' operation and returns the [Response].
  /// Parameters:
  ///
  /// * [MultipartFile] image (required):
  Future<Response> updateUserProfilePhotoWithHttpInfo(MultipartFile image,) async {
    // ignore: prefer_const_declarations
    final path = r'/api/v1/users/profile-photo';

    // ignore: prefer_final_locals
    Object? postBody;

    final queryParams = <QueryParam>[];
    final headerParams = <String, String>{};
    final formParams = <String, String>{};

    const contentTypes = <String>['multipart/form-data'];

    bool hasFields = false;
    final mp = MultipartRequest('PUT', Uri.parse(path));
    if (image != null) {
      hasFields = true;
      mp.fields[r'image'] = image.field;
      mp.files.add(image);
    }
    if (hasFields) {
      postBody = mp;
    }

    return apiClient.invokeAPI(
      path,
      'PUT',
      queryParams,
      postBody,
      headerParams,
      formParams,
      contentTypes.isEmpty ? null : contentTypes.first,
    );
  }

  /// Parameters:
  ///
  /// * [MultipartFile] image (required):
  Future<ImageUploadResponse?> updateUserProfilePhoto(MultipartFile image,) async {
    final response = await updateUserProfilePhotoWithHttpInfo(image,);
    if (response.statusCode >= HttpStatus.badRequest) {
      throw ApiException(response.statusCode, await _decodeBodyBytes(response));
    }
    // When a remote server returns no body with a status of 204, we shall not decode it.
    // At the time of writing this, `dart:convert` will throw an "Unexpected end of input"
    // FormatException when trying to decode an empty string.
    if (response.body.isNotEmpty && response.statusCode != HttpStatus.noContent) {
      return await apiClient.deserializeAsync(await _decodeBodyBytes(response), 'ImageUploadResponse',) as ImageUploadResponse;
    
    }
    return null;
  }
}
