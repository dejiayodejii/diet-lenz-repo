import 'dart:convert';
import 'dart:developer' as dev;
import 'dart:io';
import 'dart:math';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/material.dart';

hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}

appPrint(value) {
  if (kDebugMode) {
    dev.log(value.toString());
  }
}

String jsonEncoderFunction(val) {
  return json.encode(val);
}

jsonDecoderFunction(val) {
  return json.decode(val);
}

String capitalizeFirstLetter(String text) {
  if (text.isEmpty) {
    return text;
  }
  return text[0].toUpperCase() + text.substring(1).toLowerCase();
}

extension StringToDouble on String {
  double toDouble() {
    try {
      // Remove any commas and try parsing
      return double.parse(replaceAll(',', ''));
    } catch (e) {
      return 0.0;
    }
  }

  double? toDoubleOrNull() {
    try {
      // Remove any commas and try parsing
      return double.parse(replaceAll(',', ''));
    } catch (e) {
      return null;
    }
  }

  String get capitalize {
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}



String colorToHex(Color color) {
  return '#${color.value.toRadixString(16).toUpperCase().substring(2)}';
}

Color hexToColor(String hexCode) {
  try {
    return Color(int.parse(hexCode.replaceFirst('#', '0xFF')));
  } on Exception catch (e) {
    final random = Random();
    final randomItem =
        availableColors2[random.nextInt(availableColors2.length)];
    return randomItem;
  }
}

const List<Color> availableColors2 = [
  Color(0xFF062863), // Blue
  Color(0xFF008753), // Black
  Color(0xFFBD3D44),
  Color(0xFF5B6A6A),
];

Future<Map<String, dynamic>> getDeviceInfo() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  final Map<String, String> deviceData = {};

  try {
    if (Platform.isAndroid) {
      final AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      deviceData['type'] = 'android';
      deviceData['name'] = androidInfo.model;
      deviceData['device_id'] = androidInfo.id;
    } else if (Platform.isIOS) {
      final IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      deviceData['type'] = 'ios';
      deviceData['name'] = iosInfo.name;
      deviceData['device_id'] = iosInfo.identifierForVendor ?? '';
    }
  } catch (e) {
    debugPrint('Error getting device info: $e');
    // Provide fallback values
    deviceData['deviceType'] = Platform.isAndroid ? 'android' : 'ios';
    deviceData['deviceName'] = 'Unknown';
    deviceData['deviceId'] = 'Unknown';
  }
  return deviceData;
}


