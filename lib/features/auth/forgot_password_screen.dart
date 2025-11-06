import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickdrop_app/core/widgets/login_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  bool _loading = false;

  Future<void> _resetPassword() async {
    final t = AppLocalizations.of(context)!;

    setState(() => _loading = true);
    if (_emailController.text.isEmpty) {
      AppUtils.showDialog(
        context,
        t.forgot_password_empty_email,
        AppColors.error,
      );
      setState(() => _loading = false);
      return;
    }
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(
        email: _emailController.text.trim(),
      );
      AppUtils.showDialog(
        context,
        t.forgot_password_email_sent,
        AppColors.success,
      );
    } on FirebaseAuthException catch (e) {
       if (e.code == 'too-many-requests') {
    AppUtils.showDialog(
      context,
      t.too_many_requests, 
      AppColors.error,
    );
  } else {
    AppUtils.showDialog(
      context,
      t.forgot_password_error,
      AppColors.error,
    );
  }
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.forgot_password_title),
          iconTheme: const IconThemeData(color: AppColors.dark),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              t.forgot_password_description,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            LoginTextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: t.email,
              obsecureText: false,
              radius: 8,
              iconPath: "assets/icon/email.svg",
              validator: Validators.email(context),
            ),
            const SizedBox(height: 24),
            PrimaryButton(
              hintText: t.forgot_password_send_email,
              onPressed: _resetPassword,
              isLoading: _loading,
            ),
          ],
        ),
      ),
    );
  }
}
