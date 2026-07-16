//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class OnboardingSurveyRequest {
  /// Returns a new [OnboardingSurveyRequest] instance.
  OnboardingSurveyRequest({
    this.hearAboutUs,
    this.referralCode,
    required this.desiredGoal,
    required this.gender,
    required this.dateOfBirth,
    required this.height,
    required this.heightUnit,
    required this.currentWeight,
    required this.currentWeightUnit,
    required this.activityLevel,
    this.allergenExclusions = const [],
    this.targetEvent,
    this.targetEventDate,
    required this.desiredWeight,
    required this.desiredWeightUnit,
    required this.goalPace,
    this.biggestChallenge,
    this.notificationsEnabled,
    this.mealRemindersEnabled,
    this.healthSyncSettings,
    this.timeZone,
    this.countryCode,
  });

  OnboardingSurveyRequestHearAboutUsEnum? hearAboutUs;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? referralCode;

  OnboardingSurveyRequestDesiredGoalEnum desiredGoal;

  OnboardingSurveyRequestGenderEnum gender;

  DateTime dateOfBirth;

  num height;

  OnboardingSurveyRequestHeightUnitEnum heightUnit;

  int currentWeight;

  OnboardingSurveyRequestCurrentWeightUnitEnum currentWeightUnit;

  OnboardingSurveyRequestActivityLevelEnum activityLevel;

  List<String> allergenExclusions;

  OnboardingSurveyRequestTargetEventEnum? targetEvent;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? targetEventDate;

  int desiredWeight;

  OnboardingSurveyRequestDesiredWeightUnitEnum desiredWeightUnit;

  OnboardingSurveyRequestGoalPaceEnum goalPace;

  OnboardingSurveyRequestBiggestChallengeEnum? biggestChallenge;

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

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  HealthSyncSettingsDto? healthSyncSettings;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? timeZone;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? countryCode;

  @override
  bool operator ==(Object other) => identical(this, other) || other is OnboardingSurveyRequest &&
    other.hearAboutUs == hearAboutUs &&
    other.referralCode == referralCode &&
    other.desiredGoal == desiredGoal &&
    other.gender == gender &&
    other.dateOfBirth == dateOfBirth &&
    other.height == height &&
    other.heightUnit == heightUnit &&
    other.currentWeight == currentWeight &&
    other.currentWeightUnit == currentWeightUnit &&
    other.activityLevel == activityLevel &&
    _deepEquality.equals(other.allergenExclusions, allergenExclusions) &&
    other.targetEvent == targetEvent &&
    other.targetEventDate == targetEventDate &&
    other.desiredWeight == desiredWeight &&
    other.desiredWeightUnit == desiredWeightUnit &&
    other.goalPace == goalPace &&
    other.biggestChallenge == biggestChallenge &&
    other.notificationsEnabled == notificationsEnabled &&
    other.mealRemindersEnabled == mealRemindersEnabled &&
    other.healthSyncSettings == healthSyncSettings &&
    other.timeZone == timeZone &&
    other.countryCode == countryCode;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (hearAboutUs == null ? 0 : hearAboutUs!.hashCode) +
    (referralCode == null ? 0 : referralCode!.hashCode) +
    (desiredGoal.hashCode) +
    (gender.hashCode) +
    (dateOfBirth.hashCode) +
    (height.hashCode) +
    (heightUnit.hashCode) +
    (currentWeight.hashCode) +
    (currentWeightUnit.hashCode) +
    (activityLevel.hashCode) +
    (allergenExclusions.hashCode) +
    (targetEvent == null ? 0 : targetEvent!.hashCode) +
    (targetEventDate == null ? 0 : targetEventDate!.hashCode) +
    (desiredWeight.hashCode) +
    (desiredWeightUnit.hashCode) +
    (goalPace.hashCode) +
    (biggestChallenge == null ? 0 : biggestChallenge!.hashCode) +
    (notificationsEnabled == null ? 0 : notificationsEnabled!.hashCode) +
    (mealRemindersEnabled == null ? 0 : mealRemindersEnabled!.hashCode) +
    (healthSyncSettings == null ? 0 : healthSyncSettings!.hashCode) +
    (timeZone == null ? 0 : timeZone!.hashCode) +
    (countryCode == null ? 0 : countryCode!.hashCode);

  @override
  String toString() => 'OnboardingSurveyRequest[hearAboutUs=$hearAboutUs, referralCode=$referralCode, desiredGoal=$desiredGoal, gender=$gender, dateOfBirth=$dateOfBirth, height=$height, heightUnit=$heightUnit, currentWeight=$currentWeight, currentWeightUnit=$currentWeightUnit, activityLevel=$activityLevel, allergenExclusions=$allergenExclusions, targetEvent=$targetEvent, targetEventDate=$targetEventDate, desiredWeight=$desiredWeight, desiredWeightUnit=$desiredWeightUnit, goalPace=$goalPace, biggestChallenge=$biggestChallenge, notificationsEnabled=$notificationsEnabled, mealRemindersEnabled=$mealRemindersEnabled, healthSyncSettings=$healthSyncSettings, timeZone=$timeZone, countryCode=$countryCode]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.hearAboutUs != null) {
      json[r'hearAboutUs'] = this.hearAboutUs;
    } else {
      json[r'hearAboutUs'] = null;
    }
    if (this.referralCode != null) {
      json[r'referralCode'] = this.referralCode;
    } else {
      json[r'referralCode'] = null;
    }
      json[r'desiredGoal'] = this.desiredGoal;
      json[r'gender'] = this.gender;
      json[r'dateOfBirth'] = _dateFormatter.format(this.dateOfBirth.toUtc());
      json[r'height'] = this.height;
      json[r'heightUnit'] = this.heightUnit;
      json[r'currentWeight'] = this.currentWeight;
      json[r'currentWeightUnit'] = this.currentWeightUnit;
      json[r'activityLevel'] = this.activityLevel;
      json[r'allergenExclusions'] = this.allergenExclusions;
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
      json[r'desiredWeight'] = this.desiredWeight;
      json[r'desiredWeightUnit'] = this.desiredWeightUnit;
      json[r'goalPace'] = this.goalPace;
    if (this.biggestChallenge != null) {
      json[r'biggestChallenge'] = this.biggestChallenge;
    } else {
      json[r'biggestChallenge'] = null;
    }
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
    if (this.healthSyncSettings != null) {
      json[r'healthSyncSettings'] = this.healthSyncSettings;
    } else {
      json[r'healthSyncSettings'] = null;
    }
    if (this.timeZone != null) {
      json[r'timeZone'] = this.timeZone;
    } else {
      json[r'timeZone'] = null;
    }
    if (this.countryCode != null) {
      json[r'countryCode'] = this.countryCode;
    } else {
      json[r'countryCode'] = null;
    }
    return json;
  }

  /// Returns a new [OnboardingSurveyRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static OnboardingSurveyRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "OnboardingSurveyRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "OnboardingSurveyRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return OnboardingSurveyRequest(
        hearAboutUs: OnboardingSurveyRequestHearAboutUsEnum.fromJson(json[r'hearAboutUs']),
        referralCode: mapValueOfType<String>(json, r'referralCode'),
        desiredGoal: OnboardingSurveyRequestDesiredGoalEnum.fromJson(json[r'desiredGoal'])!,
        gender: OnboardingSurveyRequestGenderEnum.fromJson(json[r'gender'])!,
        dateOfBirth: mapDateTime(json, r'dateOfBirth', r'')!,
        height: num.parse('${json[r'height']}'),
        heightUnit: OnboardingSurveyRequestHeightUnitEnum.fromJson(json[r'heightUnit'])!,
        currentWeight: mapValueOfType<int>(json, r'currentWeight')!,
        currentWeightUnit: OnboardingSurveyRequestCurrentWeightUnitEnum.fromJson(json[r'currentWeightUnit'])!,
        activityLevel: OnboardingSurveyRequestActivityLevelEnum.fromJson(json[r'activityLevel'])!,
        allergenExclusions: json[r'allergenExclusions'] is Iterable
            ? (json[r'allergenExclusions'] as Iterable).cast<String>().toList(growable: false)
            : const [],
        targetEvent: OnboardingSurveyRequestTargetEventEnum.fromJson(json[r'targetEvent']),
        targetEventDate: mapDateTime(json, r'targetEventDate', r''),
        desiredWeight: mapValueOfType<int>(json, r'desiredWeight')!,
        desiredWeightUnit: OnboardingSurveyRequestDesiredWeightUnitEnum.fromJson(json[r'desiredWeightUnit'])!,
        goalPace: OnboardingSurveyRequestGoalPaceEnum.fromJson(json[r'goalPace'])!,
        biggestChallenge: OnboardingSurveyRequestBiggestChallengeEnum.fromJson(json[r'biggestChallenge']),
        notificationsEnabled: mapValueOfType<bool>(json, r'notificationsEnabled'),
        mealRemindersEnabled: mapValueOfType<bool>(json, r'mealRemindersEnabled'),
        healthSyncSettings: HealthSyncSettingsDto.fromJson(json[r'healthSyncSettings']),
        timeZone: mapValueOfType<String>(json, r'timeZone'),
        countryCode: mapValueOfType<String>(json, r'countryCode'),
      );
    }
    return null;
  }

  static List<OnboardingSurveyRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, OnboardingSurveyRequest> mapFromJson(dynamic json) {
    final map = <String, OnboardingSurveyRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = OnboardingSurveyRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of OnboardingSurveyRequest-objects as value to a dart map
  static Map<String, List<OnboardingSurveyRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<OnboardingSurveyRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = OnboardingSurveyRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'desiredGoal',
    'gender',
    'dateOfBirth',
    'height',
    'heightUnit',
    'currentWeight',
    'currentWeightUnit',
    'activityLevel',
    'desiredWeight',
    'desiredWeightUnit',
    'goalPace',
  };
}


