//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class LogMealRequestDto {
  /// Returns a new [LogMealRequestDto] instance.
  LogMealRequestDto({
    this.existingRecipeId,
    this.foodAnalysis,
    this.source_,
    this.mealType,
    this.servingMultiplier,
    this.loggedDate,
    this.notes,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? existingRecipeId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  FoodAnalysisDto? foodAnalysis;

  LogMealRequestDtoSource_Enum? source_;

  LogMealRequestDtoMealTypeEnum? mealType;

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
  DateTime? loggedDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? notes;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogMealRequestDto &&
          other.existingRecipeId == existingRecipeId &&
          other.foodAnalysis == foodAnalysis &&
          other.source_ == source_ &&
          other.mealType == mealType &&
          other.servingMultiplier == servingMultiplier &&
          other.loggedDate == loggedDate &&
          other.notes == notes;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (existingRecipeId == null ? 0 : existingRecipeId!.hashCode) +
      (foodAnalysis == null ? 0 : foodAnalysis!.hashCode) +
      (source_ == null ? 0 : source_!.hashCode) +
      (mealType == null ? 0 : mealType!.hashCode) +
      (servingMultiplier == null ? 0 : servingMultiplier!.hashCode) +
      (loggedDate == null ? 0 : loggedDate!.hashCode) +
      (notes == null ? 0 : notes!.hashCode);

  @override
  String toString() =>
      'LogMealRequestDto[existingRecipeId=$existingRecipeId, foodAnalysis=$foodAnalysis, source_=$source_, mealType=$mealType, servingMultiplier=$servingMultiplier, loggedDate=$loggedDate, notes=$notes]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.existingRecipeId != null) {
      json[r'existingRecipeId'] = this.existingRecipeId;
    } else {
      json[r'existingRecipeId'] = null;
    }
    if (this.foodAnalysis != null) {
      json[r'foodAnalysis'] = this.foodAnalysis;
    } else {
      json[r'foodAnalysis'] = null;
    }
    if (this.source_ != null) {
      json[r'source'] = this.source_;
    } else {
      json[r'source'] = null;
    }
    if (this.mealType != null) {
      json[r'mealType'] = this.mealType;
    } else {
      json[r'mealType'] = null;
    }
    if (this.servingMultiplier != null) {
      json[r'servingMultiplier'] = this.servingMultiplier;
    } else {
      json[r'servingMultiplier'] = null;
    }
    if (this.loggedDate != null) {
      json[r'loggedDate'] = _dateFormatter.format(this.loggedDate!.toUtc());
    } else {
      json[r'loggedDate'] = null;
    }
    if (this.notes != null) {
      json[r'notes'] = this.notes;
    } else {
      json[r'notes'] = null;
    }
    return json;
  }

  /// Returns a new [LogMealRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static LogMealRequestDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "LogMealRequestDto[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "LogMealRequestDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return LogMealRequestDto(
        existingRecipeId: mapValueOfType<String>(json, r'existingRecipeId'),
        foodAnalysis: FoodAnalysisDto.fromJson(json[r'foodAnalysis']),
        source_: LogMealRequestDtoSource_Enum.fromJson(json[r'source']),
        mealType: LogMealRequestDtoMealTypeEnum.fromJson(json[r'mealType']),
        servingMultiplier: mapValueOfType<double>(json, r'servingMultiplier'),
        loggedDate: mapDateTime(json, r'loggedDate', r''),
        notes: mapValueOfType<String>(json, r'notes'),
      );
    }
    return null;
  }

  static List<LogMealRequestDto> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <LogMealRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LogMealRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, LogMealRequestDto> mapFromJson(dynamic json) {
    final map = <String, LogMealRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = LogMealRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of LogMealRequestDto-objects as value to a dart map
  static Map<String, List<LogMealRequestDto>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<LogMealRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = LogMealRequestDto.listFromJson(
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

class LogMealRequestDtoSource_Enum {
  /// Instantiate a new enum with the provided [value].
  const LogMealRequestDtoSource_Enum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const SEARCH = LogMealRequestDtoSource_Enum._(r'SEARCH');
  static const AI_IMAGE = LogMealRequestDtoSource_Enum._(r'AI_IMAGE');
  static const BARCODE = LogMealRequestDtoSource_Enum._(r'BARCODE');
  static const NUTRITION_LABEL =
      LogMealRequestDtoSource_Enum._(r'NUTRITION_LABEL');
  static const MANUAL = LogMealRequestDtoSource_Enum._(r'MANUAL');
  static const UNKNOWN = LogMealRequestDtoSource_Enum._(r'UNKNOWN');

  /// List of all possible values in this [enum][LogMealRequestDtoSource_Enum].
  static const values = <LogMealRequestDtoSource_Enum>[
    SEARCH,
    AI_IMAGE,
    BARCODE,
    NUTRITION_LABEL,
    MANUAL,
    UNKNOWN,
  ];

  static LogMealRequestDtoSource_Enum? fromJson(dynamic value) =>
      LogMealRequestDtoSource_EnumTypeTransformer().decode(value);

  static List<LogMealRequestDtoSource_Enum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <LogMealRequestDtoSource_Enum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LogMealRequestDtoSource_Enum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [LogMealRequestDtoSource_Enum] to String,
/// and [decode] dynamic data back to [LogMealRequestDtoSource_Enum].
class LogMealRequestDtoSource_EnumTypeTransformer {
  factory LogMealRequestDtoSource_EnumTypeTransformer() =>
      _instance ??= const LogMealRequestDtoSource_EnumTypeTransformer._();

  const LogMealRequestDtoSource_EnumTypeTransformer._();

  String encode(LogMealRequestDtoSource_Enum data) => data.value;

  /// Decodes a [dynamic value][data] to a LogMealRequestDtoSource_Enum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  LogMealRequestDtoSource_Enum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'SEARCH':
          return LogMealRequestDtoSource_Enum.SEARCH;
        case r'AI_IMAGE':
          return LogMealRequestDtoSource_Enum.AI_IMAGE;
        case r'BARCODE':
          return LogMealRequestDtoSource_Enum.BARCODE;
        case r'NUTRITION_LABEL':
          return LogMealRequestDtoSource_Enum.NUTRITION_LABEL;
        case r'MANUAL':
          return LogMealRequestDtoSource_Enum.MANUAL;
        case r'UNKNOWN':
          return LogMealRequestDtoSource_Enum.UNKNOWN;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [LogMealRequestDtoSource_EnumTypeTransformer] instance.
  static LogMealRequestDtoSource_EnumTypeTransformer? _instance;
}

class LogMealRequestDtoMealTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const LogMealRequestDtoMealTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const BREAKFAST = LogMealRequestDtoMealTypeEnum._(r'BREAKFAST');
  static const LUNCH = LogMealRequestDtoMealTypeEnum._(r'LUNCH');
  static const DINNER = LogMealRequestDtoMealTypeEnum._(r'DINNER');
  static const SNACK = LogMealRequestDtoMealTypeEnum._(r'SNACK');

  /// List of all possible values in this [enum][LogMealRequestDtoMealTypeEnum].
  static const values = <LogMealRequestDtoMealTypeEnum>[
    BREAKFAST,
    LUNCH,
    DINNER,
    SNACK,
  ];

  static LogMealRequestDtoMealTypeEnum? fromJson(dynamic value) =>
      LogMealRequestDtoMealTypeEnumTypeTransformer().decode(value);

  static List<LogMealRequestDtoMealTypeEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <LogMealRequestDtoMealTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = LogMealRequestDtoMealTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [LogMealRequestDtoMealTypeEnum] to String,
/// and [decode] dynamic data back to [LogMealRequestDtoMealTypeEnum].
class LogMealRequestDtoMealTypeEnumTypeTransformer {
  factory LogMealRequestDtoMealTypeEnumTypeTransformer() =>
      _instance ??= const LogMealRequestDtoMealTypeEnumTypeTransformer._();

  const LogMealRequestDtoMealTypeEnumTypeTransformer._();

  String encode(LogMealRequestDtoMealTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a LogMealRequestDtoMealTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  LogMealRequestDtoMealTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'BREAKFAST':
          return LogMealRequestDtoMealTypeEnum.BREAKFAST;
        case r'LUNCH':
          return LogMealRequestDtoMealTypeEnum.LUNCH;
        case r'DINNER':
          return LogMealRequestDtoMealTypeEnum.DINNER;
        case r'SNACK':
          return LogMealRequestDtoMealTypeEnum.SNACK;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [LogMealRequestDtoMealTypeEnumTypeTransformer] instance.
  static LogMealRequestDtoMealTypeEnumTypeTransformer? _instance;
}
