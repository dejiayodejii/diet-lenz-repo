//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MacroNutrientsDto {
  /// Returns a new [MacroNutrientsDto] instance.
  MacroNutrientsDto({
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.fiber,
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
  QuantityDto? protein;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  QuantityDto? carbs;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  QuantityDto? fat;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  QuantityDto? fiber;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MacroNutrientsDto &&
    other.calories == calories &&
    other.protein == protein &&
    other.carbs == carbs &&
    other.fat == fat &&
    other.fiber == fiber;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (calories == null ? 0 : calories!.hashCode) +
    (protein == null ? 0 : protein!.hashCode) +
    (carbs == null ? 0 : carbs!.hashCode) +
    (fat == null ? 0 : fat!.hashCode) +
    (fiber == null ? 0 : fiber!.hashCode);

  @override
  String toString() => 'MacroNutrientsDto[calories=$calories, protein=$protein, carbs=$carbs, fat=$fat, fiber=$fiber]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.calories != null) {
      json[r'calories'] = this.calories;
    } else {
      json[r'calories'] = null;
    }
    if (this.protein != null) {
      json[r'protein'] = this.protein;
    } else {
      json[r'protein'] = null;
    }
    if (this.carbs != null) {
      json[r'carbs'] = this.carbs;
    } else {
      json[r'carbs'] = null;
    }
    if (this.fat != null) {
      json[r'fat'] = this.fat;
    } else {
      json[r'fat'] = null;
    }
    if (this.fiber != null) {
      json[r'fiber'] = this.fiber;
    } else {
      json[r'fiber'] = null;
    }
    return json;
  }

  /// Returns a new [MacroNutrientsDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MacroNutrientsDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MacroNutrientsDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MacroNutrientsDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MacroNutrientsDto(
        calories: mapValueOfType<double>(json, r'calories'),
        protein: QuantityDto.fromJson(json[r'protein']),
        carbs: QuantityDto.fromJson(json[r'carbs']),
        fat: QuantityDto.fromJson(json[r'fat']),
        fiber: QuantityDto.fromJson(json[r'fiber']),
      );
    }
    return null;
  }

  static List<MacroNutrientsDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroNutrientsDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroNutrientsDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MacroNutrientsDto> mapFromJson(dynamic json) {
    final map = <String, MacroNutrientsDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MacroNutrientsDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MacroNutrientsDto-objects as value to a dart map
  static Map<String, List<MacroNutrientsDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MacroNutrientsDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MacroNutrientsDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