class OnboardingSurveyRequestHearAboutUsEnum {
  /// Instantiate a new enum with the provided [value].
  const OnboardingSurveyRequestHearAboutUsEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const FROM_INFLUENCER = OnboardingSurveyRequestHearAboutUsEnum._(r'FROM_INFLUENCER');
  static const INSTAGRAM = OnboardingSurveyRequestHearAboutUsEnum._(r'INSTAGRAM');
  static const TIKTOK = OnboardingSurveyRequestHearAboutUsEnum._(r'TIKTOK');
  static const YOUTUBE = OnboardingSurveyRequestHearAboutUsEnum._(r'YOUTUBE');
  static const APP_STORE_SEARCH = OnboardingSurveyRequestHearAboutUsEnum._(r'APP_STORE_SEARCH');
  static const FRIEND_FAMILY = OnboardingSurveyRequestHearAboutUsEnum._(r'FRIEND_FAMILY');
  static const OTHER = OnboardingSurveyRequestHearAboutUsEnum._(r'OTHER');

  /// List of all possible values in this [enum][OnboardingSurveyRequestHearAboutUsEnum].
  static const values = <OnboardingSurveyRequestHearAboutUsEnum>[
    FROM_INFLUENCER,
    INSTAGRAM,
    TIKTOK,
    YOUTUBE,
    APP_STORE_SEARCH,
    FRIEND_FAMILY,
    OTHER,
  ];

