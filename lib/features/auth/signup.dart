import 'package:quickdrop_app/core/widgets/iconTextField.dart';
import 'package:quickdrop_app/features/auth/signup_screen.dart';
import 'package:quickdrop_app/core/widgets/auth_button.dart';
import 'package:quickdrop_app/core/widgets/gestureDetector.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/statictics_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final phoneNumberController = TextEditingController();
  bool _isEmailLoading = false;
  bool _isGoogleLoading = false;

  void _signupUserWithEmail() async {
  if (_isEmailLoading) return;
  setState(() {
    _isEmailLoading = true;
  });

  final phone = phoneNumberController.text.trim();
  if (phone.isEmpty) {
    AppUtils.showError(context, "Please enter your phone number");
    setState(() {
      _isEmailLoading = false;
    });
    return;
  }

  await FirebaseAuth.instance.verifyPhoneNumber(
    phoneNumber: phone,
    verificationCompleted: (PhoneAuthCredential credential) async {
      // Auto-retrieval or instant verification
      await FirebaseAuth.instance.signInWithCredential(credential);
    },
    verificationFailed: (FirebaseAuthException e) {
      setState(() => _isEmailLoading = false);
      AppUtils.showError(context, 'Phone verification failed: ${e.message}');
    },
    codeSent: (String verificationId, int? resendToken) {
      setState(() => _isEmailLoading = false);
      context.pushNamed(
        'verify-number',
        queryParameters: {
          'phoneNumber': phone,
          'verificationId': verificationId,
        },
      );
    },
    codeAutoRetrievalTimeout: (String verificationId) {
      // Optionally handle timeout
    },
  );
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
          context.go('/home');
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showError(context, "failed to log in user $e");
          return;
        }
      }
    } on FirebaseAuthException catch (e) {
      if (mounted)
        AppUtils.showError(context, 'Google Sign-In failed: ${e.message}');
    } catch (e) {
      if (mounted)
        AppUtils.showError(context, 'An unexpected error occurred: $e');
    } finally {
      setState(() {
        _isGoogleLoading = false;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
    value: SystemUiOverlayStyle.dark, 
    child:Scaffold(
        backgroundColor: AppColors.background,
        resizeToAvoidBottomInset: false,
        // appBar: AppBar(
        //   backgroundColor: AppColors.background,
        // ),
        body: Container(
            padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
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
            child: Center(
                child: Column(
              children: [
                Expanded(
                  child: Center(
                      child: SingleChildScrollView(child: _buildLogInScreen())),
                ),
              ],
            )))));
  }

  Widget _buildLogInScreen() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Join us via phone",
          style: TextStyle(
              color: AppColors.headingText,
              fontWeight: FontWeight.w700,
              fontSize: 30),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        const Text(
          "W'll text you to confirm your phone number. ",
          style: TextStyle(
            color: AppColors.shipmentText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 6,
        ),
        PhoneNumber(controller: phoneNumberController),
        const SizedBox(
          height: 6,
        ),
        LoginButton(
          hintText: "Continue",
          onPressed: _signupUserWithEmail,
          isLoading: _isEmailLoading,
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
              "or",
              style: TextStyle(color: AppColors.shipmentText, fontSize: 12),
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
          height: 15,
        ),
        AuthButton(
          hintText: "Sign up with Google",
          onPressed: _signInWithGoogle,
          imagePath: "assets/images/google.png",
          isLoading: _isGoogleLoading,
          backgroundColor: AppColors.background,
        ),
        const SizedBox(
          height: 30,
        ),
        textWithLink(
          text: "Already have an account? ",
          textLink: "sign in",
          navigatTo: '/login',
          context: context),
      ],
    );
  }
}
