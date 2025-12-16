//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserProfile {
  /// Returns a new [UserProfile] instance.
  UserProfile({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.height,
    this.weight,
    this.age,
    this.activityLevel,
    this.goal,
    this.macroTarget,
    this.dietaryPreference,
    this.allergenExclusions = const {},
    this.cuisinePreferences = const {},
    this.notificationsEnabled,
    this.mealRemindersEnabled,
    this.gender,
    this.currentWeight,
    this.macroResult,
    this.currentWeightUnit,
    this.heightUnit,
    this.dateOfBirth,
    this.desiredGoal,
    this.desiredWeight,
    this.desiredWeightUnit,
    this.country,
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
  DateTime? createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? updatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? height;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? weight;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? age;

  UserProfileActivityLevelEnum? activityLevel;

  UserProfileGoalEnum? goal;

  UserProfileMacroTargetEnum? macroTarget;

  UserProfileDietaryPreferenceEnum? dietaryPreference;

  Set<String> allergenExclusions;

  Set<String> cuisinePreferences;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? notificationsEnabled;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? mealRemindersEnabled;

  UserProfileGenderEnum? gender;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? currentWeight;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MacroResult? macroResult;

  UserProfileCurrentWeightUnitEnum? currentWeightUnit;

  UserProfileHeightUnitEnum? heightUnit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? dateOfBirth;

  UserProfileDesiredGoalEnum? desiredGoal;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? desiredWeight;

  UserProfileDesiredWeightUnitEnum? desiredWeightUnit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? country;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserProfile &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.height == height &&
    other.weight == weight &&
    other.age == age &&
    other.activityLevel == activityLevel &&
    other.goal == goal &&
    other.macroTarget == macroTarget &&
    other.dietaryPreference == dietaryPreference &&
    _deepEquality.equals(other.allergenExclusions, allergenExclusions) &&
    _deepEquality.equals(other.cuisinePreferences, cuisinePreferences) &&
    other.notificationsEnabled == notificationsEnabled &&
    other.mealRemindersEnabled == mealRemindersEnabled &&
    other.gender == gender &&
    other.currentWeight == currentWeight &&
    other.macroResult == macroResult &&
    other.currentWeightUnit == currentWeightUnit &&
    other.heightUnit == heightUnit &&
    other.dateOfBirth == dateOfBirth &&
    other.desiredGoal == desiredGoal &&
    other.desiredWeight == desiredWeight &&
    other.desiredWeightUnit == desiredWeightUnit &&
    other.country == country;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode) +
    (height == null ? 0 : height!.hashCode) +
    (weight == null ? 0 : weight!.hashCode) +
    (age == null ? 0 : age!.hashCode) +
    (activityLevel == null ? 0 : activityLevel!.hashCode) +
    (goal == null ? 0 : goal!.hashCode) +
    (macroTarget == null ? 0 : macroTarget!.hashCode) +
    (dietaryPreference == null ? 0 : dietaryPreference!.hashCode) +
    (allergenExclusions.hashCode) +
    (cuisinePreferences.hashCode) +
    (notificationsEnabled == null ? 0 : notificationsEnabled!.hashCode) +
    (mealRemindersEnabled == null ? 0 : mealRemindersEnabled!.hashCode) +
    (gender == null ? 0 : gender!.hashCode) +
    (currentWeight == null ? 0 : currentWeight!.hashCode) +
    (macroResult == null ? 0 : macroResult!.hashCode) +
    (currentWeightUnit == null ? 0 : currentWeightUnit!.hashCode) +
    (heightUnit == null ? 0 : heightUnit!.hashCode) +
    (dateOfBirth == null ? 0 : dateOfBirth!.hashCode) +
    (desiredGoal == null ? 0 : desiredGoal!.hashCode) +
    (desiredWeight == null ? 0 : desiredWeight!.hashCode) +
    (desiredWeightUnit == null ? 0 : desiredWeightUnit!.hashCode) +
    (country == null ? 0 : country!.hashCode);

  @override
  String toString() => 'UserProfile[id=$id, createdAt=$createdAt, updatedAt=$updatedAt, height=$height, weight=$weight, age=$age, activityLevel=$activityLevel, goal=$goal, macroTarget=$macroTarget, dietaryPreference=$dietaryPreference, allergenExclusions=$allergenExclusions, cuisinePreferences=$cuisinePreferences, notificationsEnabled=$notificationsEnabled, mealRemindersEnabled=$mealRemindersEnabled, gender=$gender, currentWeight=$currentWeight, macroResult=$macroResult, currentWeightUnit=$currentWeightUnit, heightUnit=$heightUnit, dateOfBirth=$dateOfBirth, desiredGoal=$desiredGoal, desiredWeight=$desiredWeight, desiredWeightUnit=$desiredWeightUnit, country=$country]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'createdAt'] = null;
    }
    if (this.updatedAt != null) {
      json[r'updatedAt'] = this.updatedAt!.toUtc().toIso8601String();
    } else {
      json[r'updatedAt'] = null;
    }
    if (this.height != null) {
      json[r'height'] = this.height;
    } else {
      json[r'height'] = null;
    }
    if (this.weight != null) {
      json[r'weight'] = this.weight;
    } else {
      json[r'weight'] = null;
    }
    if (this.age != null) {
      json[r'age'] = this.age;
    } else {
      json[r'age'] = null;
    }
    if (this.activityLevel != null) {
      json[r'activityLevel'] = this.activityLevel;
    } else {
      json[r'activityLevel'] = null;
    }
    if (this.goal != null) {
      json[r'goal'] = this.goal;
    } else {
      json[r'goal'] = null;
    }
    if (this.macroTarget != null) {
      json[r'macroTarget'] = this.macroTarget;
    } else {
      json[r'macroTarget'] = null;
    }
    if (this.dietaryPreference != null) {
      json[r'dietaryPreference'] = this.dietaryPreference;
    } else {
      json[r'dietaryPreference'] = null;
    }
      json[r'allergenExclusions'] = this.allergenExclusions.toList(growable: false);
      json[r'cuisinePreferences'] = this.cuisinePreferences.toList(growable: false);
    if (this.notificationsEnabled != null) {
      json[r'notificationsEnabled'] = this.notificationsEnabled;
    } else {
      json[r'notificationsEnabled'] = null;
    }
    if (this.mealRemindersEnabled != null) {
      json[r'mealRemindersEnabled'] = this.mealRemindersEnabled;
    } else {
      json[r'mealRemindersEnabled'] = null;
    }
    if (this.gender != null) {
      json[r'gender'] = this.gender;
    } else {
      json[r'gender'] = null;
    }
    if (this.currentWeight != null) {
      json[r'currentWeight'] = this.currentWeight;
    } else {
      json[r'currentWeight'] = null;
    }
    if (this.macroResult != null) {
      json[r'macroResult'] = this.macroResult;
    } else {
      json[r'macroResult'] = null;
    }
    if (this.currentWeightUnit != null) {
      json[r'currentWeightUnit'] = this.currentWeightUnit;
    } else {
      json[r'currentWeightUnit'] = null;
    }
    if (this.heightUnit != null) {
      json[r'heightUnit'] = this.heightUnit;
    } else {
      json[r'heightUnit'] = null;
    }
    if (this.dateOfBirth != null) {
      json[r'dateOfBirth'] = _dateFormatter.format(this.dateOfBirth!.toUtc());
    } else {
      json[r'dateOfBirth'] = null;
    }
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
    if (this.country != null) {
      json[r'country'] = this.country;
    } else {
      json[r'country'] = null;
    }
    return json;
  }

  /// Returns a new [UserProfile] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserProfile? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserProfile[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserProfile[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserProfile(
        id: mapValueOfType<String>(json, r'id'),
        createdAt: mapDateTime(json, r'createdAt', r''),
        updatedAt: mapDateTime(json, r'updatedAt', r''),
        height: num.parse('${json[r'height']}'),
        weight: num.parse('${json[r'weight']}'),
        age: mapValueOfType<int>(json, r'age'),
        activityLevel: UserProfileActivityLevelEnum.fromJson(json[r'activityLevel']),
        goal: UserProfileGoalEnum.fromJson(json[r'goal']),
        macroTarget: UserProfileMacroTargetEnum.fromJson(json[r'macroTarget']),
        dietaryPreference: UserProfileDietaryPreferenceEnum.fromJson(json[r'dietaryPreference']),
        allergenExclusions: json[r'allergenExclusions'] is Iterable
            ? (json[r'allergenExclusions'] as Iterable).cast<String>().toSet()
            : const {},
        cuisinePreferences: json[r'cuisinePreferences'] is Iterable
            ? (json[r'cuisinePreferences'] as Iterable).cast<String>().toSet()
            : const {},
        notificationsEnabled: mapValueOfType<bool>(json, r'notificationsEnabled'),
        mealRemindersEnabled: mapValueOfType<bool>(json, r'mealRemindersEnabled'),
        gender: UserProfileGenderEnum.fromJson(json[r'gender']),
        currentWeight: mapValueOfType<int>(json, r'currentWeight'),
        macroResult: MacroResult.fromJson(json[r'macroResult']),
        currentWeightUnit: UserProfileCurrentWeightUnitEnum.fromJson(json[r'currentWeightUnit']),
        heightUnit: UserProfileHeightUnitEnum.fromJson(json[r'heightUnit']),
        dateOfBirth: mapDateTime(json, r'dateOfBirth', r''),
        desiredGoal: UserProfileDesiredGoalEnum.fromJson(json[r'desiredGoal']),
        desiredWeight: mapValueOfType<int>(json, r'desiredWeight'),
        desiredWeightUnit: UserProfileDesiredWeightUnitEnum.fromJson(json[r'desiredWeightUnit']),
        country: mapValueOfType<String>(json, r'country'),
      );
    }
    return null;
  }

  static List<UserProfile> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfile>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfile.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserProfile> mapFromJson(dynamic json) {
    final map = <String, UserProfile>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserProfile.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserProfile-objects as value to a dart map
  static Map<String, List<UserProfile>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserProfile>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserProfile.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class UserProfileActivityLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const UserProfileActivityLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const SEDENTARY = UserProfileActivityLevelEnum._(r'SEDENTARY');
  static const LIGHTLY_ACTIVE = UserProfileActivityLevelEnum._(r'LIGHTLY_ACTIVE');
  static const MODERATELY_ACTIVE = UserProfileActivityLevelEnum._(r'MODERATELY_ACTIVE');
  static const VERY_ACTIVE = UserProfileActivityLevelEnum._(r'VERY_ACTIVE');
  static const EXTRA_ACTIVE = UserProfileActivityLevelEnum._(r'EXTRA_ACTIVE');

  /// List of all possible values in this [enum][UserProfileActivityLevelEnum].
  static const values = <UserProfileActivityLevelEnum>[
    SEDENTARY,
    LIGHTLY_ACTIVE,
    MODERATELY_ACTIVE,
    VERY_ACTIVE,
    EXTRA_ACTIVE,
  ];

  static UserProfileActivityLevelEnum? fromJson(dynamic value) => UserProfileActivityLevelEnumTypeTransformer().decode(value);

  static List<UserProfileActivityLevelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfileActivityLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileActivityLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UserProfileActivityLevelEnum] to String,
