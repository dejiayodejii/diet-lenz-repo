//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProfileRequestDto {
  /// Returns a new [ProfileRequestDto] instance.
  ProfileRequestDto({
    required this.gender,
    this.currentWeight,
    this.currentWeightUnit,
    this.height,
    this.heightUnit,
    required this.dateOfBirth,
    this.desiredGoal,
    this.desiredWeight,
    this.desiredWeightUnit,
    this.dietaryPreference,
    this.activityLevel,
    this.macroTarget,
    this.allergies = const [],
    this.country,
    this.timeZone,
  });

  ProfileRequestDtoGenderEnum gender;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? currentWeight;

  ProfileRequestDtoCurrentWeightUnitEnum? currentWeightUnit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? height;

  ProfileRequestDtoHeightUnitEnum? heightUnit;

  DateTime dateOfBirth;

  ProfileRequestDtoDesiredGoalEnum? desiredGoal;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? desiredWeight;

  ProfileRequestDtoDesiredWeightUnitEnum? desiredWeightUnit;

  ProfileRequestDtoDietaryPreferenceEnum? dietaryPreference;

  ProfileRequestDtoActivityLevelEnum? activityLevel;

  ProfileRequestDtoMacroTargetEnum? macroTarget;

  List<String> allergies;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? country;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? timeZone;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProfileRequestDto &&
          other.gender == gender &&
          other.currentWeight == currentWeight &&
          other.currentWeightUnit == currentWeightUnit &&
          other.height == height &&
          other.heightUnit == heightUnit &&
          other.dateOfBirth == dateOfBirth &&
          other.desiredGoal == desiredGoal &&
          other.desiredWeight == desiredWeight &&
          other.desiredWeightUnit == desiredWeightUnit &&
          other.dietaryPreference == dietaryPreference &&
          other.activityLevel == activityLevel &&
          other.macroTarget == macroTarget &&
          _deepEquality.equals(other.allergies, allergies) &&
          other.country == country &&
          other.timeZone == timeZone;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (gender.hashCode) +
      (currentWeight == null ? 0 : currentWeight!.hashCode) +
      (currentWeightUnit == null ? 0 : currentWeightUnit!.hashCode) +
      (height == null ? 0 : height!.hashCode) +
      (heightUnit == null ? 0 : heightUnit!.hashCode) +
      (dateOfBirth.hashCode) +
      (desiredGoal == null ? 0 : desiredGoal!.hashCode) +
      (desiredWeight == null ? 0 : desiredWeight!.hashCode) +
      (desiredWeightUnit == null ? 0 : desiredWeightUnit!.hashCode) +
      (dietaryPreference == null ? 0 : dietaryPreference!.hashCode) +
      (activityLevel == null ? 0 : activityLevel!.hashCode) +
      (macroTarget == null ? 0 : macroTarget!.hashCode) +
      (allergies.hashCode) +
      (country == null ? 0 : country!.hashCode) +
      (timeZone == null ? 0 : timeZone!.hashCode);

  @override
  String toString() =>
      'ProfileRequestDto[gender=$gender, currentWeight=$currentWeight, currentWeightUnit=$currentWeightUnit, height=$height, heightUnit=$heightUnit, dateOfBirth=$dateOfBirth, desiredGoal=$desiredGoal, desiredWeight=$desiredWeight, desiredWeightUnit=$desiredWeightUnit, dietaryPreference=$dietaryPreference, activityLevel=$activityLevel, macroTarget=$macroTarget, allergies=$allergies, country=$country, timeZone=$timeZone]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'gender'] = this.gender;
    if (this.currentWeight != null) {
      json[r'currentWeight'] = this.currentWeight;
    } else {
      json[r'currentWeight'] = null;
    }
    if (this.currentWeightUnit != null) {
      json[r'currentWeightUnit'] = this.currentWeightUnit;
    } else {
      json[r'currentWeightUnit'] = null;
    }
    if (this.height != null) {
      json[r'height'] = this.height;
    } else {
      json[r'height'] = null;
    }
    if (this.heightUnit != null) {
      json[r'heightUnit'] = this.heightUnit;
    } else {
      json[r'heightUnit'] = null;
    }
    json[r'dateOfBirth'] = _dateFormatter.format(this.dateOfBirth.toUtc());
    if (this.desiredGoal != null) {
      json[r'desiredGoal'] = this.desiredGoal;
    } else {
      json[r'desiredGoal'] = null;
    }
    if (this.desiredWeight != null) {
      json[r'desiredWeight'] = this.desiredWeight;
    } else {
      json[r'desiredWeight'] = null;
    }
    if (this.desiredWeightUnit != null) {
      json[r'desiredWeightUnit'] = this.desiredWeightUnit;
    } else {
      json[r'desiredWeightUnit'] = null;
    }
    if (this.dietaryPreference != null) {
      json[r'dietaryPreference'] = this.dietaryPreference;
    } else {
      json[r'dietaryPreference'] = null;
    }
    if (this.activityLevel != null) {
      json[r'activityLevel'] = this.activityLevel;
    } else {
      json[r'activityLevel'] = null;
    }
    if (this.macroTarget != null) {
      json[r'macroTarget'] = this.macroTarget;
    } else {
      json[r'macroTarget'] = null;
    }
    json[r'allergies'] = this.allergies;
    if (this.country != null) {
      json[r'country'] = this.country;
    } else {
      json[r'country'] = null;
    }
    if (this.timeZone != null) {
      json[r'timeZone'] = this.timeZone;
    } else {
      json[r'timeZone'] = null;
    }
    return json;
  }

  /// Returns a new [ProfileRequestDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProfileRequestDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "ProfileRequestDto[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "ProfileRequestDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProfileRequestDto(
        gender: ProfileRequestDtoGenderEnum.fromJson(json[r'gender'])!,
        currentWeight: mapValueOfType<int>(json, r'currentWeight'),
        currentWeightUnit: ProfileRequestDtoCurrentWeightUnitEnum.fromJson(
            json[r'currentWeightUnit']),
        height: mapValueOfType<int>(json, r'height'),
        heightUnit:
            ProfileRequestDtoHeightUnitEnum.fromJson(json[r'heightUnit']),
        dateOfBirth: mapDateTime(json, r'dateOfBirth', r'')!,
        desiredGoal:
            ProfileRequestDtoDesiredGoalEnum.fromJson(json[r'desiredGoal']),
        desiredWeight: mapValueOfType<int>(json, r'desiredWeight'),
        desiredWeightUnit: ProfileRequestDtoDesiredWeightUnitEnum.fromJson(
            json[r'desiredWeightUnit']),
        dietaryPreference: ProfileRequestDtoDietaryPreferenceEnum.fromJson(
            json[r'dietaryPreference']),
        activityLevel:
            ProfileRequestDtoActivityLevelEnum.fromJson(json[r'activityLevel']),
        macroTarget:
            ProfileRequestDtoMacroTargetEnum.fromJson(json[r'macroTarget']),
        allergies: json[r'allergies'] is Iterable
            ? (json[r'allergies'] as Iterable)
                .cast<String>()
                .toList(growable: false)
            : const [],
        country: mapValueOfType<String>(json, r'country'),
        timeZone: mapValueOfType<String>(json, r'timeZone'),
      );
    }
    return null;
  }

  static List<ProfileRequestDto> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProfileRequestDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileRequestDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProfileRequestDto> mapFromJson(dynamic json) {
    final map = <String, ProfileRequestDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProfileRequestDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProfileRequestDto-objects as value to a dart map
  static Map<String, List<ProfileRequestDto>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ProfileRequestDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProfileRequestDto.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'gender',
    'dateOfBirth',
  };
}

