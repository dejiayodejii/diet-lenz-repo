// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the push notification service
final pushNotificationServiceProvider =
    Provider<PushNotificationService>((ref) {
  return PushNotificationService();
});

/// Top-level function for handling background messages.
/// Must be a top-level function (not a class method).
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print('📩 Background message: ${message.messageId}');
}

/// Service that manages Firebase Cloud Messaging (FCM) for push notifications.
///
/// Handles:
/// 1. Permission requests (iOS)
/// 2. FCM token retrieval and refresh
/// 3. Foreground notification display via flutter_local_notifications
/// 4. Notification tap handling (foreground, background, terminated)
class PushNotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  /// The current FCM token. Available after [initialize] completes.
  String? _fcmToken;
  String? get fcmToken => _fcmToken;

  /// Callback invoked when user taps a notification. Set this from your UI
  /// layer to handle navigation.
  void Function(Map<String, dynamic> data)? onNotificationTapped;

  /// Callback invoked when the FCM token refreshes. Use this to send the
  /// updated token to your backend.
  void Function(String token)? onTokenRefresh;

  // Android notification channel
  static const _androidChannel = AndroidNotificationChannel(
    'diet_lenz_notifications', // id
    'Diet Lenz Notifications', // name
    description: 'Notifications from Diet Lenz',
    importance: Importance.high,
  );

  /// Initialize FCM and local notifications. Call once after Firebase.initializeApp().
  Future<void> initialize() async {
    // 1. Request permission (iOS shows a prompt; Android 13+ also requires it)
    await _requestPermission();

    // 2. Set up the Android notification channel
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    // 3. Initialize flutter_local_notifications
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: false, // We already requested via FCM
      requestBadgePermission: false,
      requestSoundPermission: false,
    );
    await _localNotifications.initialize(
      settings:
          const InitializationSettings(android: androidInit, iOS: iosInit),
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );

    // 4. Get FCM token
    // iOS simulators do NOT support APNS, so skip FCM token retrieval there.
    if (Platform.isIOS && !await _isRealDevice()) {
      print(
          '📱 Running on iOS simulator — APNS/FCM not supported. Skipping token retrieval.');
    } else {
      try {
        if (Platform.isIOS) {
          // Wait for APNS token to be available before requesting FCM token
          String? apnsToken = await _messaging.getAPNSToken();
          if (apnsToken == null) {
            await Future.delayed(const Duration(seconds: 3));
            apnsToken = await _messaging.getAPNSToken();
          }
          if (apnsToken == null) {
            print(
                '⚠️ APNS token not available yet, FCM token will be fetched on refresh');
          }
        }
        _fcmToken = await _messaging.getToken();
        print('🔔 FCM Token: $_fcmToken');
      } catch (e) {
        print('⚠️ Could not get FCM token: $e');
      }
    }

    // 5. Listen for token refresh
    _messaging.onTokenRefresh.listen((newToken) {
      _fcmToken = newToken;
      print('🔔 FCM Token refreshed: $newToken');
      onTokenRefresh?.call(newToken);
    });

    // 6. Handle foreground messages — show a local notification
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // 7. Handle notification taps when app was in background
    FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationOpen);

    // 8. Check if app was opened from a terminated state by a notification
    final initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationOpen(initialMessage);
    }

    // 9. iOS foreground presentation options
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Request notification permission from the user.
  Future<void> _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('🔔 Notification permission: ${settings.authorizationStatus}');
  }

  /// Show a local notification when a message arrives while the app is in
  /// the foreground.
  void _handleForegroundMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification == null) return;

    _localNotifications.show(
      id: notification.hashCode,
      title: notification.title,
      body: notification.body,
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          _androidChannel.id,
          _androidChannel.name,
          channelDescription: _androidChannel.description,
          icon: '@mipmap/ic_launcher',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: jsonEncode(message.data),
    );
  }

  /// Handle notification taps (background or terminated).
  void _handleNotificationOpen(RemoteMessage message) {
    print('🔔 Notification tapped: ${message.data}');
    onNotificationTapped?.call(message.data);
  }

  /// Handle local notification taps (foreground).
  void _onNotificationTapped(NotificationResponse response) {
    if (response.payload != null) {
      try {
        final data = jsonDecode(response.payload!) as Map<String, dynamic>;
        print('🔔 Local notification tapped: $data');
        onNotificationTapped?.call(data);
      } catch (_) {}
    }
  }

  /// Subscribe to a topic (e.g. "promotions", "updates").
  Future<void> subscribeToTopic(String topic) async {
    await _messaging.subscribeToTopic(topic);
    print('🔔 Subscribed to topic: $topic');
  }

  /// Unsubscribe from a topic.
  Future<void> unsubscribeFromTopic(String topic) async {
    await _messaging.unsubscribeFromTopic(topic);
    print('🔔 Unsubscribed from topic: $topic');
  }

  /// Returns true if running on a physical iOS device (not a simulator).
  Future<bool> _isRealDevice() async {
    if (!Platform.isIOS) return true;
    final info = await DeviceInfoPlugin().iosInfo;
    return info.isPhysicalDevice;
  }
}
