import 'package:quickdrop_app/core/widgets/login_text_field.dart';
import 'package:quickdrop_app/core/widgets/auth_button.dart';
import 'package:quickdrop_app/core/widgets/password_text_field.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}


class FcmHandler {
  static void handleFcmTokenSave(String userId, BuildContext context) {
    // Run FCM token save in background
    saveFcmToken(userId).then((_) {
      print("FCM token saved successfully");
    }).catchError((error) {
      
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Push notifications may not work properly"),
            duration: Duration(seconds: 3),
            backgroundColor: Colors.orange,
          ),
        );
      
    });
  }

  static Future<void> saveFcmToken(String userId) async {
    try {
      print("Starting FCM token save for Android...");

      final fcm = FirebaseMessaging.instance;

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

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
          'fcmToken': token,
        }, SetOptions(merge: true));
      } catch (e) {
        print("Error getting FCM token: $e");
      }
    } catch (e) {
      print("Error requesting FCM permission: $e");
    }
  }
 

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

      FcmHandler.handleFcmTokenSave(FirebaseAuth.instance.currentUser!.uid, context);
    } catch (e) {
      print("error login $e");
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

        await FirebaseFirestore.instance.collection('users').doc(userId).set({
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
    final t = AppLocalizations.of(context)!;
    if (_formKey.currentState!.validate()) {
      setState(() => _isEmailLoading = true);
      try {
        await Provider.of<UserProvider>(context, listen: false)
            .signInUserWithEmail(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
        // await saveCredentials(
        //     emailController.text.trim(), passwordController.text.trim());
        FcmHandler.handleFcmTokenSave(FirebaseAuth.instance.currentUser!.uid, context);
        UserData user = await Provider.of<UserProvider>(context, listen: false)
            .fetchUserData(FirebaseAuth.instance.currentUser!.uid);
        Provider.of<UserProvider>(context, listen: false).setUser(user);
        // print("Signed in successfully");

        await AuthService.setLoggedIn(true);
        // print("user :: ${FirebaseAuth.instance.currentUser}");
        context.go('/home');
      } catch (e) {
        final message = e.toString();
        if (message.contains('user-not-found')) {
          if (mounted) {
            AppUtils.showDialog(
              context,
              t.user_not_found,
              AppColors.error,
            );
          }
        } else if (message.contains('email-already-in-use')) {
          if (mounted) {
            AppUtils.showDialog(
              context,
              t.email_already_in_use,
              AppColors.error,
            );
          }
        } else if (message.contains('invalid-email') ||
            message.contains('wrong-password')) {
          if (mounted) {
            AppUtils.showDialog(
              context,
              t.invalid_email,
              AppColors.error,
            );
          }
        } else if (message.contains('network-request-failed')) {
          if (mounted) {
            AppUtils.showDialog(context, t.network_error, AppColors.error);
          }
        }
        else {
          if (mounted) {
            AppUtils.showDialog(context, t.error_login, AppColors.error);
          }
        }
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
       appBar: AppBar(
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
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
            child: Center(
                child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: _buildLogInScreen(),
            )),
          ),
        ));
  }

  Widget _buildLogInScreen() {

    final t = AppLocalizations.of(context)!;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FadeTransition(
            opacity: _fadeAnimation,
            child:  Text(
              t.welcome,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.blue700,
              ),
            ),
          ),
          const SizedBox(height: 16),
          FadeTransition(
            opacity: _fadeAnimation,
            child:  Text(
              t.login_title,
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.shipmentText,
              ),
            ),
          ),
          const SizedBox(height: 24),
          LoginTextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: t.email,
            obsecureText: false,
            radius: 60,
            iconPath: "assets/icon/email.svg",
            validator: Validators.email(context),
          ),
          const SizedBox(height: 16),
          PasswordTextfield(
            controller: passwordController,
            validator: Validators.notEmpty(context),
            radius: 60,
          ),
          const SizedBox(height: 24),
          PrimaryButton(
            hintText: t.login,
            onPressed: _signInUserWithEmail,
            isLoading: _isEmailLoading,
            radius: 60,
          ),
          Container(
            margin: const EdgeInsets.only(top: 24, bottom: 24),
            child:  Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: AppColors.lessImportant,
                    thickness: 0.4,
                  ),
                ),
                const SizedBox(width: 16),
                Text(
                  t.or,
                  style: TextStyle(color: AppColors.shipmentText, fontSize: 12),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Divider(
                    color: AppColors.lessImportant,
                    thickness: 0.4,
                  ),
                )
              ],
            ),
          ),
          AuthButton(
            hintText: t.continue_with_google,
            onPressed: _signInWithGoogle,
            imagePath: "assets/images/google.png",
            isLoading: _isGoogleLoading,
            backgroundColor: AppColors.background,
            radius: 60,
          ),
          const SizedBox(height: 24),
          
           TextWithLinkButton(
            text: "",
            textLink: t.forgot_password,
            navigatTo: '/forgot-password',
            context: context,
            push: true,
          ),
          const SizedBox(height: 16),
          TextWithLinkButton(
            text: t.dont_have_accout,
            textLink: t.signup,
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
