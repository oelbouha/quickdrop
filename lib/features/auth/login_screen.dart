import 'package:quickdrop_app/core/widgets/iconTextField.dart';
import 'package:quickdrop_app/features/auth/signup_screen.dart';
import 'package:quickdrop_app/features/auth/signup.dart';
import 'package:quickdrop_app/core/widgets/auth_button.dart';
import 'package:quickdrop_app/core/widgets/gestureDetector.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/statictics_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  // final UserData? _usr;

  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;

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

    bool userExist = await doesUserExist(user.uid);
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (userExist == false) {
      userProvider.setUser(user);
      userProvider.saveUserToFirestore(user);
    } else {
      await userProvider.fetchUser(user.uid);
    }
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
        AppUtils.showError(context, 'Google Sign-In failed');
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
          AppUtils.showError(context, "failed to log in user $e");
          return;
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        AppUtils.showError(context, 'Google Sign-In failed: ${e.message}');
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showError(context, 'An unexpected error occurred: $e');
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
          if (mounted) context.go('/home');
        } catch (e) {
          if (mounted) {
            AppUtils.showError(context, "failed to log in user $e");
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
        AppUtils.showError(context, errorMessage);
      } finally {
        setState(() => _isEmailLoading = false);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.cardBackground,
        body: Padding(
            padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
            child: Center(
                child: Column(
              children: [
                Expanded(
                  child: Center(
                      child: SingleChildScrollView(child: _buildLogInScreen())),
                ),
              ],
            ))));
  }

  Widget _buildLogInScreen() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // const Text(
            //   "QuickDrop",
            //   style: TextStyle(
            //       color: AppColors.blue,
            //       fontSize: 30,
            //       fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            const Text(
              "Sign in",
              style: TextStyle(
                  color: AppColors.dark,
                  fontSize: 24,
                  fontWeight: FontWeight.bold
              ),
              textAlign: TextAlign.start,
            ),
             const SizedBox(
              height: 25,
            ),
            AuthButton(
              hintText: "Sign in with Google",
              onPressed: _signInWithGoogle,
              imagePath: "assets/images/google.png",
              isLoading: _isGoogleLoading,
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
                  width: 8,
                ),
                Text(
                  "or sign in with email",
                  style:
                      TextStyle(color: AppColors.shipmentText, fontSize: 12),
                ),
                SizedBox(
                  width: 8,
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
              height: 30,
            ),

            TextFieldWithHeader(
                controller: emailController,
                hintText: 'Email',
                obsecureText: false,
                iconPath: "assets/icon/email.svg",
                isRequired: false,
                validator: Validators.email),
            const SizedBox(height: 25),
            TextFieldWithHeader(
              controller: passwordController,
              hintText: 'Password',
              isRequired: false,
              obsecureText: true,
              iconPath: "assets/icon/lock.svg",
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 25,
            ),
            LoginButton(
              hintText: "Sign in",
              onPressed: _signInUserWithEmail,
              isLoading: _isEmailLoading,
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't have an account?",
                  style:  TextStyle(
                      color: AppColors.shipmentText, fontSize: 14),
                ),
                // GestureDetectorWidget(
                //   onPressed: () => {},
                //   hintText: "Don't have an account? ",
                // ),
                GestureDetectorWidget(
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Signup()),
                    )
                  },
                  hintText: "Sign up",
                )
              ],
            ),
           
          ],
        ));
  }
}
