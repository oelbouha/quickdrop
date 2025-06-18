import 'package:quickdrop_app/features/models/statictics_model.dart';
import 'package:quickdrop_app/core/widgets/auth_button.dart';
import 'package:quickdrop_app/core/widgets/gestureDetector.dart';
import 'package:quickdrop_app/core/widgets/iconTextField.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhoneScreen extends StatefulWidget {
  final String? phoneNumber;
  final String verificationId;

  const VerifyPhoneScreen({
    super.key,
    required this.phoneNumber,
    required this.verificationId,
  });

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late String _currentVerificationId;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
  }

  void verifyCode(String smsCode) async {
    setState(() => isLoading = true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _currentVerificationId,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      AppUtils.showDialog(context, widget.phoneNumber!, AppColors.error); // Can rename later
      context.pushNamed(
        'create-account',
        queryParameters: {'phoneNumber': widget.phoneNumber},
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid code. Please try again.")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void resendCode() async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Failed to resend code: ${e.message}")),
        );
      },
      codeSent: (String newVerificationId, int? resendToken) {
        setState(() {
          _currentVerificationId = newVerificationId;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Code resent.")),
        );
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cardBackground,
      appBar: AppBar(
        backgroundColor: AppColors.cardBackground,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
        child: Form(
          key: _formKey,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  "Enter Verification Code",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                const Text(
                  "Enter the verification code sent to",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.headingText,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.phoneNumber ?? 'your phone number',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.headingText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                PinCodeTextField(
                  appContext: context,
                  length: 6,
                  controller: codeController,
                  onChanged: (value) {},
                  onCompleted: (value) {
                    if (value.length == 6) verifyCode(value.trim());
                  },
                  validator: (value) {
                    if (value == null || value.trim().length != 6) {
                      return "Enter a valid 6-digit code";
                    }
                    return null;
                  },
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(8),
                    fieldHeight: 46,
                    fieldWidth: 40,
                    activeColor: Colors.blue,
                    selectedColor: AppColors.blue,
                    inactiveColor: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                Button(
                  hintText: "Continue",
                  backgroundColor: AppColors.dark,
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      verifyCode(codeController.text.trim());
                    }
                  },
                  isLoading: isLoading,
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Didn't receive the code? ",
                      style: TextStyle(
                        color: AppColors.shipmentText,
                        fontSize: 14,
                      ),
                    ),
                    GestureDetectorWidget(
                      onPressed: resendCode,
                      hintText: "Resend code",
                      color: AppColors.dark,
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
