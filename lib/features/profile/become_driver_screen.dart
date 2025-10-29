import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/profile_avatar.dart';
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

  UserData? user;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
       final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.loadDriverData(user!.uid);
   
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

    // final user = FirebaseAuth.instance.currentUser;
    // if (user != null && !user.emailVerified) {
    //   AppUtils.showDialog(
    //     context,
    //     t.please_verify_email,
    //     AppColors.error,
    //   );
    //   return;
    // }

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
          driverStatus: "pending",
        );

        await Provider.of<UserProvider>(context, listen: false)
            .requestDriverMode(driver);
        
        await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
          'driverStatus': 'pending',
        });

         
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
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user?.subscriptionStatus == "inactive" ) {
      return true;
    }
    return false;
  }

   bool _isDriverSubscriptionExpired() {
    final user = Provider.of<UserProvider>(context, listen: false).user;
    if (user?.subscriptionStatus == "expired" ) {
      return true;
    }
    return false;
  }



  Widget _buildProgressIndicator(String currentStep) {
    final t = AppLocalizations.of(context)!;
    final steps = ['registration', 'pending', 'approved', 'active'];
    final stepLabels = [t.register, t.pending, t.payment, t.active];
    final currentIndex = steps.indexOf(currentStep);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: List.generate(steps.length * 2 - 1, (index) {
          if (index.isOdd) {
            // Line between steps
            final lineIndex = index ~/ 2;
            return Expanded(
              child: Container(
                height: 2,
                decoration: BoxDecoration(
                  color: currentIndex > lineIndex
                      ? AppColors.succes
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            );
          } else {
            // Step indicator
            final stepIndex = index ~/ 2;
            final isActive = currentIndex == stepIndex;
            final isCompleted = currentIndex > stepIndex;

            return Column(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isActive
                        ? AppColors.blue
                        : isCompleted
                            ? AppColors.succes
                            : Colors.grey[300],
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const CustomIcon(iconPath: "assets/icon/check.svg", color: Colors.white, size: 20)
                        : Text(
                            '${stepIndex + 1}',
                            style: TextStyle(
                              color: isActive || isCompleted
                                  ? Colors.white
                                  : Colors.grey[600],
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  stepLabels[stepIndex],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                    color:
                        isActive ? AppColors.blue : Colors.grey[600],
                  ),
                ),
              ],
            );
          }
        }),
      ),
    );
  }



String _getCurrentStep(UserProvider userProvider) {
  if (userProvider.driverRequestStatus == null) {
    return 'registration';
  } else if (userProvider.driverRequestStatus == 'pending') {
    return 'pending';
  } else if (userProvider.driverRequestStatus == 'accepted') {
    
    if (_isDriverShouldPay()) {
      return 'approved';
    } else {
      return 'active';
    }
  }
  return 'registration';
}


