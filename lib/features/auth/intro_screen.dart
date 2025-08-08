import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter/services.dart'; 

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
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header Section
                 Column(
                  children: [
                    const SizedBox(height: 32),
                    Image.asset(
                      "assets/images/logo.png",
                      height: 80,
                    ),
                    
                    // Text(
                    //   'QUICKDROP',
                    //   style: TextStyle(
                    //     fontSize: 36,
                    //     fontWeight: FontWeight.bold,
                    //     color: Colors.black,
                    //   ),
                    // ),
                    // SizedBox(height: 8),
                    // Text(
                    //   'Connect. Ship. Deliver.',
                    //   style: TextStyle(
                    //     fontSize: 14,
                    //     color: Colors.black, 
                    //   ),
                    // ),
                  ],
                ),
                
                const SizedBox(height: 32),
                
                // Spacer for visual balance
                Container(
                  width: double.infinity,
                  height: 200,
                  decoration: const BoxDecoration(),
                  child: Image.asset('assets/images/ani.png', 
                    fit: BoxFit.cover,
                  ),
                ),
                
                // Buttons Section
                const Spacer(),
                Column(
                  children: [
                    // Sign In Button
                    LoginButton(
                      hintText: "Sign in",
                      backgroundColor: AppColors.blue700,
                      textColor: AppColors.white,
                      onPressed: () {
                        setState(() {
                          _isLoginLoading = true;
                        });
                        context.pushNamed('login');
                        setState(() {
                          _isLoginLoading = false;
                        });
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
                        setState(() {
                          _isSignUpLoading = false;
                        });
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
      ),
    );
  }
}