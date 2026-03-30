//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class GoogleSubscriptionVerifyRequest {
  /// Returns a new [GoogleSubscriptionVerifyRequest] instance.
  GoogleSubscriptionVerifyRequest({
    required this.purchaseToken,
    required this.productId,
  });

  String purchaseToken;

  String productId;

  @override
  bool operator ==(Object other) => identical(this, other) || other is GoogleSubscriptionVerifyRequest &&
    other.purchaseToken == purchaseToken &&
    other.productId == productId;

  @override
  int get hashCode =>
    // ignore: unnecessary_parenthesis
    (purchaseToken.hashCode) +
    (productId.hashCode);

  @override
  String toString() => 'GoogleSubscriptionVerifyRequest[purchaseToken=$purchaseToken, productId=$productId]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
      json[r'purchaseToken'] = this.purchaseToken;
      json[r'productId'] = this.productId;
    return json;
  }

  /// Returns a new [GoogleSubscriptionVerifyRequest] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static GoogleSubscriptionVerifyRequest? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key), 'Required key "GoogleSubscriptionVerifyRequest[$key]" is missing from JSON.');
          assert(json[key] != null, 'Required key "GoogleSubscriptionVerifyRequest[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return GoogleSubscriptionVerifyRequest(
        purchaseToken: mapValueOfType<String>(json, r'purchaseToken')!,
        productId: mapValueOfType<String>(json, r'productId')!,
      );
    }
    return null;
  }

  static List<GoogleSubscriptionVerifyRequest> listFromJson(dynamic json, {bool growable = false,}) {
    final result = <GoogleSubscriptionVerifyRequest>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = GoogleSubscriptionVerifyRequest.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, GoogleSubscriptionVerifyRequest> mapFromJson(dynamic json) {
    final map = <String, GoogleSubscriptionVerifyRequest>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = GoogleSubscriptionVerifyRequest.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of GoogleSubscriptionVerifyRequest-objects as value to a dart map
  static Map<String, List<GoogleSubscriptionVerifyRequest>> mapListFromJson(dynamic json, {bool growable = false,}) {
    final map = <String, List<GoogleSubscriptionVerifyRequest>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = GoogleSubscriptionVerifyRequest.listFromJson(entry.value, growable: growable,);
      }
    }
    return map;
  }

  /// The list of required keys that must be present in a JSON.
  static const requiredKeys = <String>{
    'purchaseToken',
    'productId',
  };
}

