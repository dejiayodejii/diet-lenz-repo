//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class StreakInfoDto {
  /// Returns a new [StreakInfoDto] instance.
  StreakInfoDto({
    this.currentBasicStreak,
    this.longestBasicStreak,
    this.currentMacroStreak,
    this.longestMacroStreak,
    this.lastLoggedDate,
    this.totalDaysLogged,
    this.macrosGoalMet,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? currentBasicStreak;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? longestBasicStreak;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? currentMacroStreak;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? longestMacroStreak;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? lastLoggedDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? totalDaysLogged;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? macrosGoalMet;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StreakInfoDto &&
          other.currentBasicStreak == currentBasicStreak &&
          other.longestBasicStreak == longestBasicStreak &&
          other.currentMacroStreak == currentMacroStreak &&
          other.longestMacroStreak == longestMacroStreak &&
          other.lastLoggedDate == lastLoggedDate &&
          other.totalDaysLogged == totalDaysLogged &&
          other.macrosGoalMet == macrosGoalMet;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (currentBasicStreak == null ? 0 : currentBasicStreak!.hashCode) +
      (longestBasicStreak == null ? 0 : longestBasicStreak!.hashCode) +
      (currentMacroStreak == null ? 0 : currentMacroStreak!.hashCode) +
      (longestMacroStreak == null ? 0 : longestMacroStreak!.hashCode) +
      (lastLoggedDate == null ? 0 : lastLoggedDate!.hashCode) +
      (totalDaysLogged == null ? 0 : totalDaysLogged!.hashCode) +
      (macrosGoalMet == null ? 0 : macrosGoalMet!.hashCode);

  @override
  String toString() =>
      'StreakInfoDto[currentBasicStreak=$currentBasicStreak, longestBasicStreak=$longestBasicStreak, currentMacroStreak=$currentMacroStreak, longestMacroStreak=$longestMacroStreak, lastLoggedDate=$lastLoggedDate, totalDaysLogged=$totalDaysLogged, macrosGoalMet=$macrosGoalMet]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.currentBasicStreak != null) {
      json[r'currentBasicStreak'] = this.currentBasicStreak;
    } else {
      json[r'currentBasicStreak'] = null;
    }
    if (this.longestBasicStreak != null) {
      json[r'longestBasicStreak'] = this.longestBasicStreak;
    } else {
      json[r'longestBasicStreak'] = null;
    }
    if (this.currentMacroStreak != null) {
      json[r'currentMacroStreak'] = this.currentMacroStreak;
    } else {
      json[r'currentMacroStreak'] = null;
    }
    if (this.longestMacroStreak != null) {
      json[r'longestMacroStreak'] = this.longestMacroStreak;
    } else {
      json[r'longestMacroStreak'] = null;
    }
    if (this.lastLoggedDate != null) {
      json[r'lastLoggedDate'] =
          _dateFormatter.format(this.lastLoggedDate!.toUtc());
    } else {
      json[r'lastLoggedDate'] = null;
    }
    if (this.totalDaysLogged != null) {
      json[r'totalDaysLogged'] = this.totalDaysLogged;
    } else {
      json[r'totalDaysLogged'] = null;
    }
    if (this.macrosGoalMet != null) {
      json[r'macrosGoalMet'] = this.macrosGoalMet;
    } else {
      json[r'macrosGoalMet'] = null;
    }
    return json;
  }

  /// Returns a new [StreakInfoDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static StreakInfoDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "StreakInfoDto[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "StreakInfoDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return StreakInfoDto(
        currentBasicStreak: mapValueOfType<int>(json, r'currentBasicStreak'),
        longestBasicStreak: mapValueOfType<int>(json, r'longestBasicStreak'),
        currentMacroStreak: mapValueOfType<int>(json, r'currentMacroStreak'),
        longestMacroStreak: mapValueOfType<int>(json, r'longestMacroStreak'),
        lastLoggedDate: mapDateTime(json, r'lastLoggedDate', r''),
        totalDaysLogged: mapValueOfType<int>(json, r'totalDaysLogged'),
        macrosGoalMet: mapValueOfType<int>(json, r'macrosGoalMet'),
      );
    }
    return null;
  }

  static List<StreakInfoDto> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <StreakInfoDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = StreakInfoDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, StreakInfoDto> mapFromJson(dynamic json) {
    final map = <String, StreakInfoDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = StreakInfoDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of StreakInfoDto-objects as value to a dart map
  static Map<String, List<StreakInfoDto>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<StreakInfoDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = StreakInfoDto.listFromJson(
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
