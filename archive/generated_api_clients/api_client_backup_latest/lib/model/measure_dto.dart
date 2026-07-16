//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class MeasureDto {
  /// Returns a new [MeasureDto] instance.
  MeasureDto({
    this.label,
    this.weightGrams,
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
  double? weightGrams;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MeasureDto &&
          other.label == label &&
          other.weightGrams == weightGrams;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (label == null ? 0 : label!.hashCode) +
      (weightGrams == null ? 0 : weightGrams!.hashCode);

  @override
  String toString() => 'MeasureDto[label=$label, weightGrams=$weightGrams]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.label != null) {
      json[r'label'] = this.label;
    } else {
      json[r'label'] = null;
    }
    if (this.weightGrams != null) {
      json[r'weightGrams'] = this.weightGrams;
    } else {
      json[r'weightGrams'] = null;
    }
    return json;
  }

  /// Returns a new [MeasureDto] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static MeasureDto? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "MeasureDto[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "MeasureDto[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return MeasureDto(
        label: mapValueOfType<String>(json, r'label'),
        weightGrams: mapValueOfType<double>(json, r'weightGrams'),
      );
    }
    return null;
  }

  static List<MeasureDto> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <MeasureDto>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = MeasureDto.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, MeasureDto> mapFromJson(dynamic json) {
    final map = <String, MeasureDto>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = MeasureDto.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of MeasureDto-objects as value to a dart map
  static Map<String, List<MeasureDto>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<MeasureDto>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = MeasureDto.listFromJson(
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
