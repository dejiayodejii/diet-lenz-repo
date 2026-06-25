//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Percentages {
  /// Returns a new [Percentages] instance.
  Percentages({
    this.protein,
    this.carbs,
    this.fat,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? protein;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? carbs;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? fat;

  @override
  bool operator ==(Object other) => identical(this, other) || other is Percentages &&
    other.protein == protein &&
    other.carbs == carbs &&
    other.fat == fat;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (protein == null ? 0 : protein!.hashCode) +
    (carbs == null ? 0 : carbs!.hashCode) +
    (fat == null ? 0 : fat!.hashCode);

  @override
  String toString() => 'Percentages[protein=$protein, carbs=$carbs, fat=$fat]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
    return json;
  }

  /// Returns a new [Percentages] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Percentages? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Percentages[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Percentages[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Percentages(
        protein: mapValueOfType<int>(json, r'protein'),
        carbs: mapValueOfType<int>(json, r'carbs'),
        fat: mapValueOfType<int>(json, r'fat'),
      );
    }
    return null;
  }

  static List<Percentages> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Percentages>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Percentages.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Percentages> mapFromJson(dynamic json) {
    final map = <String, Percentages>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Percentages.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Percentages-objects as value to a dart map
  static Map<String, List<Percentages>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Percentages>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Percentages.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