/// and [decode] dynamic data back to [UserProfileActivityLevelEnum].
class UserProfileActivityLevelEnumTypeTransformer {
  factory UserProfileActivityLevelEnumTypeTransformer() => _instance ??= const UserProfileActivityLevelEnumTypeTransformer._();

  const UserProfileActivityLevelEnumTypeTransformer._();

  String encode(UserProfileActivityLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UserProfileActivityLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UserProfileActivityLevelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'SEDENTARY': return UserProfileActivityLevelEnum.SEDENTARY;
        case r'LIGHTLY_ACTIVE': return UserProfileActivityLevelEnum.LIGHTLY_ACTIVE;
        case r'MODERATELY_ACTIVE': return UserProfileActivityLevelEnum.MODERATELY_ACTIVE;
        case r'VERY_ACTIVE': return UserProfileActivityLevelEnum.VERY_ACTIVE;
        case r'EXTRA_ACTIVE': return UserProfileActivityLevelEnum.EXTRA_ACTIVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UserProfileActivityLevelEnumTypeTransformer] instance.
  static UserProfileActivityLevelEnumTypeTransformer? _instance;
}



class UserProfileGoalEnum {
  /// Instantiate a new enum with the provided [value].
  const UserProfileGoalEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const LOSE_WEIGHT = UserProfileGoalEnum._(r'LOSE_WEIGHT');
  static const MAINTAIN_WEIGHT = UserProfileGoalEnum._(r'MAINTAIN_WEIGHT');
  static const GAIN_WEIGHT = UserProfileGoalEnum._(r'GAIN_WEIGHT');
  static const NOTHING = UserProfileGoalEnum._(r'NOTHING');