class ProfileRequestDtoGenderEnum {
  /// Instantiate a new enum with the provided [value].
  const ProfileRequestDtoGenderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MALE = ProfileRequestDtoGenderEnum._(r'MALE');
  static const FEMALE = ProfileRequestDtoGenderEnum._(r'FEMALE');
  static const OTHER = ProfileRequestDtoGenderEnum._(r'OTHER');

  /// List of all possible values in this [enum][ProfileRequestDtoGenderEnum].
  static const values = <ProfileRequestDtoGenderEnum>[
    MALE,
    FEMALE,
    OTHER,
  ];

  static ProfileRequestDtoGenderEnum? fromJson(dynamic value) =>
      ProfileRequestDtoGenderEnumTypeTransformer().decode(value);

  static List<ProfileRequestDtoGenderEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProfileRequestDtoGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileRequestDtoGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileRequestDtoGenderEnum] to String,
/// and [decode] dynamic data back to [ProfileRequestDtoGenderEnum].
class ProfileRequestDtoGenderEnumTypeTransformer {
  factory ProfileRequestDtoGenderEnumTypeTransformer() =>
      _instance ??= const ProfileRequestDtoGenderEnumTypeTransformer._();

  const ProfileRequestDtoGenderEnumTypeTransformer._();

  String encode(ProfileRequestDtoGenderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ProfileRequestDtoGenderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileRequestDtoGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MALE':
          return ProfileRequestDtoGenderEnum.MALE;
        case r'FEMALE':
          return ProfileRequestDtoGenderEnum.FEMALE;
        case r'OTHER':
          return ProfileRequestDtoGenderEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ProfileRequestDtoGenderEnumTypeTransformer] instance.
  static ProfileRequestDtoGenderEnumTypeTransformer? _instance;
}

class ProfileRequestDtoCurrentWeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const ProfileRequestDtoCurrentWeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const KG = ProfileRequestDtoCurrentWeightUnitEnum._(r'KG');
  static const POUNDS = ProfileRequestDtoCurrentWeightUnitEnum._(r'POUNDS');

  /// List of all possible values in this [enum][ProfileRequestDtoCurrentWeightUnitEnum].
  static const values = <ProfileRequestDtoCurrentWeightUnitEnum>[
    KG,
    POUNDS,
  ];

  static ProfileRequestDtoCurrentWeightUnitEnum? fromJson(dynamic value) =>
      ProfileRequestDtoCurrentWeightUnitEnumTypeTransformer().decode(value);

  static List<ProfileRequestDtoCurrentWeightUnitEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProfileRequestDtoCurrentWeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileRequestDtoCurrentWeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileRequestDtoCurrentWeightUnitEnum] to String,
/// and [decode] dynamic data back to [ProfileRequestDtoCurrentWeightUnitEnum].
class ProfileRequestDtoCurrentWeightUnitEnumTypeTransformer {
  factory ProfileRequestDtoCurrentWeightUnitEnumTypeTransformer() =>
      _instance ??=
          const ProfileRequestDtoCurrentWeightUnitEnumTypeTransformer._();

  const ProfileRequestDtoCurrentWeightUnitEnumTypeTransformer._();

  String encode(ProfileRequestDtoCurrentWeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ProfileRequestDtoCurrentWeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileRequestDtoCurrentWeightUnitEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'KG':
          return ProfileRequestDtoCurrentWeightUnitEnum.KG;
        case r'POUNDS':
          return ProfileRequestDtoCurrentWeightUnitEnum.POUNDS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ProfileRequestDtoCurrentWeightUnitEnumTypeTransformer] instance.
  static ProfileRequestDtoCurrentWeightUnitEnumTypeTransformer? _instance;
}

class ProfileRequestDtoHeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const ProfileRequestDtoHeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const CM = ProfileRequestDtoHeightUnitEnum._(r'CM');
  static const FT = ProfileRequestDtoHeightUnitEnum._(r'FT');

  /// List of all possible values in this [enum][ProfileRequestDtoHeightUnitEnum].
  static const values = <ProfileRequestDtoHeightUnitEnum>[
    CM,
    FT,
  ];

  static ProfileRequestDtoHeightUnitEnum? fromJson(dynamic value) =>
      ProfileRequestDtoHeightUnitEnumTypeTransformer().decode(value);

  static List<ProfileRequestDtoHeightUnitEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProfileRequestDtoHeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileRequestDtoHeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileRequestDtoHeightUnitEnum] to String,
/// and [decode] dynamic data back to [ProfileRequestDtoHeightUnitEnum].
class ProfileRequestDtoHeightUnitEnumTypeTransformer {
  factory ProfileRequestDtoHeightUnitEnumTypeTransformer() =>
      _instance ??= const ProfileRequestDtoHeightUnitEnumTypeTransformer._();

  const ProfileRequestDtoHeightUnitEnumTypeTransformer._();

  String encode(ProfileRequestDtoHeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ProfileRequestDtoHeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileRequestDtoHeightUnitEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'CM':
          return ProfileRequestDtoHeightUnitEnum.CM;
        case r'FT':
          return ProfileRequestDtoHeightUnitEnum.FT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ProfileRequestDtoHeightUnitEnumTypeTransformer] instance.
  static ProfileRequestDtoHeightUnitEnumTypeTransformer? _instance;
}

