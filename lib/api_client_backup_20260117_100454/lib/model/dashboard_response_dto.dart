//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DashboardResponseDto {
  /// Returns a new [DashboardResponseDto] instance.
  DashboardResponseDto({
    this.date,
    this.targets,
    this.actuals,
    this.performance,
    this.mealsToday = const [],
    this.streaks,
    this.basicGoalMet,
    this.macroGoalMet,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? date;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MacroTargetDto? targets;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MacroActualDto? actuals;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MacroPerformanceDto? performance;

  List<MealLogResponseDto> mealsToday;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  StreakInfoDto? streaks;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? basicGoalMet;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? macroGoalMet;

  @override
  bool operator ==(Object other) => identical(this, other) || other is DashboardResponseDto &&
    other.date == date &&
    other.targets == targets &&
    other.actuals == actuals &&
    other.performance == performance &&
    _deepEquality.equals(other.mealsToday, mealsToday) &&
    other.streaks == streaks &&
    other.basicGoalMet == basicGoalMet &&
    other.macroGoalMet == macroGoalMet;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date == null ? 0 : date!.hashCode) +
    (targets == null ? 0 : targets!.hashCode) +
    (actuals == null ? 0 : actuals!.hashCode) +
    (performance == null ? 0 : performance!.hashCode) +
    (mealsToday.hashCode) +
    (streaks == null ? 0 : streaks!.hashCode) +
    (basicGoalMet == null ? 0 : basicGoalMet!.hashCode) +
    (macroGoalMet == null ? 0 : macroGoalMet!.hashCode);

  @override
  String toString() => 'DashboardResponseDto[date=$date, targets=$targets, actuals=$actuals, performance=$performance, mealsToday=$mealsToday, streaks=$streaks, basicGoalMet=$basicGoalMet, macroGoalMet=$macroGoalMet]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.date != null) {
      json[r'date'] = _dateFormatter.format(this.date!.toUtc());
    } else {
      json[r'date'] = null;
    }
    if (this.targets != null) {
      json[r'targets'] = this.targets;
    } else {
      json[r'targets'] = null;
    }
    if (this.actuals != null) {
      json[r'actuals'] = this.actuals;
    } else {
      json[r'actuals'] = null;
    }
    if (this.performance != null) {
      json[r'performance'] = this.performance;
    } else {
      json[r'performance'] = null;
    }
      json[r'mealsToday'] = this.mealsToday;
    if (this.streaks != null) {
      json[r'streaks'] = this.streaks;
    } else {
      json[r'streaks'] = null;
    }
    if (this.basicGoalMet != null) {
      json[r'basicGoalMet'] = this.basicGoalMet;
    } else {
      json[r'basicGoalMet'] = null;
    }
    if (this.macroGoalMet != null) {
      json[r'macroGoalMet'] = this.macroGoalMet;
    } else {
      json[r'macroGoalMet'] = null;
    }
    return json;
  }

  /// Returns a new [DashboardResponseDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DashboardResponseDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DashboardResponseDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DashboardResponseDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DashboardResponseDto(
        date: mapDateTime(json, r'date', r''),
        targets: MacroTargetDto.fromJson(json[r'targets']),
        actuals: MacroActualDto.fromJson(json[r'actuals']),
        performance: MacroPerformanceDto.fromJson(json[r'performance']),
        mealsToday: MealLogResponseDto.listFromJson(json[r'mealsToday']),
        streaks: StreakInfoDto.fromJson(json[r'streaks']),
        basicGoalMet: mapValueOfType<bool>(json, r'basicGoalMet'),
        macroGoalMet: mapValueOfType<bool>(json, r'macroGoalMet'),
      );
    }
    return null;
  }

  static List<DashboardResponseDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DashboardResponseDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DashboardResponseDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DashboardResponseDto> mapFromJson(dynamic json) {
    final map = <String, DashboardResponseDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DashboardResponseDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DashboardResponseDto-objects as value to a dart map
  static Map<String, List<DashboardResponseDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DashboardResponseDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DashboardResponseDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