  /// List of all possible values in this [enum][UserProfileGoalEnum].
  static const values = <UserProfileGoalEnum>[
    LOSE_WEIGHT,
    MAINTAIN_WEIGHT,
    GAIN_WEIGHT,
    NOTHING,
  ];

  static UserProfileGoalEnum? fromJson(dynamic value) => UserProfileGoalEnumTypeTransformer().decode(value);

  static List<UserProfileGoalEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfileGoalEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileGoalEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UserProfileGoalEnum] to String,
/// and [decode] dynamic data back to [UserProfileGoalEnum].
class UserProfileGoalEnumTypeTransformer {
  factory UserProfileGoalEnumTypeTransformer() => _instance ??= const UserProfileGoalEnumTypeTransformer._();

  const UserProfileGoalEnumTypeTransformer._();

  String encode(UserProfileGoalEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UserProfileGoalEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UserProfileGoalEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'LOSE_WEIGHT': return UserProfileGoalEnum.LOSE_WEIGHT;
        case r'MAINTAIN_WEIGHT': return UserProfileGoalEnum.MAINTAIN_WEIGHT;
        case r'GAIN_WEIGHT': return UserProfileGoalEnum.GAIN_WEIGHT;
        case r'NOTHING': return UserProfileGoalEnum.NOTHING;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UserProfileGoalEnumTypeTransformer] instance.
  static UserProfileGoalEnumTypeTransformer? _instance;
}



