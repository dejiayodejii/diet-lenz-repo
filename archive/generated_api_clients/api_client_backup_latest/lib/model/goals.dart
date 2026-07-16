//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class Goals {
  /// Returns a new [Goals] instance.
  Goals({
    this.currentWeight,
    this.targetWeight,
    this.kgToGo,
    this.weightUnit,
    this.projectedGoalDate,
    this.headline,
  });

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
  num? kgToGo;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? weightUnit;

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

  @override
  bool operator ==(Object other) => identical(this, other) || other is Goals &&
    other.currentWeight == currentWeight &&
    other.targetWeight == targetWeight &&
    other.kgToGo == kgToGo &&
    other.weightUnit == weightUnit &&
    other.projectedGoalDate == projectedGoalDate &&
    other.headline == headline;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (currentWeight == null ? 0 : currentWeight!.hashCode) +
    (targetWeight == null ? 0 : targetWeight!.hashCode) +
    (kgToGo == null ? 0 : kgToGo!.hashCode) +
    (weightUnit == null ? 0 : weightUnit!.hashCode) +
    (projectedGoalDate == null ? 0 : projectedGoalDate!.hashCode) +
    (headline == null ? 0 : headline!.hashCode);

  @override
  String toString() => 'Goals[currentWeight=$currentWeight, targetWeight=$targetWeight, kgToGo=$kgToGo, weightUnit=$weightUnit, projectedGoalDate=$projectedGoalDate, headline=$headline]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
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
    if (this.kgToGo != null) {
      json[r'kgToGo'] = this.kgToGo;
    } else {
      json[r'kgToGo'] = null;
    }
    if (this.weightUnit != null) {
      json[r'weightUnit'] = this.weightUnit;
    } else {
      json[r'weightUnit'] = null;
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
    return json;
  }

  /// Returns a new [Goals] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static Goals? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "Goals[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "Goals[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return Goals(
        currentWeight: num.parse('${json[r'currentWeight']}'),
        targetWeight: num.parse('${json[r'targetWeight']}'),
        kgToGo: num.parse('${json[r'kgToGo']}'),
        weightUnit: mapValueOfType<String>(json, r'weightUnit'),
        projectedGoalDate: mapDateTime(json, r'projectedGoalDate', r''),
        headline: mapValueOfType<String>(json, r'headline'),
      );
    }
    return null;
  }

  static List<Goals> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <Goals>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = Goals.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, Goals> mapFromJson(dynamic json) {
    final map = <String, Goals>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = Goals.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of Goals-objects as value to a dart map
  static Map<String, List<Goals>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<Goals>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = Goals.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

