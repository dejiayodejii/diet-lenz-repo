//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WeightProgressResponse {
  /// Returns a new [WeightProgressResponse] instance.
  WeightProgressResponse({
    this.filter,
    this.unit,
    this.chartData = const [],
    this.summary,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? filter;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? unit;

  List<ChartPoint> chartData;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Summary? summary;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightProgressResponse &&
          other.filter == filter &&
          other.unit == unit &&
          _deepEquality.equals(other.chartData, chartData) &&
          other.summary == summary;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (filter == null ? 0 : filter!.hashCode) +
      (unit == null ? 0 : unit!.hashCode) +
      (chartData.hashCode) +
      (summary == null ? 0 : summary!.hashCode);

  @override
  String toString() =>
      'WeightProgressResponse[filter=$filter, unit=$unit, chartData=$chartData, summary=$summary]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.filter != null) {
      json[r'filter'] = this.filter;
    } else {
      json[r'filter'] = null;
    }
    if (this.unit != null) {
      json[r'unit'] = this.unit;
    } else {
      json[r'unit'] = null;
    }
    json[r'chartData'] = this.chartData;
    if (this.summary != null) {
      json[r'summary'] = this.summary;
    } else {
      json[r'summary'] = null;
    }
    return json;
  }

  /// Returns a new [WeightProgressResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WeightProgressResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "WeightProgressResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "WeightProgressResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WeightProgressResponse(
        filter: mapValueOfType<String>(json, r'filter'),
        unit: mapValueOfType<String>(json, r'unit'),
        chartData: ChartPoint.listFromJson(json[r'chartData']),
        summary: Summary.fromJson(json[r'summary']),
      );
    }
    return null;
  }

  static List<WeightProgressResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <WeightProgressResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WeightProgressResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WeightProgressResponse> mapFromJson(dynamic json) {
    final map = <String, WeightProgressResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WeightProgressResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WeightProgressResponse-objects as value to a dart map
  static Map<String, List<WeightProgressResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<WeightProgressResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WeightProgressResponse.listFromJson(
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
