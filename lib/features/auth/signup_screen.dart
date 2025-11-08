import 'package:provider/provider.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:go_router/go_router.dart';
import 'package:quickdrop_app/core/widgets/password_text_field.dart';
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
  // final birthdayController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isEmailLoading = false;

  void _singUpUserWithEmail() async {
    if (_formKey.currentState!.validate()) {
      if (_isEmailLoading) return;
      setState(() {
        _isEmailLoading = true;
      });
      try {
        await Provider.of<UserProvider>(context, listen: false)
        .singUpUserWithEmail(
            emailController.text.trim(),
            passwordController.text.trim(),
            firstNameController.text.trim(),
            lastNameController.text.trim(),
            widget.phoneNumber ?? phoneNumberController.text.trim(),
            context
        );

        FcmHandler.handleFcmTokenSave(FirebaseAuth.instance.currentUser!.uid, context);
        if (mounted) {
          context.go('/home');
        }
      }  catch (e) {
        if (e.toString().contains('email-already-in-use')) {
          if (mounted) {
            AppUtils.showDialog(
                context, AppLocalizations.of(context)!.email_already_in_use, AppColors.error);
          }
        } else if (e.toString().contains('invalid-email')) {
          if (mounted) {
            AppUtils.showDialog(
                context, AppLocalizations.of(context)!.invalid_email, AppColors.error);
          }
        } else if (e.toString().contains('network-request-failed')) {
          if (mounted) {
            AppUtils.showDialog(context, AppLocalizations.of(context)!.network_error, AppColors.error);
          }
        } else {
          // Handle other errors
          if (mounted) {
            AppUtils.showDialog(
                context, AppLocalizations.of(context)!.error_login, AppColors.error);
          }
        }
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
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
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
    final t = AppLocalizations.of(context)!;
    return Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Text(
              t.signup_title,
              style:const TextStyle(
                  color: AppColors.headingText,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 24,
            ),
            AppTextField(
              controller: firstNameController,
              label: t.full_name,
              hintText: t.first_name,
              obsecureText: false,
              iconPath: "assets/icon/user.svg",
              isRequired: false,
              validator: Validators.name(context),
            ),
            const SizedBox(height: 8),
            AppTextField(
              controller: lastNameController,
              hintText: t.last_name,
              displayLabel: false,
              iconPath: "assets/icon/user.svg",
              isRequired: false,
              validator: Validators.name(context),
            ),
            const SizedBox(height: 8),
            
             StatusCard(
              icon: Icons.info_outline,
              title: t.important_note,
              message: t.signup_note,
              color: Colors.blue,
            ),
            // TipWidget(message: "Make sure this matches the name on your government ID or passport."),
            // const SizedBox(height: 15),
            // AppTextField(
            //   controller: birthdayController,
            //   hintText: 'Birthday',
            //   isRequired: false,
            //   label: 'Date of Birth',
            //   obsecureText: false,
            //   iconPath: "assets/icon/email.svg",
            //   keyboardType: TextInputType.datetime,
            //   validator: Validators.notEmpty,
            // ),
            // const SizedBox(height: 8),
            //  buildInfoCard(
            //   icon: Icons.info_outline,
            //   title: "Age Tip",
            //   message: "To Sign up, you must be at least 18 years old. other peaaple  who use quickdrop won't see your birthday.",
            //   color: Colors.blue,
            // ),
            const SizedBox(height: 24),
            AppTextField(
              controller: emailController,
              hintText: 'example@gmail.com',
              isRequired: false,
              label: t.email,
              obsecureText: false,
              iconPath: "assets/icon/email.svg",
              validator: Validators.email(context),
            ),
            const SizedBox(height: 8),
            PasswordTextfield(
              controller: passwordController,
              validator: Validators.notEmpty(context),
              showPrefix: true,
            ),
            const SizedBox(
              height: 24,
            ),
            Text.rich(
              TextSpan(
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.shipmentText,
                ),
                children: [
                   TextSpan(text: t.by_clicking),
                   TextSpan(
                    text: t.continue_action,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColors.dark,
                    ),
                  ),
                   TextSpan(text: t.agree_to_quickdrop),
                  TextSpan(
                    text: t.terms_of_service,
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
                   TextSpan(
                      text: t.acknowledge_read),
                  TextSpan(
                    text: t.privacy_policy,
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
              height: 24,
            ),
            PrimaryButton(
                hintText: t.cntinue,
                radius: 30  ,
                backgroundColor: AppColors.dark,
                onPressed: _singUpUserWithEmail,
                isLoading: _isEmailLoading),
            const SizedBox(
              height: 24,
            ),
          ],
        ));
  }


}
