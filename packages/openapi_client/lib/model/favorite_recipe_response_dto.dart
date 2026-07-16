//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class FavoriteRecipeResponseDto {
  /// Returns a new [FavoriteRecipeResponseDto] instance.
  FavoriteRecipeResponseDto({
    this.recipeId,
    this.foodName,
    this.description,
    this.macros,
    this.imageUrl,
    this.usageCount,
    this.favoritedAt,
    this.lastLoggedAt,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? recipeId;

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
  DateTime? favoritedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? lastLoggedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteRecipeResponseDto &&
          other.recipeId == recipeId &&
          other.foodName == foodName &&
          other.description == description &&
          other.macros == macros &&
          other.imageUrl == imageUrl &&
          other.usageCount == usageCount &&
          other.favoritedAt == favoritedAt &&
          other.lastLoggedAt == lastLoggedAt;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (recipeId == null ? 0 : recipeId!.hashCode) +
      (foodName == null ? 0 : foodName!.hashCode) +
      (description == null ? 0 : description!.hashCode) +
      (macros == null ? 0 : macros!.hashCode) +
      (imageUrl == null ? 0 : imageUrl!.hashCode) +
      (usageCount == null ? 0 : usageCount!.hashCode) +
      (favoritedAt == null ? 0 : favoritedAt!.hashCode) +
      (lastLoggedAt == null ? 0 : lastLoggedAt!.hashCode);

  @override
  String toString() =>
      'FavoriteRecipeResponseDto[recipeId=$recipeId, foodName=$foodName, description=$description, macros=$macros, imageUrl=$imageUrl, usageCount=$usageCount, favoritedAt=$favoritedAt, lastLoggedAt=$lastLoggedAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.recipeId != null) {
      json[r'recipeId'] = this.recipeId;
    } else {
      json[r'recipeId'] = null;
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
    if (this.favoritedAt != null) {
      json[r'favoritedAt'] = this.favoritedAt!.toUtc().toIso8601String();
    } else {
      json[r'favoritedAt'] = null;
    }
    if (this.lastLoggedAt != null) {
      json[r'lastLoggedAt'] = this.lastLoggedAt!.toUtc().toIso8601String();
    } else {
      json[r'lastLoggedAt'] = null;
    }
    return json;
  }

  /// Returns a new [FavoriteRecipeResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static FavoriteRecipeResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "FavoriteRecipeResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "FavoriteRecipeResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return FavoriteRecipeResponseDto(
        recipeId: mapValueOfType<String>(json, r'recipeId'),
        foodName: mapValueOfType<String>(json, r'foodName'),
        description: mapValueOfType<String>(json, r'description'),
        macros: MacroInfoDto.fromJson(json[r'macros']),
        imageUrl: mapValueOfType<String>(json, r'imageUrl'),
        usageCount: mapValueOfType<int>(json, r'usageCount'),
        favoritedAt: mapDateTime(json, r'favoritedAt', r''),
        lastLoggedAt: mapDateTime(json, r'lastLoggedAt', r''),
      );
    }
    return null;
  }

  static List<FavoriteRecipeResponseDto> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <FavoriteRecipeResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = FavoriteRecipeResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, FavoriteRecipeResponseDto> mapFromJson(dynamic json) {
    final map = <String, FavoriteRecipeResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = FavoriteRecipeResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of FavoriteRecipeResponseDto-objects as value to a dart map
  static Map<String, List<FavoriteRecipeResponseDto>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<FavoriteRecipeResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = FavoriteRecipeResponseDto.listFromJson(
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
