//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ProjectionResponse {
  /// Returns a new [ProjectionResponse] instance.
  ProjectionResponse({
    this.bucket,
    this.unit,
    this.currentWeight,
    this.targetWeight,
    this.ratePerWeek,
    this.projectedGoalDate,
    this.headline,
    this.points = const [],
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? bucket;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? unit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? currentWeight;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? targetWeight;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? ratePerWeek;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? projectedGoalDate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? headline;

  List<ProjectionPoint> points;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ProjectionResponse &&
    other.bucket == bucket &&
    other.unit == unit &&
    other.currentWeight == currentWeight &&
    other.targetWeight == targetWeight &&
    other.ratePerWeek == ratePerWeek &&
    other.projectedGoalDate == projectedGoalDate &&
    other.headline == headline &&
    _deepEquality.equals(other.points, points);

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (bucket == null ? 0 : bucket!.hashCode) +
    (unit == null ? 0 : unit!.hashCode) +
    (currentWeight == null ? 0 : currentWeight!.hashCode) +
    (targetWeight == null ? 0 : targetWeight!.hashCode) +
    (ratePerWeek == null ? 0 : ratePerWeek!.hashCode) +
    (projectedGoalDate == null ? 0 : projectedGoalDate!.hashCode) +
    (headline == null ? 0 : headline!.hashCode) +
    (points.hashCode);

  @override
  String toString() => 'ProjectionResponse[bucket=$bucket, unit=$unit, currentWeight=$currentWeight, targetWeight=$targetWeight, ratePerWeek=$ratePerWeek, projectedGoalDate=$projectedGoalDate, headline=$headline, points=$points]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.bucket != null) {
      json[r'bucket'] = this.bucket;
    } else {
      json[r'bucket'] = null;
    }
    if (this.unit != null) {
      json[r'unit'] = this.unit;
    } else {
      json[r'unit'] = null;
    }
    if (this.currentWeight != null) {
      json[r'currentWeight'] = this.currentWeight;
    } else {
      json[r'currentWeight'] = null;
    }
    if (this.targetWeight != null) {
      json[r'targetWeight'] = this.targetWeight;
    } else {
      json[r'targetWeight'] = null;
    }
    if (this.ratePerWeek != null) {
      json[r'ratePerWeek'] = this.ratePerWeek;
    } else {
      json[r'ratePerWeek'] = null;
    }
    if (this.projectedGoalDate != null) {
      json[r'projectedGoalDate'] = _dateFormatter.format(this.projectedGoalDate!.toUtc());
    } else {
      json[r'projectedGoalDate'] = null;
    }
    if (this.headline != null) {
      json[r'headline'] = this.headline;
    } else {
      json[r'headline'] = null;
    }
      json[r'points'] = this.points;
    return json;
  }

  /// Returns a new [ProjectionResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ProjectionResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ProjectionResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ProjectionResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ProjectionResponse(
        bucket: mapValueOfType<String>(json, r'bucket'),
        unit: mapValueOfType<String>(json, r'unit'),
        currentWeight: num.parse('${json[r'currentWeight']}'),
        targetWeight: num.parse('${json[r'targetWeight']}'),
        ratePerWeek: num.parse('${json[r'ratePerWeek']}'),
        projectedGoalDate: mapDateTime(json, r'projectedGoalDate', r''),
        headline: mapValueOfType<String>(json, r'headline'),
        points: ProjectionPoint.listFromJson(json[r'points']),
      );
    }
    return null;
  }

  static List<ProjectionResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ProjectionResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ProjectionResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ProjectionResponse> mapFromJson(dynamic json) {
    final map = <String, ProjectionResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ProjectionResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ProjectionResponse-objects as value to a dart map
  static Map<String, List<ProjectionResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ProjectionResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ProjectionResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