  static OnboardingSurveyRequestHearAboutUsEnum? fromJson(dynamic value) => OnboardingSurveyRequestHearAboutUsEnumTypeTransformer().decode(value);

  static List<OnboardingSurveyRequestHearAboutUsEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequestHearAboutUsEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequestHearAboutUsEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnboardingSurveyRequestHearAboutUsEnum] to String,
/// and [decode] dynamic data back to [OnboardingSurveyRequestHearAboutUsEnum].
class OnboardingSurveyRequestHearAboutUsEnumTypeTransformer {
  factory OnboardingSurveyRequestHearAboutUsEnumTypeTransformer() => _instance ??= const OnboardingSurveyRequestHearAboutUsEnumTypeTransformer._();

  const OnboardingSurveyRequestHearAboutUsEnumTypeTransformer._();

  String encode(OnboardingSurveyRequestHearAboutUsEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OnboardingSurveyRequestHearAboutUsEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnboardingSurveyRequestHearAboutUsEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'FROM_INFLUENCER': return OnboardingSurveyRequestHearAboutUsEnum.FROM_INFLUENCER;
        case r'INSTAGRAM': return OnboardingSurveyRequestHearAboutUsEnum.INSTAGRAM;
        case r'TIKTOK': return OnboardingSurveyRequestHearAboutUsEnum.TIKTOK;
        case r'YOUTUBE': return OnboardingSurveyRequestHearAboutUsEnum.YOUTUBE;
        case r'APP_STORE_SEARCH': return OnboardingSurveyRequestHearAboutUsEnum.APP_STORE_SEARCH;
        case r'FRIEND_FAMILY': return OnboardingSurveyRequestHearAboutUsEnum.FRIEND_FAMILY;
        case r'OTHER': return OnboardingSurveyRequestHearAboutUsEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OnboardingSurveyRequestHearAboutUsEnumTypeTransformer] instance.
  static OnboardingSurveyRequestHearAboutUsEnumTypeTransformer? _instance;
}