class UserProfileMacroTargetEnum {
  /// Instantiate a new enum with the provided [value].
  const UserProfileMacroTargetEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const BALANCED = UserProfileMacroTargetEnum._(r'BALANCED');
  static const HIGH_PROTEIN = UserProfileMacroTargetEnum._(r'HIGH_PROTEIN');
  static const LOW_CARB = UserProfileMacroTargetEnum._(r'LOW_CARB');
  static const LOW_FAT = UserProfileMacroTargetEnum._(r'LOW_FAT');
  static const HIGH_FIBER = UserProfileMacroTargetEnum._(r'HIGH_FIBER');

  /// List of all possible values in this [enum][UserProfileMacroTargetEnum].
  static const values = <UserProfileMacroTargetEnum>[
    BALANCED,
    HIGH_PROTEIN,
    LOW_CARB,
    LOW_FAT,
    HIGH_FIBER,
  ];

  static UserProfileMacroTargetEnum? fromJson(dynamic value) => UserProfileMacroTargetEnumTypeTransformer().decode(value);

  static List<UserProfileMacroTargetEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfileMacroTargetEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileMacroTargetEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UserProfileMacroTargetEnum] to String,
/// and [decode] dynamic data back to [UserProfileMacroTargetEnum].
class UserProfileMacroTargetEnumTypeTransformer {
  factory UserProfileMacroTargetEnumTypeTransformer() => _instance ??= const UserProfileMacroTargetEnumTypeTransformer._();

