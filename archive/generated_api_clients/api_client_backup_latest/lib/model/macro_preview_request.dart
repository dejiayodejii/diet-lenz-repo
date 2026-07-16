//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MacroPreviewRequest {
  /// Returns a new [MacroPreviewRequest] instance.
  MacroPreviewRequest({
    required this.gender,
    required this.dateOfBirth,
    required this.height,
    required this.heightUnit,
    required this.currentWeight,
    required this.currentWeightUnit,
    required this.activityLevel,
    required this.desiredGoal,
    required this.desiredWeight,
    required this.desiredWeightUnit,
    required this.goalPace,
    this.macroTarget,
    this.targetEvent,
    this.targetEventDate,
  });

  MacroPreviewRequestGenderEnum gender;

  DateTime dateOfBirth;

  num height;

  MacroPreviewRequestHeightUnitEnum heightUnit;

  int currentWeight;

  MacroPreviewRequestCurrentWeightUnitEnum currentWeightUnit;

  MacroPreviewRequestActivityLevelEnum activityLevel;

  MacroPreviewRequestDesiredGoalEnum desiredGoal;

  int desiredWeight;

  MacroPreviewRequestDesiredWeightUnitEnum desiredWeightUnit;

  MacroPreviewRequestGoalPaceEnum goalPace;

  MacroPreviewRequestMacroTargetEnum? macroTarget;

  MacroPreviewRequestTargetEventEnum? targetEvent;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? targetEventDate;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MacroPreviewRequest &&
    other.gender == gender &&
    other.dateOfBirth == dateOfBirth &&
    other.height == height &&
    other.heightUnit == heightUnit &&
    other.currentWeight == currentWeight &&
    other.currentWeightUnit == currentWeightUnit &&
    other.activityLevel == activityLevel &&
    other.desiredGoal == desiredGoal &&
    other.desiredWeight == desiredWeight &&
    other.desiredWeightUnit == desiredWeightUnit &&
    other.goalPace == goalPace &&
    other.macroTarget == macroTarget &&
    other.targetEvent == targetEvent &&
    other.targetEventDate == targetEventDate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (gender.hashCode) +
    (dateOfBirth.hashCode) +
    (height.hashCode) +
    (heightUnit.hashCode) +
    (currentWeight.hashCode) +
    (currentWeightUnit.hashCode) +
    (activityLevel.hashCode) +
    (desiredGoal.hashCode) +
    (desiredWeight.hashCode) +
    (desiredWeightUnit.hashCode) +
    (goalPace.hashCode) +
    (macroTarget == null ? 0 : macroTarget!.hashCode) +
    (targetEvent == null ? 0 : targetEvent!.hashCode) +
    (targetEventDate == null ? 0 : targetEventDate!.hashCode);

  @override
  String toString() => 'MacroPreviewRequest[gender=$gender, dateOfBirth=$dateOfBirth, height=$height, heightUnit=$heightUnit, currentWeight=$currentWeight, currentWeightUnit=$currentWeightUnit, activityLevel=$activityLevel, desiredGoal=$desiredGoal, desiredWeight=$desiredWeight, desiredWeightUnit=$desiredWeightUnit, goalPace=$goalPace, macroTarget=$macroTarget, targetEvent=$targetEvent, targetEventDate=$targetEventDate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'gender'] = this.gender;
      json[r'dateOfBirth'] = _dateFormatter.format(this.dateOfBirth.toUtc());
      json[r'height'] = this.height;
      json[r'heightUnit'] = this.heightUnit;
      json[r'currentWeight'] = this.currentWeight;
      json[r'currentWeightUnit'] = this.currentWeightUnit;
      json[r'activityLevel'] = this.activityLevel;
      json[r'desiredGoal'] = this.desiredGoal;
      json[r'desiredWeight'] = this.desiredWeight;
      json[r'desiredWeightUnit'] = this.desiredWeightUnit;
      json[r'goalPace'] = this.goalPace;
    if (this.macroTarget != null) {
      json[r'macroTarget'] = this.macroTarget;
    } else {
      json[r'macroTarget'] = null;
    }
    if (this.targetEvent != null) {
      json[r'targetEvent'] = this.targetEvent;
    } else {
      json[r'targetEvent'] = null;
    }
    if (this.targetEventDate != null) {
      json[r'targetEventDate'] = _dateFormatter.format(this.targetEventDate!.toUtc());
    } else {
      json[r'targetEventDate'] = null;
    }
    return json;
  }

  /// Returns a new [MacroPreviewRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MacroPreviewRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MacroPreviewRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MacroPreviewRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MacroPreviewRequest(
        gender: MacroPreviewRequestGenderEnum.fromJson(json[r'gender'])!,
        dateOfBirth: mapDateTime(json, r'dateOfBirth', r'')!,
        height: num.parse('${json[r'height']}'),
        heightUnit: MacroPreviewRequestHeightUnitEnum.fromJson(json[r'heightUnit'])!,
        currentWeight: mapValueOfType<int>(json, r'currentWeight')!,
        currentWeightUnit: MacroPreviewRequestCurrentWeightUnitEnum.fromJson(json[r'currentWeightUnit'])!,
        activityLevel: MacroPreviewRequestActivityLevelEnum.fromJson(json[r'activityLevel'])!,
        desiredGoal: MacroPreviewRequestDesiredGoalEnum.fromJson(json[r'desiredGoal'])!,
        desiredWeight: mapValueOfType<int>(json, r'desiredWeight')!,
        desiredWeightUnit: MacroPreviewRequestDesiredWeightUnitEnum.fromJson(json[r'desiredWeightUnit'])!,
        goalPace: MacroPreviewRequestGoalPaceEnum.fromJson(json[r'goalPace'])!,
        macroTarget: MacroPreviewRequestMacroTargetEnum.fromJson(json[r'macroTarget']),
        targetEvent: MacroPreviewRequestTargetEventEnum.fromJson(json[r'targetEvent']),
        targetEventDate: mapDateTime(json, r'targetEventDate', r''),
      );
    }
    return null;
  }

  static List<MacroPreviewRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroPreviewRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPreviewRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MacroPreviewRequest> mapFromJson(dynamic json) {
    final map = <String, MacroPreviewRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MacroPreviewRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MacroPreviewRequest-objects as value to a dart map
  static Map<String, List<MacroPreviewRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MacroPreviewRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MacroPreviewRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'gender',
    'dateOfBirth',
    'height',
    'heightUnit',
    'currentWeight',
    'currentWeightUnit',
    'activityLevel',
    'desiredGoal',
    'desiredWeight',
    'desiredWeightUnit',
    'goalPace',
  };
}


