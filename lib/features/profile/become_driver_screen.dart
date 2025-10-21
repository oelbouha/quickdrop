import 'dart:io';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/profile_image.dart';
import 'package:quickdrop_app/features/profile/payment.screen.dart';

class BecomeDriverScreen extends StatefulWidget {
  const BecomeDriverScreen({Key? key}) : super(key: key);

  @override
  State<BecomeDriverScreen> createState() => BecomeDriverScreenState();
}

class BecomeDriverScreenState extends State<BecomeDriverScreen>
    with TickerProviderStateMixin {
  bool _isLoading = false;
  bool _isLoadingData = true;
  bool _isUserRequestedDriver = false;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final emailController = TextEditingController();
  final idNumberController = TextEditingController();
  final vehiclePlateNumberController = TextEditingController();
  final driverNumberController = TextEditingController();
  final vehicleTypeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  File? _selectedImage;
  String? imagePath;
  bool _isImageLoading = false;
  bool _showRegistrationForm = false;

  UserData? user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _isUserRequestedDriver =
          await Provider.of<UserProvider>(context, listen: false)
              .doesUserRequestDriverMode(user!.uid);
      setState(() {
        _isLoadingData = false;
        _showRegistrationForm = !_isUserRequestedDriver;
      });
    });

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

  Future<void> requestDriverMode() async {
    final t = AppLocalizations.of(context)!;
    if (_isLoading) return;

    if (_isImageLoading) {
      AppUtils.showDialog(context, t.image_uploading_message, AppColors.error);
      return;
    }

     final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        AppUtils.showDialog(
            context,
            t.please_verify_email,
            AppColors.error,
          );
        return;
      }
      
    if (_formKey.currentState!.validate()) {
      // Show confirmation dialog
      final confirmed = await ConfirmationDialog.show(
        context: context,
        message: t.driver_registration_confirm_message,
        header: t.driver_registration_confirm_header,
        buttonHintText: t.confirm,
        buttonColor: AppColors.blue700,
        iconColor: AppColors.blue700,
        iconData: Icons.save,
      );
      if (!confirmed) return;

      setState(() => _isLoading = true);

      try {
        final user = Provider.of<UserProvider>(context, listen: false).user;
        UserData driver = UserData(
          uid: user!.uid,
          displayName:
              '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
          email: emailController.text.trim(),
          firstName: firstNameController.text.trim(),
          lastName: lastNameController.text.trim(),
          phoneNumber: phoneNumberController.text.trim(),
          photoUrl: imagePath ?? user.photoUrl,
          idNumber: idNumberController.text.trim(),
          carPlateNumber: vehiclePlateNumberController.text.trim(),
          carModel: vehicleTypeController.text.trim(),
          driverNumber: driverNumberController.text.trim(),
          createdAt: DateTime.now().toIso8601String(),
        );

        await Provider.of<UserProvider>(context, listen: false)
            .requestDriverMode(driver);

        await showSuccessAnimation(context,
            title: t.driver_mode_title, message: t.driver_mode_success_message);
      } catch (e) {
        if (mounted) {
          AppUtils.showDialog(
              context, t.driver_mode_request_failed, AppColors.error);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      AppUtils.showDialog(context, t.please_fill_all_fields, AppColors.error);
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
      imagePath = await Provider.of<ShipmentProvider>(context, listen: false)
          .uploadImageToSupabase(File(pickerFile.path));
      setState(() {
        _isImageLoading = false;
      });
    }
  }

  bool _isDriverShouldPay() {
    // return true;
    final user = Provider.of<UserProvider>(context, listen: false).user;

    if (user?.subscriptionStatus == "inactive" && user?.status == "driver") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          t.registration,
          style: const TextStyle(
            color: AppColors.appBarText,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: AppColors.appBarBackground,
        elevation: 0,
        centerTitle: true,
      ),
      body: _isLoadingData
          ? loadingAnimation()
          : SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
                child: _isDriverShouldPay()
                    ? PaymentScreen()
                    : _buildUpdateScreen(),
              ),
            ),
    );
  }

  Widget _buildUpdateScreen() {
    final t = AppLocalizations.of(context)!;
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 24),
          if (_isUserRequestedDriver) ...[
            buildInfoCard(
              icon: Icons.info_outline,
              title: t.request_driver_mode_title,
              message: t.request_driver_mode_message,
              color: AppColors.succes,
            ),
            if (!_showRegistrationForm) ...[
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _showRegistrationForm = true;
                  });
                },
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.blue700.withOpacity(0.8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  t.resend_request,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ],
          ],
          if (_showRegistrationForm) ...[
            const SizedBox(height: 32),
            _buildImageInfoSection(),
            const SizedBox(height: 24),
            _buildPersonalInfoSection(),
            const SizedBox(height: 24),
            _buildContactInfoSection(),
            const SizedBox(height: 24),
            _buildCarInfoSection(),
            const SizedBox(height: 32),
            _buildSaveButton(),
            const SizedBox(height: 20),
          ]
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
          colors: [
            AppColors.blue.withOpacity(0.1),
            AppColors.purple600.withOpacity(0.1)
          ],
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
                      t.driver_registration,
                      style: TextStyle(
                        color: AppColors.headingText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      t.driver_registration_subtitle,
                      maxLines: 2,
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
    return Container(
      width: double.infinity,
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
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          buildProfileImage(
            user: user,
            onTap: () async {
              // Show image picker
              await _pickImage();
            },
            size: 110,
          ),
          const SizedBox(width: 32),
          ElevatedButton(
            onPressed: () async {
              // Show image picker
              await _pickImage();
            },
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: AppColors.blue700.withOpacity(0.8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              t.upload_image,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPersonalInfoSection() {
    final t = AppLocalizations.of(context)!;
    return _buildSection(
      title: t.personal_information,
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
        ImprovedTextField(
          controller: idNumberController,
          label: t.id_card_number,
          hint: t.enter_national_id,
          icon: Icons.person,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.notEmpty,
        ),
        const SizedBox(height: 16),
        buildInfoCard(
          icon: Icons.info_outline,
          title: t.important,
          message: t.personal_info_note,
          color: Colors.blue,
        ),
      ],
    );
  }

  Widget _buildContactInfoSection() {
    final t = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    final isEmailVerified = user?.emailVerified ?? false;

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

        // Email verification warning
        if (!isEmailVerified) ...[
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.orange.shade700,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        t.email_not_verified,
                        style: TextStyle(
                          color: Colors.orange.shade900,
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        t.please_verify_email,
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: _sendVerificationEmail,
            icon: const Icon(Icons.mail_outline),
            label: Text(t.send_verification_email),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],

        ImprovedTextField(
          controller: phoneNumberController,
          label: t.phone_number,
          hint: t.phone_hint,
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: Validators.phone,
        ),
        const SizedBox(height: 16),
        Text(
          t.email_verification_note,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Future<void> _sendVerificationEmail() async {
    final t = AppLocalizations.of(context)!;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();

        if (mounted) {
         AppUtils.showDialog(
            context,
            t.verification_email_sent,
            AppColors.succes,
          );
        context.push("/verify-email");
        }
      }
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(
            context,
            t.error_sending_verification,
            AppColors.error,
          );
      }
    }
  }

  Widget _buildCarInfoSection() {
    final t = AppLocalizations.of(context)!;
    return _buildSection(
      title: t.vehicle_information,
      icon: Icons.contact_mail_outlined,
      children: [
        ImprovedTextField(
          controller: vehiclePlateNumberController,
          label: t.registration_plate,
          hint: t.vehicle_plate_number_hint,
          icon: Icons.car_crash_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.notEmpty,
        ),
        const SizedBox(height: 16),
        ImprovedTextField(
          controller: driverNumberController,
          label: t.driver_number_label,
          hint: t.driver_number_hint,
          icon: Icons.car_crash_outlined,
          keyboardType: TextInputType.phone,
          validator: Validators.notEmpty,
        ),
        const SizedBox(height: 16),
        ImprovedTextField(
          controller: vehicleTypeController,
          label: t.vehicle_type_label,
          hint: t.vehicle_type_hint,
          icon: Icons.car_crash_outlined,
          keyboardType: TextInputType.text,
          validator: Validators.notEmpty,
        ),
        const SizedBox(height: 16),
        buildInfoCard(
          icon: Icons.info_outline,
          title: t.important,
          message: t.vehicle_info_note,
          color: Colors.green,
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
          onTap: _isLoading ? null : requestDriverMode,
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
                  Text(
                    t.registering,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ] else ...[
                  Icon(Icons.save, color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    t.register,
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
