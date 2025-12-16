import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/storage_service.dart';
import 'package:diet_lenz/features/onboarding/view/splash_screen.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'constants/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize storage service
  final storageService = await StorageService.getInstance();

  runApp(
    ProviderScope(
      overrides: [
        // Override the storage service provider with the actual instance
        storageServiceProvider.overrideWithValue(storageService),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Load user profile if user is authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final apiService = ref.read(apiServiceProvider);
      final token = apiService.getAuthToken();

      if (token != null && token.isNotEmpty) {
        // User is authenticated, load their profile
        ref.read(userProfileViewModelProvider.notifier).getUserProfile();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      position: ToastPosition.top,
      textPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Diet Lenz',
        theme: AppTheme.darkTheme,
        navigatorKey: NavigationService.navigationKey,
        home: const SplashScreen(),
      ),
    );
  }
}
