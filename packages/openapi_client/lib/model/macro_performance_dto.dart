//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MacroPerformanceDto {
  /// Returns a new [MacroPerformanceDto] instance.
  MacroPerformanceDto({
    this.caloriesPercentage,
    this.proteinPercentage,
    this.carbsPercentage,
    this.fatPercentage,
    this.fiberPercentage,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? caloriesPercentage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? proteinPercentage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? carbsPercentage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? fatPercentage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? fiberPercentage;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MacroPerformanceDto &&
          other.caloriesPercentage == caloriesPercentage &&
          other.proteinPercentage == proteinPercentage &&
          other.carbsPercentage == carbsPercentage &&
          other.fatPercentage == fatPercentage &&
          other.fiberPercentage == fiberPercentage;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (caloriesPercentage == null ? 0 : caloriesPercentage!.hashCode) +
      (proteinPercentage == null ? 0 : proteinPercentage!.hashCode) +
      (carbsPercentage == null ? 0 : carbsPercentage!.hashCode) +
      (fatPercentage == null ? 0 : fatPercentage!.hashCode) +
      (fiberPercentage == null ? 0 : fiberPercentage!.hashCode);

  @override
  String toString() =>
      'MacroPerformanceDto[caloriesPercentage=$caloriesPercentage, proteinPercentage=$proteinPercentage, carbsPercentage=$carbsPercentage, fatPercentage=$fatPercentage, fiberPercentage=$fiberPercentage]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.caloriesPercentage != null) {
      json[r'caloriesPercentage'] = this.caloriesPercentage;
    } else {
      json[r'caloriesPercentage'] = null;
    }
    if (this.proteinPercentage != null) {
      json[r'proteinPercentage'] = this.proteinPercentage;
    } else {
      json[r'proteinPercentage'] = null;
    }
    if (this.carbsPercentage != null) {
      json[r'carbsPercentage'] = this.carbsPercentage;
    } else {
      json[r'carbsPercentage'] = null;
    }
    if (this.fatPercentage != null) {
      json[r'fatPercentage'] = this.fatPercentage;
    } else {
      json[r'fatPercentage'] = null;
    }
    if (this.fiberPercentage != null) {
      json[r'fiberPercentage'] = this.fiberPercentage;
    } else {
      json[r'fiberPercentage'] = null;
    }
    return json;
  }

  /// Returns a new [MacroPerformanceDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MacroPerformanceDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "MacroPerformanceDto[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "MacroPerformanceDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MacroPerformanceDto(
        caloriesPercentage: mapValueOfType<double>(json, r'caloriesPercentage'),
        proteinPercentage: mapValueOfType<double>(json, r'proteinPercentage'),
        carbsPercentage: mapValueOfType<double>(json, r'carbsPercentage'),
        fatPercentage: mapValueOfType<double>(json, r'fatPercentage'),
        fiberPercentage: mapValueOfType<double>(json, r'fiberPercentage'),
      );
    }
    return null;
  }

  static List<MacroPerformanceDto> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <MacroPerformanceDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPerformanceDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MacroPerformanceDto> mapFromJson(dynamic json) {
    final map = <String, MacroPerformanceDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MacroPerformanceDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MacroPerformanceDto-objects as value to a dart map
  static Map<String, List<MacroPerformanceDto>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<MacroPerformanceDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MacroPerformanceDto.listFromJson(
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
