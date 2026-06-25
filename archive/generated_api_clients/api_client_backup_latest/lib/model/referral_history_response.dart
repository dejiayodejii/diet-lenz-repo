//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class ReferralHistoryResponse {
  /// Returns a new [ReferralHistoryResponse] instance.
  ReferralHistoryResponse({
    this.referralId,
    this.refereeEmail,
    this.codeUsed,
    this.status,
    this.rewardAmount,
    this.rewardCurrency,
    this.isPaid,
    this.paidAt,
    this.createdAt,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? referralId;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? refereeEmail;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? codeUsed;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? status;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? rewardAmount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? rewardCurrency;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isPaid;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? paidAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? createdAt;

  @override
  bool operator ==(Object other) => identical(this, other) || other is ReferralHistoryResponse &&
    other.referralId == referralId &&
    other.refereeEmail == refereeEmail &&
    other.codeUsed == codeUsed &&
    other.status == status &&
    other.rewardAmount == rewardAmount &&
    other.rewardCurrency == rewardCurrency &&
    other.isPaid == isPaid &&
    other.paidAt == paidAt &&
    other.createdAt == createdAt;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (referralId == null ? 0 : referralId!.hashCode) +
    (refereeEmail == null ? 0 : refereeEmail!.hashCode) +
    (codeUsed == null ? 0 : codeUsed!.hashCode) +
    (status == null ? 0 : status!.hashCode) +
    (rewardAmount == null ? 0 : rewardAmount!.hashCode) +
    (rewardCurrency == null ? 0 : rewardCurrency!.hashCode) +
    (isPaid == null ? 0 : isPaid!.hashCode) +
    (paidAt == null ? 0 : paidAt!.hashCode) +
    (createdAt == null ? 0 : createdAt!.hashCode);

  @override
  String toString() => 'ReferralHistoryResponse[referralId=$referralId, refereeEmail=$refereeEmail, codeUsed=$codeUsed, status=$status, rewardAmount=$rewardAmount, rewardCurrency=$rewardCurrency, isPaid=$isPaid, paidAt=$paidAt, createdAt=$createdAt]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.referralId != null) {
      json[r'referralId'] = this.referralId;
    } else {
      json[r'referralId'] = null;
    }
    if (this.refereeEmail != null) {
      json[r'refereeEmail'] = this.refereeEmail;
    } else {
      json[r'refereeEmail'] = null;
    }
    if (this.codeUsed != null) {
      json[r'codeUsed'] = this.codeUsed;
    } else {
      json[r'codeUsed'] = null;
    }
    if (this.status != null) {
      json[r'status'] = this.status;
    } else {
      json[r'status'] = null;
    }
    if (this.rewardAmount != null) {
      json[r'rewardAmount'] = this.rewardAmount;
    } else {
      json[r'rewardAmount'] = null;
    }
    if (this.rewardCurrency != null) {
      json[r'rewardCurrency'] = this.rewardCurrency;
    } else {
      json[r'rewardCurrency'] = null;
    }
    if (this.isPaid != null) {
      json[r'isPaid'] = this.isPaid;
    } else {
      json[r'isPaid'] = null;
    }
    if (this.paidAt != null) {
      json[r'paidAt'] = this.paidAt;
    } else {
      json[r'paidAt'] = null;
    }
    if (this.createdAt != null) {
      json[r'createdAt'] = this.createdAt;
    } else {
      json[r'createdAt'] = null;
    }
    return json;
  }

  /// Returns a new [ReferralHistoryResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static ReferralHistoryResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "ReferralHistoryResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "ReferralHistoryResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return ReferralHistoryResponse(
        referralId: mapValueOfType<String>(json, r'referralId'),
        refereeEmail: mapValueOfType<String>(json, r'refereeEmail'),
        codeUsed: mapValueOfType<String>(json, r'codeUsed'),
        status: mapValueOfType<String>(json, r'status'),
        rewardAmount: mapValueOfType<double>(json, r'rewardAmount'),
        rewardCurrency: mapValueOfType<String>(json, r'rewardCurrency'),
        isPaid: mapValueOfType<bool>(json, r'isPaid'),
        paidAt: mapValueOfType<String>(json, r'paidAt'),
        createdAt: mapValueOfType<String>(json, r'createdAt'),
      );
    }
    return null;
  }

  static List<ReferralHistoryResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <ReferralHistoryResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = ReferralHistoryResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, ReferralHistoryResponse> mapFromJson(dynamic json) {
    final map = <String, ReferralHistoryResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = ReferralHistoryResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of ReferralHistoryResponse-objects as value to a dart map
  static Map<String, List<ReferralHistoryResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<ReferralHistoryResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = ReferralHistoryResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

