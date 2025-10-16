import 'dart:io';
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
    emailController.text = user?.email ?? "";
    firstNameController.text = user?.firstName ?? "";
    lastNameController.text = user?.lastName ?? "";
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

    // Haptic feedback
    // HapticFeedback.lightImpact();

    if (_isImageLoading) {
      AppUtils.showDialog(context, t.image_uploading_message, AppColors.error);
      return;
    }
    if (_formKey.currentState!.validate()) {
      // Show confirmation dialog
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
          displayName:
              '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
          email: emailController.text.trim(),
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phoneNumber: phoneNumberController.text.trim(),
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
          HapticFeedback.heavyImpact();
          AppUtils.showDialog(context, t.update_error_message, AppColors.error);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      // Validation failed haptic feedback
      HapticFeedback.heavyImpact();
    }
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
            child: _buildUpdateScreen(),
          ),
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
          _buildImageInfoSection(),
          const SizedBox(height: 24),
          _buildPersonalInfoSection(),
          const SizedBox(height: 24),
          _buildContactInfoSection(),
          const SizedBox(height: 32),
          _buildSaveButton(),
          const SizedBox(height: 20),
        ],
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



 Widget _buildImageInfoSection() {
  final t = AppLocalizations.of(context)!;
    return _buildSection(
      title: t.profile_image,
      icon: Icons.image,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildProfileImage(
              user: user,
              onTap: () async {
                // Show image picker
                await _pickImage();
              },
              size: 110,
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () async {
                // Show image picker
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
                style: TextStyle(color: Colors.white),
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



  Widget _buildPersonalInfoSection() {
    final t = AppLocalizations.of(context)!;
    return _buildSection(
      title: t.personal_info,
      icon: Icons.badge_outlined,
      children: [
        Row(
          children: [
            Expanded(
              child: ImprovedTextField(
                controller: firstNameController,
                label: t.first_name,
                hint: t.enter_first_name,
                icon: Icons.person_outline,
                validator: Validators.name,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ImprovedTextField(
                controller: lastNameController,
                label: t.last_name,
                hint: t.enter_last_name,
                icon: Icons.person_outline,
                validator: Validators.name,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        buildInfoCard(
          icon: Icons.info_outline,
          title: t.important,
          message:t.personal_info_note,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    final t = AppLocalizations.of(context)!;
    return _buildSection(
      title: t.contact_information,
      icon: Icons.contact_mail_outlined,
      children: [
        ImprovedTextField(
          controller: emailController,
          label: t.email_address,
          hint: t.email_hint,
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
        ),
        const SizedBox(height: 16),
        ImprovedTextField(
          controller: phoneNumberController,
          label: t.phone_number,
          hint: t.phone_hint,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: Validators.phone,
        ),
      ],
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.blue, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    final t = AppLocalizations.of(context)!;
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: _isLoading
              ? [Colors.grey, Colors.grey]
              : [AppColors.blue, AppColors.blue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.blue700.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _isLoading ? null : updateInfo,
          borderRadius: BorderRadius.circular(16),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoading) ...[
                 const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                   Text(
                    t.saving,
                    style:const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  const Icon(Icons.save, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                   Text(
                    t.save_changes,
                    style:const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

