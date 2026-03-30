//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class SubscriptionPlanDto {
  /// Returns a new [SubscriptionPlanDto] instance.
  SubscriptionPlanDto({
    this.id,
    this.name,
    this.priceDisplay,
    this.description,
    this.platform,
    this.countryCode,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? name;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? priceDisplay;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? platform;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? countryCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is SubscriptionPlanDto &&
    other.id == id &&
    other.name == name &&
    other.priceDisplay == priceDisplay &&
    other.description == description &&
    other.platform == platform &&
    other.countryCode == countryCode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (name == null ? 0 : name!.hashCode) +
    (priceDisplay == null ? 0 : priceDisplay!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (platform == null ? 0 : platform!.hashCode) +
    (countryCode == null ? 0 : countryCode!.hashCode);

  @override
  String toString() => 'SubscriptionPlanDto[id=$id, name=$name, priceDisplay=$priceDisplay, description=$description, platform=$platform, countryCode=$countryCode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.priceDisplay != null) {
      json[r'priceDisplay'] = this.priceDisplay;
    } else {
      json[r'priceDisplay'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
    if (this.platform != null) {
      json[r'platform'] = this.platform;
    } else {
      json[r'platform'] = null;
    }
    if (this.countryCode != null) {
      json[r'countryCode'] = this.countryCode;
    } else {
      json[r'countryCode'] = null;
    }
    return json;
  }

  /// Returns a new [SubscriptionPlanDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static SubscriptionPlanDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "SubscriptionPlanDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "SubscriptionPlanDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return SubscriptionPlanDto(
        id: mapValueOfType<String>(json, r'id'),
        name: mapValueOfType<String>(json, r'name'),
        priceDisplay: mapValueOfType<String>(json, r'priceDisplay'),
        description: mapValueOfType<String>(json, r'description'),
        platform: mapValueOfType<String>(json, r'platform'),
        countryCode: mapValueOfType<String>(json, r'countryCode'),
      );
    }
    return null;
  }

  static List<SubscriptionPlanDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <SubscriptionPlanDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = SubscriptionPlanDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, SubscriptionPlanDto> mapFromJson(dynamic json) {
    final map = <String, SubscriptionPlanDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = SubscriptionPlanDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of SubscriptionPlanDto-objects as value to a dart map
  static Map<String, List<SubscriptionPlanDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<SubscriptionPlanDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = SubscriptionPlanDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

