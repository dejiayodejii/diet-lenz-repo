import 'package:diet_lenz/core/providers/api_providers.dart';
import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/services/iap_service.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/push_notification_service.dart';
import 'package:diet_lenz/core/services/storage_service.dart';
import 'package:diet_lenz/core/widgets/restart_widget.dart';
import 'package:diet_lenz/features/onboarding/view/splash_screen.dart';
import 'package:diet_lenz/features/subscription/controller/subscription_viewmodel.dart';
import 'package:diet_lenz/features/user/controller/user_profile_viewmodel.dart';
import 'package:diet_lenz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'constants/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
  DeviceOrientation.portraitDown,
]);

  // Initialize Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize push notifications
  final pushService = PushNotificationService();
  try {
    await pushService.initialize();
    // print('✅ Push notifications initialized');
  } catch (e) {
    // print('⚠️ Push notification init failed (non-fatal): $e');
  }

  // Initialize storage service
  final storageService = await StorageService.getInstance();

  // Initialize RevenueCat SDK early (before runApp)
  final iapService = IAPService();
  try {
    await iapService.configure();
    print('✅ RevenueCat initialized');
  } catch (e) {
    print('⚠️ RevenueCat init failed (non-fatal): $e');
  }

  runApp(
    RestartWidget(
      overrides: [
        // Override the storage service provider with the actual instance
        storageServiceProvider.overrideWithValue(storageService),
        // Provide the already-configured IAP service
        iapServiceProvider.overrideWithValue(iapService),
        // Provide the push notification service
        pushNotificationServiceProvider.overrideWithValue(pushService),
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

        // Identify user with RevenueCat & check entitlement
        final authResponse = apiService.getSavedAuthResponse();
        if (authResponse != null && authResponse.isNotEmpty) {
          try {
            final userId =
                apiService.getAuthToken(); // or parse userId from authResponse
            if (userId != null && userId.isNotEmpty) {
              ref
                  .read(subscriptionViewModelProvider.notifier)
                  .loginUser(userId);
            }
          } catch (_) {}
        }
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
        // home: const MealDetailScreen(),
        // home: const SuggestResultScreen(),
      ),
    );
  }
}
