import 'package:flutter/material.dart';
import 'package:quickdrop_app/features/navigation/bottom_nav_bar.dart';
import 'package:quickdrop_app/features/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:quickdrop_app/features/models/user_model.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

import 'package:flutter/services.dart'; 
import 'package:quickdrop_app/core/widgets/auth_button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _isLoginLoading = false;
  // bool _hasClearedUser = false;


@override
Widget build(BuildContext context) {
  return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark, 
    child: Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.backgroundStart,
              AppColors.backgroundMiddle,
              AppColors.backgroundEnd,
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
        child: Column(
          children: [
            Expanded(
              child: PageView(
                children: const [
                  OnboardingSlide(
                    title: "Fast Delivery",
                    description: "Get your packages delivered quickly and safely.",
                  ),
                  OnboardingSlide(
                    title: "Trusted Service",
                    description: "Our community ensures reliability and trust.",
                  ),
                  OnboardingSlide(
                    title: "Track Your Items",
                    description: "Real-time tracking of all your shipments.",
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            LoginButton(
              hintText: "Sign in",
              onPressed: () {
                context.pushNamed('login');
              },
              isLoading: false,
            ),
            const SizedBox(height: 10),
            textWithLink(
              text: "Don't have an account? ",
              textLink: "sign up",
              navigatTo: '/signup',
              context: context,
            ),
            const SizedBox(height: 15),
          ],
        ),
      ),
    ),
  );
}


}

class OnboardingSlide extends StatelessWidget {
  final String title;
  final String description;

  const OnboardingSlide({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const CustomIcon( iconPath: "assets/icon/car.svg", size: 60, color: AppColors.blue),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ],
    );
  }
}
