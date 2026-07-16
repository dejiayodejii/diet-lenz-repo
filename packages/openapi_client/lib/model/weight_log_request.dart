//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class WeightLogRequest {
  /// Returns a new [WeightLogRequest] instance.
  WeightLogRequest({
    required this.value,
    required this.unit,
    this.date,
  });

  /// Minimum value: 1.0
  num value;

  WeightLogRequestUnitEnum unit;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? date;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WeightLogRequest &&
          other.value == value &&
          other.unit == unit &&
          other.date == date;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (value.hashCode) + (unit.hashCode) + (date == null ? 0 : date!.hashCode);

  @override
  String toString() => 'WeightLogRequest[value=$value, unit=$unit, date=$date]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    json[r'value'] = this.value;
    json[r'unit'] = this.unit;
    if (this.date != null) {
      json[r'date'] = _dateFormatter.format(this.date!.toUtc());
    } else {
      json[r'date'] = null;
    }
    return json;
  }

  /// Returns a new [WeightLogRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static WeightLogRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "WeightLogRequest[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "WeightLogRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return WeightLogRequest(
        value: num.parse('${json[r'value']}'),
        unit: WeightLogRequestUnitEnum.fromJson(json[r'unit'])!,
        date: mapDateTime(json, r'date', r''),
      );
    }
    return null;
  }

  static List<WeightLogRequest> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <WeightLogRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WeightLogRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, WeightLogRequest> mapFromJson(dynamic json) {
    final map = <String, WeightLogRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = WeightLogRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of WeightLogRequest-objects as value to a dart map
  static Map<String, List<WeightLogRequest>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<WeightLogRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = WeightLogRequest.listFromJson(
          entry.value,
          growable: growable,
        );
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'value',
    'unit',
  };
}

class WeightLogRequestUnitEnum {
  /// Instantiate a new enum with the provided [value].
  const WeightLogRequestUnitEnum._(this.value);

  /// The underlying value of this enum member.
  final String value;

  @override
  String toString() => value;

  String toJson() => value;

  static const KG = WeightLogRequestUnitEnum._(r'KG');
  static const POUNDS = WeightLogRequestUnitEnum._(r'POUNDS');

  /// List of all possible values in this [enum][WeightLogRequestUnitEnum].
  static const values = <WeightLogRequestUnitEnum>[
    KG,
    POUNDS,
  ];

  static WeightLogRequestUnitEnum? fromJson(dynamic value) =>
      WeightLogRequestUnitEnumTypeTransformer().decode(value);

  static List<WeightLogRequestUnitEnum> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <WeightLogRequestUnitEnum>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = WeightLogRequestUnitEnum.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }
}

/// Transformation class that can [encode] an instance of [WeightLogRequestUnitEnum] to String,
/// and [decode] dynamic data back to [WeightLogRequestUnitEnum].
class WeightLogRequestUnitEnumTypeTransformer {
  factory WeightLogRequestUnitEnumTypeTransformer() =>
      _instance ??= const WeightLogRequestUnitEnumTypeTransformer._();

  const WeightLogRequestUnitEnumTypeTransformer._();

  String encode(WeightLogRequestUnitEnum data) => data.value;

  /// Decodes a [dynamic value][data] to a WeightLogRequestUnitEnum.
  ///
  /// If [allowNull] is true and the [dynamic value][data] cannot be decoded successfully,
  /// then null is returned. However, if [allowNull] is false and the [dynamic value][data]
  /// cannot be decoded successfully, then an [UnimplementedError] is thrown.
  ///
  /// The [allowNull] is very handy when an API changes and a new enum value is added or removed,
  /// and users are still using an old app with the old code.
  WeightLogRequestUnitEnum? decode(dynamic data, {bool allowNull = true}) {
    if (data != null) {
      switch (data) {
        case r'KG':
          return WeightLogRequestUnitEnum.KG;
        case r'POUNDS':
          return WeightLogRequestUnitEnum.POUNDS;
        default:
          if (!allowNull) {
            throw ArgumentError('Unknown enum value to decode: $data');
          }
      }
    }
    return null;
  }

  /// Singleton [WeightLogRequestUnitEnumTypeTransformer] instance.
  static WeightLogRequestUnitEnumTypeTransformer? _instance;
}