class OnboardingSurveyRequestDesiredGoalEnum {
  /// Instantiate a new enum with the provided [value].
  const OnboardingSurveyRequestDesiredGoalEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const LOSE_WEIGHT = OnboardingSurveyRequestDesiredGoalEnum._(r'LOSE_WEIGHT');
  static const MAINTAIN_WEIGHT = OnboardingSurveyRequestDesiredGoalEnum._(r'MAINTAIN_WEIGHT');
  static const GAIN_WEIGHT = OnboardingSurveyRequestDesiredGoalEnum._(r'GAIN_WEIGHT');
  static const NOTHING = OnboardingSurveyRequestDesiredGoalEnum._(r'NOTHING');

  /// List of all possible values in this [enum][OnboardingSurveyRequestDesiredGoalEnum].
  static const values = <OnboardingSurveyRequestDesiredGoalEnum>[
    LOSE_WEIGHT,
    MAINTAIN_WEIGHT,
    GAIN_WEIGHT,
    NOTHING,
  ];

  static OnboardingSurveyRequestDesiredGoalEnum? fromJson(dynamic value) => OnboardingSurveyRequestDesiredGoalEnumTypeTransformer().decode(value);

  static List<OnboardingSurveyRequestDesiredGoalEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequestDesiredGoalEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequestDesiredGoalEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnboardingSurveyRequestDesiredGoalEnum] to String,
/// and [decode] dynamic data back to [OnboardingSurveyRequestDesiredGoalEnum].
class OnboardingSurveyRequestDesiredGoalEnumTypeTransformer {
  factory OnboardingSurveyRequestDesiredGoalEnumTypeTransformer() => _instance ??= const OnboardingSurveyRequestDesiredGoalEnumTypeTransformer._();

  const OnboardingSurveyRequestDesiredGoalEnumTypeTransformer._();

  String encode(OnboardingSurveyRequestDesiredGoalEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OnboardingSurveyRequestDesiredGoalEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnboardingSurveyRequestDesiredGoalEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'LOSE_WEIGHT': return OnboardingSurveyRequestDesiredGoalEnum.LOSE_WEIGHT;
        case r'MAINTAIN_WEIGHT': return OnboardingSurveyRequestDesiredGoalEnum.MAINTAIN_WEIGHT;
        case r'GAIN_WEIGHT': return OnboardingSurveyRequestDesiredGoalEnum.GAIN_WEIGHT;
        case r'NOTHING': return OnboardingSurveyRequestDesiredGoalEnum.NOTHING;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OnboardingSurveyRequestDesiredGoalEnumTypeTransformer] instance.
  static OnboardingSurveyRequestDesiredGoalEnumTypeTransformer? _instance;
}



class OnboardingSurveyRequestGenderEnum {
  /// Instantiate a new enum with the provided [value].
  const OnboardingSurveyRequestGenderEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MALE = OnboardingSurveyRequestGenderEnum._(r'MALE');
  static const FEMALE = OnboardingSurveyRequestGenderEnum._(r'FEMALE');
  static const OTHER = OnboardingSurveyRequestGenderEnum._(r'OTHER');

  /// List of all possible values in this [enum][OnboardingSurveyRequestGenderEnum].
  static const values = <OnboardingSurveyRequestGenderEnum>[
    MALE,
    FEMALE,
    OTHER,
  ];

  static OnboardingSurveyRequestGenderEnum? fromJson(dynamic value) => OnboardingSurveyRequestGenderEnumTypeTransformer().decode(value);

  static List<OnboardingSurveyRequestGenderEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequestGenderEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequestGenderEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnboardingSurveyRequestGenderEnum] to String,
/// and [decode] dynamic data back to [OnboardingSurveyRequestGenderEnum].
class OnboardingSurveyRequestGenderEnumTypeTransformer {
  factory OnboardingSurveyRequestGenderEnumTypeTransformer() => _instance ??= const OnboardingSurveyRequestGenderEnumTypeTransformer._();

