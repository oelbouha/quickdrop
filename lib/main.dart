import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:quickdrop_app/core/providers/locale_provider.dart';
import 'package:quickdrop_app/core/providers/negotiation_provider.dart';
import 'package:quickdrop_app/core/providers/notification_provider.dart';
import 'package:quickdrop_app/features/notification/notification_handler.dart';
import 'firebase_options.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/providers/review_provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart';
import 'l10n/app_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("🔔 Background message: ${message.messageId}");
}


NotificationHandler notificationHandler = NotificationHandler();

final ColorScheme myColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF6750A4),
  onPrimary: Color(0xFFFFFFFF),
  secondary: Color(0xFF625B71),
  onSecondary: Color(0xFFFFFFFF),
  tertiary: Color(0xFF7D5260),
  onTertiary: Color(0xFFFFFFFF),
  error: Color(0xFFB3261E),
  onError: Color(0xFFFFFFFF),
  background: Color(0xFFFFFBFE),
  onBackground: Color(0xFF1C1B1F),
  surface: Color(0xFFFFFBFE),
  onSurface: Color(0xFF1C1B1F),
);



void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  print("🔍 Starting app initialization...");

  await dotenv.load(fileName: ".env");

  try {
    await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!,
    );
    print("✅ Supabase initialized successfully");
  } catch (e) {
    print("❌ Supabase initialization error: $e");
  }

  try {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    print("✅ Firebase initialized successfully");
    await FirebaseAppCheck.instance.activate(
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    );
    print("✅ Firebase App Check activated");
  } catch (e) {
    print("❌ Firebase initialization error: $e");
  }

  Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'] ?? '';

  // Set background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  try {
    print("🔍 Attempting to get FCM token...");
    FirebaseMessaging messaging = FirebaseMessaging.instance;

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

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print("🔍 Permission granted, getting token...");
      String? token = await messaging.getToken();
      if (token != null) {
        print("✅ FCM Token received: $token");
      } else {
        print("❌ FCM Token is null");
      }
    } else {
      print(
          "❌ Notification permission denied: ${settings.authorizationStatus}");
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
        ChangeNotifierProvider(create: (context) => LocaleProvider()),
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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _stripeInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeStripe();
  }

  Future<void> _initializeStripe() async {
    try {
      // Wait a bit to ensure Activity is ready
      await Future.delayed(const Duration(milliseconds: 500));
      await Stripe.instance.applySettings();
      print("✅ Stripe initialized successfully in MyApp");
      setState(() {
        _stripeInitialized = true;
      });
    } catch (e) {
      print("❌ Stripe initialization error in MyApp: $e");
 
      // Continue anyway - the app can function without Stripe
      setState(() {
        _stripeInitialized = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final router = AppRouter.createRouter(context);

    final localeProvider = Provider.of<LocaleProvider>(context);

    // Show loading screen while Stripe initializes
    if (!_stripeInitialized) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: localeProvider.locale, // default language
        supportedLocales: const [
          Locale('en'),
          Locale('fr'),
          Locale('ar'),
        ],
        localizationsDelegates: const [
          AppLocalizations.delegate, // custom delegate
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
         localeResolutionCallback: (locale, supportedLocales) {
          for (var supportedLocale in supportedLocales) {
            if (supportedLocale.languageCode == locale?.languageCode) {
              return supportedLocale;
            }
          }
          return supportedLocales.first;
        },
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: myColorScheme,
          fontFamily: 'MonaSans',
        ),
        home: Scaffold(
          backgroundColor: AppColors.background,
          body: loadingAnimation(),
        ),
      );
    }

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      locale: localeProvider.locale,
      supportedLocales: const [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        for (var supportedLocale in supportedLocales) {
          if (supportedLocale.languageCode == locale?.languageCode) {
            return supportedLocale;
          }
        }
        return supportedLocales.first;
      },
      theme: ThemeData(
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          titleMedium: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
          labelLarge: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        useMaterial3: true,
        colorScheme: myColorScheme,
        fontFamily: 'MonaSans',
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
        ),
      ),
      routerConfig: router,
    );
  }
}