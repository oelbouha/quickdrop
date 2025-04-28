import 'firebase_options.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:quickdrop_app/routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ShipmentProvider()),
        ChangeNotifierProvider(create: (context) => TripProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()),
        ChangeNotifierProvider(create: (context) => DeliveryRequestProvider()),
        ChangeNotifierProvider(create: (context) => ChatProvider()),
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
    return  SkeletonizerConfig(
      data: const SkeletonizerConfigData(
        effect: ShimmerEffect(
          baseColor: Color.fromARGB(255, 151, 143, 143), 
          highlightColor: Color.fromARGB(255, 95, 94, 94),
        ),
      ),
    child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          fontFamily: 'Roboto',
          appBarTheme: const AppBarTheme(
            // backgroundColor: Colors.blue,
            iconTheme: IconThemeData(color: Colors.white), // Makes the back arrow white
          ),
        ),
        routerConfig: router,
        ));
  }
}
