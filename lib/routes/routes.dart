import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/home/home_screen.dart';
import 'package:quickdrop_app/features/chat/chat_screen.dart';
import 'package:quickdrop_app/features/profile/profile_screen.dart';
import 'package:quickdrop_app/features/shipment/shipment_screen.dart';
import 'package:quickdrop_app/features/trip/trip_screen.dart';

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/home',
      redirect: (context, state) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final user = userProvider.user;

        final loggingIn = state.uri.path == '/';

        if (user == null) {
          return loggingIn ? null : '/';
        } else {
          return loggingIn ? '/home' : null;
        }
      },
      routes: [
        ShellRoute(
            navigatorKey: GlobalKey<NavigatorState>(),
            builder: (context, state, child) {
              return BottomNavScreen(child: child);
            },
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (context, state) => NoTransitionPage(child: HomeScreen()),
              ),
              GoRoute(
                path: '/trip',
                pageBuilder: (context, state) => NoTransitionPage(child: TripScreen()),
              ),
              GoRoute(
                path: '/shipment',
                pageBuilder: (context, state) => NoTransitionPage(child: ShipmentScreen()),
              ),
              GoRoute(
                path: '/chat',
                pageBuilder: (context, state) => NoTransitionPage(child: ChatScreen()),
              ),
            ]),
        GoRoute(
          path: '/',
          name: 'login',
          builder: (context, state) => const LoginPage(),
        ),
     
        GoRoute(
          name: "chat",
          path: "/chat",
          builder: (context, state) => const ChatScreen(),
        ),
        GoRoute(
          name: "profile",
          path: "/profile",
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          name: "trip",
          path: "/trip",
          builder: (context, state) => const TripScreen(),
        ),
        GoRoute(
          name: "shipment",
          path: "/shipment",
          builder: (context, state) => const ShipmentScreen(),
        ),
        GoRoute(
          name: "notification",
          path: "/notification",
          builder: (context, state) => const NotificationScreen(),
        ),
        GoRoute(
          name: "help",
          path: "/help",
          builder: (context, state) => const HelpScreen(),
        ),
      ],
    );
  }
}
