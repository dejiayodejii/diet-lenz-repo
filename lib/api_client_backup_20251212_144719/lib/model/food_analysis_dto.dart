//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FoodAnalysisDto {
  /// Returns a new [FoodAnalysisDto] instance.
  FoodAnalysisDto({
    this.foodName,
    this.description,
    this.ingredients = const [],
    this.totalMacros,
    this.recipeSteps = const [],
    this.imageBase64,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? foodName;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? description;

  List<IngredientDto> ingredients;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MacroNutrientsDto? totalMacros;

  List<String> recipeSteps;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? imageBase64;

  @override
  bool operator ==(Object other) => identical(this, other) || other is FoodAnalysisDto &&
    other.foodName == foodName &&
    other.description == description &&
    _deepEquality.equals(other.ingredients, ingredients) &&
    other.totalMacros == totalMacros &&
    _deepEquality.equals(other.recipeSteps, recipeSteps) &&
    other.imageBase64 == imageBase64;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (foodName == null ? 0 : foodName!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (ingredients.hashCode) +
    (totalMacros == null ? 0 : totalMacros!.hashCode) +
    (recipeSteps.hashCode) +
    (imageBase64 == null ? 0 : imageBase64!.hashCode);

  @override
  String toString() => 'FoodAnalysisDto[foodName=$foodName, description=$description, ingredients=$ingredients, totalMacros=$totalMacros, recipeSteps=$recipeSteps, imageBase64=$imageBase64]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.foodName != null) {
      json[r'foodName'] = this.foodName;
    } else {
      json[r'foodName'] = null;
    }
    if (this.description != null) {
      json[r'description'] = this.description;
    } else {
      json[r'description'] = null;
    }
      json[r'ingredients'] = this.ingredients;
    if (this.totalMacros != null) {
      json[r'totalMacros'] = this.totalMacros;
    } else {
      json[r'totalMacros'] = null;
    }
      json[r'recipeSteps'] = this.recipeSteps;
    if (this.imageBase64 != null) {
      json[r'imageBase64'] = this.imageBase64;
    } else {
      json[r'imageBase64'] = null;
    }
    return json;
  }

  /// Returns a new [FoodAnalysisDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FoodAnalysisDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "FoodAnalysisDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "FoodAnalysisDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FoodAnalysisDto(
        foodName: mapValueOfType<String>(json, r'foodName'),
        description: mapValueOfType<String>(json, r'description'),
        ingredients: IngredientDto.listFromJson(json[r'ingredients']),
        totalMacros: MacroNutrientsDto.fromJson(json[r'totalMacros']),
        recipeSteps: json[r'recipeSteps'] is Iterable
            ? (json[r'recipeSteps'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        imageBase64: mapValueOfType<String>(json, r'imageBase64'),
      );
    }
    return null;
  }

  static List<FoodAnalysisDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <FoodAnalysisDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FoodAnalysisDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FoodAnalysisDto> mapFromJson(dynamic json) {
    final map = <String, FoodAnalysisDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FoodAnalysisDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FoodAnalysisDto-objects as value to a dart map
  static Map<String, List<FoodAnalysisDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<FoodAnalysisDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FoodAnalysisDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

