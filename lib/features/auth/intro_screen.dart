import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter/services.dart';

import 'package:quickdrop_app/core/widgets/auth_button.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  _IntroScreenState createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> with TickerProviderStateMixin {
  bool _isLoginLoading = false;
  bool _isSignUpLoading = false;
  bool _isGoogleLoading = false;
  
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOut),
    );
    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _signInWithGoogle() async {
    if (_isGoogleLoading) return;
    
    // Add haptic feedback
    HapticFeedback.lightImpact();
    
    setState(() {
      _isGoogleLoading = true;
    });

    try {
      await Provider.of<UserProvider>(context, listen: false)
          .signInWithGoogle(context);
    } catch (e) {
      if (mounted) AppUtils.showDialog(context, e.toString(), AppColors.error);
    } finally {
      if (mounted) {
        setState(() {
          _isGoogleLoading = false;
        });
      }
    }
  }

  void _navigateWithHaptic(String route) {
    HapticFeedback.lightImpact();
    context.pushNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
   
    return Scaffold(
        appBar: AppBar(
          
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFF8FAFC),
              Color(0xFFEFF6FF), 
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24.0),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeTransition(
                        opacity: _fadeAnimation,
                        child: Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            gradient:  LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Theme.of(context).colorScheme.primary,
                                Theme.of(context).colorScheme.tertiary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF2563EB).withOpacity(0.2),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.local_shipping_rounded,
                            color: Colors.white,
                            size: 40,
                          ),
                        ),
                      ),

                      const SizedBox(height: 48),

                      /// Enhanced Hero Text
                      Column(
                        children: [
                          RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                height: 1.2,
                              ),
                              children: [
                                 TextSpan(
                                  text: "${t.home_title_part1}\n",
                                  style: const TextStyle(color: Color(0xFF1F2937)),
                                ),
                                
                                TextSpan(
                                  text: t.home_title_part2,
                                  style: TextStyle(
                                    foreground: Paint()
                                      ..shader =  LinearGradient(
                                        colors: [  
                                          Theme.of(context).colorScheme.primary,
                                          Theme.of(context).colorScheme.tertiary,
                                        ],
                                      ).createShader(
                                         Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                                      ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          /// Value Proposition
                           Text(
                            t.intro_subtitle,
                            style:const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF4B5563),
                            ),
                          ),
                          
                          const SizedBox(height: 8),
                          
                           Text(
                            t.intro_description,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF6B7280),
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                /// Bottom Action Section
                Column(
                  children: [
                   
                   LoginButton(
                      hintText: t.login,
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.onPrimary,
                      onPressed: () {
                        context.pushNamed('login');
                      },
                      isLoading: _isLoginLoading,
                      radius: 60,
                    ),
                    const SizedBox(height: 12),
                    LoginButton(
                      hintText: t.signup,
                      onPressed: () {
                        context.pushNamed('signup');
                      },
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                      isLoading: _isSignUpLoading,
                      radius: 60,
                    ),
                  
                    
                    const SizedBox(height: 12),
                    
                    /// Google Sign In Button
                    AuthButton(
                      hintText: t.continue_with_google,
                      onPressed: _signInWithGoogle,
                      imagePath: "assets/images/google.png",
                      isLoading: _isGoogleLoading,
                      backgroundColor: AppColors.background,
                      radius: 60,
                    ),

                    const SizedBox(height: 24),

                    /// Terms Text
                     Text(
                      t.policy,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF9CA3AF),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Bottom handle bar
                    Container(
                      width: 128,
                      height: 4,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD1D5DB),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}