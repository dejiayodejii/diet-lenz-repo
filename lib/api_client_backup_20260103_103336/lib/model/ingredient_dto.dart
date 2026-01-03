//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class IngredientDto {
  /// Returns a new [IngredientDto] instance.
  IngredientDto({
    this.name,
    this.quantity,
    this.unit,
    this.macros,
  });

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
  double? quantity;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? unit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MacroNutrientsDto? macros;

  @override
  bool operator ==(Object other) => identical(this, other) || other is IngredientDto &&
    other.name == name &&
    other.quantity == quantity &&
    other.unit == unit &&
    other.macros == macros;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (name == null ? 0 : name!.hashCode) +
    (quantity == null ? 0 : quantity!.hashCode) +
    (unit == null ? 0 : unit!.hashCode) +
    (macros == null ? 0 : macros!.hashCode);

  @override
  String toString() => 'IngredientDto[name=$name, quantity=$quantity, unit=$unit, macros=$macros]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.name != null) {
      json[r'name'] = this.name;
    } else {
      json[r'name'] = null;
    }
    if (this.quantity != null) {
      json[r'quantity'] = this.quantity;
    } else {
      json[r'quantity'] = null;
    }
    if (this.unit != null) {
      json[r'unit'] = this.unit;
    } else {
      json[r'unit'] = null;
    }
    if (this.macros != null) {
      json[r'macros'] = this.macros;
    } else {
      json[r'macros'] = null;
    }
    return json;
  }

  /// Returns a new [IngredientDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static IngredientDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "IngredientDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "IngredientDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return IngredientDto(
        name: mapValueOfType<String>(json, r'name'),
        quantity: mapValueOfType<double>(json, r'quantity'),
        unit: mapValueOfType<String>(json, r'unit'),
        macros: MacroNutrientsDto.fromJson(json[r'macros']),
      );
    }
    return null;
  }

  static List<IngredientDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <IngredientDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = IngredientDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, IngredientDto> mapFromJson(dynamic json) {
    final map = <String, IngredientDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = IngredientDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of IngredientDto-objects as value to a dart map
  static Map<String, List<IngredientDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<IngredientDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = IngredientDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

