// import 'dart:developer';
// import 'dart:io';

// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:vepay/core/constants/app_colors.dart';

// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'My Channel', // title
//   description: 'Important notifications from my server.', // description
//   importance: Importance.high,
// );

// class FirebaseNotificationHandler {
//   FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

//   // Private constructor
//   FirebaseNotificationHandler._();

//   // Singleton instance
//   static final FirebaseNotificationHandler _instance =
//       FirebaseNotificationHandler._();

//   // Getter for the singleton instance
//   static FirebaseNotificationHandler get instance => _instance;

//  String token = '';
//   final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   Future<void> initialize() async {
//     // Request permission for receiving push notifications
//     NotificationSettings settings = await _firebaseMessaging.requestPermission(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     // Check if permission is granted
//     if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//       print('User granted permission for push notifications');
//     } else {
//       print(
//           'User declined or hasn\'t accepted permission for push notifications');
//     }

//     await FirebaseMessaging.instance
//         .setForegroundNotificationPresentationOptions(
//       alert: true,
//       badge: true,
//       sound: true,
//     );

//     await initializeLocalNotif();
//     // Configure handlers for receiving messages
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) {
//       final notification = message.notification;
//       if (notification != null) {
//         flutterLocalNotificationsPlugin.show(
//             notification.hashCode,
//             notification.title,
//             notification.body,
//             NotificationDetails(
//               android: AndroidNotificationDetails(channel.id, channel.name,
//                   channelDescription: channel.description,
//                   icon: '@mipmap/launcher_icon',
//                   color: AppColors.primary),
//             ));
//       }
//     });

//     // AndroidPushNotificationConfiguration().setUpAndroidNotificationChannels();

//     FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
//       print('A new onMessageOpenedApp event was published!');
//       print('Message data: ${message.data}');
//     });

//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     getToken();
//     // Configure token refresh handler
//     _firebaseMessaging.onTokenRefresh.listen((String token) {
//       print('Token refreshed: $token');
//     });
//   }

//   initializeLocalNotif() async {
//     await flutterLocalNotificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);

//     var initializationSettingsAndroid =
//         new AndroidInitializationSettings('@mipmap/launcher_icon');
//     var initializationSettingsIOS = new DarwinInitializationSettings();
//     var initializationSettings = new InitializationSettings(
//         android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
//     flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//     );
//     flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//  Future<String?> getToken() async {
//   String? fcmToken;
//   if (Platform.isIOS) {
//     // On iOS we need to see an APN token is available first
//     String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//     if (apnsToken != null) {
//       fcmToken = await FirebaseMessaging.instance.getToken();
//     }
//     else {
//       // add a delay and retry getting APN token
//       await Future<void>.delayed(const Duration(seconds: 3,));
//       apnsToken = await FirebaseMessaging.instance.getAPNSToken();
//       if (apnsToken != null) {
//         fcmToken = await FirebaseMessaging.instance.getToken();
//       }
//     }
//   }
//   else {
//     // android platform
//     fcmToken = await FirebaseMessaging.instance.getToken();
//   }
//   return fcmToken;
// }
// }

// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   // Handle the message here...
// }
