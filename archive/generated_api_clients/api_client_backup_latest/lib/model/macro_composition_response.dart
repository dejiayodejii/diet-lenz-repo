//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MacroCompositionResponse {
  /// Returns a new [MacroCompositionResponse] instance.
  MacroCompositionResponse({
    this.filter,
    this.totalCalories,
    this.macros,
    this.percentages,
    this.chartData = const [],
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
  double? totalCalories;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Macros? macros;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  Percentages? percentages;

  List<ChartPoint> chartData;

  @override
  bool operator ==(Object other) => identical(this, other) || other is MacroCompositionResponse &&
    other.filter == filter &&
    other.totalCalories == totalCalories &&
    other.macros == macros &&
    other.percentages == percentages &&
    _deepEquality.equals(other.chartData, chartData);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (filter == null ? 0 : filter!.hashCode) +
    (totalCalories == null ? 0 : totalCalories!.hashCode) +
    (macros == null ? 0 : macros!.hashCode) +
    (percentages == null ? 0 : percentages!.hashCode) +
    (chartData.hashCode);

  @override
  String toString() => 'MacroCompositionResponse[filter=$filter, totalCalories=$totalCalories, macros=$macros, percentages=$percentages, chartData=$chartData]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.filter != null) {
      json[r'filter'] = this.filter;
    } else {
      json[r'filter'] = null;
    }
    if (this.totalCalories != null) {
      json[r'totalCalories'] = this.totalCalories;
    } else {
      json[r'totalCalories'] = null;
    }
    if (this.macros != null) {
      json[r'macros'] = this.macros;
    } else {
      json[r'macros'] = null;
    }
    if (this.percentages != null) {
      json[r'percentages'] = this.percentages;
    } else {
      json[r'percentages'] = null;
    }
      json[r'chartData'] = this.chartData;
    return json;
  }

  /// Returns a new [MacroCompositionResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MacroCompositionResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "MacroCompositionResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "MacroCompositionResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MacroCompositionResponse(
        filter: mapValueOfType<String>(json, r'filter'),
        totalCalories: mapValueOfType<double>(json, r'totalCalories'),
        macros: Macros.fromJson(json[r'macros']),
        percentages: Percentages.fromJson(json[r'percentages']),
        chartData: ChartPoint.listFromJson(json[r'chartData']),
      );
    }
    return null;
  }

  static List<MacroCompositionResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <MacroCompositionResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MacroCompositionResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MacroCompositionResponse> mapFromJson(dynamic json) {
    final map = <String, MacroCompositionResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MacroCompositionResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MacroCompositionResponse-objects as value to a dart map
  static Map<String, List<MacroCompositionResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<MacroCompositionResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MacroCompositionResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