  const OnboardingSurveyRequestGenderEnumTypeTransformer._();

  String encode(OnboardingSurveyRequestGenderEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OnboardingSurveyRequestGenderEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnboardingSurveyRequestGenderEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MALE': return OnboardingSurveyRequestGenderEnum.MALE;
        case r'FEMALE': return OnboardingSurveyRequestGenderEnum.FEMALE;
        case r'OTHER': return OnboardingSurveyRequestGenderEnum.OTHER;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OnboardingSurveyRequestGenderEnumTypeTransformer] instance.
  static OnboardingSurveyRequestGenderEnumTypeTransformer? _instance;
}



class OnboardingSurveyRequestHeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const OnboardingSurveyRequestHeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const CM = OnboardingSurveyRequestHeightUnitEnum._(r'CM');
  static const FT = OnboardingSurveyRequestHeightUnitEnum._(r'FT');

  /// List of all possible values in this [enum][OnboardingSurveyRequestHeightUnitEnum].
  static const values = <OnboardingSurveyRequestHeightUnitEnum>[
    CM,
    FT,
  ];

  static OnboardingSurveyRequestHeightUnitEnum? fromJson(dynamic value) => OnboardingSurveyRequestHeightUnitEnumTypeTransformer().decode(value);

  static List<OnboardingSurveyRequestHeightUnitEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequestHeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequestHeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnboardingSurveyRequestHeightUnitEnum] to String,
/// and [decode] dynamic data back to [OnboardingSurveyRequestHeightUnitEnum].
class OnboardingSurveyRequestHeightUnitEnumTypeTransformer {
  factory OnboardingSurveyRequestHeightUnitEnumTypeTransformer() => _instance ??= const OnboardingSurveyRequestHeightUnitEnumTypeTransformer._();

  const OnboardingSurveyRequestHeightUnitEnumTypeTransformer._();

  String encode(OnboardingSurveyRequestHeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OnboardingSurveyRequestHeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnboardingSurveyRequestHeightUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'CM': return OnboardingSurveyRequestHeightUnitEnum.CM;
        case r'FT': return OnboardingSurveyRequestHeightUnitEnum.FT;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OnboardingSurveyRequestHeightUnitEnumTypeTransformer] instance.
  static OnboardingSurveyRequestHeightUnitEnumTypeTransformer? _instance;
}



class OnboardingSurveyRequestCurrentWeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const OnboardingSurveyRequestCurrentWeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const KG = OnboardingSurveyRequestCurrentWeightUnitEnum._(r'KG');
  static const POUNDS = OnboardingSurveyRequestCurrentWeightUnitEnum._(r'POUNDS');

  /// List of all possible values in this [enum][OnboardingSurveyRequestCurrentWeightUnitEnum].
  static const values = <OnboardingSurveyRequestCurrentWeightUnitEnum>[
    KG,
    POUNDS,
  ];

  static OnboardingSurveyRequestCurrentWeightUnitEnum? fromJson(dynamic value) => OnboardingSurveyRequestCurrentWeightUnitEnumTypeTransformer().decode(value);

  static List<OnboardingSurveyRequestCurrentWeightUnitEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequestCurrentWeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequestCurrentWeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnboardingSurveyRequestCurrentWeightUnitEnum] to String,
/// and [decode] dynamic data back to [OnboardingSurveyRequestCurrentWeightUnitEnum].
class OnboardingSurveyRequestCurrentWeightUnitEnumTypeTransformer {
  factory OnboardingSurveyRequestCurrentWeightUnitEnumTypeTransformer() => _instance ??= const OnboardingSurveyRequestCurrentWeightUnitEnumTypeTransformer._();

  const OnboardingSurveyRequestCurrentWeightUnitEnumTypeTransformer._();

  String encode(OnboardingSurveyRequestCurrentWeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OnboardingSurveyRequestCurrentWeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnboardingSurveyRequestCurrentWeightUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'KG': return OnboardingSurveyRequestCurrentWeightUnitEnum.KG;
        case r'POUNDS': return OnboardingSurveyRequestCurrentWeightUnitEnum.POUNDS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OnboardingSurveyRequestCurrentWeightUnitEnumTypeTransformer] instance.
  static OnboardingSurveyRequestCurrentWeightUnitEnumTypeTransformer? _instance;
}



