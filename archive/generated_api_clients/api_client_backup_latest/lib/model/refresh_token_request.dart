//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RefreshTokenRequest {
  /// Returns a new [RefreshTokenRequest] instance.
  RefreshTokenRequest({
    this.refreshToken,
    required this.device,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? refreshToken;

  RegisterDeviceRequest device;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RefreshTokenRequest &&
    other.refreshToken == refreshToken &&
    other.device == device;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (refreshToken == null ? 0 : refreshToken!.hashCode) +
    (device.hashCode);

  @override
  String toString() => 'RefreshTokenRequest[refreshToken=$refreshToken, device=$device]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.refreshToken != null) {
      json[r'refreshToken'] = this.refreshToken;
    } else {
      json[r'refreshToken'] = null;
    }
      json[r'device'] = this.device;
    return json;
  }

  /// Returns a new [RefreshTokenRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RefreshTokenRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RefreshTokenRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RefreshTokenRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RefreshTokenRequest(
        refreshToken: mapValueOfType<String>(json, r'refreshToken'),
        device: RegisterDeviceRequest.fromJson(json[r'device'])!,
      );
    }
    return null;
  }

  static List<RefreshTokenRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RefreshTokenRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RefreshTokenRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RefreshTokenRequest> mapFromJson(dynamic json) {
    final map = <String, RefreshTokenRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RefreshTokenRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RefreshTokenRequest-objects as value to a dart map
  static Map<String, List<RefreshTokenRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RefreshTokenRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RefreshTokenRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'device',
  };
}

