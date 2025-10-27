import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/auth/onboarding_screen.dart';
import 'package:quickdrop_app/features/auth/splash_redirect.dart';
import 'package:quickdrop_app/features/profile/change_contact_info_screen.dart';
import 'package:quickdrop_app/features/profile/change_language_screen.dart';
import 'package:quickdrop_app/features/profile/change_personal_info_screen.dart';
import 'package:quickdrop_app/features/profile/change_profile_image_screen.dart';
import 'package:quickdrop_app/features/profile/payment.screen.dart';
import 'package:quickdrop_app/features/requests/negotiation_screen.dart';
import 'package:quickdrop_app/features/home/home_screen.dart';
import 'package:quickdrop_app/features/auth/intro_screen.dart';
import 'package:quickdrop_app/features/auth/signup.dart';
import 'package:quickdrop_app/features/auth/signup_screen.dart';
import 'package:quickdrop_app/features/chat/chat_screen.dart';
import 'package:quickdrop_app/features/requests/requests_screen.dart';
import 'package:quickdrop_app/features/profile/profile_screen.dart';
import 'package:quickdrop_app/features/shipment/shipment_screen.dart';
import 'package:quickdrop_app/features/trip/trip_screen.dart';
import 'package:quickdrop_app/features/chat/convo_screen.dart';
import 'package:quickdrop_app/features/profile/security_screen.dart';
import 'package:quickdrop_app/features/profile/become_driver_screen.dart';
import 'package:quickdrop_app/features/profile/update_user_info_screen.dart';
import 'package:quickdrop_app/features/profile/profile_statistics.dart';
import 'package:quickdrop_app/features/shipment/listing_card_details_screen.dart';
import 'package:quickdrop_app/features/home/search_page.dart';
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
        final isLoggingIn = currentPath == '/';
        final publicRoutes = {
          '/',
          '/signup',
          '/login',
          '/forgot-password',
          '/create-account',
          '/verify-number',
          '/privacy-policy',
          '/terms-of-service',
        };


        if (user != null && currentPath == '/create-account' ||
            currentPath == "/verify-number") {
          return null;
        }

        if (publicRoutes.contains(currentPath)) {
          return null;
        }

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
                path: '/trips',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: TripScreen()),
              ),
              GoRoute(
                path: '/shipments',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ShipmentScreen()),
              ),
              GoRoute(
                path: '/requests',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: OfferScreen()),
              ),
              GoRoute(
                path: '/chats',
                pageBuilder: (context, state) =>
                    const NoTransitionPage(child: ChatScreen()),
              ),
            ]),
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (context, state) => const SplashRedirect(),
        ),
        GoRoute(
          path: '/onboarding',
          name: 'onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),

        GoRoute(
          path: '/intro',
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
            path: '/change-language',
            name: 'change-language',
            pageBuilder: (context, state) {
              return buildCustomTransitionPage(
                context,
                const ChangeLanguageScreen(),
              );
            }),
        GoRoute(
            path: '/change-image',
            name: 'change-image',
            pageBuilder: (context, state) {
              return buildCustomTransitionPage(
                context,
                const ChangeProfileImageScreen(),
              );
            }),
        GoRoute(
            path: '/change-personal-info',
            name: 'change-personal-info',
            pageBuilder: (context, state) {
              return buildCustomTransitionPage(
                context,
                const ChangePersonalInfoScreen(),
              );
            }),
        GoRoute(
            path: '/change-contact-info',
            name: 'change-contact-info',
            pageBuilder: (context, state) {
              return buildCustomTransitionPage(
                context,
                const ChangeContactInfoScreen(),
              );
            }),
        GoRoute(
            path: '/verify-number',
            name: 'verify-number',
            pageBuilder: (context, state) {
              final phoneNumber = state.uri.queryParameters['phoneNumber'];
              final verificationId =
                  state.uri.queryParameters['verificationId'];

              // print("phoneNumber: $phoneNumber");
              return buildCustomTransitionPage(
                context,
                VerifyPhoneScreen(
                    phoneNumber: phoneNumber, verificationId: verificationId!),
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
            pageBuilder: (context, state) {
              final String? email = state.uri.queryParameters['email'];

              return buildCustomTransitionPage(
                  context,
                  VerifyEmailScreen(
                    email: email ?? "Your Email",
                  ));
            }),
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
          name: "Register-driver",
          path: "/Register-driver",
          pageBuilder: (context, state) => buildCustomTransitionPage(
            context,
            const BecomeDriverScreen(),
          ),
        ),
        GoRoute(
          name: "Payment",
          path: "/Payment",
          pageBuilder: (context, state) => buildCustomTransitionPage(
            context,
            const PaymentScreen(),
          ),
        ),
        GoRoute(
          name: "profile-security",
          path: "/profile-security",
          pageBuilder: (context, state) => buildCustomTransitionPage(
            context,
            const SecurityScreen(),
          ),
        ),
        GoRoute(
            name: "profile-statistics",
            path: "/profile/statistics",
            pageBuilder: (context, state) {
              final userId = state.uri.queryParameters['userId'];
              return buildCustomTransitionPage(
                  context,
                  ProfileStatisticsLoader(
                    userId: userId!,
                  ));
            }),
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
            pageBuilder: (context, state) {
              final id = state.uri.queryParameters['shipmentId'];
              final isEdit = state.uri.queryParameters['isEdit'] == "true";
              Shipment? shipment;
              if (id != null) {
                shipment = Provider.of<ShipmentProvider>(context, listen: false)
                    .getShipment(id);
              }

              return buildCustomTransitionPage(
                context,
                AddShipmentScreen(
                  isEditMode: isEdit,
                  existingShipment: shipment,
                ),
              );
            }),
        GoRoute(
            name: "add-trip",
            path: "/add-trip",
            pageBuilder: (context, state) {
              final id = state.uri.queryParameters['tripId'];
              final isEdit = state.uri.queryParameters['isEdit'] == "true";

              Trip? trip;
              if (id != null) {
                trip = Provider.of<TripProvider>(context, listen: false)
                    .getTrip(id);
              }
              return buildCustomTransitionPage(
                context,
                AddTripScreen(
                  isEditMode: isEdit,
                  existingTrip: trip,
                ),
              );
            }),
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
            name: "negotiation-screen",
            path: "/negotiation-screen",
            pageBuilder: (context, state) {
              final userId = state.uri.queryParameters['userId'];
              final shipmentId = state.uri.queryParameters['shipmentId'];
              final requestId = state.uri.queryParameters['requestId'];
              try {
                return buildCustomTransitionPage(
                    context,
                    NegotiationScreen(
                        userId: userId!,
                        requestId: requestId!,
                        shipmentId: shipmentId!));
              } catch (e) {
                return buildCustomTransitionPage(
                    context,
                    ErrorPage(
                      errorMessage: e.toString(),
                    ));
              }
            }),
        GoRoute(
          path: '/search',
          pageBuilder: (context, state) {
            final filters = (state.extra is SearchFilters)
                ? state.extra as SearchFilters
                : const SearchFilters();
            return buildCustomTransitionPage(
                context, SearchResultsScreen(filters: filters));
          },
        ),

        GoRoute(
            name: "shipment-details",
            path: "/shipment-details",
            pageBuilder: (context, state) {
              final shipmentId = state.uri.queryParameters['shipmentId'];
              final userId = state.uri.queryParameters['userId'];
              final viewOnly = state.uri.queryParameters['viewOnly'] == "true";
              return buildCustomTransitionPage(
                  context,
                  ListingShipmentLoader(
                    viewOnly: viewOnly,
                    userId: userId!,
                    shipmentId: shipmentId!,
                  ));
            }),
        GoRoute(
            name: "trip-details",
            path: "/trip-details",
            pageBuilder: (context, state) {
              final tripId = state.uri.queryParameters['tripId'];
              final userId = state.uri.queryParameters['userId'];
              final viewOnly = state.uri.queryParameters['viewOnly'] == "true";
              if (tripId == null || userId == null) {
                return buildCustomTransitionPage(
                    context,
                    ErrorPage(
                      errorMessage: "Trip ID or User ID is missing.",
                    ));
              }
              return buildCustomTransitionPage(
                  context,
                  ListingTripLoader(
                    viewOnly: viewOnly,
                    userId: userId!,
                    shipmentId: tripId!,
                  ));
            }),
      ],
    );
  }
}
