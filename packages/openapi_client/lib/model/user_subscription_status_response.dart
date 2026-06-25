//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class UserSubscriptionStatusResponse {
  /// Returns a new [UserSubscriptionStatusResponse] instance.
  UserSubscriptionStatusResponse({
    this.isPremium,
    this.referralCode,
    this.premiumExpiresAt,
    this.firstPromoterReferralCode,
    this.firstPromoterReferralLink,
    this.firstPromoterAuthToken,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? isPremium;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? referralCode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  DateTime? premiumExpiresAt;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? firstPromoterReferralCode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? firstPromoterReferralLink;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? firstPromoterAuthToken;

  @override
  bool operator ==(Object other) => identical(this, other) || other is UserSubscriptionStatusResponse &&
    other.isPremium == isPremium &&
    other.referralCode == referralCode &&
    other.premiumExpiresAt == premiumExpiresAt &&
    other.firstPromoterReferralCode == firstPromoterReferralCode &&
    other.firstPromoterReferralLink == firstPromoterReferralLink &&
    other.firstPromoterAuthToken == firstPromoterAuthToken;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (isPremium == null ? 0 : isPremium!.hashCode) +
    (referralCode == null ? 0 : referralCode!.hashCode) +
    (premiumExpiresAt == null ? 0 : premiumExpiresAt!.hashCode) +
    (firstPromoterReferralCode == null ? 0 : firstPromoterReferralCode!.hashCode) +
    (firstPromoterReferralLink == null ? 0 : firstPromoterReferralLink!.hashCode) +
    (firstPromoterAuthToken == null ? 0 : firstPromoterAuthToken!.hashCode);

  @override
  String toString() => 'UserSubscriptionStatusResponse[isPremium=$isPremium, referralCode=$referralCode, premiumExpiresAt=$premiumExpiresAt, firstPromoterReferralCode=$firstPromoterReferralCode, firstPromoterReferralLink=$firstPromoterReferralLink, firstPromoterAuthToken=$firstPromoterAuthToken]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.isPremium != null) {
      json[r'isPremium'] = this.isPremium;
    } else {
      json[r'isPremium'] = null;
    }
    if (this.referralCode != null) {
      json[r'referralCode'] = this.referralCode;
    } else {
      json[r'referralCode'] = null;
    }
    if (this.premiumExpiresAt != null) {
      json[r'premiumExpiresAt'] = this.premiumExpiresAt!.toUtc().toIso8601String();
    } else {
      json[r'premiumExpiresAt'] = null;
    }
    if (this.firstPromoterReferralCode != null) {
      json[r'firstPromoterReferralCode'] = this.firstPromoterReferralCode;
    } else {
      json[r'firstPromoterReferralCode'] = null;
    }
    if (this.firstPromoterReferralLink != null) {
      json[r'firstPromoterReferralLink'] = this.firstPromoterReferralLink;
    } else {
      json[r'firstPromoterReferralLink'] = null;
    }
    if (this.firstPromoterAuthToken != null) {
      json[r'firstPromoterAuthToken'] = this.firstPromoterAuthToken;
    } else {
      json[r'firstPromoterAuthToken'] = null;
    }
    return json;
  }

  /// Returns a new [UserSubscriptionStatusResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static UserSubscriptionStatusResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "UserSubscriptionStatusResponse[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "UserSubscriptionStatusResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return UserSubscriptionStatusResponse(
        isPremium: mapValueOfType<bool>(json, r'isPremium'),
        referralCode: mapValueOfType<String>(json, r'referralCode'),
        premiumExpiresAt: mapDateTime(json, r'premiumExpiresAt', r''),
        firstPromoterReferralCode: mapValueOfType<String>(json, r'firstPromoterReferralCode'),
        firstPromoterReferralLink: mapValueOfType<String>(json, r'firstPromoterReferralLink'),
        firstPromoterAuthToken: mapValueOfType<String>(json, r'firstPromoterAuthToken'),
      );
    }
    return null;
  }

  static List<UserSubscriptionStatusResponse> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <UserSubscriptionStatusResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = UserSubscriptionStatusResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, UserSubscriptionStatusResponse> mapFromJson(dynamic json) {
    final map = <String, UserSubscriptionStatusResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = UserSubscriptionStatusResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of UserSubscriptionStatusResponse-objects as value to a dart map
  static Map<String, List<UserSubscriptionStatusResponse>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<UserSubscriptionStatusResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = UserSubscriptionStatusResponse.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
  };
}