  const UserProfileMacroTargetEnumTypeTransformer._();

  String encode(UserProfileMacroTargetEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UserProfileMacroTargetEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UserProfileMacroTargetEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'BALANCED': return UserProfileMacroTargetEnum.BALANCED;
        case r'HIGH_PROTEIN': return UserProfileMacroTargetEnum.HIGH_PROTEIN;
        case r'LOW_CARB': return UserProfileMacroTargetEnum.LOW_CARB;
        case r'LOW_FAT': return UserProfileMacroTargetEnum.LOW_FAT;
        case r'HIGH_FIBER': return UserProfileMacroTargetEnum.HIGH_FIBER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UserProfileMacroTargetEnumTypeTransformer] instance.
  static UserProfileMacroTargetEnumTypeTransformer? _instance;
}



class UserProfileDietaryPreferenceEnum {
  /// Instantiate a new enum with the provided [value].
  const UserProfileDietaryPreferenceEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const NONE = UserProfileDietaryPreferenceEnum._(r'NONE');
  static const VEGETARIAN = UserProfileDietaryPreferenceEnum._(r'VEGETARIAN');
  static const VEGAN = UserProfileDietaryPreferenceEnum._(r'VEGAN');
  static const KETO = UserProfileDietaryPreferenceEnum._(r'KETO');
  static const PALEO = UserProfileDietaryPreferenceEnum._(r'PALEO');
  static const GLUTEN_FREE = UserProfileDietaryPreferenceEnum._(r'GLUTEN_FREE');
  static const DAIRY_FREE = UserProfileDietaryPreferenceEnum._(r'DAIRY_FREE');

  /// List of all possible values in this [enum][UserProfileDietaryPreferenceEnum].
  static const values = <UserProfileDietaryPreferenceEnum>[
    NONE,
    VEGETARIAN,
    VEGAN,
    KETO,
    PALEO,
    GLUTEN_FREE,
    DAIRY_FREE,
  ];

  static UserProfileDietaryPreferenceEnum? fromJson(dynamic value) => UserProfileDietaryPreferenceEnumTypeTransformer().decode(value);

  static List<UserProfileDietaryPreferenceEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfileDietaryPreferenceEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileDietaryPreferenceEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UserProfileDietaryPreferenceEnum] to String,
/// and [decode] dynamic data back to [UserProfileDietaryPreferenceEnum].
class UserProfileDietaryPreferenceEnumTypeTransformer {
  factory UserProfileDietaryPreferenceEnumTypeTransformer() => _instance ??= const UserProfileDietaryPreferenceEnumTypeTransformer._();

  const UserProfileDietaryPreferenceEnumTypeTransformer._();

  String encode(UserProfileDietaryPreferenceEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UserProfileDietaryPreferenceEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UserProfileDietaryPreferenceEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'NONE': return UserProfileDietaryPreferenceEnum.NONE;
        case r'VEGETARIAN': return UserProfileDietaryPreferenceEnum.VEGETARIAN;
        case r'VEGAN': return UserProfileDietaryPreferenceEnum.VEGAN;
        case r'KETO': return UserProfileDietaryPreferenceEnum.KETO;
        case r'PALEO': return UserProfileDietaryPreferenceEnum.PALEO;
        case r'GLUTEN_FREE': return UserProfileDietaryPreferenceEnum.GLUTEN_FREE;
        case r'DAIRY_FREE': return UserProfileDietaryPreferenceEnum.DAIRY_FREE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UserProfileDietaryPreferenceEnumTypeTransformer] instance.
  static UserProfileDietaryPreferenceEnumTypeTransformer? _instance;
}



class UserProfileGenderEnum {
  /// Instantiate a new enum with the provided [value].
  const UserProfileGenderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MALE = UserProfileGenderEnum._(r'MALE');
  static const FEMALE = UserProfileGenderEnum._(r'FEMALE');
  static const OTHER = UserProfileGenderEnum._(r'OTHER');

