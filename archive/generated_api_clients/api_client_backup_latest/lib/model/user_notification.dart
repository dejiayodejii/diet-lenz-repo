//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserNotification {
  /// Returns a new [UserNotification] instance.
  UserNotification({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.title,
    this.message,
    this.readAt,
    this.actionUrl,
    this.read,
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

  UserNotificationTypeEnum? type;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? title;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? message;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? readAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? actionUrl;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? read;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserNotification &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.type == type &&
    other.title == title &&
    other.message == message &&
    other.readAt == readAt &&
    other.actionUrl == actionUrl &&
    other.read == read;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode) +
    (type == null ? 0 : type!.hashCode) +
    (title == null ? 0 : title!.hashCode) +
    (message == null ? 0 : message!.hashCode) +
    (readAt == null ? 0 : readAt!.hashCode) +
    (actionUrl == null ? 0 : actionUrl!.hashCode) +
    (read == null ? 0 : read!.hashCode);

  @override
  String toString() => 'UserNotification[id=$id, createdAt=$createdAt, updatedAt=$updatedAt, type=$type, title=$title, message=$message, readAt=$readAt, actionUrl=$actionUrl, read=$read]';

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
    if (this.type != null) {
      json[r'type'] = this.type;
    } else {
      json[r'type'] = null;
    }
    if (this.title != null) {
      json[r'title'] = this.title;
    } else {
      json[r'title'] = null;
    }
    if (this.message != null) {
      json[r'message'] = this.message;
    } else {
      json[r'message'] = null;
    }
    if (this.readAt != null) {
      json[r'readAt'] = this.readAt!.toUtc().toIso8601String();
    } else {
      json[r'readAt'] = null;
    }
    if (this.actionUrl != null) {
      json[r'actionUrl'] = this.actionUrl;
    } else {
      json[r'actionUrl'] = null;
    }
    if (this.read != null) {
      json[r'read'] = this.read;
    } else {
      json[r'read'] = null;
    }
    return json;
  }

  /// Returns a new [UserNotification] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserNotification? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserNotification[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserNotification[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserNotification(
        id: mapValueOfType<String>(json, r'id'),
        createdAt: mapDateTime(json, r'createdAt', r''),
        updatedAt: mapDateTime(json, r'updatedAt', r''),
        type: UserNotificationTypeEnum.fromJson(json[r'type']),
        title: mapValueOfType<String>(json, r'title'),
        message: mapValueOfType<String>(json, r'message'),
        readAt: mapDateTime(json, r'readAt', r''),
        actionUrl: mapValueOfType<String>(json, r'actionUrl'),
        read: mapValueOfType<bool>(json, r'read'),
      );
    }
    return null;
  }

  static List<UserNotification> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserNotification>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserNotification.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserNotification> mapFromJson(dynamic json) {
    final map = <String, UserNotification>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserNotification.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserNotification-objects as value to a dart map
  static Map<String, List<UserNotification>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserNotification>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserNotification.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class UserNotificationTypeEnum {
  /// Instantiate a new enum with the provided [value].
  const UserNotificationTypeEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const MEAL_REMINDER = UserNotificationTypeEnum._(r'MEAL_REMINDER');
  static const RECIPE_SUGGESTION = UserNotificationTypeEnum._(r'RECIPE_SUGGESTION');
  static const GOAL_ACHIEVEMENT = UserNotificationTypeEnum._(r'GOAL_ACHIEVEMENT');
  static const SYSTEM_UPDATE = UserNotificationTypeEnum._(r'SYSTEM_UPDATE');
  static const RECIPE_SAVED = UserNotificationTypeEnum._(r'RECIPE_SAVED');
  static const WEEKLY_SUMMARY = UserNotificationTypeEnum._(r'WEEKLY_SUMMARY');

  /// List of all possible values in this [enum][UserNotificationTypeEnum].
  static const values = <UserNotificationTypeEnum>[
    MEAL_REMINDER,
    RECIPE_SUGGESTION,
    GOAL_ACHIEVEMENT,
    SYSTEM_UPDATE,
    RECIPE_SAVED,
    WEEKLY_SUMMARY,
  ];

  static UserNotificationTypeEnum? fromJson(dynamic value) => UserNotificationTypeEnumTypeTransformer().decode(value);

  static List<UserNotificationTypeEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserNotificationTypeEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserNotificationTypeEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [UserNotificationTypeEnum] to String,
/// and [decode] dynamic data back to [UserNotificationTypeEnum].
class UserNotificationTypeEnumTypeTransformer {
  factory UserNotificationTypeEnumTypeTransformer() => _instance ??= const UserNotificationTypeEnumTypeTransformer._();

  const UserNotificationTypeEnumTypeTransformer._();

  String encode(UserNotificationTypeEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a UserNotificationTypeEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  UserNotificationTypeEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'MEAL_REMINDER': return UserNotificationTypeEnum.MEAL_REMINDER;
        case r'RECIPE_SUGGESTION': return UserNotificationTypeEnum.RECIPE_SUGGESTION;
        case r'GOAL_ACHIEVEMENT': return UserNotificationTypeEnum.GOAL_ACHIEVEMENT;
        case r'SYSTEM_UPDATE': return UserNotificationTypeEnum.SYSTEM_UPDATE;
        case r'RECIPE_SAVED': return UserNotificationTypeEnum.RECIPE_SAVED;
        case r'WEEKLY_SUMMARY': return UserNotificationTypeEnum.WEEKLY_SUMMARY;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [UserNotificationTypeEnumTypeTransformer] instance.
  static UserNotificationTypeEnumTypeTransformer? _instance;
}


