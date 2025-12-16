#!/usr/bin/env dart

/// TEMPORARY FIX for UserProfile deserialization error
///
/// Problem: Backend returns null for weight/height but Swagger spec says they're required
/// Solution: This script patches the generated UserProfile.fromJson to handle null values
///
/// Usage: dart fix_user_profile_nullability.dart
///
/// NOTE: This is a TEMPORARY workaround. The real fix is to:
/// 1. Update the Swagger spec on the backend to mark weight/height as nullable
/// 2. Regenerate the API client
///
/// This script needs to be run AFTER every API regeneration until the backend is fixed.

import 'dart:io';

void main() {
  final file = File('lib/api_client/lib/model/user_profile.dart');

  if (!file.existsSync()) {
    print('❌ Error: user_profile.dart not found');
    exit(1);
  }

  print('📝 Patching user_profile.dart for null weight/height handling...');

  String content = file.readAsStringSync();

  // Check if already patched
  if (content.contains('// PATCHED FOR NULL HANDLING')) {
    print('✅ Already patched!');
    exit(0);
  }

  // Replace the problematic lines
  final oldPattern1 = "        height: num.parse('\${json[r'height']}'),";
  final newPattern1 =
      "        height: json[r'height'] != null ? num.parse('\${json[r'height']}') : null, // PATCHED FOR NULL HANDLING";

  final oldPattern2 = "        weight: num.parse('\${json[r'weight']}'),";
  final newPattern2 =
      "        weight: json[r'weight'] != null ? num.parse('\${json[r'weight']}') : null, // PATCHED FOR NULL HANDLING";

  if (!content.contains(oldPattern1)) {
    print(
        '⚠️  Warning: Could not find height parsing pattern. File may have changed.');
  }

  if (!content.contains(oldPattern2)) {
    print(
        '⚠️  Warning: Could not find weight parsing pattern. File may have changed.');
  }

  content = content.replaceAll(oldPattern1, newPattern1);
  content = content.replaceAll(oldPattern2, newPattern2);

  // Write back
  file.writeAsStringSync(content);

  print('✅ Patched successfully!');
  print('');
  print('Next steps:');
  print('1. Test your app - the deserialization error should be gone');
  print(
      '2. Ask backend team to fix Swagger spec (mark weight/height as nullable)');
  print('3. After backend fixes it, regenerate API: ./regenerate_api.sh');
  print('4. Delete this patch script - you won\'t need it anymore');
}
