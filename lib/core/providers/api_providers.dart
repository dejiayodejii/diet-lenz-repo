import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final storageRepository = ref.watch(storageRepositoryProvider);
  final apiService = ApiService();

  apiService.initialize(
    storageRepository: storageRepository,
    enableLogging: kDebugMode,
  );

  // Restore authentication if token exists
  apiService.restoreAuthentication();

  return apiService;
});
