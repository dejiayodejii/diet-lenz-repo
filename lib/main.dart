import 'package:diet_lenz/core/config/app_config.dart';
import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/services/iap_service.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/push_notification_service.dart';
import 'package:diet_lenz/core/services/storage_service.dart';
import 'package:diet_lenz/core/widgets/restart_widget.dart';
import 'package:diet_lenz/features/auth/view/personization/plan_setup.dart';
import 'package:diet_lenz/features/onboarding/view/splash_screen.dart';
import 'package:diet_lenz/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oktoast/oktoast.dart';
import 'constants/app_theme.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize Firebase (ignore duplicate-initialization errors)
  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  } on FirebaseException catch (e) {
    final msg = e.message?.toLowerCase() ?? '';
    if (e.code.contains('duplicate') || msg.contains('already exists')) {
      // Firebase was already initialized by a ContentProvider or another
      // automatic initializer on some platforms — ignore.
    } else {
      rethrow;
    }
  }

  // Register background message handler
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // Initialize push notifications
  final pushService = PushNotificationService();
  try {
    pushService.initialize();
    // print('✅ Push notifications initialized');what
  } catch (e) {
    // print('⚠️ Push notification init failed (non-fatal): $e');
  }

  // Initialize storage service
  final storageService = await StorageService.getInstance();

  // Initialize RevenueCat SDK early (before runApp)
  final iapService = IAPService();
  try {
    await iapService.configure();
  } catch (_) {
    // Non-fatal: app continues without RevenueCat
  }

  await SentryFlutter.init(
    (options) {
      options.dsn = AppConfig.sentryDsn;
      options.sendDefaultPii = true;
      options.enableLogs = true;
      options.tracesSampleRate = AppConfig.sentryTracesSampleRate;
      options.profilesSampleRate = AppConfig.sentryProfilesSampleRate;
      options.replay.sessionSampleRate =
          AppConfig.sentryReplaySessionSampleRate;
      options.replay.onErrorSampleRate = 1.0;
    },
    appRunner: () => runApp(RestartWidget(
      overrides: [
        // Override the storage service provider with the actual instance
        storageServiceProvider.overrideWithValue(storageService),
        // Provide the already-configured IAP service
        iapServiceProvider.overrideWithValue(iapService),
        // Provide the push notification service
        pushNotificationServiceProvider.overrideWithValue(pushService),
      ],
      child: const MyApp(),
    )),
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
        // home: PlanSetUpScreen(),
        home: const SplashScreen(),
      ),
    );
  }
}
