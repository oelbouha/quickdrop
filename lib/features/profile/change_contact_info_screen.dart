

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/core/widgets/profile_image.dart';
import 'package:quickdrop_app/features/profile/settings_card.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class ChangeContactInfoScreen extends StatefulWidget {
  const ChangeContactInfoScreen({Key? key}) : super(key: key);

  @override
  State<ChangeContactInfoScreen> createState() => ChangeContactInfoScreenState();
}

class ChangeContactInfoScreenState extends State<ChangeContactInfoScreen> {
  bool _isLoading = false;
  UserData? user;

  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

 @override
  void initState() {
    super.initState();

    user = Provider.of<UserProvider>(context, listen: false).user;
    _initializeFields();

  }

  void _initializeFields() {
       emailController.text = user?.email ?? "";
    phoneNumberController.text = user?.phoneNumber ?? "";
  }

  @override
  void dispose() {
    emailController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

Future<void> updateInfo() async {
  final t = AppLocalizations.of(context)!;
  if (_isLoading) return;

  final confirmed = await ConfirmationDialog.show(
    context: context,
    message: t.save_changes_message,
    header: t.save_changes,
    buttonHintText: t.save_button_text,
    buttonColor: AppColors.blue700,
    iconColor: AppColors.blue700,
    iconData: Icons.save,
  );

  if (!confirmed) return;

  setState(() => _isLoading = true);

  try {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final currentUser = FirebaseAuth.instance.currentUser;
    final newEmail = emailController.text.trim();

    if (currentUser == null) throw Exception("User not logged in");


    if (currentUser.email != newEmail) {
      // This sends a verification email to the new address
      await currentUser.verifyBeforeUpdateEmail(newEmail);
      await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .update({'email': newEmail});

      if (mounted) {
        AppUtils.showDialog(context, t.verification_email_sent, AppColors.success);
        context.push("/verify-email?email=$newEmail");
      }
    } else {
      AppUtils.showDialog(context, t.no_changes_detected, AppColors.warning);
    }

  } on FirebaseAuthException catch (e) {
    String message = t.update_error_message;

    if (e.code == 'requires-recent-login') {
      message = t.reauth_required_message;
    } else if (e.code == 'invalid-email') {
      message = t.invalid_email_message;
    } else if (e.code == 'email-already-in-use') {
      message = t.email_in_use_message;
    }

    AppUtils.showDialog(context, message, AppColors.error);
  } catch (e) {
    AppUtils.showDialog(context, "update_error_message $e", AppColors.error);
  } finally {
    if (mounted) setState(() => _isLoading = false);
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context)!.security_profile_settings_title,
          style: const TextStyle(
            color: AppColors.appBarText,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoading
    ? loadingAnimation()
    : SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
        child: _buildUpdateScreen(),
      ),
    );
  }



  Widget _buildHeaderSection() {

    final t = AppLocalizations.of(context)!;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue.withOpacity(0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.person_outline,
                  color: AppColors.blue,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                     Text(
                      t.update_profile,
                      style:const TextStyle(
                        color: AppColors.headingText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(t.update_profile_subtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }





 Widget _buildUpdateScreen() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 32),
          _buildContactInfoSection(),
          const SizedBox(height: 24),
          SaveButton(
            isLoading: _isLoading,
            onPressed: updateInfo,
          ),
        ],
      ),
    );
  }




  Widget _buildContactInfoSection() {
    final t = AppLocalizations.of(context)!;
    return buildSection(
      title: t.contact_information,
      icon: Icons.contact_mail_outlined,
      children: [
        TextFieldWithHeader(
          controller: emailController,
          headerText: t.email_address,
          hintText: t.email_hint,
         iconPath: "assets/icon/email.svg",
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
        ),
        // const SizedBox(height: 16),
        // TextFieldWithHeader(
        //   controller: phoneNumberController,
        //   headerText: t.phone_number,
        //   hintText: t.phone_hint,
        //   iconPath: "assets/icon/phone.svg",
        //   keyboardType: TextInputType.phone,
        //   validator: Validators.phone,
        // ),
      ],
    );
  }







}