import 'package:flutter/material.dart';
import 'package:quickdrop_app/features/navigation/bottom_nav_bar.dart';
import 'package:quickdrop_app/features/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:quickdrop_app/features/models/user_model.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

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
  return Scaffold(
    backgroundColor: AppColors.background,
     appBar: AppBar(
        title:  const Text(
              "QuickDrop",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.blue,
              ),
            ),
        backgroundColor: AppColors.background,
        centerTitle: true,
      ),
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
        child: Column(
          children: [

            // Title
           

            // const SizedBox(height: 20),

            // Slide content area
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

            // Log in button
            LoginButton(
              hintText: "Log in",
              onPressed: () {
                context.pushNamed('login');
              },
              isLoading: _isLoginLoading,
            ),

            const SizedBox(height: 15),

            // Sign up button
            LoginButton(
              hintText: "Create an account",
              onPressed: () {
                context.pushNamed('signup');
              },
              isLoading: _isLoginLoading,
              backgroundColor: AppColors.dark,
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
        Icon(Icons.delivery_dining, size: 60, color: AppColors.blue),
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
