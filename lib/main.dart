import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/features/onboarding/view/splash_screen.dart';
import 'package:flutter/material.dart';
import 'constants/app_theme.dart';

void main() {
  runApp(const MyApp());
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
