#!/usr/bin/env dart
// ignore_for_file: avoid_print

// TEMPORARY FIX for progress deserialization.
//
// Problems:
// - Backend can return null values in weight progress chart/summary fields,
//   but the generated fromJson methods parse them unconditionally.
// - Energy balance chart points currently return caloriesEaten, while the
//   generated shared ChartPoint model expects value.
//
// Usage: dart fix_weight_progress_nullability.dart
//
// This script needs to be run AFTER every API regeneration until the Swagger
// spec/generator setup emits null-safe numeric parsing for these fields.

import 'dart:io';

const chartPointPath = 'packages/openapi_client/lib/model/chart_point.dart';
const summaryPath = 'packages/openapi_client/lib/model/summary.dart';
const patchMarker = 'PATCHED FOR NULL WEIGHT PROGRESS';
const energyPatchMarker = 'PATCHED FOR ENERGY BALANCE CALORIES';

void main() {
  final patches = <String, Map<String, String>>{
    chartPointPath: {
      "        value: num.parse('\${json[r'value']}'),":
          "        value: json[r'value'] != null ? num.parse('\${json[r'value']}') : null, // $patchMarker",
      "        value: json[r'value'] != null ? num.parse('\${json[r'value']}') : null, // $patchMarker":
          "        value: _chartPointValue(json), // $patchMarker + $energyPatchMarker",
    },
    summaryPath: {
      "        lastWeekWeight: num.parse('\${json[r'lastWeekWeight']}'),":
          "        lastWeekWeight: json[r'lastWeekWeight'] != null ? num.parse('\${json[r'lastWeekWeight']}') : null, // $patchMarker",
      "        currentWeight: num.parse('\${json[r'currentWeight']}'),":
          "        currentWeight: json[r'currentWeight'] != null ? num.parse('\${json[r'currentWeight']}') : null, // $patchMarker",
      "        targetWeight: num.parse('\${json[r'targetWeight']}'),":
          "        targetWeight: json[r'targetWeight'] != null ? num.parse('\${json[r'targetWeight']}') : null, // $patchMarker",
    },
  };

  var patchedAnyFile = false;

  for (final fileEntry in patches.entries) {
    final file = File(fileEntry.key);

    if (!file.existsSync()) {
      print('❌ Error: ${fileEntry.key} not found');
      exit(1);
    }

    print(
        '📝 Patching ${fileEntry.key} for nullable weight progress fields...');

    var content = file.readAsStringSync();

    var changed = false;
    for (final replacement in fileEntry.value.entries) {
      if (content.contains(replacement.value)) {
        continue;
      }
      if (content.contains(replacement.key)) {
        content = content.replaceAll(replacement.key, replacement.value);
        changed = true;
      } else {
        print('⚠️  Warning: Could not find pattern: ${replacement.key.trim()}');
      }
    }

    if (fileEntry.key == chartPointPath &&
        !content.contains('num? _chartPointValue(')) {
      content = content.replaceFirst(
        '\n  static Map<String, ChartPoint> mapFromJson(dynamic json) {',
        '''

  static num? _chartPointValue(Map<String, dynamic> json) {
    final rawValue = json[r'value'] ?? json[r'caloriesEaten'];
    return rawValue != null ? num.parse('\$rawValue') : null;
  }

  static Map<String, ChartPoint> mapFromJson(dynamic json) {''',
      );
      changed = true;
    }

    if (!changed) {
      if (content.contains(patchMarker)) {
        print('✅ Already patched: ${fileEntry.key}');
        continue;
      }
      print('❌ Error: No progress fields were patched in ${fileEntry.key}.');
      exit(1);
    }

    file.writeAsStringSync(content);
    patchedAnyFile = true;
    print('✅ Patched successfully: ${fileEntry.key}');
  }

  if (!patchedAnyFile) {
    print('✅ Weight progress nullability patches already applied.');
  }
}