Widget _buildStepContent(String step, UserProvider userProvider) {
  switch (step) {
    case 'registration':
      return _buildRegistrationForm();
    case 'pending':
      return _buildPendingApproval();
    case 'approved':
      return _buildApprovedPayment();
    case 'active':
      return _buildActiveDriver();
    default:
      return _buildRegistrationForm();
  }
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
      body: Consumer<UserProvider>(
        builder: (context, userProvider, child) {
          if (userProvider.driverRequestStatus == null && _isLoadingData) {
            return loadingAnimation();
          }

          String currentStep = _getCurrentStep(userProvider);
          

          return Column(
            children: [
              _buildProgressIndicator(currentStep),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
                    child:  _buildStepContent(currentStep, userProvider),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }


    Widget _buildRegistrationForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeaderSection(),
          const SizedBox(height: 24),
          _buildImageInfoSection(),
          const SizedBox(height: 24),
          _buildPersonalInfoSection(),
          const SizedBox(height: 24),
          _buildContactInfoSection(),
          const SizedBox(height: 24),
          _buildCarInfoSection(),
          const SizedBox(height: 32),
          IconTextButton(
            onPressed:  requestDriverMode,
            isLoading: _isLoading, 
            iconPath: "assets/icon/save.svg",
            loadingText: AppLocalizations.of(context)!.registering, 
            hint: AppLocalizations.of(context)!.register),
          const SizedBox(height: 20),
        ],
      ),
    );
  }


  Widget _buildNextStep(int number, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: AppColors.blue.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '$number',
              style: TextStyle(
                color: AppColors.blue,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

    Widget _buildApprovedPayment() {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        StatusCard(
          icon: Icons.check_circle,
          title: t.registration_approved,
          message: t.registration_approved_message,
          color: AppColors.succes,
        ),
        const SizedBox(height: 24),
        const PaymentScreen(),
      ],
    );
  }


  Widget _buildActiveDriver() {
    final t = AppLocalizations.of(context)!;
    final expiredSubscription = _isDriverSubscriptionExpired();

    if (expiredSubscription) {
      return Column(
        children: [
          StatusCard(
            icon: Icons.warning,
            title: t.subscription_expired,
            message: t.subscription_expired_message,
            color: Colors.red,
          ),
          const SizedBox(height: 24),
          const PaymentScreen(),
        ],
      );
    }

    return Column(
      children: [
        StatusCard(
          icon: Icons.check_circle,
          title: t.you_are_all_set,
          message: t.you_are_all_set_message,
          color: AppColors.succes,
        ),
        const SizedBox(height: 24),
        _buildSubscriptionStatus(),
        // const SizedBox(height: 24),
        // _buildQuickStats(),
        // const SizedBox(height: 24),
        // _buildViewDeliveriesButton(),
      ],
    );
  }

 Widget _buildSubscriptionStatus() {
    final t = AppLocalizations.of(context)!;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    final subscriptionEndDate = user?.subscriptionEndsAt != null
        ? DateTime.parse(user!.subscriptionEndsAt!)
        : null;
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                t.subscription_status,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingText,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.succes.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  t.active_status,
                  style: TextStyle(
                    color: AppColors.succes,
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.succes.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.succes.withOpacity(0.2)),
            ),
            child: Text(
              subscriptionEndDate != null
                  ? "${t.subscription_active_until} ${subscriptionEndDate.day}/${subscriptionEndDate.month}/${subscriptionEndDate.year}"
                  : t.subscription_is_active,
              style: TextStyle(
                color: AppColors.succes,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildPendingApproval() {
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        StatusCard(
          icon: Icons.schedule,
          title: t.request_driver_mode_title,
          message: t.request_driver_mode_message,
          color: Colors.orange,
        ),
        const SizedBox(height: 24),
        Container(
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
              Text(
                t.whats_next,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingText,
                ),
              ),
              const SizedBox(height: 20),
              _buildNextStep(1, t.document_verification,
                  t.document_verification_desc),
              const SizedBox(height: 12),
              _buildNextStep(2, t.vehicle_inspection,
                  t.vehicle_inspection_desc),
              const SizedBox(height: 12),
              _buildNextStep(3, t.approval_and_payment,
                  t.approval_and_payment_desc),
            ],
          ),
        ),
      ],
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
          ProfileAvatar(
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
              child: AppTextField(
                controller: firstNameController,
                label: t.first_name,
                hintText: t.enter_first_name,
                iconPath: "assets/icon/user.svg",
                validator: Validators.name,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: AppTextField(
                controller: lastNameController,
                label: t.last_name,
                hintText: t.enter_last_name,
                iconPath: "assets/icon/user.svg",
                validator: Validators.name,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: idNumberController,
          label: t.id_card_number,
          hintText: t.enter_national_id,
          iconPath: "assets/icon/id-card.svg",
          keyboardType: TextInputType.emailAddress,
          validator: Validators.notEmpty,
        ),
        const SizedBox(height: 16),
        StatusCard(
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
    final isEmailVerified = true;

    return _buildSection(
      title: t.contact_information,
      icon: Icons.contact_mail_outlined,
      children: [
        AppTextField(
          controller: emailController,
          label: t.email_address,
          hintText: t.email_hint,
          iconPath: "assets/icon/email.svg",
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

        AppTextField(
          controller: phoneNumberController,
          label: t.phone_number,
          hintText: t.phone_hint,
          iconPath: "assets/icon/phone.svg",
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
          context.push(
              "/verify-email?email=${FirebaseAuth.instance.currentUser?.email}");
        }
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
        AppTextField(
          controller: vehiclePlateNumberController,
          label: t.registration_plate,
          hintText: t.vehicle_plate_number_hint,
          iconPath: "assets/icon/car.svg",
          keyboardType: TextInputType.emailAddress,
          validator: Validators.notEmpty,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: driverNumberController,
          label: t.driver_number_label,
          hintText: t.driver_number_hint,
          iconPath: "assets/icon/car.svg",
          keyboardType: TextInputType.phone,
          validator: Validators.notEmpty,
        ),
        const SizedBox(height: 16),
        AppTextField(
          controller: vehicleTypeController,
          label: t.vehicle_type_label,
          hintText: t.vehicle_type_hint,
          iconPath: "assets/icon/car.svg",
          keyboardType: TextInputType.text,
          validator: Validators.notEmpty,
        ),
        const SizedBox(height: 16),
        StatusCard(
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

}