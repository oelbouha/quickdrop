import 'dart:async';

import 'package:quickdrop_app/core/widgets/gesture_detector.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:go_router/go_router.dart';

import 'package:flutter/services.dart';
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

  int maxCodeSend = 1;
  int _timeLeft = 60;
  bool _canSendCode = false;
  bool maxRetryTimeOutEnd = false;

  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _currentVerificationId = widget.verificationId;
    startTimer();
  }

  void startTimer() {
    setState(() {
      _timeLeft = 60;
      _canSendCode = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft == 0) {
        setState(() {
          _canSendCode = true;
        });
        timer.cancel();
      } else {
        setState(() {
          _timeLeft--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void verifyCode(String smsCode) async {
    final t = AppLocalizations.of(context)!;
    setState(() => isLoading = true);
    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _currentVerificationId,
        smsCode: smsCode,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      context.pushNamed(
        'create-account',
        queryParameters: {'phoneNumber': widget.phoneNumber},
      );
    } catch (e) {
      AppUtils.showDialog(
          context, t.invalid_code_error, AppColors.error);
    } finally {
      setState(() => isLoading = false);
    }
  }

  void resendCode() async {
    final t = AppLocalizations.of(context)!;
    if (_canSendCode == false) {
      AppUtils.showDialog(context, t.please_wait, AppColors.error);
      return;
    }
    if (maxCodeSend == 3) {
      AppUtils.showDialog(
          context, t.max_retries_reached, AppColors.error);
      if (maxRetryTimeOutEnd) return;
      maxRetryTimeOutEnd = true;
      Future.delayed(const Duration(seconds: 10000), () {
        maxCodeSend = 1;
        maxRetryTimeOutEnd = false;
      });
      return;
    }
    ++maxCodeSend;
    startTimer();
    // return;
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: widget.phoneNumber!,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${t.failed_to_resend_code} ${e.message}")),
        );
      },
      codeSent: (String newVerificationId, int? resendToken) {
        setState(() {
          _currentVerificationId = newVerificationId;
        });

        AppUtils.showDialog(
            context, t.code_sent_success, AppColors.blue700);
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                Text(
                  t.enter_verification_code,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  t.verification_code_sent_to,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.headingText,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.phoneNumber ?? t.your_phone_number,
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
                      return t.enter_valid_code;
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
                  hintText: t.cntinue,
                  radius: 30,
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
                    Text(
                      _canSendCode
                          ? t.didnt_receive_code
                          : "${t.resend_code_in} $_timeLeft ${t.seconds}",
                      style: const TextStyle(
                        color: AppColors.shipmentText,
                        fontSize: 14,
                      ),
                    ),
                    if (_canSendCode)
                      GestureDetectorWidget(
                        onPressed: resendCode,
                        hintText: t.resend_code,
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