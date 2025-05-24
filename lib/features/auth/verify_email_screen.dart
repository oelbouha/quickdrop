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

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.cardBackground,
        body: Padding(
            padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width:  50,
                      height: 50,
                      decoration: const BoxDecoration(
                        // shape: BoxShape.circle,
                        // color: AppColors.blue,
                        color: AppColors.requestButton,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                      ),
                      child: const Icon(
                        Icons.mail_outline,
                        color: AppColors.white,
                        size: 35,
                      ),
                    ),
                    const Text("Check your email",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const Text(
                      "We've sent a verification link to",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser?.email ?? "Your email",
                      style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: double.infinity,
                        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: AppColors.lessImportant,
                            width: AppTheme.textFieldBorderWidth),
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                      ),
                      child: const Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Next steps",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text("1. . Check your email inbox"),
                          Text("2. . Click the verification link"),
                          Text("3.  Return here and click \"I've verified\""),
                      ]
                      ),

                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    LoginButton(hintText: "I've verified my email", onPressed: () async {
                      await FirebaseAuth.instance.currentUser?.reload();
                            User? user = FirebaseAuth.instance.currentUser;

                            if (user != null && user.emailVerified) {
                              context.go('/home');
                            } else {
                              AppUtils.showError(
                                  context, "Please verify your email first.");
                            }
                    }, 
                      isLoading: false,
                      radius: 12,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                     LoginButton(hintText: "Resend verification link", onPressed: () async {
                      await FirebaseAuth.instance.currentUser?.reload();
                          User? user = FirebaseAuth.instance.currentUser;
                          await user?.sendEmailVerification();
                          AppUtils.showSuccess(
                              context, "A new email has been sent.");
                    }, 
                      isLoading: false,
                      radius: 12,
                      backgroundColor: AppColors.dark,
                    ),

                    const SizedBox(
                      height: 40,
                    ),
                    const Text("Didn't receive the email? Check your spam folder or contact support", 
                      style: TextStyle(color: AppColors.shipmentText, fontSize: 12),
                      textAlign: TextAlign.center,), 
                    const SizedBox(
                      height: 20
                    ),
                    const Text("Want to use a different email?"),
                    textWithLink(
                      text: "Sign up with a different email? ", 
                      textLink: "Change email", 
                      navigatTo: '/create-account', 
                      context: context
                    )
                   
              ],
            ))));
  }
}
