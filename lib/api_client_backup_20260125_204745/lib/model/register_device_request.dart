//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RegisterDeviceRequest {
  /// Returns a new [RegisterDeviceRequest] instance.
  RegisterDeviceRequest({
    this.timeZone,
    this.deviceId,
    this.platform,
    this.pushToken,
    this.appVersion,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? timeZone;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? deviceId;

  RegisterDeviceRequestPlatformEnum? platform;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? pushToken;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? appVersion;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RegisterDeviceRequest &&
    other.timeZone == timeZone &&
    other.deviceId == deviceId &&
    other.platform == platform &&
    other.pushToken == pushToken &&
    other.appVersion == appVersion;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (timeZone == null ? 0 : timeZone!.hashCode) +
    (deviceId == null ? 0 : deviceId!.hashCode) +
    (platform == null ? 0 : platform!.hashCode) +
    (pushToken == null ? 0 : pushToken!.hashCode) +
    (appVersion == null ? 0 : appVersion!.hashCode);

  @override
  String toString() => 'RegisterDeviceRequest[timeZone=$timeZone, deviceId=$deviceId, platform=$platform, pushToken=$pushToken, appVersion=$appVersion]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.timeZone != null) {
      json[r'timeZone'] = this.timeZone;
    } else {
      json[r'timeZone'] = null;
    }
    if (this.deviceId != null) {
      json[r'deviceId'] = this.deviceId;
    } else {
      json[r'deviceId'] = null;
    }
    if (this.platform != null) {
      json[r'platform'] = this.platform;
    } else {
      json[r'platform'] = null;
    }
    if (this.pushToken != null) {
      json[r'pushToken'] = this.pushToken;
    } else {
      json[r'pushToken'] = null;
    }
    if (this.appVersion != null) {
      json[r'appVersion'] = this.appVersion;
    } else {
      json[r'appVersion'] = null;
    }
    return json;
  }

  /// Returns a new [RegisterDeviceRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RegisterDeviceRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RegisterDeviceRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RegisterDeviceRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RegisterDeviceRequest(
        timeZone: mapValueOfType<String>(json, r'timeZone'),
        deviceId: mapValueOfType<String>(json, r'deviceId'),
        platform: RegisterDeviceRequestPlatformEnum.fromJson(json[r'platform']),
        pushToken: mapValueOfType<String>(json, r'pushToken'),
        appVersion: mapValueOfType<String>(json, r'appVersion'),
      );
    }
    return null;
  }

  static List<RegisterDeviceRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegisterDeviceRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegisterDeviceRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RegisterDeviceRequest> mapFromJson(dynamic json) {
    final map = <String, RegisterDeviceRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RegisterDeviceRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RegisterDeviceRequest-objects as value to a dart map
  static Map<String, List<RegisterDeviceRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RegisterDeviceRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RegisterDeviceRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class RegisterDeviceRequestPlatformEnum {
  /// Instantiate a new enum with the provided [value].
  const RegisterDeviceRequestPlatformEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const IOS = RegisterDeviceRequestPlatformEnum._(r'IOS');
  static const ANDROID = RegisterDeviceRequestPlatformEnum._(r'ANDROID');

  /// List of all possible values in this [enum][RegisterDeviceRequestPlatformEnum].
  static const values = <RegisterDeviceRequestPlatformEnum>[
    IOS,
    ANDROID,
  ];

  static RegisterDeviceRequestPlatformEnum? fromJson(dynamic value) => RegisterDeviceRequestPlatformEnumTypeTransformer().decode(value);

  static List<RegisterDeviceRequestPlatformEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RegisterDeviceRequestPlatformEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RegisterDeviceRequestPlatformEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [RegisterDeviceRequestPlatformEnum] to String,
/// and [decode] dynamic data back to [RegisterDeviceRequestPlatformEnum].
class RegisterDeviceRequestPlatformEnumTypeTransformer {
  factory RegisterDeviceRequestPlatformEnumTypeTransformer() => _instance ??= const RegisterDeviceRequestPlatformEnumTypeTransformer._();

  const RegisterDeviceRequestPlatformEnumTypeTransformer._();

  String encode(RegisterDeviceRequestPlatformEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a RegisterDeviceRequestPlatformEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  RegisterDeviceRequestPlatformEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'IOS': return RegisterDeviceRequestPlatformEnum.IOS;
        case r'ANDROID': return RegisterDeviceRequestPlatformEnum.ANDROID;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [RegisterDeviceRequestPlatformEnumTypeTransformer] instance.
  static RegisterDeviceRequestPlatformEnumTypeTransformer? _instance;
}


