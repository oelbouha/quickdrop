import 'package:quickdrop_app/core/utils/imports.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationHandler {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void setupNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission();
    print('🔐 Permission: ${settings.authorizationStatus}');

    // Get FCM token
    String? token = await messaging.getToken();
    print("📲 FCM Token: $token");

    

    // Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📨 Message received: ${message.notification?.title}');

      // Show notification
      flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification?.title,
        message.notification?.body,
        NotificationDetails(
           android: AndroidNotificationDetails(
            'default_channel',
            'Default',
            importance: Importance.max,
            priority: Priority.high,
          ),
        ),
      );
    });

    // When app is opened from background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📬 Notification tapped: ${message.data}');
    });

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }
  // @override

  // State<NotificationHandler> createState() => _NotificationHandlerState();
}


// class _NotificationHandlerState extends State<NotificationHandler> {


//   @override
//   Widget build(BuildContext context) {
//   }
// }            
              
            
            
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   