import 'package:diet_lenz/core/repositories/storage_repository.dart';
import 'package:diet_lenz/core/services/storage_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final storageServiceProvider = Provider<StorageService>((ref) {
  throw UnimplementedError();
});

final storageRepositoryProvider = Provider<StorageRepository>((ref) {
  final storageService = ref.watch(storageServiceProvider);
  return StorageRepository(storageService);
});
