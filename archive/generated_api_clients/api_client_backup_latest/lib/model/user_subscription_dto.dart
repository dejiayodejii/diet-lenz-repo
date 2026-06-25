//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserSubscriptionDto {
  /// Returns a new [UserSubscriptionDto] instance.
  UserSubscriptionDto({
    this.status,
    this.expiresAt,
    this.autoRenewing,
    this.planName,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? status;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? expiresAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? autoRenewing;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? planName;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserSubscriptionDto &&
    other.status == status &&
    other.expiresAt == expiresAt &&
    other.autoRenewing == autoRenewing &&
    other.planName == planName;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (status == null ? 0 : status!.hashCode) +
    (expiresAt == null ? 0 : expiresAt!.hashCode) +
    (autoRenewing == null ? 0 : autoRenewing!.hashCode) +
    (planName == null ? 0 : planName!.hashCode);

  @override
  String toString() => 'UserSubscriptionDto[status=$status, expiresAt=$expiresAt, autoRenewing=$autoRenewing, planName=$planName]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    if (this.expiresAt != null) {
      json[r'expiresAt'] = this.expiresAt!.toUtc().toIso8601String();
    } else {
      json[r'expiresAt'] = null;
    }
    if (this.autoRenewing != null) {
      json[r'autoRenewing'] = this.autoRenewing;
    } else {
      json[r'autoRenewing'] = null;
    }
    if (this.planName != null) {
      json[r'planName'] = this.planName;
    } else {
      json[r'planName'] = null;
    }
    return json;
  }

  /// Returns a new [UserSubscriptionDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserSubscriptionDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserSubscriptionDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserSubscriptionDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserSubscriptionDto(
        status: mapValueOfType<String>(json, r'status'),
        expiresAt: mapDateTime(json, r'expiresAt', r''),
        autoRenewing: mapValueOfType<bool>(json, r'autoRenewing'),
        planName: mapValueOfType<String>(json, r'planName'),
      );
    }
    return null;
  }

  static List<UserSubscriptionDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserSubscriptionDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserSubscriptionDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserSubscriptionDto> mapFromJson(dynamic json) {
    final map = <String, UserSubscriptionDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserSubscriptionDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserSubscriptionDto-objects as value to a dart map
  static Map<String, List<UserSubscriptionDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserSubscriptionDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserSubscriptionDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