class MacroPreviewRequestGenderEnum {
  /// Instantiate a new enum with the provided [value].
  const MacroPreviewRequestGenderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MALE = MacroPreviewRequestGenderEnum._(r'MALE');
  static const FEMALE = MacroPreviewRequestGenderEnum._(r'FEMALE');
  static const OTHER = MacroPreviewRequestGenderEnum._(r'OTHER');

  /// List of all possible values in this [enum][MacroPreviewRequestGenderEnum].
  static const values = <MacroPreviewRequestGenderEnum>[
    MALE,
    FEMALE,
    OTHER,
  ];

  static MacroPreviewRequestGenderEnum? fromJson(dynamic value) => MacroPreviewRequestGenderEnumTypeTransformer().decode(value);

  static List<MacroPreviewRequestGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroPreviewRequestGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPreviewRequestGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MacroPreviewRequestGenderEnum] to String,
/// and [decode] dynamic data back to [MacroPreviewRequestGenderEnum].
class MacroPreviewRequestGenderEnumTypeTransformer {
  factory MacroPreviewRequestGenderEnumTypeTransformer() => _instance ??= const MacroPreviewRequestGenderEnumTypeTransformer._();

  const MacroPreviewRequestGenderEnumTypeTransformer._();

  String encode(MacroPreviewRequestGenderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MacroPreviewRequestGenderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MacroPreviewRequestGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MALE': return MacroPreviewRequestGenderEnum.MALE;
        case r'FEMALE': return MacroPreviewRequestGenderEnum.FEMALE;
        case r'OTHER': return MacroPreviewRequestGenderEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MacroPreviewRequestGenderEnumTypeTransformer] instance.
  static MacroPreviewRequestGenderEnumTypeTransformer? _instance;
}



class MacroPreviewRequestHeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const MacroPreviewRequestHeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const CM = MacroPreviewRequestHeightUnitEnum._(r'CM');
  static const FT = MacroPreviewRequestHeightUnitEnum._(r'FT');

  /// List of all possible values in this [enum][MacroPreviewRequestHeightUnitEnum].
  static const values = <MacroPreviewRequestHeightUnitEnum>[
    CM,
    FT,
  ];

  static MacroPreviewRequestHeightUnitEnum? fromJson(dynamic value) => MacroPreviewRequestHeightUnitEnumTypeTransformer().decode(value);

  static List<MacroPreviewRequestHeightUnitEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroPreviewRequestHeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPreviewRequestHeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MacroPreviewRequestHeightUnitEnum] to String,
/// and [decode] dynamic data back to [MacroPreviewRequestHeightUnitEnum].
class MacroPreviewRequestHeightUnitEnumTypeTransformer {
  factory MacroPreviewRequestHeightUnitEnumTypeTransformer() => _instance ??= const MacroPreviewRequestHeightUnitEnumTypeTransformer._();

  const MacroPreviewRequestHeightUnitEnumTypeTransformer._();

  String encode(MacroPreviewRequestHeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MacroPreviewRequestHeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MacroPreviewRequestHeightUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'CM': return MacroPreviewRequestHeightUnitEnum.CM;
        case r'FT': return MacroPreviewRequestHeightUnitEnum.FT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MacroPreviewRequestHeightUnitEnumTypeTransformer] instance.
  static MacroPreviewRequestHeightUnitEnumTypeTransformer? _instance;
}



class MacroPreviewRequestCurrentWeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const MacroPreviewRequestCurrentWeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const KG = MacroPreviewRequestCurrentWeightUnitEnum._(r'KG');
  static const POUNDS = MacroPreviewRequestCurrentWeightUnitEnum._(r'POUNDS');

  /// List of all possible values in this [enum][MacroPreviewRequestCurrentWeightUnitEnum].
  static const values = <MacroPreviewRequestCurrentWeightUnitEnum>[
    KG,
    POUNDS,
  ];

  static MacroPreviewRequestCurrentWeightUnitEnum? fromJson(dynamic value) => MacroPreviewRequestCurrentWeightUnitEnumTypeTransformer().decode(value);

  static List<MacroPreviewRequestCurrentWeightUnitEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroPreviewRequestCurrentWeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPreviewRequestCurrentWeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MacroPreviewRequestCurrentWeightUnitEnum] to String,
/// and [decode] dynamic data back to [MacroPreviewRequestCurrentWeightUnitEnum].
class MacroPreviewRequestCurrentWeightUnitEnumTypeTransformer {
  factory MacroPreviewRequestCurrentWeightUnitEnumTypeTransformer() => _instance ??= const MacroPreviewRequestCurrentWeightUnitEnumTypeTransformer._();

  const MacroPreviewRequestCurrentWeightUnitEnumTypeTransformer._();

  String encode(MacroPreviewRequestCurrentWeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MacroPreviewRequestCurrentWeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MacroPreviewRequestCurrentWeightUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'KG': return MacroPreviewRequestCurrentWeightUnitEnum.KG;
        case r'POUNDS': return MacroPreviewRequestCurrentWeightUnitEnum.POUNDS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MacroPreviewRequestCurrentWeightUnitEnumTypeTransformer] instance.
  static MacroPreviewRequestCurrentWeightUnitEnumTypeTransformer? _instance;
}



class MacroPreviewRequestActivityLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const MacroPreviewRequestActivityLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const SEDENTARY = MacroPreviewRequestActivityLevelEnum._(r'SEDENTARY');
  static const LIGHTLY_ACTIVE = MacroPreviewRequestActivityLevelEnum._(r'LIGHTLY_ACTIVE');
  static const MODERATELY_ACTIVE = MacroPreviewRequestActivityLevelEnum._(r'MODERATELY_ACTIVE');
  static const VERY_ACTIVE = MacroPreviewRequestActivityLevelEnum._(r'VERY_ACTIVE');
  static const EXTRA_ACTIVE = MacroPreviewRequestActivityLevelEnum._(r'EXTRA_ACTIVE');

  /// List of all possible values in this [enum][MacroPreviewRequestActivityLevelEnum].
  static const values = <MacroPreviewRequestActivityLevelEnum>[
    SEDENTARY,
    LIGHTLY_ACTIVE,
    MODERATELY_ACTIVE,
    VERY_ACTIVE,
    EXTRA_ACTIVE,
  ];

  static MacroPreviewRequestActivityLevelEnum? fromJson(dynamic value) => MacroPreviewRequestActivityLevelEnumTypeTransformer().decode(value);

  static List<MacroPreviewRequestActivityLevelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroPreviewRequestActivityLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPreviewRequestActivityLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MacroPreviewRequestActivityLevelEnum] to String,
