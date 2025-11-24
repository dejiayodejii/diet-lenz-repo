import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/storage_service.dart';
import 'package:diet_lenz/features/onboarding/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Diet Lenz',
      theme: AppTheme.darkTheme,
      navigatorKey: NavigationService.navigationKey,
      home: const SplashScreen(),
    );
  }
}
