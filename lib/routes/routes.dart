import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/home/home_screen.dart';
import 'package:quickdrop_app/features/chat/chat_screen.dart';
import 'package:quickdrop_app/features/profile/profile_screen.dart';
import 'package:quickdrop_app/features/shipment/shipment_screen.dart';
import 'package:quickdrop_app/features/trip/trip_screen.dart';
import 'package:quickdrop_app/features/chat/convo_screen.dart';
import 'package:quickdrop_app/features/profile/update_user_info_screen.dart';
import 'package:quickdrop_app/features/profile/profile_statistics.dart';
import 'package:quickdrop_app/features/shipment/listing_card_details_screen.dart';

CustomTransitionPage buildCustomTransitionPage(
  BuildContext context,
  Widget child,
) {
  return CustomTransitionPage(
    key: ValueKey(child),
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

class AppRouter {
  static GoRouter createRouter(BuildContext context) {
    return GoRouter(
      initialLocation: '/home',
      redirect: (context, state) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        final user = userProvider.user;
        // if (user == null) print("user is null");
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
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: HomeScreen()),
              ),
              GoRoute(
                path: '/trip',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: TripScreen()),
              ),
              GoRoute(
                path: '/shipment',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: ShipmentScreen()),
              ),
              GoRoute(
                path: '/chat',
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: ChatScreen()),
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
          pageBuilder: (context, state) => buildCustomTransitionPage(
            context,
            const ProfileScreen(),
          ),
        ),
        GoRoute(
            name: "profile-statistics",
            path: "/profile/statistics",
            pageBuilder: (context, state) => buildCustomTransitionPage(
                  context,
                  const ProfileStatistics(),
                )),
        GoRoute(
            name: "profile-info",
            path: "/profile/info",
            pageBuilder: (context, state) => buildCustomTransitionPage(
                  context,
                  const UpdateUserInfoScreen(),
                )),
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
          pageBuilder: (context, state) =>
              buildCustomTransitionPage(context, const NotificationScreen()),
        ),
        GoRoute(
          name: "help",
          path: "/help",
          pageBuilder: (context, state) =>
              buildCustomTransitionPage(context, const HelpScreen()),
        ),
        GoRoute(
            name: "add-shipment",
            path: "/add-shipment",
            pageBuilder: (context, state) => buildCustomTransitionPage(
                  context,
                  const AddShipmentScreen(),
                )),
        GoRoute(
            name: "add-trip",
            path: "/add-trip",
            pageBuilder: (context, state) => buildCustomTransitionPage(
                  context,
                  const AddTripScreen(),
                )),
        GoRoute(
            name: "convo-screen",
            path: "/convo-screen",
            pageBuilder: (context, state) {
              Map<String, dynamic> user = state.extra as Map<String, dynamic>;
              return buildCustomTransitionPage(
                  context,
                  ConversationScreen(
                    user: user,
                  ));
            }),
        GoRoute(
            name: "shipment-details",
            path: "/shipment-details",
            pageBuilder: (context, state) {
              final shipmentId = state.uri.queryParameters['shipmentId'];
              final userId = state.uri.queryParameters['userId'];
              try {
                final userData = Provider.of<UserProvider>(context, listen: false)
                    .getUserById(userId!);
                if (userData == null) throw ("user is null");
                final shipment =
                    Provider.of<ShipmentProvider>(context, listen: false)
                        .getShipment(shipmentId!);
                return buildCustomTransitionPage(
                    context,
                    ListingCardDetails(
                      user: userData,
                      shipment: shipment,
                    ));
              } catch (e) {
                return buildCustomTransitionPage(context, const ErrorPage());
              }
            }),
      ],
    );
  }
}