/// and [decode] dynamic data back to [MacroPreviewRequestActivityLevelEnum].
class MacroPreviewRequestActivityLevelEnumTypeTransformer {
  factory MacroPreviewRequestActivityLevelEnumTypeTransformer() => _instance ??= const MacroPreviewRequestActivityLevelEnumTypeTransformer._();

  const MacroPreviewRequestActivityLevelEnumTypeTransformer._();

  String encode(MacroPreviewRequestActivityLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MacroPreviewRequestActivityLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MacroPreviewRequestActivityLevelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'SEDENTARY': return MacroPreviewRequestActivityLevelEnum.SEDENTARY;
        case r'LIGHTLY_ACTIVE': return MacroPreviewRequestActivityLevelEnum.LIGHTLY_ACTIVE;
        case r'MODERATELY_ACTIVE': return MacroPreviewRequestActivityLevelEnum.MODERATELY_ACTIVE;
        case r'VERY_ACTIVE': return MacroPreviewRequestActivityLevelEnum.VERY_ACTIVE;
        case r'EXTRA_ACTIVE': return MacroPreviewRequestActivityLevelEnum.EXTRA_ACTIVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MacroPreviewRequestActivityLevelEnumTypeTransformer] instance.
  static MacroPreviewRequestActivityLevelEnumTypeTransformer? _instance;
}



class MacroPreviewRequestDesiredGoalEnum {
  /// Instantiate a new enum with the provided [value].
  const MacroPreviewRequestDesiredGoalEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const LOSE_WEIGHT = MacroPreviewRequestDesiredGoalEnum._(r'LOSE_WEIGHT');
  static const MAINTAIN_WEIGHT = MacroPreviewRequestDesiredGoalEnum._(r'MAINTAIN_WEIGHT');
  static const GAIN_WEIGHT = MacroPreviewRequestDesiredGoalEnum._(r'GAIN_WEIGHT');
  static const NOTHING = MacroPreviewRequestDesiredGoalEnum._(r'NOTHING');

  /// List of all possible values in this [enum][MacroPreviewRequestDesiredGoalEnum].
  static const values = <MacroPreviewRequestDesiredGoalEnum>[
    LOSE_WEIGHT,
    MAINTAIN_WEIGHT,
    GAIN_WEIGHT,
    NOTHING,
  ];

  static MacroPreviewRequestDesiredGoalEnum? fromJson(dynamic value) => MacroPreviewRequestDesiredGoalEnumTypeTransformer().decode(value);

  static List<MacroPreviewRequestDesiredGoalEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroPreviewRequestDesiredGoalEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPreviewRequestDesiredGoalEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MacroPreviewRequestDesiredGoalEnum] to String,
/// and [decode] dynamic data back to [MacroPreviewRequestDesiredGoalEnum].
class MacroPreviewRequestDesiredGoalEnumTypeTransformer {
  factory MacroPreviewRequestDesiredGoalEnumTypeTransformer() => _instance ??= const MacroPreviewRequestDesiredGoalEnumTypeTransformer._();

  const MacroPreviewRequestDesiredGoalEnumTypeTransformer._();

  String encode(MacroPreviewRequestDesiredGoalEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MacroPreviewRequestDesiredGoalEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MacroPreviewRequestDesiredGoalEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'LOSE_WEIGHT': return MacroPreviewRequestDesiredGoalEnum.LOSE_WEIGHT;
        case r'MAINTAIN_WEIGHT': return MacroPreviewRequestDesiredGoalEnum.MAINTAIN_WEIGHT;
        case r'GAIN_WEIGHT': return MacroPreviewRequestDesiredGoalEnum.GAIN_WEIGHT;
        case r'NOTHING': return MacroPreviewRequestDesiredGoalEnum.NOTHING;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MacroPreviewRequestDesiredGoalEnumTypeTransformer] instance.
  static MacroPreviewRequestDesiredGoalEnumTypeTransformer? _instance;
}



class MacroPreviewRequestDesiredWeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const MacroPreviewRequestDesiredWeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const KG = MacroPreviewRequestDesiredWeightUnitEnum._(r'KG');
  static const POUNDS = MacroPreviewRequestDesiredWeightUnitEnum._(r'POUNDS');

  /// List of all possible values in this [enum][MacroPreviewRequestDesiredWeightUnitEnum].
  static const values = <MacroPreviewRequestDesiredWeightUnitEnum>[
    KG,
    POUNDS,
  ];

  static MacroPreviewRequestDesiredWeightUnitEnum? fromJson(dynamic value) => MacroPreviewRequestDesiredWeightUnitEnumTypeTransformer().decode(value);

  static List<MacroPreviewRequestDesiredWeightUnitEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroPreviewRequestDesiredWeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPreviewRequestDesiredWeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MacroPreviewRequestDesiredWeightUnitEnum] to String,
/// and [decode] dynamic data back to [MacroPreviewRequestDesiredWeightUnitEnum].
class MacroPreviewRequestDesiredWeightUnitEnumTypeTransformer {
  factory MacroPreviewRequestDesiredWeightUnitEnumTypeTransformer() => _instance ??= const MacroPreviewRequestDesiredWeightUnitEnumTypeTransformer._();

  const MacroPreviewRequestDesiredWeightUnitEnumTypeTransformer._();

  String encode(MacroPreviewRequestDesiredWeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MacroPreviewRequestDesiredWeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MacroPreviewRequestDesiredWeightUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'KG': return MacroPreviewRequestDesiredWeightUnitEnum.KG;
        case r'POUNDS': return MacroPreviewRequestDesiredWeightUnitEnum.POUNDS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MacroPreviewRequestDesiredWeightUnitEnumTypeTransformer] instance.
  static MacroPreviewRequestDesiredWeightUnitEnumTypeTransformer? _instance;
}



class MacroPreviewRequestGoalPaceEnum {
  /// Instantiate a new enum with the provided [value].
  const MacroPreviewRequestGoalPaceEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const SLOW = MacroPreviewRequestGoalPaceEnum._(r'SLOW');
  static const OPTIMAL = MacroPreviewRequestGoalPaceEnum._(r'OPTIMAL');
  static const FAST = MacroPreviewRequestGoalPaceEnum._(r'FAST');

  /// List of all possible values in this [enum][MacroPreviewRequestGoalPaceEnum].
  static const values = <MacroPreviewRequestGoalPaceEnum>[
    SLOW,
    OPTIMAL,
    FAST,
  ];

  static MacroPreviewRequestGoalPaceEnum? fromJson(dynamic value) => MacroPreviewRequestGoalPaceEnumTypeTransformer().decode(value);

  static List<MacroPreviewRequestGoalPaceEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroPreviewRequestGoalPaceEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPreviewRequestGoalPaceEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MacroPreviewRequestGoalPaceEnum] to String,
/// and [decode] dynamic data back to [MacroPreviewRequestGoalPaceEnum].
class MacroPreviewRequestGoalPaceEnumTypeTransformer {
  factory MacroPreviewRequestGoalPaceEnumTypeTransformer() => _instance ??= const MacroPreviewRequestGoalPaceEnumTypeTransformer._();

  const MacroPreviewRequestGoalPaceEnumTypeTransformer._();

  String encode(MacroPreviewRequestGoalPaceEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MacroPreviewRequestGoalPaceEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MacroPreviewRequestGoalPaceEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'SLOW': return MacroPreviewRequestGoalPaceEnum.SLOW;
        case r'OPTIMAL': return MacroPreviewRequestGoalPaceEnum.OPTIMAL;
        case r'FAST': return MacroPreviewRequestGoalPaceEnum.FAST;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MacroPreviewRequestGoalPaceEnumTypeTransformer] instance.
  static MacroPreviewRequestGoalPaceEnumTypeTransformer? _instance;
}



class MacroPreviewRequestMacroTargetEnum {
  /// Instantiate a new enum with the provided [value].
  const MacroPreviewRequestMacroTargetEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const BALANCED = MacroPreviewRequestMacroTargetEnum._(r'BALANCED');
  static const HIGH_PROTEIN = MacroPreviewRequestMacroTargetEnum._(r'HIGH_PROTEIN');
  static const LOW_CARB = MacroPreviewRequestMacroTargetEnum._(r'LOW_CARB');
  static const LOW_FAT = MacroPreviewRequestMacroTargetEnum._(r'LOW_FAT');
  static const HIGH_FIBER = MacroPreviewRequestMacroTargetEnum._(r'HIGH_FIBER');

