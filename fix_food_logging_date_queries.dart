#!/usr/bin/env dart
// ignore_for_file: avoid_print

// TEMPORARY FIX for FoodLoggingControllerApi date query serialization.
//
// Problem: The generated client sends DateTime query params as full ISO
// timestamps, but the backend expects date-only values like yyyy-MM-dd.
//
// Usage: dart fix_food_logging_date_queries.dart
//
// This script needs to be run AFTER every API regeneration until the Swagger
// spec/generator setup can express these query params as date-only strings.

import 'dart:io';

const apiPath =
    'packages/openapi_client/lib/api/food_logging_controller_api.dart';
const patchMarker = 'PATCHED: date-only query';

void main() {
  final file = File(apiPath);

  if (!file.existsSync()) {
    print('❌ Error: $apiPath not found');
    exit(1);
  }

  print('📝 Patching $apiPath for date-only query params...');

  var content = file.readAsStringSync();

  if (content.contains(patchMarker)) {
    print('✅ Already patched!');
    exit(0);
  }

  final replacements = <String, String>{
    "      queryParams.addAll(_queryParams('', 'date', date));":
        _dateOnlyQueryBlock('date', 'date', 'dateStr'),
    "      queryParams.addAll(_queryParams('', 'startDate', startDate));":
        _dateOnlyQueryBlock('startDate', 'startDate', 'startDateStr'),
  };

  var changed = false;
  for (final entry in replacements.entries) {
    if (content.contains(entry.key)) {
      content = content.replaceAll(entry.key, entry.value);
      changed = true;
    } else {
      print('⚠️  Warning: Could not find query pattern: ${entry.key.trim()}');
    }
  }

  if (!changed) {
    print('❌ Error: No date query params were patched. File may have changed.');
    exit(1);
  }

  file.writeAsStringSync(content);

  print('✅ Patched successfully!');
}

String _dateOnlyQueryBlock(
  String variableName,
  String queryName,
  String stringName,
) {
  return '''
      final $stringName = '\${$variableName.year.toString().padLeft(4, '0')}-'
          '\${$variableName.month.toString().padLeft(2, '0')}-'
          '\${$variableName.day.toString().padLeft(2, '0')}';
      queryParams.addAll(_queryParams('', '$queryName', $stringName)); // $patchMarker
''';
}