class ProfileRequestDtoDesiredGoalEnum {
  /// Instantiate a new enum with the provided [value].
  const ProfileRequestDtoDesiredGoalEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const LOSE_WEIGHT = ProfileRequestDtoDesiredGoalEnum._(r'LOSE_WEIGHT');
  static const MAINTAIN_WEIGHT =
      ProfileRequestDtoDesiredGoalEnum._(r'MAINTAIN_WEIGHT');
  static const GAIN_WEIGHT = ProfileRequestDtoDesiredGoalEnum._(r'GAIN_WEIGHT');
  static const NOTHING = ProfileRequestDtoDesiredGoalEnum._(r'NOTHING');

  /// List of all possible values in this [enum][ProfileRequestDtoDesiredGoalEnum].
  static const values = <ProfileRequestDtoDesiredGoalEnum>[
    LOSE_WEIGHT,
    MAINTAIN_WEIGHT,
    GAIN_WEIGHT,
    NOTHING,
  ];

  static ProfileRequestDtoDesiredGoalEnum? fromJson(dynamic value) =>
      ProfileRequestDtoDesiredGoalEnumTypeTransformer().decode(value);

  static List<ProfileRequestDtoDesiredGoalEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProfileRequestDtoDesiredGoalEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileRequestDtoDesiredGoalEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileRequestDtoDesiredGoalEnum] to String,
/// and [decode] dynamic data back to [ProfileRequestDtoDesiredGoalEnum].
class ProfileRequestDtoDesiredGoalEnumTypeTransformer {
  factory ProfileRequestDtoDesiredGoalEnumTypeTransformer() =>
      _instance ??= const ProfileRequestDtoDesiredGoalEnumTypeTransformer._();

  const ProfileRequestDtoDesiredGoalEnumTypeTransformer._();

  String encode(ProfileRequestDtoDesiredGoalEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ProfileRequestDtoDesiredGoalEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileRequestDtoDesiredGoalEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'LOSE_WEIGHT':
          return ProfileRequestDtoDesiredGoalEnum.LOSE_WEIGHT;
        case r'MAINTAIN_WEIGHT':
          return ProfileRequestDtoDesiredGoalEnum.MAINTAIN_WEIGHT;
        case r'GAIN_WEIGHT':
          return ProfileRequestDtoDesiredGoalEnum.GAIN_WEIGHT;
        case r'NOTHING':
          return ProfileRequestDtoDesiredGoalEnum.NOTHING;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ProfileRequestDtoDesiredGoalEnumTypeTransformer] instance.
  static ProfileRequestDtoDesiredGoalEnumTypeTransformer? _instance;
}

class ProfileRequestDtoDesiredWeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const ProfileRequestDtoDesiredWeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const KG = ProfileRequestDtoDesiredWeightUnitEnum._(r'KG');
  static const POUNDS = ProfileRequestDtoDesiredWeightUnitEnum._(r'POUNDS');

  /// List of all possible values in this [enum][ProfileRequestDtoDesiredWeightUnitEnum].
  static const values = <ProfileRequestDtoDesiredWeightUnitEnum>[
    KG,
    POUNDS,
  ];

  static ProfileRequestDtoDesiredWeightUnitEnum? fromJson(dynamic value) =>
      ProfileRequestDtoDesiredWeightUnitEnumTypeTransformer().decode(value);

  static List<ProfileRequestDtoDesiredWeightUnitEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProfileRequestDtoDesiredWeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileRequestDtoDesiredWeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileRequestDtoDesiredWeightUnitEnum] to String,
/// and [decode] dynamic data back to [ProfileRequestDtoDesiredWeightUnitEnum].
class ProfileRequestDtoDesiredWeightUnitEnumTypeTransformer {
  factory ProfileRequestDtoDesiredWeightUnitEnumTypeTransformer() =>
      _instance ??=
          const ProfileRequestDtoDesiredWeightUnitEnumTypeTransformer._();

  const ProfileRequestDtoDesiredWeightUnitEnumTypeTransformer._();

  String encode(ProfileRequestDtoDesiredWeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ProfileRequestDtoDesiredWeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileRequestDtoDesiredWeightUnitEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'KG':
          return ProfileRequestDtoDesiredWeightUnitEnum.KG;
        case r'POUNDS':
          return ProfileRequestDtoDesiredWeightUnitEnum.POUNDS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ProfileRequestDtoDesiredWeightUnitEnumTypeTransformer] instance.
  static ProfileRequestDtoDesiredWeightUnitEnumTypeTransformer? _instance;
}

