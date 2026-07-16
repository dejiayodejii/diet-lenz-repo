//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProjectionPoint {
  /// Returns a new [ProjectionPoint] instance.
  ProjectionPoint({
    this.label,
    this.date,
    this.weight,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? label;

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
  num? weight;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProjectionPoint &&
          other.label == label &&
          other.date == date &&
          other.weight == weight;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (label == null ? 0 : label!.hashCode) +
      (date == null ? 0 : date!.hashCode) +
      (weight == null ? 0 : weight!.hashCode);

  @override
  String toString() =>
      'ProjectionPoint[label=$label, date=$date, weight=$weight]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.label != null) {
      json[r'label'] = this.label;
    } else {
      json[r'label'] = null;
    }
    if (this.date != null) {
      json[r'date'] = _dateFormatter.format(this.date!.toUtc());
    } else {
      json[r'date'] = null;
    }
    if (this.weight != null) {
      json[r'weight'] = this.weight;
    } else {
      json[r'weight'] = null;
    }
    return json;
  }

  /// Returns a new [ProjectionPoint] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProjectionPoint? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "ProjectionPoint[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "ProjectionPoint[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProjectionPoint(
        label: mapValueOfType<String>(json, r'label'),
        date: mapDateTime(json, r'date', r''),
        weight: num.parse('${json[r'weight']}'),
      );
    }
    return null;
  }

  static List<ProjectionPoint> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <ProjectionPoint>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProjectionPoint.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProjectionPoint> mapFromJson(dynamic json) {
    final map = <String, ProjectionPoint>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProjectionPoint.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProjectionPoint-objects as value to a dart map
  static Map<String, List<ProjectionPoint>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<ProjectionPoint>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProjectionPoint.listFromJson(
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
