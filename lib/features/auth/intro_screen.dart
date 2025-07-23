import 'package:flutter/material.dart';
import 'package:quickdrop_app/features/navigation/bottom_nav_bar.dart';
import 'package:quickdrop_app/features/auth/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:quickdrop_app/features/models/user_model.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter/services.dart'; 
import 'package:quickdrop_app/core/widgets/auth_button.dart';
import 'package:flutter_svg/flutter_svg.dart';



class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  bool _isLoginLoading = false;
  bool _isSignUpLoading = false;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.4),
                  Colors.black.withOpacity(0.2),
                ],
              ),
            ),
          
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Header Section
                  const Column(
                    children: [
                      const SizedBox(height: 32),
                      Text(
                        'QUICKDROP',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Connect. Ship. Deliver.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151), // gray-700
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Spacer for visual balance
                  Container(
                    width: double.infinity,
                    height: 192,
                  ),
                  
                  // const SizedBox(height: 48),
                  
                  // Buttons Section
                  const Spacer(),
                  Column(
                    children: [
                      // Sign In Button
                      LoginButton(
                        hintText: "Sign in",
                        onPressed: () {
                          setState(() {
                            _isLoginLoading = true;
                          });
                          context.pushNamed('login');
                        },
                        isLoading: _isLoginLoading,
                        radius: 60,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      LoginButton(
                        hintText: "Sign up",
                        onPressed: () {
                          setState(() {
                            _isSignUpLoading = true;
                          });
                          context.pushNamed('signup');
                        },
                        backgroundColor: AppColors.appBarIcons,
                        isLoading: _isSignUpLoading,
                        radius: 60,
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Bottom Indicator
                  const Spacer(),
                  Container(
                    width: 100,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )),
    );
  }
}