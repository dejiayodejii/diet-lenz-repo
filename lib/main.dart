import 'package:diet_lenz/core/config/app_config.dart';
import 'package:diet_lenz/core/providers/storage_providers.dart';
import 'package:diet_lenz/core/services/iap_service.dart';
import 'package:diet_lenz/core/services/navigation_service.dart';
import 'package:diet_lenz/core/services/push_notification_service.dart';
import 'package:diet_lenz/core/services/storage_service.dart';
import 'package:diet_lenz/core/widgets/restart_widget.dart';
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

// List<int>? twoSum(List<int> numbs, int target) {
//   var checkMap = {};

//   for (var i = 0; i < numbs.length; i++) {
//     final currentNumber = numbs[i];
//     final compliment = target - currentNumber;
//     if (checkMap[compliment] != null) {
//       return [checkMap[compliment], i];
//     } else {
//       checkMap[currentNumber] = i;
//     }
//   }
//   return null;
// }

// List<int>? twoSumSorted(List<int> numbs, int target) {
//   int left = 0;
//   int right = numbs.length - 1;

//   while (left < right) {
//     final sum = numbs[left] + numbs[right];
//     if (sum == target) {
//       return [left, right];
//     }
//     if (sum < target) {
//       left++;
//     } else {
//       right--;
//     }
//   }
//   return null;
// }

// best time to buy and sell stock
// int maximumProfit(List<int> prices) {
//   int minimumBuyPrice = prices[0];
//   int maximumProfit = 0;

//   for (var i = 1; i < prices.length; i++) {
//     int todaySellingPrice = prices[i];
//     int profit = todaySellingPrice - minimumBuyPrice;
//     if (maximumProfit < profit) {
//       maximumProfit = profit;
//     }

//     if (todaySellingPrice < minimumBuyPrice) {
//       minimumBuyPrice = todaySellingPrice;
//     }
//   }

//   return maximumProfit;
// }

//contain duplicate

// bool containsDuplicate(List<int> numbers) {
//   Set<int> storage = {};

//   for (var i = 0; i < numbers.length; i++) {
//     if (storage.contains(numbers[i])) {
//       return true;
//     }
//     storage.add(numbers[i]) ;
//   }
//   return false;
// }

//validAnagram

// bool validAnagram(String firstWord, String secondWord) {

//   if (firstWord.split("").length != secondWord.split("").length) {
//     return false;
//   }

//   Map<String, int> storage = {};

//   for (var element in firstWord.split("")) {
//     if (storage.containsKey(element)) {
//       storage[element] = storage[element]! + 1;
//     } else {
//       storage[element] = 1;
//     }
//   }

//   for (var element in secondWord.split("")) {
//     if (!storage.containsKey(element)) {
//       return false;
//     }
//     storage[element] = storage[element]! - 1;

//     if (storage[element]! < 0) {
//       return false;
//     }
//   }

//   return true;
// }

//
int firstUniqueCharacter(String words) {
  Map<String, int> storage = {};

  List<String> word = words.split("");

  for (var i = 0; i < word.length; i++) {
    if (storage.containsKey(words[i])) {
      storage[words[i]] = storage[words[i]]! + 1;
    } else {
      storage[words[i]] = 1;
    }
  }

  for (var i = 0; i < word.length; i++) {
    if (storage[word[i]] == 1) {
      return i;
    }
  }
  return -1;
}

int majorityElement(List<int> numbers) {
  final threshold = numbers.length ~/ 2;

  Map<int, int> storage = {};

  for (var i = 0; i < numbers.length; i++) {
    if (storage.containsKey(numbers[i])) {
      storage[numbers[i]] = storage[numbers[i]]! + 1;
    } else {
      storage[numbers[i]] = 1;
    }
  }

  late int element;

  for (var i = 0; i < numbers.length; i++) {
    if (storage[numbers[i]]! > threshold) {
      element = numbers[i];
      break;
    }
  }
  return element;
}

//remive duplicate and return new length
// int removeDuplicatedSortedArray(List<int> numbers) {
//   if (numbers.isEmpty) {
//     return 0;
//   }
//   int left = 0;

//   for (var i = 1; i < numbers.length; i++) {
//     final fast = numbers[i];

//     if (numbers[left] != fast) {
//       left++;
//       numbers[left] = fast;
//     }
//   }
//   return left + 1;
// }

//move zeroes to end of array
void moveZeroes(List<int> numbers) {
  int left = 0;

  for (var i = 0; i < numbers.length; i++) {
    if (numbers[i] != 0) {
      int newLeft = numbers[left];
      int newRight = numbers[i];
      numbers[left] = newRight;
      numbers[i] = newLeft;
      left++;
    }
  }
}
