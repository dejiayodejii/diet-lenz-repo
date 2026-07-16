//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//
// @dart=2.18

// ignore_for_file: unused_element, unused_import
// ignore_for_file: always_put_required_named_parameters_first
// ignore_for_file: constant_identifier_names
// ignore_for_file: lines_longer_than_80_chars

part of openapi.api;

class PricingResponse {
  /// Returns a new [PricingResponse] instance.
  PricingResponse({
    this.countryCode,
    this.currency,
    this.monthlyPrice,
    this.yearlyPrice,
    this.referralReward,
    this.hasWinbackDiscount,
    this.winbackDiscountPercentage,
    this.monthlyPriceAfterDiscount,
    this.yearlyPriceAfterDiscount,
  });

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? countryCode;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  String? currency;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? monthlyPrice;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? yearlyPrice;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? referralReward;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  bool? hasWinbackDiscount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  double? winbackDiscountPercentage;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? monthlyPriceAfterDiscount;

  ///
  /// Please note: This property should have been non-nullable! Since the specification file
  /// does not include a default value (using the "default:" property), however, the generated
  /// source code must fall back to having a nullable type.
  /// Consider adding a "default:" property in the specification file to hide this note.
  ///
  num? yearlyPriceAfterDiscount;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PricingResponse &&
          other.countryCode == countryCode &&
          other.currency == currency &&
          other.monthlyPrice == monthlyPrice &&
          other.yearlyPrice == yearlyPrice &&
          other.referralReward == referralReward &&
          other.hasWinbackDiscount == hasWinbackDiscount &&
          other.winbackDiscountPercentage == winbackDiscountPercentage &&
          other.monthlyPriceAfterDiscount == monthlyPriceAfterDiscount &&
          other.yearlyPriceAfterDiscount == yearlyPriceAfterDiscount;

  @override
  int get hashCode =>
      // ignore: unnecessary_parenthesis
      (countryCode == null ? 0 : countryCode!.hashCode) +
      (currency == null ? 0 : currency!.hashCode) +
      (monthlyPrice == null ? 0 : monthlyPrice!.hashCode) +
      (yearlyPrice == null ? 0 : yearlyPrice!.hashCode) +
      (referralReward == null ? 0 : referralReward!.hashCode) +
      (hasWinbackDiscount == null ? 0 : hasWinbackDiscount!.hashCode) +
      (winbackDiscountPercentage == null
          ? 0
          : winbackDiscountPercentage!.hashCode) +
      (monthlyPriceAfterDiscount == null
          ? 0
          : monthlyPriceAfterDiscount!.hashCode) +
      (yearlyPriceAfterDiscount == null
          ? 0
          : yearlyPriceAfterDiscount!.hashCode);

  @override
  String toString() =>
      'PricingResponse[countryCode=$countryCode, currency=$currency, monthlyPrice=$monthlyPrice, yearlyPrice=$yearlyPrice, referralReward=$referralReward, hasWinbackDiscount=$hasWinbackDiscount, winbackDiscountPercentage=$winbackDiscountPercentage, monthlyPriceAfterDiscount=$monthlyPriceAfterDiscount, yearlyPriceAfterDiscount=$yearlyPriceAfterDiscount]';

  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{};
    if (this.countryCode != null) {
      json[r'countryCode'] = this.countryCode;
    } else {
      json[r'countryCode'] = null;
    }
    if (this.currency != null) {
      json[r'currency'] = this.currency;
    } else {
      json[r'currency'] = null;
    }
    if (this.monthlyPrice != null) {
      json[r'monthlyPrice'] = this.monthlyPrice;
    } else {
      json[r'monthlyPrice'] = null;
    }
    if (this.yearlyPrice != null) {
      json[r'yearlyPrice'] = this.yearlyPrice;
    } else {
      json[r'yearlyPrice'] = null;
    }
    if (this.referralReward != null) {
      json[r'referralReward'] = this.referralReward;
    } else {
      json[r'referralReward'] = null;
    }
    if (this.hasWinbackDiscount != null) {
      json[r'hasWinbackDiscount'] = this.hasWinbackDiscount;
    } else {
      json[r'hasWinbackDiscount'] = null;
    }
    if (this.winbackDiscountPercentage != null) {
      json[r'winbackDiscountPercentage'] = this.winbackDiscountPercentage;
    } else {
      json[r'winbackDiscountPercentage'] = null;
    }
    if (this.monthlyPriceAfterDiscount != null) {
      json[r'monthlyPriceAfterDiscount'] = this.monthlyPriceAfterDiscount;
    } else {
      json[r'monthlyPriceAfterDiscount'] = null;
    }
    if (this.yearlyPriceAfterDiscount != null) {
      json[r'yearlyPriceAfterDiscount'] = this.yearlyPriceAfterDiscount;
    } else {
      json[r'yearlyPriceAfterDiscount'] = null;
    }
    return json;
  }

  /// Returns a new [PricingResponse] instance and imports its values from
  /// [value] if it's a [Map], null otherwise.
  // ignore: prefer_constructors_over_static_methods
  static PricingResponse? fromJson(dynamic value) {
    if (value is Map) {
      final json = value.cast<String, dynamic>();

      // Ensure that the map contains the required keys.
      // Note 1: the values aren't checked for validity beyond being non-null.
      // Note 2: this code is stripped in release mode!
      assert(() {
        requiredKeys.forEach((key) {
          assert(json.containsKey(key),
              'Required key "PricingResponse[$key]" is missing from JSON.');
          assert(json[key] != null,
              'Required key "PricingResponse[$key]" has a null value in JSON.');
        });
        return true;
      }());

      return PricingResponse(
        countryCode: mapValueOfType<String>(json, r'countryCode'),
        currency: mapValueOfType<String>(json, r'currency'),
        monthlyPrice: num.parse('${json[r'monthlyPrice']}'),
        yearlyPrice: num.parse('${json[r'yearlyPrice']}'),
        referralReward: num.parse('${json[r'referralReward']}'),
        hasWinbackDiscount: mapValueOfType<bool>(json, r'hasWinbackDiscount'),
        winbackDiscountPercentage:
            mapValueOfType<double>(json, r'winbackDiscountPercentage'),
        monthlyPriceAfterDiscount:
            num.parse('${json[r'monthlyPriceAfterDiscount']}'),
        yearlyPriceAfterDiscount:
            num.parse('${json[r'yearlyPriceAfterDiscount']}'),
      );
    }
    return null;
  }

  static List<PricingResponse> listFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final result = <PricingResponse>[];
    if (json is List && json.isNotEmpty) {
      for (final row in json) {
        final value = PricingResponse.fromJson(row);
        if (value != null) {
          result.add(value);
        }
      }
    }
    return result.toList(growable: growable);
  }

  static Map<String, PricingResponse> mapFromJson(dynamic json) {
    final map = <String, PricingResponse>{};
    if (json is Map && json.isNotEmpty) {
      json = json.cast<String, dynamic>(); // ignore: parameter_assignments
      for (final entry in json.entries) {
        final value = PricingResponse.fromJson(entry.value);
        if (value != null) {
          map[entry.key] = value;
        }
      }
    }
    return map;
  }

  // maps a json object with a list of PricingResponse-objects as value to a dart map
  static Map<String, List<PricingResponse>> mapListFromJson(
    dynamic json, {
    bool growable = false,
  }) {
    final map = <String, List<PricingResponse>>{};
    if (json is Map && json.isNotEmpty) {
      // ignore: parameter_assignments
      json = json.cast<String, dynamic>();
      for (final entry in json.entries) {
        map[entry.key] = PricingResponse.listFromJson(
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