class OnboardingSurveyRequestActivityLevelEnum {
  /// Instantiate a new enum with the provided [value].
  const OnboardingSurveyRequestActivityLevelEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const SEDENTARY = OnboardingSurveyRequestActivityLevelEnum._(r'SEDENTARY');
  static const LIGHTLY_ACTIVE = OnboardingSurveyRequestActivityLevelEnum._(r'LIGHTLY_ACTIVE');
  static const MODERATELY_ACTIVE = OnboardingSurveyRequestActivityLevelEnum._(r'MODERATELY_ACTIVE');
  static const VERY_ACTIVE = OnboardingSurveyRequestActivityLevelEnum._(r'VERY_ACTIVE');
  static const EXTRA_ACTIVE = OnboardingSurveyRequestActivityLevelEnum._(r'EXTRA_ACTIVE');

  /// List of all possible values in this [enum][OnboardingSurveyRequestActivityLevelEnum].
  static const values = <OnboardingSurveyRequestActivityLevelEnum>[
    SEDENTARY,
    LIGHTLY_ACTIVE,
    MODERATELY_ACTIVE,
    VERY_ACTIVE,
    EXTRA_ACTIVE,
  ];

  static OnboardingSurveyRequestActivityLevelEnum? fromJson(dynamic value) => OnboardingSurveyRequestActivityLevelEnumTypeTransformer().decode(value);

  static List<OnboardingSurveyRequestActivityLevelEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequestActivityLevelEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequestActivityLevelEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnboardingSurveyRequestActivityLevelEnum] to String,
/// and [decode] dynamic data back to [OnboardingSurveyRequestActivityLevelEnum].
class OnboardingSurveyRequestActivityLevelEnumTypeTransformer {
  factory OnboardingSurveyRequestActivityLevelEnumTypeTransformer() => _instance ??= const OnboardingSurveyRequestActivityLevelEnumTypeTransformer._();

  const OnboardingSurveyRequestActivityLevelEnumTypeTransformer._();

  String encode(OnboardingSurveyRequestActivityLevelEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OnboardingSurveyRequestActivityLevelEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnboardingSurveyRequestActivityLevelEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'SEDENTARY': return OnboardingSurveyRequestActivityLevelEnum.SEDENTARY;
        case r'LIGHTLY_ACTIVE': return OnboardingSurveyRequestActivityLevelEnum.LIGHTLY_ACTIVE;
        case r'MODERATELY_ACTIVE': return OnboardingSurveyRequestActivityLevelEnum.MODERATELY_ACTIVE;
        case r'VERY_ACTIVE': return OnboardingSurveyRequestActivityLevelEnum.VERY_ACTIVE;
        case r'EXTRA_ACTIVE': return OnboardingSurveyRequestActivityLevelEnum.EXTRA_ACTIVE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OnboardingSurveyRequestActivityLevelEnumTypeTransformer] instance.
  static OnboardingSurveyRequestActivityLevelEnumTypeTransformer? _instance;
}



class OnboardingSurveyRequestTargetEventEnum {
  /// Instantiate a new enum with the provided [value].
  const OnboardingSurveyRequestTargetEventEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const VACATION = OnboardingSurveyRequestTargetEventEnum._(r'VACATION');
  static const WEDDING = OnboardingSurveyRequestTargetEventEnum._(r'WEDDING');
  static const BIRTHDAY = OnboardingSurveyRequestTargetEventEnum._(r'BIRTHDAY');
  static const PERSONAL_MILESTONE = OnboardingSurveyRequestTargetEventEnum._(r'PERSONAL_MILESTONE');
  static const NONE = OnboardingSurveyRequestTargetEventEnum._(r'NONE');

  /// List of all possible values in this [enum][OnboardingSurveyRequestTargetEventEnum].
  static const values = <OnboardingSurveyRequestTargetEventEnum>[
    VACATION,
    WEDDING,
    BIRTHDAY,
    PERSONAL_MILESTONE,
    NONE,
  ];

  static OnboardingSurveyRequestTargetEventEnum? fromJson(dynamic value) => OnboardingSurveyRequestTargetEventEnumTypeTransformer().decode(value);

  static List<OnboardingSurveyRequestTargetEventEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequestTargetEventEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequestTargetEventEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnboardingSurveyRequestTargetEventEnum] to String,
