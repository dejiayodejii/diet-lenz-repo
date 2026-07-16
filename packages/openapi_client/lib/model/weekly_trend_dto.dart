//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WeeklyTrendDto {
  /// Returns a new [WeeklyTrendDto] instance.
  WeeklyTrendDto({
    this.startDate,
    this.endDate,
    this.dailyTrends = const [],
    this.averages,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? startDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? endDate;

  List<DailyTrendDto> dailyTrends;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  AverageMacrosDto? averages;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeeklyTrendDto &&
          other.startDate == startDate &&
          other.endDate == endDate &&
          _deepEquality.equals(other.dailyTrends, dailyTrends) &&
          other.averages == averages;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (startDate == null ? 0 : startDate!.hashCode) +
      (endDate == null ? 0 : endDate!.hashCode) +
      (dailyTrends.hashCode) +
      (averages == null ? 0 : averages!.hashCode);

  @override
  String toString() =>
      'WeeklyTrendDto[startDate=$startDate, endDate=$endDate, dailyTrends=$dailyTrends, averages=$averages]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.startDate != null) {
      json[r'startDate'] = _dateFormatter.format(this.startDate!.toUtc());
    } else {
      json[r'startDate'] = null;
    }
    if (this.endDate != null) {
      json[r'endDate'] = _dateFormatter.format(this.endDate!.toUtc());
    } else {
      json[r'endDate'] = null;
    }
    json[r'dailyTrends'] = this.dailyTrends;
    if (this.averages != null) {
      json[r'averages'] = this.averages;
    } else {
      json[r'averages'] = null;
    }
    return json;
  }

  /// Returns a new [WeeklyTrendDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WeeklyTrendDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "WeeklyTrendDto[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "WeeklyTrendDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WeeklyTrendDto(
        startDate: mapDateTime(json, r'startDate', r''),
        endDate: mapDateTime(json, r'endDate', r''),
        dailyTrends: DailyTrendDto.listFromJson(json[r'dailyTrends']),
        averages: AverageMacrosDto.fromJson(json[r'averages']),
      );
    }
    return null;
  }

  static List<WeeklyTrendDto> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <WeeklyTrendDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WeeklyTrendDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WeeklyTrendDto> mapFromJson(dynamic json) {
    final map = <String, WeeklyTrendDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WeeklyTrendDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WeeklyTrendDto-objects as value to a dart map
  static Map<String, List<WeeklyTrendDto>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<WeeklyTrendDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WeeklyTrendDto.listFromJson(
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
