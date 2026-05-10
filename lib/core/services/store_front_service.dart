import 'dart:io';
import 'package:flutter/services.dart';

class StorefrontService {
  static const MethodChannel _channel =
      MethodChannel('storefront_channel');

  static Future<String?> getCountryCode() async {
    if (!Platform.isIOS) return null;

    try {
      final code = await _channel.invokeMethod<String>(
        'getStorefrontCountry',
      );

      return code;
    } catch (_) {
      return null;
    }
  }
}