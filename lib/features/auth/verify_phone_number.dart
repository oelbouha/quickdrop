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

import 'package:pin_code_fields/pin_code_fields.dart';

class VerifyPhoneScreen extends StatefulWidget {
  const VerifyPhoneScreen({super.key});

  @override
  _VerifyPhoneScreenState createState() => _VerifyPhoneScreenState();
}

class _VerifyPhoneScreenState extends State<VerifyPhoneScreen> {
  final codeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.cardBackground,
        appBar: AppBar(
          backgroundColor: AppColors.cardBackground,
          centerTitle: true,
        ),
        body: Padding(
            padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                      const Text("Enter Verification Code",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 20),
                      const Text(
                        "Enter the verification code sent to your phone number",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
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
                          // Trigger verifyCode(value) here
                        },
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(8),
                          fieldHeight: 46,
                          fieldWidth: 40,
                          activeColor: Colors.blue,
                          selectedColor: AppColors.blue,
                          inactiveColor: Colors.blue,
                          borderWidth: 0.5,

                        ),
                      ),
                      const SizedBox(height: 20),
                      LoginButton(
                        hintText: "Verify phone number",
                        backgroundColor: AppColors.dark,
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            // Call your verification function here
                            // verifyCode(codeController.text);
                          }
                        },
                        isLoading: false, // Set to true if loading
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          // Handle resend code
                        },
                        child: const Text(
                          "Resend Code",
                          style: TextStyle(
                            color: AppColors.blue,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                  ],
            ))));
  }
}
