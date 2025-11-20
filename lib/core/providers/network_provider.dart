import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/data/network/api_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final networkProvider = Provider<NetworkProvider>((ref) {
  final storageRepository = ref.watch(storageRepositoryProvider);
  return NetworkProviderImp(storageRepository);
});
