import 'package:quickdrop_app/features/models/statictics_model.dart';
import 'package:quickdrop_app/core/widgets/gestureDetector.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  final String ? phoneNumber;
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
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

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
  
 void _singUpUserWithEmail() async {
    if (_formKey.currentState!.validate()) {
      if (_isEmailLoading) return;

      setState(() {
        _isEmailLoading = true;
      });

      try {
        final email = emailController.text.trim();
        final password = passwordController.text.trim();
        if (passwordController.text != confirmPasswordController.text) {
          AppUtils.showError(context, "passwords does not match");
          return;
        }

        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        // await FirebaseService().saveUserToFirestore(userCredential.user!);

        // await FirebaseAuth.instance.currentUser
        //     ?.updateDisplayName(fullNameController.text.trim());
        // Send email verification
        await userCredential.user?.sendEmailVerification();

        UserData user = UserData(
          uid: userCredential.user!.uid,
          email: userCredential.user!.email,
          firstName: firstNameController.text,
          lastName: lastNameController.text,
          displayName: "${firstNameController.text} ${lastNameController.text}",
          phoneNumber: phoneNumberController.text,
          photoUrl: null,
          createdAt: DateFormat('dd/MM/yyyy').format(DateTime.now()).toString(),
        );
        try {
          _createStatsIfNewUser(user.uid);
          // bool userExist = await doesUserExist(user.uid);
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          userProvider.setUser(user);
          userProvider.saveUserToFirestore(user);
          if (mounted) {
            context.go('/verify-email');
          }
        } catch (e) {
          if (mounted) {
            AppUtils.showError(context, "failed to log in user $e");
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
        if (mounted) AppUtils.showError(context, errorMessage);
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
            // const Text(
            //   "Sing up",
            //   style: TextStyle(
            //       color: AppColors.headingText,
            //       fontSize: 24,
            //       fontWeight: FontWeight.bold),
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
          Row(
            children: [
              Expanded(
                child: TextFieldWithHeader(
                  controller: firstNameController,
                  hintText: 'First Name',
                  obsecureText: false,
                  iconPath: "assets/icon/user.svg",
                  validator: Validators.name,
                ),
              ),
              const SizedBox(width: 10),
            Expanded(
              child: TextFieldWithHeader(
                controller: lastNameController,
                hintText: 'Last Name',
                obsecureText: false,
                iconPath: "assets/icon/user.svg",
                validator: Validators.name,
              ),
            ),
          ],
        ),
            const SizedBox(height: 8),
            TextFieldWithHeader(
              controller: emailController,
              hintText: 'Email',
              obsecureText: false,
              iconPath: "assets/icon/email.svg",
              validator: Validators.email,
            ),
            const SizedBox(height: 8),
            TextFieldWithHeader(
              controller: passwordController,
              hintText: 'Password',
              obsecureText: true,
              iconPath: "assets/icon/lock.svg",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field cannot be empty';
                }
                if (confirmPasswordController.text.trim() !=
                    passwordController.text.trim()) {
                  return 'passwords does not match';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 8,
            ),
            TextFieldWithHeader(
              controller: confirmPasswordController,
              hintText: 'Confirm Password',
              obsecureText: true,
              iconPath: "assets/icon/lock.svg",
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'This field cannot be empty';
                }
                if (confirmPasswordController.text.trim() !=
                    passwordController.text.trim()) {
                  return 'passwords does not match';
                }
                return null;
              },
            ),
            const SizedBox(
              height: 25,
            ),
            LoginButton(
                hintText: "Create Account",
                onPressed: _singUpUserWithEmail,
                isLoading: _isEmailLoading),
            const SizedBox(
              height: 30,
            ),
            textWithLink(
              text: "Already have an account? ", 
              textLink: "sign in", 
              navigatTo: '/login', 
              context: context
            ),
          ],
        ));
  }
}
