//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class AverageMacrosDto {
  /// Returns a new [AverageMacrosDto] instance.
  AverageMacrosDto({
    this.avgCalories,
    this.avgProteinGrams,
    this.avgCarbsGrams,
    this.avgFatGrams,
    this.avgFiberGrams,
    this.avgCaloriesPercentage,
    this.avgProteinPercentage,
    this.avgCarbsPercentage,
    this.avgFatPercentage,
    this.avgFiberPercentage,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? avgCalories;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? avgProteinGrams;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? avgCarbsGrams;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? avgFatGrams;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? avgFiberGrams;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? avgCaloriesPercentage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? avgProteinPercentage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? avgCarbsPercentage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? avgFatPercentage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? avgFiberPercentage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AverageMacrosDto &&
          other.avgCalories == avgCalories &&
          other.avgProteinGrams == avgProteinGrams &&
          other.avgCarbsGrams == avgCarbsGrams &&
          other.avgFatGrams == avgFatGrams &&
          other.avgFiberGrams == avgFiberGrams &&
          other.avgCaloriesPercentage == avgCaloriesPercentage &&
          other.avgProteinPercentage == avgProteinPercentage &&
          other.avgCarbsPercentage == avgCarbsPercentage &&
          other.avgFatPercentage == avgFatPercentage &&
          other.avgFiberPercentage == avgFiberPercentage;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (avgCalories == null ? 0 : avgCalories!.hashCode) +
      (avgProteinGrams == null ? 0 : avgProteinGrams!.hashCode) +
      (avgCarbsGrams == null ? 0 : avgCarbsGrams!.hashCode) +
      (avgFatGrams == null ? 0 : avgFatGrams!.hashCode) +
      (avgFiberGrams == null ? 0 : avgFiberGrams!.hashCode) +
      (avgCaloriesPercentage == null ? 0 : avgCaloriesPercentage!.hashCode) +
      (avgProteinPercentage == null ? 0 : avgProteinPercentage!.hashCode) +
      (avgCarbsPercentage == null ? 0 : avgCarbsPercentage!.hashCode) +
      (avgFatPercentage == null ? 0 : avgFatPercentage!.hashCode) +
      (avgFiberPercentage == null ? 0 : avgFiberPercentage!.hashCode);

  @override
  String toString() =>
      'AverageMacrosDto[avgCalories=$avgCalories, avgProteinGrams=$avgProteinGrams, avgCarbsGrams=$avgCarbsGrams, avgFatGrams=$avgFatGrams, avgFiberGrams=$avgFiberGrams, avgCaloriesPercentage=$avgCaloriesPercentage, avgProteinPercentage=$avgProteinPercentage, avgCarbsPercentage=$avgCarbsPercentage, avgFatPercentage=$avgFatPercentage, avgFiberPercentage=$avgFiberPercentage]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.avgCalories != null) {
      json[r'avgCalories'] = this.avgCalories;
    } else {
      json[r'avgCalories'] = null;
    }
    if (this.avgProteinGrams != null) {
      json[r'avgProteinGrams'] = this.avgProteinGrams;
    } else {
      json[r'avgProteinGrams'] = null;
    }
    if (this.avgCarbsGrams != null) {
      json[r'avgCarbsGrams'] = this.avgCarbsGrams;
    } else {
      json[r'avgCarbsGrams'] = null;
    }
    if (this.avgFatGrams != null) {
      json[r'avgFatGrams'] = this.avgFatGrams;
    } else {
      json[r'avgFatGrams'] = null;
    }
    if (this.avgFiberGrams != null) {
      json[r'avgFiberGrams'] = this.avgFiberGrams;
    } else {
      json[r'avgFiberGrams'] = null;
    }
    if (this.avgCaloriesPercentage != null) {
      json[r'avgCaloriesPercentage'] = this.avgCaloriesPercentage;
    } else {
      json[r'avgCaloriesPercentage'] = null;
    }
    if (this.avgProteinPercentage != null) {
      json[r'avgProteinPercentage'] = this.avgProteinPercentage;
    } else {
      json[r'avgProteinPercentage'] = null;
    }
    if (this.avgCarbsPercentage != null) {
      json[r'avgCarbsPercentage'] = this.avgCarbsPercentage;
    } else {
      json[r'avgCarbsPercentage'] = null;
    }
    if (this.avgFatPercentage != null) {
      json[r'avgFatPercentage'] = this.avgFatPercentage;
    } else {
      json[r'avgFatPercentage'] = null;
    }
    if (this.avgFiberPercentage != null) {
      json[r'avgFiberPercentage'] = this.avgFiberPercentage;
    } else {
      json[r'avgFiberPercentage'] = null;
    }
    return json;
  }

  /// Returns a new [AverageMacrosDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static AverageMacrosDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "AverageMacrosDto[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "AverageMacrosDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return AverageMacrosDto(
        avgCalories: mapValueOfType<double>(json, r'avgCalories'),
        avgProteinGrams: mapValueOfType<double>(json, r'avgProteinGrams'),
        avgCarbsGrams: mapValueOfType<double>(json, r'avgCarbsGrams'),
        avgFatGrams: mapValueOfType<double>(json, r'avgFatGrams'),
        avgFiberGrams: mapValueOfType<double>(json, r'avgFiberGrams'),
        avgCaloriesPercentage:
            mapValueOfType<double>(json, r'avgCaloriesPercentage'),
        avgProteinPercentage:
            mapValueOfType<double>(json, r'avgProteinPercentage'),
        avgCarbsPercentage: mapValueOfType<double>(json, r'avgCarbsPercentage'),
        avgFatPercentage: mapValueOfType<double>(json, r'avgFatPercentage'),
        avgFiberPercentage: mapValueOfType<double>(json, r'avgFiberPercentage'),
      );
    }
    return null;
  }

  static List<AverageMacrosDto> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <AverageMacrosDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = AverageMacrosDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, AverageMacrosDto> mapFromJson(dynamic json) {
    final map = <String, AverageMacrosDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = AverageMacrosDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of AverageMacrosDto-objects as value to a dart map
  static Map<String, List<AverageMacrosDto>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<AverageMacrosDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = AverageMacrosDto.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{};
}
