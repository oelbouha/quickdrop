
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/core/widgets/image_picker_bottom_sheet.dart';
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
    if (user == null) {
      Navigator.of(context).pop();
    }
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
        
        imagePath =  await Provider.of<ShipmentProvider>(context, listen: false)
            .uploadImageToSupabase(File(_selectedImage!.path));

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
  final pickedFile = await ImagePickerHelper.pickImage(context: context);
   if (pickedFile != null) {
    setState(() {
      _selectedImage = pickedFile;
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
            _buildProfileImage(
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




Widget _buildProfileImage({
  VoidCallback? onTap,
  double size = 50,
}) {
  return GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(500),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: AppColors.blueStart.withValues(alpha: 0.1),
            // borderRadius: BorderRadius.circular(500),

              shape: BoxShape.circle,
              border: Border.all(color: AppColors.blue, width: 2),
          ),
        child: _selectedImage != null ? ClipRRect(
                          // borderRadius: BorderRadius.circular(21),
                        child: Image.file(
                            File(_selectedImage!.path), // path to local file
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                          )
                        )
         : user!.photoUrl != null ? CachedNetworkImage(
              imageUrl: user!.photoUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: AppColors.blueStart.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.blue700, strokeWidth: 2))),
              errorWidget: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.blueStart.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.blueStart,
                      size: size * 0.6,
                    ),
                  );
                },
            ) : Container(
                    decoration: BoxDecoration(
                      color: AppColors.blueStart.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: CustomIcon(
                        iconPath: "assets/icon/camera-add.svg",
                        size: size * 0.6,
                        color: AppColors.lessImportant,
                      ),
                  )
      ),
    ),
  );
}



}

