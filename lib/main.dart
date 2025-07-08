import 'package:quickdrop_app/core/providers/negotiation_provider.dart';

import 'firebase_options.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/providers/review_provider.dart';

import 'package:supabase_flutter/supabase_flutter.dart';

const String supabaseUrl = "https://tkybfgcldgoqrleaxlmb.supabase.co";
const String anonKey =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRreWJmZ2NsZGdvcXJsZWF4bG1iIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ2MzM3MDksImV4cCI6MjA2MDIwOTcwOX0.h7dCsmBJvcEkOgnFixtHQVuyxqtqN3FnOI9liKUeJQM";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: anonKey,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
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
    return SkeletonizerConfig(
        data: const SkeletonizerConfigData(
          effect: ShimmerEffect(
            baseColor: Color.fromARGB(255, 151, 143, 143),
            highlightColor: Color.fromARGB(255, 95, 94, 94),
          ),
        ),
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'MonaSans',
            appBarTheme: const AppBarTheme(
              // backgroundColor: Colors.blue,
              iconTheme: IconThemeData(
                  color: Colors.white), // Makes the back arrow white
            ),
          ),
          routerConfig: router,
        ));
  }
}
