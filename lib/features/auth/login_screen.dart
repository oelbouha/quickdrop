import 'package:quickdrop_app/core/widgets/iconTextField.dart';
import 'package:quickdrop_app/core/widgets/auth_button.dart';
import 'package:quickdrop_app/core/widgets/passwordTextField.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.forward();
    _loadSavedCredentials();
  }

  void _signInWithGoogle() async {
    if (_isGoogleLoading) return;
    setState(
      () {
        _isGoogleLoading = true;
      },
    );

    try {
      await Provider.of<UserProvider>(context, listen: false)
          .signInWithGoogle(context);
    } catch (e) {
      if (mounted) AppUtils.showDialog(context, e.toString(), AppColors.error);
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  void _handleFcmTokenSave(String userId) {
    // Run FCM token save in background
    saveFcmToken(userId).then((_) {
      print("FCM token saved successfully");
    }).catchError((error) {
      print("FCM token save failed (non-critical): $error");

      // Optional: Show a subtle notification that push notifications might not work
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Push notifications may not work properly"),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      }
    });
  }

  Future<void> saveFcmToken(String userId) async {
    try {
      print("Starting FCM token save for Android...");

      final fcm = FirebaseMessaging.instance;

      // Request permission (required for Android 13+)
      NotificationSettings settings = await fcm.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print("Notification settings: ${settings.authorizationStatus}");
      if (settings.authorizationStatus == AuthorizationStatus.denied) {
        print("User denied FCM permissions");
        return;
      }
      // Get the FCM token
      String? token;
      try {
        token = await fcm.getToken().timeout(
          const Duration(seconds: 20), // Longer timeout for Android
          onTimeout: () {
            print("FCM getToken timed out");
            return null;
          },
        );

        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .set({
          'fcmToken': token,
        }, SetOptions(merge: true));

      } catch (e) {
        print("Error getting FCM token: $e");
      }
    } catch (e) {
      print("Error requesting FCM permission: $e");
    }
  }

  void _signInUserWithEmail() async {
    if (_isEmailLoading) return;
    if (_formKey.currentState!.validate()) {
      setState(() => _isEmailLoading = true);
      try {
        await Provider.of<UserProvider>(context, listen: false)
            .signInUserWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        await saveCredentials(
            emailController.text.trim(), passwordController.text.trim());
        _handleFcmTokenSave(FirebaseAuth.instance.currentUser!.uid);
        context.go('/home');
      } catch (e) {
        print("Error signing in: $e");
        if (mounted)
          AppUtils.showDialog(context, e.toString(), AppColors.error);
      } finally {
        setState(() => _isEmailLoading = false);
      }
    }
  }

  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', password);
  }

  Future<Map<String, String>> getSavedCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final email = prefs.getString('email') ?? '';
    final password = prefs.getString('password') ?? '';
    return {'email': email, 'password': password};
  }

  void _loadSavedCredentials() async {
    final creds = await getSavedCredentials();
    setState(() {
      emailController.text = creds['email']!;
      passwordController.text = creds['password']!;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: _buildLogInScreen(),
        )),
      ),
    );
  }

  Widget _buildLogInScreen() {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child: const Text(
              'Welcome Back',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.blue700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: _fadeAnimation,
            child: const Text(
              'Please sign in to continue',
              style: TextStyle(
                fontSize: 16,
                color: AppColors.shipmentText,
              ),
            ),
          ),
          const SizedBox(height: 32),
          IconTextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Email',
            obsecureText: false,
            radius: 30,
            iconPath: "assets/icon/email.svg",
            validator: Validators.email,
          ),
          const SizedBox(height: 16),
          PasswordTextfield(
            controller: passwordController,
            validator: Validators.notEmpty,
            radius: 30,
          ),
          const SizedBox(height: 24), // Add spacing before button
          Button(
            hintText: "Sign in",
            onPressed: _signInUserWithEmail,
            isLoading: _isEmailLoading,
            radius: 60,
          ),
          Container(
            margin: const EdgeInsets.only(top: 16, bottom: 16),
            child: const Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.lessImportant,
                    thickness: 0.4,
                  ),
                ),
                SizedBox(width: 16),
                Text(
                  "or",
                  style: TextStyle(color: AppColors.shipmentText, fontSize: 12),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Divider(
                    color: AppColors.lessImportant,
                    thickness: 0.4,
                  ),
                )
              ],
            ),
          ),
          AuthButton(
            hintText: "Sign in with Google",
            onPressed: _signInWithGoogle,
            imagePath: "assets/images/google.png",
            isLoading: _isGoogleLoading,
            backgroundColor: AppColors.background,
            radius: 60,
          ),
          const SizedBox(height: 24),
          textWithLink(
            text: "Don't have an account? ",
            textLink: "sign up",
            navigatTo: '/signup',
            context: context,
          ),
          //  const Spacer(),
          // const SizedBox(height: 32),
          //   Container(
          //     width: 100,
          //     height: 4,
          //     decoration: BoxDecoration(
          //       color: Colors.black,
          //       borderRadius: BorderRadius.circular(2),
          //     ),
          //   ),
        ],
      ),
    );
  }
}
