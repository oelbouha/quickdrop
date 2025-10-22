import 'dart:io';
import 'package:quickdrop_app/core/widgets/iconTextField.dart';
import 'package:quickdrop_app/features/profile/settings_card.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/profile_image.dart';


class UpdateUserInfoScreen extends StatefulWidget {
  const UpdateUserInfoScreen({Key? key}) : super(key: key);

  @override
  State<UpdateUserInfoScreen> createState() => UpdateUserInfoScreenState();
}

class UpdateUserInfoScreenState extends State<UpdateUserInfoScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  File? _selectedImage;
  String? imagePath;
  bool _isImageLoading = false;

  UserData? user;

  @override
  void initState() {
    super.initState();

    user = Provider.of<UserProvider>(context, listen: false).user;
    _initializeFields();

  }

  void _initializeFields() {
    firstNameController.text = user?.firstName ?? "";
    lastNameController.text = user?.lastName ?? "";
    emailController.text = user?.email ?? "";
    phoneNumberController.text = user?.phoneNumber ?? "";
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }


  Future<void> updateInfo() async {
    final t = AppLocalizations.of(context)!;
    if (_isLoading) return;

    if (_isImageLoading) {
      AppUtils.showDialog(context, t.image_uploading_message, AppColors.error);
      return;
    }

    if (_formKey.currentState!.validate()) {
      
      final confirmed =  await ConfirmationDialog.show(
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
        final user = Provider.of<UserProvider>(context, listen: false).user;
          final newEmail = emailController.text.trim();

        UserData updatedUser = UserData(
          uid: user!.uid,
          displayName:
              '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
          email: newEmail,
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phoneNumber: phoneNumberController.text.trim(),
          photoUrl: imagePath ?? user.photoUrl,
        );

        await Provider.of<UserProvider>(context, listen: false)
            .updateUserInfo(updatedUser);


   // 🔹 Update Firebase Authentication email too
          final currentUser = FirebaseAuth.instance.currentUser;
          print(" Current User Email: ${currentUser?.email}, New Email: $newEmail ");
          if (currentUser != null && currentUser.email != newEmail) {
            try {
              await currentUser.verifyBeforeUpdateEmail(newEmail);
              await currentUser.sendEmailVerification();
            } on FirebaseAuthException catch (e) {
              if (e.code == 'requires-recent-login') {
                AppUtils.showDialog(
                  context,
                  t.reauth_required_message,
                  AppColors.error,
                );
                return;
              } else {
                AppUtils.showDialog(
                  context,
                  t.update_error_message,
                  AppColors.error,
                );
              }
            }
          }

        if (mounted) {
          await showSuccessAnimation(context,
            title: t.update_success_title,
            message: t.update_success_message
          );
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showDialog(context, t.update_error_message, AppColors.error);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } 
  }




  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
         backgroundColor: AppColors.appBarBackground,
          title:  Text(
            t.edit_profile,
            style:const TextStyle(color: AppColors.appBarText, fontWeight: FontWeight.w600),
            
          ),
          centerTitle: true,
      ),
      body:  SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
            child: _buildSttingsScreen(),
          ),
        ),
    );
  }


  Widget _buildSttingsScreen() {
    return Container(
       decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
      child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        settingsCard(
          title: AppLocalizations.of(context)!.profile_image,
          subtitle: AppLocalizations.of(context)!.profile_image,
          iconPath: "assets/icon/photo.svg",
          onTap: () => {context.push('/change-image')},
        ),
         settingsCard(
          title: AppLocalizations.of(context)!.personal_info,
          subtitle: AppLocalizations.of(context)!.personal_info,
          iconPath: "assets/icon/user.svg",
          onTap: () => {context.push('/change-personal-info')},
        ),
          settingsCard(
          title: AppLocalizations.of(context)!.contact_information,
          subtitle: AppLocalizations.of(context)!.contact_information,
          iconPath: "assets/icon/email.svg",
          onTap: () => {context.push('/change-contact-info')},
        ),
      ],
    ));
  }




}

