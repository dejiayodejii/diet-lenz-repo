//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReferralEarningsResponse {
  /// Returns a new [ReferralEarningsResponse] instance.
  ReferralEarningsResponse({
    this.totalEarningsUsd,
    this.totalEarningsNgn,
    this.totalReferrals,
    this.pendingEarningsUsd,
    this.pendingEarningsNgn,
    this.lifetimeEarningsUsd,
    this.lifetimeEarningsNgn,
    this.lastPayoutAt,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? totalEarningsUsd;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? totalEarningsNgn;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  int? totalReferrals;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? pendingEarningsUsd;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? pendingEarningsNgn;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? lifetimeEarningsUsd;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? lifetimeEarningsNgn;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? lastPayoutAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReferralEarningsResponse &&
    other.totalEarningsUsd == totalEarningsUsd &&
    other.totalEarningsNgn == totalEarningsNgn &&
    other.totalReferrals == totalReferrals &&
    other.pendingEarningsUsd == pendingEarningsUsd &&
    other.pendingEarningsNgn == pendingEarningsNgn &&
    other.lifetimeEarningsUsd == lifetimeEarningsUsd &&
    other.lifetimeEarningsNgn == lifetimeEarningsNgn &&
    other.lastPayoutAt == lastPayoutAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (totalEarningsUsd == null ? 0 : totalEarningsUsd!.hashCode) +
    (totalEarningsNgn == null ? 0 : totalEarningsNgn!.hashCode) +
    (totalReferrals == null ? 0 : totalReferrals!.hashCode) +
    (pendingEarningsUsd == null ? 0 : pendingEarningsUsd!.hashCode) +
    (pendingEarningsNgn == null ? 0 : pendingEarningsNgn!.hashCode) +
    (lifetimeEarningsUsd == null ? 0 : lifetimeEarningsUsd!.hashCode) +
    (lifetimeEarningsNgn == null ? 0 : lifetimeEarningsNgn!.hashCode) +
    (lastPayoutAt == null ? 0 : lastPayoutAt!.hashCode);

  @override
  String toString() => 'ReferralEarningsResponse[totalEarningsUsd=$totalEarningsUsd, totalEarningsNgn=$totalEarningsNgn, totalReferrals=$totalReferrals, pendingEarningsUsd=$pendingEarningsUsd, pendingEarningsNgn=$pendingEarningsNgn, lifetimeEarningsUsd=$lifetimeEarningsUsd, lifetimeEarningsNgn=$lifetimeEarningsNgn, lastPayoutAt=$lastPayoutAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.totalEarningsUsd != null) {
      json[r'totalEarningsUsd'] = this.totalEarningsUsd;
    } else {
      json[r'totalEarningsUsd'] = null;
    }
    if (this.totalEarningsNgn != null) {
      json[r'totalEarningsNgn'] = this.totalEarningsNgn;
    } else {
      json[r'totalEarningsNgn'] = null;
    }
    if (this.totalReferrals != null) {
      json[r'totalReferrals'] = this.totalReferrals;
    } else {
      json[r'totalReferrals'] = null;
    }
    if (this.pendingEarningsUsd != null) {
      json[r'pendingEarningsUsd'] = this.pendingEarningsUsd;
    } else {
      json[r'pendingEarningsUsd'] = null;
    }
    if (this.pendingEarningsNgn != null) {
      json[r'pendingEarningsNgn'] = this.pendingEarningsNgn;
    } else {
      json[r'pendingEarningsNgn'] = null;
    }
    if (this.lifetimeEarningsUsd != null) {
      json[r'lifetimeEarningsUsd'] = this.lifetimeEarningsUsd;
    } else {
      json[r'lifetimeEarningsUsd'] = null;
    }
    if (this.lifetimeEarningsNgn != null) {
      json[r'lifetimeEarningsNgn'] = this.lifetimeEarningsNgn;
    } else {
      json[r'lifetimeEarningsNgn'] = null;
    }
    if (this.lastPayoutAt != null) {
      json[r'lastPayoutAt'] = this.lastPayoutAt;
    } else {
      json[r'lastPayoutAt'] = null;
    }
    return json;
  }

  /// Returns a new [ReferralEarningsResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReferralEarningsResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReferralEarningsResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReferralEarningsResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReferralEarningsResponse(
        totalEarningsUsd: num.parse('${json[r'totalEarningsUsd']}'),
        totalEarningsNgn: num.parse('${json[r'totalEarningsNgn']}'),
        totalReferrals: mapValueOfType<int>(json, r'totalReferrals'),
        pendingEarningsUsd: num.parse('${json[r'pendingEarningsUsd']}'),
        pendingEarningsNgn: num.parse('${json[r'pendingEarningsNgn']}'),
        lifetimeEarningsUsd: num.parse('${json[r'lifetimeEarningsUsd']}'),
        lifetimeEarningsNgn: num.parse('${json[r'lifetimeEarningsNgn']}'),
        lastPayoutAt: mapValueOfType<String>(json, r'lastPayoutAt'),
      );
    }
    return null;
  }

  static List<ReferralEarningsResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReferralEarningsResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReferralEarningsResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReferralEarningsResponse> mapFromJson(dynamic json) {
    final map = <String, ReferralEarningsResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReferralEarningsResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReferralEarningsResponse-objects as value to a dart map
  static Map<String, List<ReferralEarningsResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReferralEarningsResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReferralEarningsResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

