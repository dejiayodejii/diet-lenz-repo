//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class HealthSyncSettings {
  /// Returns a new [HealthSyncSettings] instance.
  HealthSyncSettings({
    this.readSteps,
    this.readActiveCalories,
    this.readWeight,
    this.readHeartRate,
    this.readSleep,
    this.writeDietaryEnergy,
    this.writeProtein,
    this.writeCarbohydrate,
    this.writeFat,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? readSteps;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? readActiveCalories;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? readWeight;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? readHeartRate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? readSleep;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? writeDietaryEnergy;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? writeProtein;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? writeCarbohydrate;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? writeFat;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthSyncSettings &&
          other.readSteps == readSteps &&
          other.readActiveCalories == readActiveCalories &&
          other.readWeight == readWeight &&
          other.readHeartRate == readHeartRate &&
          other.readSleep == readSleep &&
          other.writeDietaryEnergy == writeDietaryEnergy &&
          other.writeProtein == writeProtein &&
          other.writeCarbohydrate == writeCarbohydrate &&
          other.writeFat == writeFat;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (readSteps == null ? 0 : readSteps!.hashCode) +
      (readActiveCalories == null ? 0 : readActiveCalories!.hashCode) +
      (readWeight == null ? 0 : readWeight!.hashCode) +
      (readHeartRate == null ? 0 : readHeartRate!.hashCode) +
      (readSleep == null ? 0 : readSleep!.hashCode) +
      (writeDietaryEnergy == null ? 0 : writeDietaryEnergy!.hashCode) +
      (writeProtein == null ? 0 : writeProtein!.hashCode) +
      (writeCarbohydrate == null ? 0 : writeCarbohydrate!.hashCode) +
      (writeFat == null ? 0 : writeFat!.hashCode);

  @override
  String toString() =>
      'HealthSyncSettings[readSteps=$readSteps, readActiveCalories=$readActiveCalories, readWeight=$readWeight, readHeartRate=$readHeartRate, readSleep=$readSleep, writeDietaryEnergy=$writeDietaryEnergy, writeProtein=$writeProtein, writeCarbohydrate=$writeCarbohydrate, writeFat=$writeFat]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.readSteps != null) {
      json[r'readSteps'] = this.readSteps;
    } else {
      json[r'readSteps'] = null;
    }
    if (this.readActiveCalories != null) {
      json[r'readActiveCalories'] = this.readActiveCalories;
    } else {
      json[r'readActiveCalories'] = null;
    }
    if (this.readWeight != null) {
      json[r'readWeight'] = this.readWeight;
    } else {
      json[r'readWeight'] = null;
    }
    if (this.readHeartRate != null) {
      json[r'readHeartRate'] = this.readHeartRate;
    } else {
      json[r'readHeartRate'] = null;
    }
    if (this.readSleep != null) {
      json[r'readSleep'] = this.readSleep;
    } else {
      json[r'readSleep'] = null;
    }
    if (this.writeDietaryEnergy != null) {
      json[r'writeDietaryEnergy'] = this.writeDietaryEnergy;
    } else {
      json[r'writeDietaryEnergy'] = null;
    }
    if (this.writeProtein != null) {
      json[r'writeProtein'] = this.writeProtein;
    } else {
      json[r'writeProtein'] = null;
    }
    if (this.writeCarbohydrate != null) {
      json[r'writeCarbohydrate'] = this.writeCarbohydrate;
    } else {
      json[r'writeCarbohydrate'] = null;
    }
    if (this.writeFat != null) {
      json[r'writeFat'] = this.writeFat;
    } else {
      json[r'writeFat'] = null;
    }
    return json;
  }

  /// Returns a new [HealthSyncSettings] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static HealthSyncSettings? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "HealthSyncSettings[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "HealthSyncSettings[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return HealthSyncSettings(
        readSteps: mapValueOfType<bool>(json, r'readSteps'),
        readActiveCalories: mapValueOfType<bool>(json, r'readActiveCalories'),
        readWeight: mapValueOfType<bool>(json, r'readWeight'),
        readHeartRate: mapValueOfType<bool>(json, r'readHeartRate'),
        readSleep: mapValueOfType<bool>(json, r'readSleep'),
        writeDietaryEnergy: mapValueOfType<bool>(json, r'writeDietaryEnergy'),
        writeProtein: mapValueOfType<bool>(json, r'writeProtein'),
        writeCarbohydrate: mapValueOfType<bool>(json, r'writeCarbohydrate'),
        writeFat: mapValueOfType<bool>(json, r'writeFat'),
      );
    }
    return null;
  }

  static List<HealthSyncSettings> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <HealthSyncSettings>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = HealthSyncSettings.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, HealthSyncSettings> mapFromJson(dynamic json) {
    final map = <String, HealthSyncSettings>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = HealthSyncSettings.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of HealthSyncSettings-objects as value to a dart map
  static Map<String, List<HealthSyncSettings>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<HealthSyncSettings>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = HealthSyncSettings.listFromJson(
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