class ProfileRequestDtoDietaryPreferenceEnum {
  /// Instantiate a new enum with the provided [value].
  const ProfileRequestDtoDietaryPreferenceEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const NONE = ProfileRequestDtoDietaryPreferenceEnum._(r'NONE');
  static const VEGETARIAN =
      ProfileRequestDtoDietaryPreferenceEnum._(r'VEGETARIAN');
  static const VEGAN = ProfileRequestDtoDietaryPreferenceEnum._(r'VEGAN');
  static const KETO = ProfileRequestDtoDietaryPreferenceEnum._(r'KETO');
  static const PALEO = ProfileRequestDtoDietaryPreferenceEnum._(r'PALEO');
  static const GLUTEN_FREE =
      ProfileRequestDtoDietaryPreferenceEnum._(r'GLUTEN_FREE');
  static const DAIRY_FREE =
      ProfileRequestDtoDietaryPreferenceEnum._(r'DAIRY_FREE');

  /// List of all possible values in this [enum][ProfileRequestDtoDietaryPreferenceEnum].
  static const values = <ProfileRequestDtoDietaryPreferenceEnum>[
    NONE,
    VEGETARIAN,
    VEGAN,
    KETO,
    PALEO,
    GLUTEN_FREE,
    DAIRY_FREE,
  ];

  static ProfileRequestDtoDietaryPreferenceEnum? fromJson(dynamic value) =>
      ProfileRequestDtoDietaryPreferenceEnumTypeTransformer().decode(value);

  static List<ProfileRequestDtoDietaryPreferenceEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProfileRequestDtoDietaryPreferenceEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileRequestDtoDietaryPreferenceEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileRequestDtoDietaryPreferenceEnum] to String,
/// and [decode] dynamic data back to [ProfileRequestDtoDietaryPreferenceEnum].
class ProfileRequestDtoDietaryPreferenceEnumTypeTransformer {
  factory ProfileRequestDtoDietaryPreferenceEnumTypeTransformer() =>
      _instance ??=
          const ProfileRequestDtoDietaryPreferenceEnumTypeTransformer._();

  const ProfileRequestDtoDietaryPreferenceEnumTypeTransformer._();

  String encode(ProfileRequestDtoDietaryPreferenceEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ProfileRequestDtoDietaryPreferenceEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileRequestDtoDietaryPreferenceEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'NONE':
          return ProfileRequestDtoDietaryPreferenceEnum.NONE;
        case r'VEGETARIAN':
          return ProfileRequestDtoDietaryPreferenceEnum.VEGETARIAN;
        case r'VEGAN':
          return ProfileRequestDtoDietaryPreferenceEnum.VEGAN;
        case r'KETO':
          return ProfileRequestDtoDietaryPreferenceEnum.KETO;
        case r'PALEO':
          return ProfileRequestDtoDietaryPreferenceEnum.PALEO;
        case r'GLUTEN_FREE':
          return ProfileRequestDtoDietaryPreferenceEnum.GLUTEN_FREE;
        case r'DAIRY_FREE':
          return ProfileRequestDtoDietaryPreferenceEnum.DAIRY_FREE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ProfileRequestDtoDietaryPreferenceEnumTypeTransformer] instance.
  static ProfileRequestDtoDietaryPreferenceEnumTypeTransformer? _instance;
}

class ProfileRequestDtoActivityLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const ProfileRequestDtoActivityLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const SEDENTARY = ProfileRequestDtoActivityLevelEnum._(r'SEDENTARY');
  static const LIGHTLY_ACTIVE =
      ProfileRequestDtoActivityLevelEnum._(r'LIGHTLY_ACTIVE');
  static const MODERATELY_ACTIVE =
      ProfileRequestDtoActivityLevelEnum._(r'MODERATELY_ACTIVE');
  static const VERY_ACTIVE =
      ProfileRequestDtoActivityLevelEnum._(r'VERY_ACTIVE');
  static const EXTRA_ACTIVE =
      ProfileRequestDtoActivityLevelEnum._(r'EXTRA_ACTIVE');

  /// List of all possible values in this [enum][ProfileRequestDtoActivityLevelEnum].
  static const values = <ProfileRequestDtoActivityLevelEnum>[
    SEDENTARY,
    LIGHTLY_ACTIVE,
    MODERATELY_ACTIVE,
    VERY_ACTIVE,
    EXTRA_ACTIVE,
  ];

  static ProfileRequestDtoActivityLevelEnum? fromJson(dynamic value) =>
      ProfileRequestDtoActivityLevelEnumTypeTransformer().decode(value);

  static List<ProfileRequestDtoActivityLevelEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProfileRequestDtoActivityLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileRequestDtoActivityLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileRequestDtoActivityLevelEnum] to String,
/// and [decode] dynamic data back to [ProfileRequestDtoActivityLevelEnum].
class ProfileRequestDtoActivityLevelEnumTypeTransformer {
  factory ProfileRequestDtoActivityLevelEnumTypeTransformer() =>
      _instance ??= const ProfileRequestDtoActivityLevelEnumTypeTransformer._();

  const ProfileRequestDtoActivityLevelEnumTypeTransformer._();

  String encode(ProfileRequestDtoActivityLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ProfileRequestDtoActivityLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileRequestDtoActivityLevelEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'SEDENTARY':
          return ProfileRequestDtoActivityLevelEnum.SEDENTARY;
        case r'LIGHTLY_ACTIVE':
          return ProfileRequestDtoActivityLevelEnum.LIGHTLY_ACTIVE;
        case r'MODERATELY_ACTIVE':
          return ProfileRequestDtoActivityLevelEnum.MODERATELY_ACTIVE;
        case r'VERY_ACTIVE':
          return ProfileRequestDtoActivityLevelEnum.VERY_ACTIVE;
        case r'EXTRA_ACTIVE':
          return ProfileRequestDtoActivityLevelEnum.EXTRA_ACTIVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ProfileRequestDtoActivityLevelEnumTypeTransformer] instance.
  static ProfileRequestDtoActivityLevelEnumTypeTransformer? _instance;
}

class ProfileRequestDtoMacroTargetEnum {
  /// Instantiate a new enum with the provided [value].
  const ProfileRequestDtoMacroTargetEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const BALANCED = ProfileRequestDtoMacroTargetEnum._(r'BALANCED');
  static const HIGH_PROTEIN =
      ProfileRequestDtoMacroTargetEnum._(r'HIGH_PROTEIN');
  static const LOW_CARB = ProfileRequestDtoMacroTargetEnum._(r'LOW_CARB');
  static const LOW_FAT = ProfileRequestDtoMacroTargetEnum._(r'LOW_FAT');
  static const HIGH_FIBER = ProfileRequestDtoMacroTargetEnum._(r'HIGH_FIBER');

  /// List of all possible values in this [enum][ProfileRequestDtoMacroTargetEnum].
  static const values = <ProfileRequestDtoMacroTargetEnum>[
    BALANCED,
    HIGH_PROTEIN,
    LOW_CARB,
    LOW_FAT,
    HIGH_FIBER,
  ];

  static ProfileRequestDtoMacroTargetEnum? fromJson(dynamic value) =>
      ProfileRequestDtoMacroTargetEnumTypeTransformer().decode(value);

  static List<ProfileRequestDtoMacroTargetEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProfileRequestDtoMacroTargetEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProfileRequestDtoMacroTargetEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [ProfileRequestDtoMacroTargetEnum] to String,
/// and [decode] dynamic data back to [ProfileRequestDtoMacroTargetEnum].
class ProfileRequestDtoMacroTargetEnumTypeTransformer {
  factory ProfileRequestDtoMacroTargetEnumTypeTransformer() =>
      _instance ??= const ProfileRequestDtoMacroTargetEnumTypeTransformer._();

  const ProfileRequestDtoMacroTargetEnumTypeTransformer._();

  String encode(ProfileRequestDtoMacroTargetEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a ProfileRequestDtoMacroTargetEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  ProfileRequestDtoMacroTargetEnum? decode(dynamic data,
      {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'BALANCED':
          return ProfileRequestDtoMacroTargetEnum.BALANCED;
        case r'HIGH_PROTEIN':
          return ProfileRequestDtoMacroTargetEnum.HIGH_PROTEIN;
        case r'LOW_CARB':
          return ProfileRequestDtoMacroTargetEnum.LOW_CARB;
        case r'LOW_FAT':
          return ProfileRequestDtoMacroTargetEnum.LOW_FAT;
        case r'HIGH_FIBER':
          return ProfileRequestDtoMacroTargetEnum.HIGH_FIBER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [ProfileRequestDtoMacroTargetEnumTypeTransformer] instance.
  static ProfileRequestDtoMacroTargetEnumTypeTransformer? _instance;
}
