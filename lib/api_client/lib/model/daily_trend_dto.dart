//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class DailyTrendDto {
  /// Returns a new [DailyTrendDto] instance.
  DailyTrendDto({
    this.date,
    this.actuals,
    this.performance,
    this.mealsLogged,
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
  MacroActualDto? actuals;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  MacroPerformanceDto? performance;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? mealsLogged;

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
  bool operator ==(Object other) => identical(this, other) || other is DailyTrendDto &&
    other.date == date &&
    other.actuals == actuals &&
    other.performance == performance &&
    other.mealsLogged == mealsLogged &&
    other.basicGoalMet == basicGoalMet &&
    other.macroGoalMet == macroGoalMet;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (date == null ? 0 : date!.hashCode) +
    (actuals == null ? 0 : actuals!.hashCode) +
    (performance == null ? 0 : performance!.hashCode) +
    (mealsLogged == null ? 0 : mealsLogged!.hashCode) +
    (basicGoalMet == null ? 0 : basicGoalMet!.hashCode) +
    (macroGoalMet == null ? 0 : macroGoalMet!.hashCode);

  @override
  String toString() => 'DailyTrendDto[date=$date, actuals=$actuals, performance=$performance, mealsLogged=$mealsLogged, basicGoalMet=$basicGoalMet, macroGoalMet=$macroGoalMet]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.date != null) {
      json[r'date'] = _dateFormatter.format(this.date!.toUtc());
    } else {
      json[r'date'] = null;
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
    if (this.mealsLogged != null) {
      json[r'mealsLogged'] = this.mealsLogged;
    } else {
      json[r'mealsLogged'] = null;
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

  /// Returns a new [DailyTrendDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static DailyTrendDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "DailyTrendDto[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "DailyTrendDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return DailyTrendDto(
        date: mapDateTime(json, r'date', r''),
        actuals: MacroActualDto.fromJson(json[r'actuals']),
        performance: MacroPerformanceDto.fromJson(json[r'performance']),
        mealsLogged: mapValueOfType<int>(json, r'mealsLogged'),
        basicGoalMet: mapValueOfType<bool>(json, r'basicGoalMet'),
        macroGoalMet: mapValueOfType<bool>(json, r'macroGoalMet'),
      );
    }
    return null;
  }

  static List<DailyTrendDto> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <DailyTrendDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = DailyTrendDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, DailyTrendDto> mapFromJson(dynamic json) {
    final map = <String, DailyTrendDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = DailyTrendDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of DailyTrendDto-objects as value to a dart map
  static Map<String, List<DailyTrendDto>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<DailyTrendDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = DailyTrendDto.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