  /// List of all possible values in this [enum][UserProfileGenderEnum].
  static const values = <UserProfileGenderEnum>[
    MALE,
    FEMALE,
    OTHER,
  ];

  static UserProfileGenderEnum? fromJson(dynamic value) => UserProfileGenderEnumTypeTransformer().decode(value);

  static List<UserProfileGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfileGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UserProfileGenderEnum] to String,
/// and [decode] dynamic data back to [UserProfileGenderEnum].
class UserProfileGenderEnumTypeTransformer {
  factory UserProfileGenderEnumTypeTransformer() => _instance ??= const UserProfileGenderEnumTypeTransformer._();

  const UserProfileGenderEnumTypeTransformer._();

  String encode(UserProfileGenderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UserProfileGenderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UserProfileGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MALE': return UserProfileGenderEnum.MALE;
        case r'FEMALE': return UserProfileGenderEnum.FEMALE;
        case r'OTHER': return UserProfileGenderEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UserProfileGenderEnumTypeTransformer] instance.
  static UserProfileGenderEnumTypeTransformer? _instance;
}



class UserProfileCurrentWeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const UserProfileCurrentWeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const KG = UserProfileCurrentWeightUnitEnum._(r'KG');
  static const POUNDS = UserProfileCurrentWeightUnitEnum._(r'POUNDS');

  /// List of all possible values in this [enum][UserProfileCurrentWeightUnitEnum].
  static const values = <UserProfileCurrentWeightUnitEnum>[
    KG,
    POUNDS,
  ];

  static UserProfileCurrentWeightUnitEnum? fromJson(dynamic value) => UserProfileCurrentWeightUnitEnumTypeTransformer().decode(value);

  static List<UserProfileCurrentWeightUnitEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfileCurrentWeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileCurrentWeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UserProfileCurrentWeightUnitEnum] to String,
/// and [decode] dynamic data back to [UserProfileCurrentWeightUnitEnum].
class UserProfileCurrentWeightUnitEnumTypeTransformer {
  factory UserProfileCurrentWeightUnitEnumTypeTransformer() => _instance ??= const UserProfileCurrentWeightUnitEnumTypeTransformer._();

  const UserProfileCurrentWeightUnitEnumTypeTransformer._();

  String encode(UserProfileCurrentWeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UserProfileCurrentWeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UserProfileCurrentWeightUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'KG': return UserProfileCurrentWeightUnitEnum.KG;
        case r'POUNDS': return UserProfileCurrentWeightUnitEnum.POUNDS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UserProfileCurrentWeightUnitEnumTypeTransformer] instance.
  static UserProfileCurrentWeightUnitEnumTypeTransformer? _instance;
}



class UserProfileHeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const UserProfileHeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const CM = UserProfileHeightUnitEnum._(r'CM');
  static const FT = UserProfileHeightUnitEnum._(r'FT');

  /// List of all possible values in this [enum][UserProfileHeightUnitEnum].
  static const values = <UserProfileHeightUnitEnum>[
    CM,
    FT,
  ];

  static UserProfileHeightUnitEnum? fromJson(dynamic value) => UserProfileHeightUnitEnumTypeTransformer().decode(value);

  static List<UserProfileHeightUnitEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfileHeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileHeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UserProfileHeightUnitEnum] to String,
/// and [decode] dynamic data back to [UserProfileHeightUnitEnum].
class UserProfileHeightUnitEnumTypeTransformer {
  factory UserProfileHeightUnitEnumTypeTransformer() => _instance ??= const UserProfileHeightUnitEnumTypeTransformer._();

  const UserProfileHeightUnitEnumTypeTransformer._();

  String encode(UserProfileHeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UserProfileHeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UserProfileHeightUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'CM': return UserProfileHeightUnitEnum.CM;
        case r'FT': return UserProfileHeightUnitEnum.FT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UserProfileHeightUnitEnumTypeTransformer] instance.
  static UserProfileHeightUnitEnumTypeTransformer? _instance;
}