/// and [decode] dynamic data back to [OnboardingSurveyRequestTargetEventEnum].
class OnboardingSurveyRequestTargetEventEnumTypeTransformer {
  factory OnboardingSurveyRequestTargetEventEnumTypeTransformer() => _instance ??= const OnboardingSurveyRequestTargetEventEnumTypeTransformer._();

  const OnboardingSurveyRequestTargetEventEnumTypeTransformer._();

  String encode(OnboardingSurveyRequestTargetEventEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OnboardingSurveyRequestTargetEventEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnboardingSurveyRequestTargetEventEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'VACATION': return OnboardingSurveyRequestTargetEventEnum.VACATION;
        case r'WEDDING': return OnboardingSurveyRequestTargetEventEnum.WEDDING;
        case r'BIRTHDAY': return OnboardingSurveyRequestTargetEventEnum.BIRTHDAY;
        case r'PERSONAL_MILESTONE': return OnboardingSurveyRequestTargetEventEnum.PERSONAL_MILESTONE;
        case r'NONE': return OnboardingSurveyRequestTargetEventEnum.NONE;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OnboardingSurveyRequestTargetEventEnumTypeTransformer] instance.
  static OnboardingSurveyRequestTargetEventEnumTypeTransformer? _instance;
}



class OnboardingSurveyRequestDesiredWeightUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const OnboardingSurveyRequestDesiredWeightUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const KG = OnboardingSurveyRequestDesiredWeightUnitEnum._(r'KG');
  static const POUNDS = OnboardingSurveyRequestDesiredWeightUnitEnum._(r'POUNDS');

  /// List of all possible values in this [enum][OnboardingSurveyRequestDesiredWeightUnitEnum].
  static const values = <OnboardingSurveyRequestDesiredWeightUnitEnum>[
    KG,
    POUNDS,
  ];

  static OnboardingSurveyRequestDesiredWeightUnitEnum? fromJson(dynamic value) => OnboardingSurveyRequestDesiredWeightUnitEnumTypeTransformer().decode(value);

  static List<OnboardingSurveyRequestDesiredWeightUnitEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequestDesiredWeightUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequestDesiredWeightUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnboardingSurveyRequestDesiredWeightUnitEnum] to String,
/// and [decode] dynamic data back to [OnboardingSurveyRequestDesiredWeightUnitEnum].
class OnboardingSurveyRequestDesiredWeightUnitEnumTypeTransformer {
  factory OnboardingSurveyRequestDesiredWeightUnitEnumTypeTransformer() => _instance ??= const OnboardingSurveyRequestDesiredWeightUnitEnumTypeTransformer._();

  const OnboardingSurveyRequestDesiredWeightUnitEnumTypeTransformer._();

  String encode(OnboardingSurveyRequestDesiredWeightUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OnboardingSurveyRequestDesiredWeightUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnboardingSurveyRequestDesiredWeightUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'KG': return OnboardingSurveyRequestDesiredWeightUnitEnum.KG;
        case r'POUNDS': return OnboardingSurveyRequestDesiredWeightUnitEnum.POUNDS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OnboardingSurveyRequestDesiredWeightUnitEnumTypeTransformer] instance.
  static OnboardingSurveyRequestDesiredWeightUnitEnumTypeTransformer? _instance;
}



class OnboardingSurveyRequestGoalPaceEnum {
  /// Instantiate a new enum with the provided [value].
  const OnboardingSurveyRequestGoalPaceEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const SLOW = OnboardingSurveyRequestGoalPaceEnum._(r'SLOW');
  static const OPTIMAL = OnboardingSurveyRequestGoalPaceEnum._(r'OPTIMAL');
  static const FAST = OnboardingSurveyRequestGoalPaceEnum._(r'FAST');

  /// List of all possible values in this [enum][OnboardingSurveyRequestGoalPaceEnum].
  static const values = <OnboardingSurveyRequestGoalPaceEnum>[
    SLOW,
    OPTIMAL,
    FAST,
  ];

  static OnboardingSurveyRequestGoalPaceEnum? fromJson(dynamic value) => OnboardingSurveyRequestGoalPaceEnumTypeTransformer().decode(value);

  static List<OnboardingSurveyRequestGoalPaceEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequestGoalPaceEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequestGoalPaceEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnboardingSurveyRequestGoalPaceEnum] to String,
