import 'package:diet_lenz/core/constants/storage_keys.dart';
import 'package:diet_lenz/core/repositories/storage_repository.dart';
import 'package:diet_lenz/core/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('clearing auth storage preserves the one-time camera guide flag',
      () async {
    SharedPreferences.setMockInitialValues({
      StorageKeys.token: 'token',
      StorageKeys.cameraGuideAutomaticallyShown: true,
    });
    final storage = await StorageService.getInstance();
    final repository = StorageRepository(storage);

    await repository.clearStorage();

    expect(storage.getString(StorageKeys.token), isNull);
    expect(storage.getBool(StorageKeys.cameraGuideAutomaticallyShown), isTrue);
  });
}
