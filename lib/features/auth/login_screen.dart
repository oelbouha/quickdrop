import 'package:quickdrop_app/core/widgets/iconTextField.dart';
import 'package:quickdrop_app/features/auth/signup_screen.dart';
import 'package:quickdrop_app/features/auth/signup.dart';
import 'package:quickdrop_app/core/widgets/auth_button.dart';
import 'package:quickdrop_app/core/widgets/gestureDetector.dart';
import 'package:quickdrop_app/core/widgets/passwordTextField.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/statictics_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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

  Future<void> _createStatsIfNewUser(String userId) async {
    bool userExist = await doesUserExist(userId);
    if (userExist == false) {
      StatisticsModel stats = StatisticsModel(
          pendingShipments: 0,
          ongoingShipments: 0,
          completedShipments: 0,
          reviewCount: 0,
          id: userId,
          userId: userId);
      Provider.of<StatisticsProvider>(context, listen: false)
          .addStatictics(userId, stats);
    }
  }

  Future<void> setUserData(userCredential) async {
    _createStatsIfNewUser(userCredential.user.uid);
    UserData user = UserData(
      uid: userCredential.user.uid,
      email: userCredential.user!.email,
      displayName: userCredential.user!.displayName,
      photoUrl: userCredential.user!.photoURL,
      createdAt: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
    );

    // bool userExist = await doesUserExist(user.uid);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // if (userExist == false) {
    // userProvider.setUser(user);
    // userProvider.saveUserToFirestore(user);
    // } else {
    await userProvider.fetchUser(user.uid);
    // }
  }

  Future<bool> doesUserExist(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.exists;
  }

  void _signInWithGoogle() async {
    if (_isGoogleLoading) return;
    setState(
      () {
        _isGoogleLoading = true;
      },
    );

    try {
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
      );

      await googleSignIn.signOut();

      GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        AppUtils.showDialog(context, 'Google Sign-In failed', AppColors.error);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // await FirebaseService().saveUserToFirestore(userCredential.user!);
      try {
        await setUserData(userCredential);
        if (mounted) {
          // print("switching to home");
          context.go('/home');
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showDialog(context, "failed to log in user $e", AppColors.error);
          return;
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        AppUtils.showDialog(context, 'Google Sign-In failed: ${e.message}', AppColors.error);
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(context, 'An unexpected error occurred: $e', AppColors.error);
      }
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  void _signInUserWithEmail() async {
    if (_isEmailLoading) return;

    // Validate the form
    if (_formKey.currentState!.validate()) {
      setState(() => _isEmailLoading = true);
      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        UserCredential userCredential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );

        try {
          setUserData(userCredential);

          // Save credentials
          await saveCredentials(email, password);
          // print("switching to home");
          if (mounted) context.go('/home');
        } catch (e) {
          if (mounted) {
            AppUtils.showDialog(context, "failed to log in user $e", AppColors.error);
            return;
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'user-not-found':
            errorMessage = AppTheme.loginErrorMessage;
            break;
          case 'wrong-password':
            errorMessage = AppTheme.loginErrorMessage;
            break;
          case 'invalid-email':
            errorMessage = 'Invalid email format.';
            break;
          case 'invalid-credential':
            errorMessage = AppTheme.loginErrorMessage;
            break;
          default:
            errorMessage = e.message ?? 'An error occurred during login.';
        }
        AppUtils.showDialog(context, errorMessage, AppColors.error);
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: FadeTransition(
        opacity: _fadeAnimation,
        child: Scaffold(
            backgroundColor: AppColors.background,
            resizeToAvoidBottomInset: false,
            body: Container(
                padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
                decoration: const BoxDecoration(
                  color: AppColors.white,
                  // gradient: LinearGradient(
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  //   colors: [
                  //     AppColors.backgroundStart,
                  //     AppColors.backgroundMiddle,
                  //     AppColors.backgroundEnd,
                  //   ],
                  //   stops: [0.0, 0.5, 1.0],
                  // ),
                ),
                child: Center(
                    child: Column(
                  children: [
                    Expanded(
                      child: Center(
                          child: SingleChildScrollView(
                              child: _buildLogInScreen())),
                    ),
                  ],
                ))))));
  }

  Widget _buildLogInScreen() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
          child: Container(
            margin: const EdgeInsets.only(bottom: 40),
            child:  Column(
              children: [
                
              // Image.asset(
              //   'assets/images/quickdrop.png',
              //   height: 180,
              //   fit: BoxFit.cover,
              // ),
                //  SizedBox(height: 16),
                const Text(
                  "Welcome back",
                  style: TextStyle(
                    color: AppColors.dark,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                 const Text(
                  "Sign in to continue",
                  style: TextStyle(
                    color: AppColors.shipmentText,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
            // const SizedBox(
            //   height: 25,
            // ),
            AuthButton(
              hintText: "Sign in with Google",
              onPressed: _signInWithGoogle,
              imagePath: "assets/images/google.png",
              isLoading: _isGoogleLoading,
              backgroundColor: AppColors.background,
            ),
            const SizedBox(
              height: 15,
            ),
            const Row(
              children: [
                Expanded(
                  child: Divider(
                    color: AppColors.lessImportant,
                    thickness: 0.4,
                  ),
                ),
                SizedBox(
                  width: 12,
                ),
                Text(
                  "or",
                  style: TextStyle(color: AppColors.shipmentText, fontSize: 12),
                ),
                SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Divider(
                    color: AppColors.lessImportant,
                    thickness: 0.4,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 24,
            ),
// Replace your current text fields with more polished versions
Container(
  margin: const EdgeInsets.only(bottom: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Email",
        style: TextStyle(
          color: AppColors.shipmentText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lessImportant,
            width: 1,
          ),
        ),
        child: IconTextField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          hintText: 'Enter your email',
          obsecureText: false,
          iconPath: "assets/icon/email.svg",
          validator: Validators.email,
        ),
      ),
    ],
  ),
),
            // const SizedBox(height: 15),

        Container(
  margin: const EdgeInsets.only(bottom: 20),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        "Password",
        style: TextStyle(
          color: AppColors.shipmentText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.lessImportant,
            width: 1,
          ),
        ),
        child:   PasswordTextfield(
              controller: passwordController,
              validator: Validators.notEmpty,
            ),
      ),
    ],
  ),
),    
            // const Text(
            //   "Password",
            //   style: const TextStyle(
            //     color: AppColors.shipmentText,
            //     fontSize: 16,
            //     fontWeight: FontWeight.w600,
            //   ),
            //   textAlign: TextAlign.start,
            // ),
            // PasswordTextfield(
            //   controller: passwordController,
            //   validator: Validators.notEmpty,
            // ),
            // const SizedBox(
            //   height: 25,
            // ),
            Button(
              hintText: "Sign in",
              onPressed: _signInUserWithEmail,
              isLoading: _isEmailLoading,
            ),
            // const SizedBox(
            //   height: 10,
            // ),
            textWithLink(
                text: "Don't have an account? ",
                textLink: "sign up",
                navigatTo: '/signup',
                context: context),
          ],
        ));
  }
}
