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

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  File? _selectedImage;
  String? imagePath;
  bool _isImageLoading = false;

  UserData? user;

  @override
  void initState() {
    super.initState();

    // Initialize animation
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    user = Provider.of<UserProvider>(context, listen: false).user;
    _initializeFields();

    // Start animation
    _animationController.forward();
  }

  void _initializeFields() {
    emailController.text = user?.email ?? "";
    firstNameController.text = user?.firstName ?? "";
    lastNameController.text = user?.lastName ?? "";
    phoneNumberController.text = user?.phoneNumber ?? "";
  }

  @override
  void dispose() {
    _animationController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneNumberController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Future<void> updateInfo() async {
    if (_isLoading) return;

    // Haptic feedback
    HapticFeedback.lightImpact();

    if (_isImageLoading) {
      AppUtils.showDialog(context, "Image is still uploading, please wait", AppColors.error);
      return;
    }
    if (_formKey.currentState!.validate()) {
      // Show confirmation dialog
      final confirmed =  await ConfirmationDialog.show(
        context: context,
        message: 'Are you sure you want to update your information?',
        header: 'Save Changes',
        buttonHintText: 'save',
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
          // Success haptic feedback
          HapticFeedback.mediumImpact();

          AppUtils.showDialog(context, "Information updated successfully!", AppColors.succes);

          // Delay navigation to show success message
          await Future.delayed(const Duration(milliseconds: 1500));
          Navigator.pop(context, true); // Return true to indicate success
        }
      } catch (e) {
        if (mounted) {
          HapticFeedback.heavyImpact();
          AppUtils.showDialog(context, "Failed to update profile information", AppColors.error);
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
          print("Image uploaded to Supabase: $imagePath");
      setState(() {
        _isImageLoading = false;
        print("Image selected: ${_selectedImage!.path}");
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text(
          'Edit Profile',
          style: TextStyle(
            color: AppColors.dark,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: _buildUpdateScreen(),
          ),
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
                    const Text(
                      "Update Profile",
                      style: TextStyle(
                        color: AppColors.headingText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Keep your information up to date",
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
    return _buildSection(
      title: "Profile Image",
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
              child: const Text(
                'Change Image',
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
          title: "Important",
          message:
              "Make sure your profile image is clear and recognizable.",
          color: Colors.blue,
        ),
      ],
    );
  }



  Widget _buildPersonalInfoSection() {
    return _buildSection(
      title: "Personal Information",
      icon: Icons.badge_outlined,
      children: [
        Row(
          children: [
            Expanded(
              child: ImprovedTextField(
                controller: firstNameController,
                label: 'First Name',
                hint: 'Enter your first name',
                icon: Icons.person_outline,
                validator: Validators.name,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ImprovedTextField(
                controller: lastNameController,
                label: 'Last Name',
                hint: 'Enter your last name',
                icon: Icons.person_outline,
                validator: Validators.name,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        buildInfoCard(
          icon: Icons.info_outline,
          title: "Important",
          message:
              "Make sure this matches the name on your government ID or passport.",
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    return _buildSection(
      title: "Contact Information",
      icon: Icons.contact_mail_outlined,
      children: [
        ImprovedTextField(
          controller: emailController,
          label: 'Email Address',
          hint: 'example@gmail.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.email,
        ),
        const SizedBox(height: 16),
        ImprovedTextField(
          controller: phoneNumberController,
          label: 'Phone Number',
          hint: '06 000 00 00',
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
                  SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Saving...',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  Icon(Icons.save, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  const Text(
                    'Save Changes',
                    style: TextStyle(
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

// Improved TextField Widget
class ImprovedTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const ImprovedTextField({
    Key? key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  }) : super(key: key);

  @override
  State<ImprovedTextField> createState() => _ImprovedTextFieldState();
}

class _ImprovedTextFieldState extends State<ImprovedTextField> {
  bool _isFocused = false;
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.headingText,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: (value) {
            final result = widget.validator?.call(value);
            setState(() {
              _hasError = result != null;
            });
            return result;
          },
          onChanged: (value) {
            if (_hasError) {
              setState(() {
                _hasError = widget.validator?.call(value) != null;
              });
            }
          },
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: TextStyle(color: Colors.grey[400]),
            prefixIcon: Icon(
              widget.icon,
              color: _isFocused
                  ? AppColors.blue700
                  : _hasError
                      ? AppColors.error
                      : Colors.grey[400],
              size: 20,
            ),
            filled: true,
            fillColor: _isFocused
                ? AppColors.blue700.withOpacity(0.05)
                : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.blue700, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          ),
          // onFocusChange: (focused) {
          //   setState(() {
          //     _isFocused = focused;
          //   });
          // },
        ),
      ],
    );
  }
}
