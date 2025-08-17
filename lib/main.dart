import 'package:quickdrop_app/core/providers/negotiation_provider.dart';
import 'package:quickdrop_app/core/providers/notification_provider.dart';
import 'package:quickdrop_app/features/notification/notification_handler.dart';
import 'firebase_options.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/providers/review_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Background message: ${message.messageId}");
}

const String supabaseUrl = "https://tkybfgcldgoqrleaxlmb.supabase.co";
const String anonKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRreWJmZ2NsZGdvcXJsZWF4bG1iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2MzM3MDksImV4cCI6MjA2MDIwOTcwOX0.h7dCsmBJvcEkOgnFixtHQVuyxqtqN3FnOI9liKUeJQM";

NotificationHandler notificationHandler = NotificationHandler();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  print("🔍 Starting app initialization...");
  
  try {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: anonKey,
    );
    print("✅ Supabase initialized successfully");
  } catch (e) {
    print("❌ Supabase initialization error: $e");
  }

  try {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
    print("✅ Firebase initialized successfully");
    
    // Debug: Check Firebase app name and options
    print("🔍 Firebase app name: ${Firebase.app().name}");
    print("🔍 Firebase project ID: ${Firebase.app().options.projectId}");
    print("🔍 Firebase app ID: ${Firebase.app().options.appId}");
    
  } catch (e) {
    print("❌ Firebase initialization error: $e");
  }

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Debug: Try to get FCM token immediately
  try {
    print("🔍 Attempting to get FCM token...");
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    
    // Check if Firebase Messaging is available
    print("🔍 Firebase Messaging instance created");
    
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print("🔐 Permission status: ${settings.authorizationStatus}");
    print("🔐 Alert setting: ${settings.alert}");
    print("🔐 Badge setting: ${settings.badge}");
    print("🔐 Sound setting: ${settings.sound}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("🔍 Permission granted, getting token...");
      String? token = await messaging.getToken();
      if (token != null) {
        print("✅ FCM Token received: $token");
      } else {
        print("❌ FCM Token is null");
      }
    } else {
      print("❌ Notification permission denied: ${settings.authorizationStatus}");
    }
    
  } catch (e, stackTrace) {
    print("❌ Direct FCM token error: $e");
    print("❌ Stack trace: $stackTrace");
  }

  // Initialize notification handler
  try {
    notificationHandler.setupNotifications();
    print("✅ Notification handler setup completed");
  } catch (e) {
    print("❌ Notification handler setup error: $e");
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ShipmentProvider()),
        ChangeNotifierProvider(create: (context) => StatisticsProvider()),
        ChangeNotifierProvider(create: (context) => ReviewProvider()),
        ChangeNotifierProvider(create: (context) => TripProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => DeliveryRequestProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
        ChangeNotifierProvider(create: (context) => NegotiationProvider()),
        ChangeNotifierProvider(create: (context) => NotificationProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter(context);
    return  MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'MonaSans',
            appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: Colors.black12),
            ),
          ),
          routerConfig: router,
        );
  }
}