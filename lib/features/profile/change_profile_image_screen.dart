
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/core/widgets/profile_image.dart';
import 'package:quickdrop_app/features/profile/settings_card.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class ChangeProfileImageScreen extends StatefulWidget {
  const ChangeProfileImageScreen({Key? key}) : super(key: key);

  @override
  State<ChangeProfileImageScreen> createState() => ChangeProfileImageScreenState();
}

class ChangeProfileImageScreenState extends State<ChangeProfileImageScreen> {
  bool _isLoading = false;
  UserData? user;


  File? _selectedImage;
  String? imagePath;
  bool _isImageLoading = false;


 @override
  void initState() {
    super.initState();
    user = Provider.of<UserProvider>(context, listen: false).user;
  }


  Future<void> updateInfo() async {
    final t = AppLocalizations.of(context)!;
    if (_isLoading) return;

    if (_isImageLoading) {
      AppUtils.showDialog(context, t.image_uploading_message, AppColors.error);
      return;
    }

      
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

        UserData updatedUser = UserData(
          uid: user!.uid,
          photoUrl: imagePath ?? user.photoUrl,
        );

        await Provider.of<UserProvider>(context, listen: false)
            .updateUserInfo(updatedUser);
   

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
        child: Column(
          children: [
              _buildImageInfoSection(),
               const SizedBox(height: 24),
              SaveButton(
                isLoading: _isLoading,
                onPressed: updateInfo,
              ),
          ],
        ) 
      ),
    );
  }




Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickerFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickerFile != null) {
      setState(() {
        _isImageLoading = true;
      });
        _selectedImage = File(pickerFile.path);
         imagePath =  await Provider.of<ShipmentProvider>(context, listen: false)
            .uploadImageToSupabase(File(pickerFile.path));
      setState(() {
        _isImageLoading = false;
      });
    }
  }

 
 Widget _buildImageInfoSection() {
  final t = AppLocalizations.of(context)!;
    return buildSection(
      title: t.profile_image,
      icon: Icons.image,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildProfileImage(
              user: user,
              onTap: () async {
              
                await _pickImage();
              },
              size: 110,
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () async {
                await _pickImage();
              },
              style: ElevatedButton.styleFrom(
                // color: AppColors.blue,
                elevation: 0,
                  backgroundColor: AppColors.blue700.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child:  Text(
                t.change_image,
                style: const TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
        // buildProfileImage(user: user, 
        //   onTap: () async {
        //     // Show image picker
        //     await _pickImage();
        //   },
        //   size: 110,
        // ),
        const SizedBox(height: 16),
        buildInfoCard(
          icon: Icons.info_outline,
          title: t.important,
          message: t.profile_image_note,
          color: Colors.blue,
        ),
       
      ],
    );
  }


}