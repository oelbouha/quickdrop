import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:go_router/go_router.dart';

class VerifyEmailScreen extends StatefulWidget {
  final String email;
  const VerifyEmailScreen({
    super.key,
    required this.email,
  });

  @override
  _VerifyEmailScreenState createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {

  bool _isLoading = false;


  void _resendEmailVerification() async {
    final t = AppLocalizations.of(context)!;
    if (_isLoading) return;

    setState(() => _isLoading = true);

    try {
      final user = FirebaseAuth.instance.currentUser;
      // if (user != null && !user.emailVerified) {
        await user?.verifyBeforeUpdateEmail(widget.email);
        AppUtils.showDialog(
          context,
          t.verify_dialog_email_resent,
          AppColors.success,
        );
      // }
    } catch (e) {
      AppUtils.showDialog(
        context,
        t.error_sending_verification,
        AppColors.error,
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.dark,
        // backgroundColor: Theme.of(context).primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.dark),
      ),
      backgroundColor: AppColors.cardBackground,
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: AppColors.blue,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                ),
                child: const Icon(
                  Icons.mail_outline,
                  color: AppColors.white,
                  size: 35,
                ),
              ),
              Text(
                t.verify_check_email_title,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              Text(
                t.verify_sent_link_message,
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Text(
                widget.email ,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.lessImportant,
                    width: AppTheme.textFieldBorderWidth,
                  ),
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(AppTheme.cardRadius),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.verify_next_steps_title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(t.verify_step_1),
                    Text(t.verify_step_2),
                    Text(t.verify_relogin_message),
                  ],
                ),
              ),
              // const SizedBox(height: 20),
              // LoginButton(
              //   hintText: t.verify_button_verified,
              //   onPressed: () async {
              //     await FirebaseAuth.instance.currentUser?.reload();
              //     User? user = FirebaseAuth.instance.currentUser;

              //     if (user != null && user.emailVerified) {
              //       context.pop();
              //     } else {
              //       AppUtils.showDialog(
              //         context,
              //         t.verify_dialog_please_verify_first,
              //         AppColors.error,
              //       );
              //     }
              //   },
              //   isLoading: false,
              //   radius: 12,
              // ),
              const SizedBox(height: 24),
              LoginButton(
                hintText: t.verify_button_resend,
                onPressed: _resendEmailVerification,
                isLoading: _isLoading,
                radius: 12,
                backgroundColor: AppColors.dark,
              ),
              const SizedBox(height: 32),
              Text(
                t.verify_didnt_receive,
                style: const TextStyle(color: AppColors.shipmentText, fontSize: 12),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
