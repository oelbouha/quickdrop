import 'package:quickdrop_app/core/widgets/login_text_field.dart';
import 'package:quickdrop_app/features/auth/signup_screen.dart';
import 'package:quickdrop_app/core/widgets/auth_button.dart';
import 'package:quickdrop_app/core/widgets/gesture_detector.dart';
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

  void _signupUserWithPhoneNumber() async {
    final t = AppLocalizations.of(context)!;
    if (_isEmailLoading) return;
    setState(() {
      _isEmailLoading = true;
    });

    final phone = phoneNumberController.text.trim();
    if (phone.isEmpty) {
      AppUtils.showDialog(
          context, t.missing_phone_number, AppColors.error);
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

        String errorMessage;
        switch (e.code) {
          case 'invalid-phone-number':
            errorMessage = t.invalid_phone_number;
            break;
          case 'too-many-requests':
            errorMessage = t.too_many_requests;
            break;
          case 'quota-exceeded':
            errorMessage = t.quota_exceeded;
            break;
          case 'missing-phone-number':
            errorMessage = t.missing_phone_number;
            break;
          default:
            errorMessage = t.error_login;
        }

        AppUtils.showDialog(context, errorMessage, AppColors.error);
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
      if (e.toString().contains('network-request-failed')) {
        if (mounted) {
          AppUtils.showDialog(context,
              AppLocalizations.of(context)!.network_error, AppColors.error);
        }
      } else {
        // Handle other errors
        if (mounted) {
          AppUtils.showDialog(context,
              AppLocalizations.of(context)!.error_login, AppColors.error);
        }
      }
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
        child: Scaffold(
            backgroundColor: AppColors.background,
            resizeToAvoidBottomInset: false,
            // appBar: AppBar(
            //   backgroundColor: AppColors.background,
            // ),
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
                )))));
  }

  Widget _buildLogInScreen() {
    final t = AppLocalizations.of(context)!;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.signup_phone_title,
          style: const TextStyle(
              color: AppColors.headingText,
              fontWeight: FontWeight.w700,
              fontSize: 30),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          t.enter_phone_number_msg,
          style: const TextStyle(
            color: AppColors.shipmentText,
            fontWeight: FontWeight.w400,
            fontSize: 14,
          ),
          textAlign: TextAlign.start,
        ),
        const SizedBox(
          height: 8,
        ),
        PhoneNumberInput(controller: phoneNumberController),
        const SizedBox(
          height: 24,
        ),
        PrimaryButton(
          hintText: t.cntinue,
          onPressed: _signupUserWithPhoneNumber,
          isLoading: _isEmailLoading,
          radius: 30,
        ),
        const SizedBox(
          height: 24,
        ),
        Row(
          children: [
            const Expanded(
              child: Divider(
                color: AppColors.lessImportant,
                thickness: 0.4,
              ),
            ),
            const SizedBox(
              width: 8,
            ),
            Text(
              t.or,
              style: TextStyle(color: AppColors.shipmentText, fontSize: 12),
            ),
            const SizedBox(
              width: 8,
            ),
            const Expanded(
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
        AuthButton(
          hintText: t.continue_with_google,
          onPressed: _signInWithGoogle,
          imagePath: "assets/images/google.png",
          isLoading: _isGoogleLoading,
          backgroundColor: AppColors.background,
          radius: 30,
        ),
        const SizedBox(
          height: 24,
        ),
        TextWithLinkButton(
            text: t.already_have_account,
            textLink: t.login,
            navigatTo: '/login',
            context: context),
      ],
    );
  }
}