  /// List of all possible values in this [enum][MacroPreviewRequestMacroTargetEnum].
  static const values = <MacroPreviewRequestMacroTargetEnum>[
    BALANCED,
    HIGH_PROTEIN,
    LOW_CARB,
    LOW_FAT,
    HIGH_FIBER,
  ];

  static MacroPreviewRequestMacroTargetEnum? fromJson(dynamic value) => MacroPreviewRequestMacroTargetEnumTypeTransformer().decode(value);

  static List<MacroPreviewRequestMacroTargetEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroPreviewRequestMacroTargetEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPreviewRequestMacroTargetEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MacroPreviewRequestMacroTargetEnum] to String,
/// and [decode] dynamic data back to [MacroPreviewRequestMacroTargetEnum].
class MacroPreviewRequestMacroTargetEnumTypeTransformer {
  factory MacroPreviewRequestMacroTargetEnumTypeTransformer() => _instance ??= const MacroPreviewRequestMacroTargetEnumTypeTransformer._();

  const MacroPreviewRequestMacroTargetEnumTypeTransformer._();

  String encode(MacroPreviewRequestMacroTargetEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MacroPreviewRequestMacroTargetEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MacroPreviewRequestMacroTargetEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'BALANCED': return MacroPreviewRequestMacroTargetEnum.BALANCED;
        case r'HIGH_PROTEIN': return MacroPreviewRequestMacroTargetEnum.HIGH_PROTEIN;
        case r'LOW_CARB': return MacroPreviewRequestMacroTargetEnum.LOW_CARB;
        case r'LOW_FAT': return MacroPreviewRequestMacroTargetEnum.LOW_FAT;
        case r'HIGH_FIBER': return MacroPreviewRequestMacroTargetEnum.HIGH_FIBER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MacroPreviewRequestMacroTargetEnumTypeTransformer] instance.
  static MacroPreviewRequestMacroTargetEnumTypeTransformer? _instance;
}



class MacroPreviewRequestTargetEventEnum {
  /// Instantiate a new enum with the provided [value].
  const MacroPreviewRequestTargetEventEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const VACATION = MacroPreviewRequestTargetEventEnum._(r'VACATION');
  static const WEDDING = MacroPreviewRequestTargetEventEnum._(r'WEDDING');
  static const BIRTHDAY = MacroPreviewRequestTargetEventEnum._(r'BIRTHDAY');
  static const PERSONAL_MILESTONE = MacroPreviewRequestTargetEventEnum._(r'PERSONAL_MILESTONE');
  static const NONE = MacroPreviewRequestTargetEventEnum._(r'NONE');

  /// List of all possible values in this [enum][MacroPreviewRequestTargetEventEnum].
  static const values = <MacroPreviewRequestTargetEventEnum>[
    VACATION,
    WEDDING,
    BIRTHDAY,
    PERSONAL_MILESTONE,
    NONE,
  ];

  static MacroPreviewRequestTargetEventEnum? fromJson(dynamic value) => MacroPreviewRequestTargetEventEnumTypeTransformer().decode(value);

  static List<MacroPreviewRequestTargetEventEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroPreviewRequestTargetEventEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroPreviewRequestTargetEventEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [MacroPreviewRequestTargetEventEnum] to String,
/// and [decode] dynamic data back to [MacroPreviewRequestTargetEventEnum].
class MacroPreviewRequestTargetEventEnumTypeTransformer {
  factory MacroPreviewRequestTargetEventEnumTypeTransformer() => _instance ??= const MacroPreviewRequestTargetEventEnumTypeTransformer._();

  const MacroPreviewRequestTargetEventEnumTypeTransformer._();

  String encode(MacroPreviewRequestTargetEventEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a MacroPreviewRequestTargetEventEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  MacroPreviewRequestTargetEventEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'VACATION': return MacroPreviewRequestTargetEventEnum.VACATION;
        case r'WEDDING': return MacroPreviewRequestTargetEventEnum.WEDDING;
        case r'BIRTHDAY': return MacroPreviewRequestTargetEventEnum.BIRTHDAY;
        case r'PERSONAL_MILESTONE': return MacroPreviewRequestTargetEventEnum.PERSONAL_MILESTONE;
        case r'NONE': return MacroPreviewRequestTargetEventEnum.NONE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [MacroPreviewRequestTargetEventEnumTypeTransformer] instance.
  static MacroPreviewRequestTargetEventEnumTypeTransformer? _instance;
}