/// and [decode] dynamic data back to [OnboardingSurveyRequestGoalPaceEnum].
class OnboardingSurveyRequestGoalPaceEnumTypeTransformer {
  factory OnboardingSurveyRequestGoalPaceEnumTypeTransformer() => _instance ??= const OnboardingSurveyRequestGoalPaceEnumTypeTransformer._();

  const OnboardingSurveyRequestGoalPaceEnumTypeTransformer._();

  String encode(OnboardingSurveyRequestGoalPaceEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OnboardingSurveyRequestGoalPaceEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnboardingSurveyRequestGoalPaceEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'SLOW': return OnboardingSurveyRequestGoalPaceEnum.SLOW;
        case r'OPTIMAL': return OnboardingSurveyRequestGoalPaceEnum.OPTIMAL;
        case r'FAST': return OnboardingSurveyRequestGoalPaceEnum.FAST;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OnboardingSurveyRequestGoalPaceEnumTypeTransformer] instance.
  static OnboardingSurveyRequestGoalPaceEnumTypeTransformer? _instance;
}



class OnboardingSurveyRequestBiggestChallengeEnum {
  /// Instantiate a new enum with the provided [value].
  const OnboardingSurveyRequestBiggestChallengeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const CONSISTENCY = OnboardingSurveyRequestBiggestChallengeEnum._(r'CONSISTENCY');
  static const CRAVINGS = OnboardingSurveyRequestBiggestChallengeEnum._(r'CRAVINGS');
  static const MOTIVATION = OnboardingSurveyRequestBiggestChallengeEnum._(r'MOTIVATION');
  static const EMOTIONAL_EATING = OnboardingSurveyRequestBiggestChallengeEnum._(r'EMOTIONAL_EATING');
  static const LACK_OF_KNOWLEDGE = OnboardingSurveyRequestBiggestChallengeEnum._(r'LACK_OF_KNOWLEDGE');
  static const NEED_EASIER_TOOL = OnboardingSurveyRequestBiggestChallengeEnum._(r'NEED_EASIER_TOOL');

  /// List of all possible values in this [enum][OnboardingSurveyRequestBiggestChallengeEnum].
  static const values = <OnboardingSurveyRequestBiggestChallengeEnum>[
    CONSISTENCY,
    CRAVINGS,
    MOTIVATION,
    EMOTIONAL_EATING,
    LACK_OF_KNOWLEDGE,
    NEED_EASIER_TOOL,
  ];

  static OnboardingSurveyRequestBiggestChallengeEnum? fromJson(dynamic value) => OnboardingSurveyRequestBiggestChallengeEnumTypeTransformer().decode(value);

  static List<OnboardingSurveyRequestBiggestChallengeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <OnboardingSurveyRequestBiggestChallengeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = OnboardingSurveyRequestBiggestChallengeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [OnboardingSurveyRequestBiggestChallengeEnum] to String,
/// and [decode] dynamic data back to [OnboardingSurveyRequestBiggestChallengeEnum].
class OnboardingSurveyRequestBiggestChallengeEnumTypeTransformer {
  factory OnboardingSurveyRequestBiggestChallengeEnumTypeTransformer() => _instance ??= const OnboardingSurveyRequestBiggestChallengeEnumTypeTransformer._();

  const OnboardingSurveyRequestBiggestChallengeEnumTypeTransformer._();

  String encode(OnboardingSurveyRequestBiggestChallengeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a OnboardingSurveyRequestBiggestChallengeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  OnboardingSurveyRequestBiggestChallengeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'CONSISTENCY': return OnboardingSurveyRequestBiggestChallengeEnum.CONSISTENCY;
        case r'CRAVINGS': return OnboardingSurveyRequestBiggestChallengeEnum.CRAVINGS;
        case r'MOTIVATION': return OnboardingSurveyRequestBiggestChallengeEnum.MOTIVATION;
        case r'EMOTIONAL_EATING': return OnboardingSurveyRequestBiggestChallengeEnum.EMOTIONAL_EATING;
        case r'LACK_OF_KNOWLEDGE': return OnboardingSurveyRequestBiggestChallengeEnum.LACK_OF_KNOWLEDGE;
        case r'NEED_EASIER_TOOL': return OnboardingSurveyRequestBiggestChallengeEnum.NEED_EASIER_TOOL;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [OnboardingSurveyRequestBiggestChallengeEnumTypeTransformer] instance.
  static OnboardingSurveyRequestBiggestChallengeEnumTypeTransformer? _instance;
}


