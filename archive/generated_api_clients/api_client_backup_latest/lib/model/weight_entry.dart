//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WeightEntry {
  /// Returns a new [WeightEntry] instance.
  WeightEntry({
    this.id,
    this.createdAt,
    this.updatedAt,
    this.value,
    this.unit,
    this.entryDate,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? id;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? createdAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? updatedAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? value;

  WeightEntryUnitEnum? unit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? entryDate;

  @override
  bool operator ==(Object other) => identical(this, other) || other is WeightEntry &&
    other.id == id &&
    other.createdAt == createdAt &&
    other.updatedAt == updatedAt &&
    other.value == value &&
    other.unit == unit &&
    other.entryDate == entryDate;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (id == null ? 0 : id!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode) +
    (updatedAt == null ? 0 : updatedAt!.hashCode) +
    (value == null ? 0 : value!.hashCode) +
    (unit == null ? 0 : unit!.hashCode) +
    (entryDate == null ? 0 : entryDate!.hashCode);

  @override
  String toString() => 'WeightEntry[id=$id, createdAt=$createdAt, updatedAt=$updatedAt, value=$value, unit=$unit, entryDate=$entryDate]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.id != null) {
      json[r'id'] = this.id;
    } else {
      json[r'id'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt!.toUtc().toIso8601String();
    } else {
      json[r'createdAt'] = null;
    }
    if (this.updatedAt != null) {
      json[r'updatedAt'] = this.updatedAt!.toUtc().toIso8601String();
    } else {
      json[r'updatedAt'] = null;
    }
    if (this.value != null) {
      json[r'value'] = this.value;
    } else {
      json[r'value'] = null;
    }
    if (this.unit != null) {
      json[r'unit'] = this.unit;
    } else {
      json[r'unit'] = null;
    }
    if (this.entryDate != null) {
      json[r'entryDate'] = _dateFormatter.format(this.entryDate!.toUtc());
    } else {
      json[r'entryDate'] = null;
    }
    return json;
  }

  /// Returns a new [WeightEntry] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WeightEntry? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "WeightEntry[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "WeightEntry[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WeightEntry(
        id: mapValueOfType<String>(json, r'id'),
        createdAt: mapDateTime(json, r'createdAt', r''),
        updatedAt: mapDateTime(json, r'updatedAt', r''),
        value: num.parse('${json[r'value']}'),
        unit: WeightEntryUnitEnum.fromJson(json[r'unit']),
        entryDate: mapDateTime(json, r'entryDate', r''),
      );
    }
    return null;
  }

  static List<WeightEntry> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WeightEntry>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WeightEntry.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WeightEntry> mapFromJson(dynamic json) {
    final map = <String, WeightEntry>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WeightEntry.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WeightEntry-objects as value to a dart map
  static Map<String, List<WeightEntry>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<WeightEntry>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WeightEntry.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}


class WeightEntryUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const WeightEntryUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const KG = WeightEntryUnitEnum._(r'KG');
  static const POUNDS = WeightEntryUnitEnum._(r'POUNDS');

  /// List of all possible values in this [enum][WeightEntryUnitEnum].
  static const values = <WeightEntryUnitEnum>[
    KG,
    POUNDS,
  ];

  static WeightEntryUnitEnum? fromJson(dynamic value) => WeightEntryUnitEnumTypeTransformer().decode(value);

  static List<WeightEntryUnitEnum> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <WeightEntryUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WeightEntryUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [WeightEntryUnitEnum] to String,
/// and [decode] dynamic data back to [WeightEntryUnitEnum].
class WeightEntryUnitEnumTypeTransformer {
  factory WeightEntryUnitEnumTypeTransformer() => _instance ??= const WeightEntryUnitEnumTypeTransformer._();

  const WeightEntryUnitEnumTypeTransformer._();

  String encode(WeightEntryUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a WeightEntryUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  WeightEntryUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'KG': return WeightEntryUnitEnum.KG;
        case r'POUNDS': return WeightEntryUnitEnum.POUNDS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [WeightEntryUnitEnumTypeTransformer] instance.
  static WeightEntryUnitEnumTypeTransformer? _instance;
}


