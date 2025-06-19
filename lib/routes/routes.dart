import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/home/home_screen.dart';
import 'package:quickdrop_app/features/auth/intro_screen.dart';
import 'package:quickdrop_app/features/auth/signup.dart';
import 'package:quickdrop_app/features/auth/signup_screen.dart';
import 'package:quickdrop_app/features/chat/chat_screen.dart';
import 'package:quickdrop_app/features/profile/profile_screen.dart';
import 'package:quickdrop_app/features/shipment/shipment_screen.dart';
import 'package:quickdrop_app/features/trip/trip_screen.dart';
import 'package:quickdrop_app/features/chat/convo_screen.dart';
import 'package:quickdrop_app/features/profile/update_user_info_screen.dart';
import 'package:quickdrop_app/features/profile/profile_statistics.dart';
import 'package:quickdrop_app/features/shipment/listing_card_details_screen.dart';

import 'package:quickdrop_app/features/help/privacy_policy.dart';
import 'package:quickdrop_app/features/help/terms_of_service.dart';
import 'package:quickdrop_app/features/auth/verify_email_screen.dart';
import 'package:quickdrop_app/features/auth/verify_phone_number.dart';

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
      // initialLocation: '/home',
      redirect: (context, state) {
        final user = FirebaseAuth.instance.currentUser;
        final currentPath = state.uri.path;
        final isEmailVerified =
            FirebaseAuth.instance.currentUser?.emailVerified;
        final isLoggingIn = currentPath == '/';
        final publicRoutes = {
          '/',
          '/signup',
          '/login',
          '/forgot-password',
          '/create-account',
          '/verify-number'
          '/privacy-policy',
          '/terms-of-service',
        };
        // return '/add-trip';
        // Debugging prints
        // print("isLoggingIn: $isLoggingIn");
        // print("currentPath: $currentPath");
        // print("user: $user");
        // print("isEmailVerified: $isEmailVerified");
        // return '/verify-email';
        if (user != null && currentPath == '/create-account' || currentPath == "/verify-number") {
          return null;
        }
        if (publicRoutes.contains(currentPath)) {
          return null;
        }

        // if (user != null && isEmailVerified == false) {
        //   Provider.of<UserProvider>(context, listen: false).fetchUser(user.uid);
        //   return '/verify-email';
        // }
        if (user != null && currentPath == '/') {
          Provider.of<UserProvider>(context, listen: false).fetchUser(user.uid);
          return '/home';
        }
        return null;
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
                    const NoTransitionPage(child: HomeScreen()),
              ),
              GoRoute(
                path: '/trip',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TripScreen()),
              ),
              GoRoute(
                path: '/shipment',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ShipmentScreen()),
              ),
              GoRoute(
                path: '/chat',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ChatScreen()),
              ),
            ]),
        GoRoute(
          path: '/',
          name: 'intro',
          builder: (context, state) => const IntroScreen(),
        ),
        GoRoute(
            path: '/signup',
            name: 'signup',
            pageBuilder: (context, state) {
              return buildCustomTransitionPage(
                context,
                const Signup(),
              );
            }),
        GoRoute(
          path: '/login',
          name: 'login',
          pageBuilder: (context, state) {
            return buildCustomTransitionPage(
              context,
              const LoginPage(),
            );
          }),
            GoRoute(
            path: '/create-account',
            name: 'create-account',
            pageBuilder: (context, state) {
              final phoneNumber = state.uri.queryParameters['phoneNumber'];
              return buildCustomTransitionPage(
                context,
                SignUpScreen(
                  phoneNumber: phoneNumber,
                ),
              );
            }),
        GoRoute(
            path: '/verify-number',
            name: 'verify-number',
            pageBuilder: (context, state) {
              final phoneNumber = state.uri.queryParameters['phoneNumber'];
              final verificationId = state.uri.queryParameters['verificationId'];
              print("Route param received: ${state.uri.queryParameters}");

              // print("phoneNumber: $phoneNumber");
              return buildCustomTransitionPage(
                context,
                VerifyPhoneScreen(
                  phoneNumber: phoneNumber,
                  verificationId: verificationId!
                ),
              );
            }),
        GoRoute(
          name: "chat",
          path: "/chat",
          builder: (context, state) => const ChatScreen(),
        ),
        GoRoute(
          name: "verify-email",
          path: "/verify-email",
          pageBuilder: (context, state) => buildCustomTransitionPage(
            context,
            const VerifyEmailScreen(),
          ),
        ),
        // GoRoute(
        //   name: "verify-phone",
        //   path: "/verify-phone",
        //   pageBuilder: (context, state) => buildCustomTransitionPage(
        //     context,
        //     const VerifyPhoneScreen(),
        //   ),
        // ),
        GoRoute(
          name: "privacy-policy",
          path: "/privacy-policy",
          pageBuilder: (context, state) => buildCustomTransitionPage(
            context,
            const PrivacyPolicy(),
          ),
        ),
        GoRoute(
          name: "terms-of-service",
          path: "/terms-of-service",
          pageBuilder: (context, state) => buildCustomTransitionPage(
            context,
            const TermsOfService(),
          ),
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
                final userData =
                    Provider.of<UserProvider>(context, listen: false)
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
        GoRoute(
            name: "trip-details",
            path: "/trip-details",
            pageBuilder: (context, state) {
              final tripId = state.uri.queryParameters['tripId'];
              final userId = state.uri.queryParameters['userId'];
              try {
                final userData =
                    Provider.of<UserProvider>(context, listen: false)
                        .getUserById(userId!);
                if (userData == null) throw ("user is null");
                final trip =
                    Provider.of<TripProvider>(context, listen: false)
                        .getTrip(tripId!);
                return buildCustomTransitionPage(
                    context,
                    ListingCardDetails(
                      user: userData,
                      shipment: trip,
                    ));
              } catch (e) {
                return buildCustomTransitionPage(context, const ErrorPage());
              }
            }),
      ],
    );
  }
}
