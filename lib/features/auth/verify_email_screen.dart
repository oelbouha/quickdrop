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
        backgroundColor: AppColors.blue,
        body: Padding(
            padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Email verification",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const Text(
                      "Please verify your email to continue.",
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.currentUser?.reload();
                            User? user = FirebaseAuth.instance.currentUser;

                            if (user != null && user.emailVerified) {
                              context.go('/home');
                            } else {
                              AppUtils.showError(
                                  context, "Please verify your email first.");
                            }
                          },
                          child: const Text("I've verified"),
                        ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.currentUser?.reload();
                          User? user = FirebaseAuth.instance.currentUser;
                          await user?.sendEmailVerification();
                          AppUtils.showSuccess(
                              context, "A new email has been sent.");
                        },
                        child: Text("resend link"),
                      ),
                    ]),
              ],
            ))));
  }
}
