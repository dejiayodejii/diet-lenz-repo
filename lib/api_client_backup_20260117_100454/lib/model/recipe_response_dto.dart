//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class RecipeResponseDto {
  /// Returns a new [RecipeResponseDto] instance.
  RecipeResponseDto({
    this.id,
    this.foodName,
    this.description,
    this.macros,
    this.imageUrl,
    this.usageCount,
    this.isFavorite,
    this.createdAt,
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
  String? foodName;

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
  MacroInfoDto? macros;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? imageUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? usageCount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isFavorite;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is RecipeResponseDto &&
    other.id == id &&
    other.foodName == foodName &&
    other.description == description &&
    other.macros == macros &&
    other.imageUrl == imageUrl &&
    other.usageCount == usageCount &&
    other.isFavorite == isFavorite &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (foodName == null ? 0 : foodName!.hashCode) +
    (description == null ? 0 : description!.hashCode) +
    (macros == null ? 0 : macros!.hashCode) +
    (imageUrl == null ? 0 : imageUrl!.hashCode) +
    (usageCount == null ? 0 : usageCount!.hashCode) +
    (isFavorite == null ? 0 : isFavorite!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'RecipeResponseDto[id=$id, foodName=$foodName, description=$description, macros=$macros, imageUrl=$imageUrl, usageCount=$usageCount, isFavorite=$isFavorite, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
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
    if (this.macros != null) {
      json[r'macros'] = this.macros;
    } else {
      json[r'macros'] = null;
    }
    if (this.imageUrl != null) {
      json[r'imageUrl'] = this.imageUrl;
    } else {
      json[r'imageUrl'] = null;
    }
    if (this.usageCount != null) {
      json[r'usageCount'] = this.usageCount;
    } else {
      json[r'usageCount'] = null;
    }
    if (this.isFavorite != null) {
      json[r'isFavorite'] = this.isFavorite;
    } else {
      json[r'isFavorite'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'createdAt'] = null;
    }
    return json;
  }

  /// Returns a new [RecipeResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static RecipeResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "RecipeResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "RecipeResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return RecipeResponseDto(
        id: mapValueOfType<String>(json, r'id'),
        foodName: mapValueOfType<String>(json, r'foodName'),
        description: mapValueOfType<String>(json, r'description'),
        macros: MacroInfoDto.fromJson(json[r'macros']),
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        usageCount: mapValueOfType<int>(json, r'usageCount'),
        isFavorite: mapValueOfType<bool>(json, r'isFavorite'),
        createdAt: mapDateTime(json, r'createdAt', r''),
      );
    }
    return null;
  }

  static List<RecipeResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <RecipeResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = RecipeResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, RecipeResponseDto> mapFromJson(dynamic json) {
    final map = <String, RecipeResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = RecipeResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of RecipeResponseDto-objects as value to a dart map
  static Map<String, List<RecipeResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<RecipeResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = RecipeResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

