import 'package:diet_lenz/core/providers/sentry_providers.dart';
import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/services/api_service.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/auth/view/login.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiServiceProvider = Provider<ApiService>((ref) {
  final storageRepository = ref.watch(storageRepositoryProvider);
  final sentryService = ref.read(sentryServiceProvider);
  final apiService = ApiService();

  apiService.initialize(
    storageRepository: storageRepository,
    sentryService: sentryService,
    enableLogging: kDebugMode,
  );

  // Restore authentication if token exists
  apiService.restoreAuthentication();

  // Set up callback for handling unauthorized/expired tokens
  apiService.onUnauthorized = () {
    // Navigate to login screen and clear navigation stack
    NavigationService.pushAndRemoveUntil(
      child: const LoginScreen(),
    );
  };

  return apiService;
});