class UserProfileDesiredGoalEnum {
  /// Instantiate a new enum with the provided [value].
  const UserProfileDesiredGoalEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const LOSE_WEIGHT = UserProfileDesiredGoalEnum._(r'LOSE_WEIGHT');
  static const MAINTAIN_WEIGHT = UserProfileDesiredGoalEnum._(r'MAINTAIN_WEIGHT');
  static const GAIN_WEIGHT = UserProfileDesiredGoalEnum._(r'GAIN_WEIGHT');
  static const NOTHING = UserProfileDesiredGoalEnum._(r'NOTHING');

  /// List of all possible values in this [enum][UserProfileDesiredGoalEnum].
  static const values = <UserProfileDesiredGoalEnum>[
    LOSE_WEIGHT,
    MAINTAIN_WEIGHT,
    GAIN_WEIGHT,
    NOTHING,
  ];

  static UserProfileDesiredGoalEnum? fromJson(dynamic value) => UserProfileDesiredGoalEnumTypeTransformer().decode(value);

  static List<UserProfileDesiredGoalEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfileDesiredGoalEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileDesiredGoalEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UserProfileDesiredGoalEnum] to String,
/// and [decode] dynamic data back to [UserProfileDesiredGoalEnum].
class UserProfileDesiredGoalEnumTypeTransformer {
  factory UserProfileDesiredGoalEnumTypeTransformer() => _instance ??= const UserProfileDesiredGoalEnumTypeTransformer._();

  const UserProfileDesiredGoalEnumTypeTransformer._();

  String encode(UserProfileDesiredGoalEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UserProfileDesiredGoalEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UserProfileDesiredGoalEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'LOSE_WEIGHT': return UserProfileDesiredGoalEnum.LOSE_WEIGHT;
        case r'MAINTAIN_WEIGHT': return UserProfileDesiredGoalEnum.MAINTAIN_WEIGHT;
        case r'GAIN_WEIGHT': return UserProfileDesiredGoalEnum.GAIN_WEIGHT;
        case r'NOTHING': return UserProfileDesiredGoalEnum.NOTHING;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UserProfileDesiredGoalEnumTypeTransformer] instance.
  static UserProfileDesiredGoalEnumTypeTransformer? _instance;
}



class UserProfileDesiredWeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const UserProfileDesiredWeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const KG = UserProfileDesiredWeightUnitEnum._(r'KG');
  static const POUNDS = UserProfileDesiredWeightUnitEnum._(r'POUNDS');

  /// List of all possible values in this [enum][UserProfileDesiredWeightUnitEnum].
  static const values = <UserProfileDesiredWeightUnitEnum>[
    KG,
    POUNDS,
  ];

  static UserProfileDesiredWeightUnitEnum? fromJson(dynamic value) => UserProfileDesiredWeightUnitEnumTypeTransformer().decode(value);

  static List<UserProfileDesiredWeightUnitEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserProfileDesiredWeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserProfileDesiredWeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UserProfileDesiredWeightUnitEnum] to String,
/// and [decode] dynamic data back to [UserProfileDesiredWeightUnitEnum].
class UserProfileDesiredWeightUnitEnumTypeTransformer {
  factory UserProfileDesiredWeightUnitEnumTypeTransformer() => _instance ??= const UserProfileDesiredWeightUnitEnumTypeTransformer._();

  const UserProfileDesiredWeightUnitEnumTypeTransformer._();

  String encode(UserProfileDesiredWeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UserProfileDesiredWeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UserProfileDesiredWeightUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'KG': return UserProfileDesiredWeightUnitEnum.KG;
        case r'POUNDS': return UserProfileDesiredWeightUnitEnum.POUNDS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UserProfileDesiredWeightUnitEnumTypeTransformer] instance.
  static UserProfileDesiredWeightUnitEnumTypeTransformer? _instance;
}


