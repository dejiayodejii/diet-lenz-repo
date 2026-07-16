//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

library openapi.api;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

part 'api_client.dart';
part 'api_helper.dart';
part 'api_exception.dart';
part 'auth/authentication.dart';
part 'auth/api_key_auth.dart';
part 'auth/oauth.dart';
part 'auth/http_basic_auth.dart';
part 'auth/http_bearer_auth.dart';

part 'api/auth_controller_api.dart';
part 'api/food_logging_controller_api.dart';
part 'api/onboarding_calculator_controller_api.dart';
part 'api/recipe_controllers_api.dart';
part 'api/subscription_controller_api.dart';
part 'api/user_controller_api.dart';

part 'model/apple_subscription_verify_request.dart';
part 'model/auth_response.dart';
part 'model/average_macros_dto.dart';
part 'model/calorie_tracker_response.dart';
part 'model/change_password_request.dart';
part 'model/chart_point.dart';
part 'model/consumed_macros_dto.dart';
part 'model/daily_trend_dto.dart';
part 'model/dashboard_response_dto.dart';
part 'model/delete_account_request.dart';
part 'model/energy_balance_response.dart';
part 'model/favorite_recipe_response_dto.dart';
part 'model/food_analysis_dto.dart';
part 'model/forgot_password_request.dart';
part 'model/goals.dart';
part 'model/google_subscription_verify_request.dart';
part 'model/health_sync_settings.dart';
part 'model/health_sync_settings_dto.dart';
part 'model/image_upload_response.dart';
part 'model/ingredient_dto.dart';
part 'model/log_meal_request_dto.dart';
part 'model/login_request.dart';
part 'model/login_with_device_request.dart';
part 'model/macro_actual_dto.dart';
part 'model/macro_composition_response.dart';
part 'model/macro_info_dto.dart';
part 'model/macro_nutrients_dto.dart';
part 'model/macro_performance_dto.dart';
part 'model/macro_preview_request.dart';
part 'model/macro_preview_response.dart';
part 'model/macro_result.dart';
part 'model/macro_summary.dart';
part 'model/macro_target_dto.dart';
part 'model/macros.dart';
part 'model/measure_dto.dart';
part 'model/meal_log_response_dto.dart';
part 'model/message_response.dart';
part 'model/onboarding_survey_request.dart';
part 'model/onboarding_survey_response.dart';
part 'model/page_metadata.dart';
part 'model/paged_model_meal_log_response_dto.dart';
part 'model/paged_model_user_notification.dart';
part 'model/password_changed_response.dart';
part 'model/percentages.dart';
part 'model/pricing_response.dart';
part 'model/profile_request_dto.dart';
part 'model/projection_point.dart';
part 'model/projection_response.dart';
part 'model/quantity_dto.dart';
part 'model/recipe_response_dto.dart';
part 'model/referral_apply_request.dart';
part 'model/referral_earnings_response.dart';
part 'model/referral_history_response.dart';
part 'model/refresh_token_request.dart';
part 'model/register_device_request.dart';
part 'model/register_request.dart';
part 'model/reset_password_request.dart';
part 'model/social_login_request.dart';
part 'model/streak_info_dto.dart';
part 'model/subscription_plan_dto.dart';
part 'model/suggested_food_analysis.dart';
part 'model/summary.dart';
part 'model/user_notification.dart';
part 'model/user_profile.dart';
part 'model/user_subscription_dto.dart';
part 'model/user_subscription_status_response.dart';
part 'model/weekly_trend_dto.dart';
part 'model/weight_entry.dart';
part 'model/weight_log_request.dart';
part 'model/weight_progress_response.dart';

/// An [ApiClient] instance that uses the default values obtained from
/// the OpenAPI specification file.
var defaultApiClient = ApiClient();

const _delimiters = {'csv': ',', 'ssv': ' ', 'tsv': '\t', 'pipes': '|'};
const _dateEpochMarker = 'epoch';
const _deepEquality = DeepCollectionEquality();
final _dateFormatter = DateFormat('yyyy-MM-dd');
final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

bool _isEpochMarker(String? pattern) =>
    pattern == _dateEpochMarker || pattern == '/$_dateEpochMarker/';
