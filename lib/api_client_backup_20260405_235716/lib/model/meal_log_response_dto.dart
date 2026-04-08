//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MealLogResponseDto {
  /// Returns a new [MealLogResponseDto] instance.
  MealLogResponseDto({
    this.id,
    this.recipeId,
    this.foodName,
    this.mealType,
    this.loggedDate,
    this.loggedTime,
    this.servingMultiplier,
    this.consumedMacros,
    this.notes,
    this.isFavorite,
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
  String? recipeId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? foodName;

  MealLogResponseDtoMealTypeEnum? mealType;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? loggedDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? loggedTime;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? servingMultiplier;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  ConsumedMacrosDto? consumedMacros;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? notes;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isFavorite;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MealLogResponseDto &&
    other.id == id &&
    other.recipeId == recipeId &&
    other.foodName == foodName &&
    other.mealType == mealType &&
    other.loggedDate == loggedDate &&
    other.loggedTime == loggedTime &&
    other.servingMultiplier == servingMultiplier &&
    other.consumedMacros == consumedMacros &&
    other.notes == notes &&
    other.isFavorite == isFavorite;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (recipeId == null ? 0 : recipeId!.hashCode) +
    (foodName == null ? 0 : foodName!.hashCode) +
    (mealType == null ? 0 : mealType!.hashCode) +
    (loggedDate == null ? 0 : loggedDate!.hashCode) +
    (loggedTime == null ? 0 : loggedTime!.hashCode) +
    (servingMultiplier == null ? 0 : servingMultiplier!.hashCode) +
    (consumedMacros == null ? 0 : consumedMacros!.hashCode) +
    (notes == null ? 0 : notes!.hashCode) +
    (isFavorite == null ? 0 : isFavorite!.hashCode);

  @override
  String toString() => 'MealLogResponseDto[id=$id, recipeId=$recipeId, foodName=$foodName, mealType=$mealType, loggedDate=$loggedDate, loggedTime=$loggedTime, servingMultiplier=$servingMultiplier, consumedMacros=$consumedMacros, notes=$notes, isFavorite=$isFavorite]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
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
    if (this.mealType != null) {
      json[r'mealType'] = this.mealType;
    } else {
      json[r'mealType'] = null;
    }
    if (this.loggedDate != null) {
      json[r'loggedDate'] = _dateFormatter.format(this.loggedDate!.toUtc());
    } else {
      json[r'loggedDate'] = null;
    }
    if (this.loggedTime != null) {
      json[r'loggedTime'] = this.loggedTime;
    } else {
      json[r'loggedTime'] = null;
    }
    if (this.servingMultiplier != null) {
      json[r'servingMultiplier'] = this.servingMultiplier;
    } else {
      json[r'servingMultiplier'] = null;
    }
    if (this.consumedMacros != null) {
      json[r'consumedMacros'] = this.consumedMacros;
    } else {
      json[r'consumedMacros'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    if (this.isFavorite != null) {
      json[r'isFavorite'] = this.isFavorite;
    } else {
      json[r'isFavorite'] = null;
    }
    return json;
  }

  /// Returns a new [MealLogResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MealLogResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MealLogResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MealLogResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MealLogResponseDto(
        id: mapValueOfType<String>(json, r'id'),
        recipeId: mapValueOfType<String>(json, r'recipeId'),
        foodName: mapValueOfType<String>(json, r'foodName'),
        mealType: MealLogResponseDtoMealTypeEnum.fromJson(json[r'mealType']),
        loggedDate: mapDateTime(json, r'loggedDate', r''),
        loggedTime: mapValueOfType<String>(json, r'loggedTime'),
        servingMultiplier: mapValueOfType<double>(json, r'servingMultiplier'),
        consumedMacros: ConsumedMacrosDto.fromJson(json[r'consumedMacros']),
        notes: mapValueOfType<String>(json, r'notes'),
        isFavorite: mapValueOfType<bool>(json, r'isFavorite'),
      );
    }
    return null;
  }

  static List<MealLogResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MealLogResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MealLogResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MealLogResponseDto> mapFromJson(dynamic json) {
    final map = <String, MealLogResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MealLogResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MealLogResponseDto-objects as value to a dart map
  static Map<String, List<MealLogResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MealLogResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MealLogResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class MealLogResponseDtoMealTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const MealLogResponseDtoMealTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const BREAKFAST = MealLogResponseDtoMealTypeEnum._(r'BREAKFAST');
  static const LUNCH = MealLogResponseDtoMealTypeEnum._(r'LUNCH');
  static const DINNER = MealLogResponseDtoMealTypeEnum._(r'DINNER');
  static const SNACK = MealLogResponseDtoMealTypeEnum._(r'SNACK');

  /// List of all possible values in this [enum][MealLogResponseDtoMealTypeEnum].
  static const values = <MealLogResponseDtoMealTypeEnum>[
    BREAKFAST,
    LUNCH,
    DINNER,
    SNACK,
  ];

  static MealLogResponseDtoMealTypeEnum? fromJson(dynamic value) => MealLogResponseDtoMealTypeEnumTypeTransformer().decode(value);

  static List<MealLogResponseDtoMealTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MealLogResponseDtoMealTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MealLogResponseDtoMealTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MealLogResponseDtoMealTypeEnum] to String,
/// and [decode] dynamic data back to [MealLogResponseDtoMealTypeEnum].
class MealLogResponseDtoMealTypeEnumTypeTransformer {
  factory MealLogResponseDtoMealTypeEnumTypeTransformer() => _instance ??= const MealLogResponseDtoMealTypeEnumTypeTransformer._();

  const MealLogResponseDtoMealTypeEnumTypeTransformer._();

  String encode(MealLogResponseDtoMealTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MealLogResponseDtoMealTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MealLogResponseDtoMealTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'BREAKFAST': return MealLogResponseDtoMealTypeEnum.BREAKFAST;
        case r'LUNCH': return MealLogResponseDtoMealTypeEnum.LUNCH;
        case r'DINNER': return MealLogResponseDtoMealTypeEnum.DINNER;
        case r'SNACK': return MealLogResponseDtoMealTypeEnum.SNACK;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MealLogResponseDtoMealTypeEnumTypeTransformer] instance.
  static MealLogResponseDtoMealTypeEnumTypeTransformer? _instance;
}


