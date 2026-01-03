//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MacroInfoDto {
  /// Returns a new [MacroInfoDto] instance.
  MacroInfoDto({
    this.calories,
    this.proteinGrams,
    this.carbsGrams,
    this.fatGrams,
    this.fiberGrams,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? calories;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? proteinGrams;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? carbsGrams;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? fatGrams;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? fiberGrams;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MacroInfoDto &&
    other.calories == calories &&
    other.proteinGrams == proteinGrams &&
    other.carbsGrams == carbsGrams &&
    other.fatGrams == fatGrams &&
    other.fiberGrams == fiberGrams;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (calories == null ? 0 : calories!.hashCode) +
    (proteinGrams == null ? 0 : proteinGrams!.hashCode) +
    (carbsGrams == null ? 0 : carbsGrams!.hashCode) +
    (fatGrams == null ? 0 : fatGrams!.hashCode) +
    (fiberGrams == null ? 0 : fiberGrams!.hashCode);

  @override
  String toString() => 'MacroInfoDto[calories=$calories, proteinGrams=$proteinGrams, carbsGrams=$carbsGrams, fatGrams=$fatGrams, fiberGrams=$fiberGrams]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.calories != null) {
      json[r'calories'] = this.calories;
    } else {
      json[r'calories'] = null;
    }
    if (this.proteinGrams != null) {
      json[r'proteinGrams'] = this.proteinGrams;
    } else {
      json[r'proteinGrams'] = null;
    }
    if (this.carbsGrams != null) {
      json[r'carbsGrams'] = this.carbsGrams;
    } else {
      json[r'carbsGrams'] = null;
    }
    if (this.fatGrams != null) {
      json[r'fatGrams'] = this.fatGrams;
    } else {
      json[r'fatGrams'] = null;
    }
    if (this.fiberGrams != null) {
      json[r'fiberGrams'] = this.fiberGrams;
    } else {
      json[r'fiberGrams'] = null;
    }
    return json;
  }

  /// Returns a new [MacroInfoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MacroInfoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MacroInfoDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MacroInfoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MacroInfoDto(
        calories: mapValueOfType<double>(json, r'calories'),
        proteinGrams: mapValueOfType<double>(json, r'proteinGrams'),
        carbsGrams: mapValueOfType<double>(json, r'carbsGrams'),
        fatGrams: mapValueOfType<double>(json, r'fatGrams'),
        fiberGrams: mapValueOfType<double>(json, r'fiberGrams'),
      );
    }
    return null;
  }

  static List<MacroInfoDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroInfoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroInfoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MacroInfoDto> mapFromJson(dynamic json) {
    final map = <String, MacroInfoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MacroInfoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MacroInfoDto-objects as value to a dart map
  static Map<String, List<MacroInfoDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MacroInfoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MacroInfoDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

