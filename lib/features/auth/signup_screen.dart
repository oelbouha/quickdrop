import 'package:quickdrop_app/features/models/statictics_model.dart';
import 'package:quickdrop_app/core/widgets/gestureDetector.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:quickdrop_app/core/widgets/passwordTextField.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';

class SignUpScreen extends StatefulWidget {
  final String? phoneNumber;
  const SignUpScreen({
    super.key,
    this.phoneNumber,
  });

  @override
  State<SignUpScreen> createState() => _SingupPageState();
}

class _SingupPageState extends State<SignUpScreen> {
  final phoneNumberController = TextEditingController();
  final lastNameController = TextEditingController();
  final firstNameController = TextEditingController();
  final passwordController = TextEditingController();
  final emailController = TextEditingController();
  final birthdayController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  bool _isEmailLoading = false;

  Future<void> _createStatsIfNewUser(String userId) async {
    try {
      bool userExist = await doesUserExist(userId);
      if (userExist == false) {
        // print("user does not exist");
        StatisticsModel stats = StatisticsModel(
            pendingShipments: 0,
            ongoingShipments: 0,
            completedShipments: 0,
            reviewCount: 0,
            id: userId,
            userId: userId);
        if (!mounted) return;
        Provider.of<StatisticsProvider>(context, listen: false)
            .addStatictics(userId, stats);
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(context, "failed to create statistics", AppColors.error);
      }
      rethrow;
    }
  }

  Future<bool> doesUserExist(String uid) async {
    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return userDoc.exists;
  }

  void _singUpUserWithEmail() async {
    if (_formKey.currentState!.validate()) {
      if (_isEmailLoading) return;

      setState(() {
        _isEmailLoading = true;
      });

      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // await FirebaseService().saveUserToFirestore(userCredential.user!);

        // await FirebaseAuth.instance.currentUser
        //     ?.updateDisplayName(fullNameController.text.trim());
        // Send email verification
        // await userCredential.user?.sendEmailVerification();

        UserData user = UserData(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          displayName: "${firstNameController.text} ${lastNameController.text}",
          phoneNumber: widget.phoneNumber,
          photoUrl: null,
          createdAt: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
        );
        try {
          await _createStatsIfNewUser(userCredential.user!.uid);

          if (!mounted) return;

          final userProvider =
              Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(user);
          await userProvider.saveUserToFirestore(user);

          if (mounted) {
            context.go('/home');
          }
        } catch (e) {
          if (mounted) {
            AppUtils.showDialog(context, "failed to signup user $e", AppColors.error);
            return;
          }
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage;
        switch (e.code) {
          case 'invalid-email':
            errorMessage = 'Invalid email format.';
            break;
          default:
            errorMessage = e.message ?? 'An error occurred during singup.';
        }
        if (mounted) AppUtils.showDialog(context, errorMessage, AppColors.error);
      } finally {
        setState(() {
          _isEmailLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.cardBackground,
        appBar: AppBar(
          backgroundColor: AppColors.cardBackground,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Colors.black, // Set the arrow back color to black
          ),
          systemOverlayStyle:
              SystemUiOverlayStyle.dark, // Ensures status bar icons are dark
        ),
        resizeToAvoidBottomInset: false,
        body: Padding(
            padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
            child: Center(
                child: Column(
              children: [
                Expanded(
                    child: Center(
                  child: SingleChildScrollView(child: _buildSignUpScreen()),
                )),
              ],
            ))));
  }

  Widget _buildSignUpScreen() {
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Finish signing up",
              style: TextStyle(
                  color: AppColors.headingText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFieldWithHeader(
              controller: firstNameController,
              headerText: 'Full Name',
              hintText: 'First name on ID',
              obsecureText: false,
              iconPath: "assets/icon/user.svg",
              isRequired: false,
              validator: Validators.name,
            ),
            const SizedBox(height: 8),
            TextFieldWithoutHeader(
              controller: lastNameController,
              hintText: 'Last name on ID',
              obsecureText: false,
              validator: Validators.name,
            ),
            const SizedBox(height: 6),
            
             buildInfoCard(
              icon: Icons.info_outline,
              title: "Name Tip",
              message: "Make sure this matches the name on your government ID or passport.",
              color: Colors.blue,
            ),
            // TipWidget(message: "Make sure this matches the name on your government ID or passport."),
            const SizedBox(height: 15),
            TextFieldWithHeader(
              controller: birthdayController,
              hintText: 'Birthday',
              isRequired: false,
              headerText: 'Date of Birth',
              obsecureText: false,
              iconPath: "assets/icon/email.svg",
              keyboardType: TextInputType.datetime,
              validator: Validators.notEmpty,
            ),
            const SizedBox(height: 8),
             buildInfoCard(
              icon: Icons.info_outline,
              title: "Age Tip",
              message: "To Sign up, you must be at least 18 years old. other peaaple  who use quickdrop won't see your birthday.",
              color: Colors.blue,
            ),
            const SizedBox(height: 15),
            TextFieldWithHeader(
              controller: emailController,
              hintText: 'example@gmail.com',
              isRequired: false,
              headerText: 'Email',
              obsecureText: false,
              iconPath: "assets/icon/email.svg",
              validator: Validators.email,
            ),
            const SizedBox(height: 8),
            PasswordTextfield(
              controller: passwordController,
              validator: Validators.notEmpty,
              showPrefix: false,
            ),
            const SizedBox(
              height: 20,
            ),
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.shipmentText,
                ),
                children: [
                  const TextSpan(text: "By clicking "),
                  const TextSpan(
                    text: "Agree and Continue, ",
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),
                  const TextSpan(text: "I agree to QuickDrop's "),
                  TextSpan(
                    text: "Terms of Service,",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.dark,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.push('/terms-of-service');
                      },
                  ),
                  const TextSpan(
                      text: " and acknowledge that I have read the "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColors.dark,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.push('/privacy-policy');
                      },
                  ),
                  const TextSpan(text: "."),
                ],
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(
              height: 20,
            ),
            LoginButton(
                hintText: "Agree and Continue",
                backgroundColor: AppColors.dark,
                onPressed: _singUpUserWithEmail,
                isLoading: _isEmailLoading),
            const SizedBox(
              height: 30,
            ),
          ],
        ));
  }
}
