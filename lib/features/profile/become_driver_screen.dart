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

    WidgetsBinding.instance.addPostFrameCallback((_)  async{
      _isUserRequestedDriver = await Provider.of<UserProvider>(context, listen: false)
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
    if (_isLoading) return;


    if (_isImageLoading) {
      AppUtils.showDialog(context, "Image is still uploading, please wait", AppColors.error);
      return;
    }
    if (_formKey.currentState!.validate()) {
      // Show confirmation dialog
      final confirmed =  await ConfirmationDialog.show(
        context: context,
        message: 'Are you sure all information is correct!',
        header: 'Register Request',
        buttonHintText: 'confirm',
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
          title: "Driver Mode",
          message: "Your request has been sent Successfully. We will update you after review your documents"
        );
      } catch (e) {
        if (mounted) {
          AppUtils.showDialog(context, "Failed to send request please try again later", AppColors.error);
        }
      } finally {
        if (mounted) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      AppUtils.showDialog(context, "Please fill all fields", AppColors.error);
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
          // print("Image uploaded to Supabase: $imagePath");
      setState(() {
        _isImageLoading = false;
        // print("Image selected: ${_selectedImage!.path}");
      });
    }
  }

  bool _isDriverShouldPay() {
    return true;
    final user = Provider.of<UserProvider>(context, listen: false).user;
    
    if (user?.subscriptionStatus == "inactive" && user?.status == "driver") {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title:  Text(
          'Registration',
          style: TextStyle(
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
            child: _isDriverShouldPay() ? PaymentScreen() : _buildUpdateScreen(),
          ),
        
      ),
    );
  }

  Widget _buildUpdateScreen() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildHeaderSection(),
           const SizedBox(height: 24),
           if (_isUserRequestedDriver) ...[buildInfoCard(
              icon: Icons.info_outline,
              title: "Request Driver Mode",
              message:
                  "You have been requested to become a driver. please wait for the admin to review your request. You will be notified once your request is approved.",
              color: AppColors.succes,
            ),
          if (!_showRegistrationForm) ...[
            const SizedBox(height: 24),
            ElevatedButton(
                onPressed: ()  {
                  setState(() {
                    _showRegistrationForm = true;
                  });
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
                  'Resend Request',
                  style: TextStyle(color: Colors.white),
                ),
              ),],],
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
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue.withOpacity(0.1), AppColors.purple600.withOpacity(0.1)],
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
                      "Driver registration",
                      style: TextStyle(
                        color: AppColors.headingText,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                     "You can request to become a driver by filling out the form below.",
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
    return Container (
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
      child:Column(
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
                // color: AppColors.blue,
                elevation: 0,
                  backgroundColor: AppColors.blue700.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Upload Image',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      
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
        ImprovedTextField(
          controller: idNumberController,
          label: 'Id cart number',
          hint: 'Enter your National ID',
          icon: Icons.person,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.notEmpty,
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
          hint: '00 000 00 00',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          validator: Validators.phone,
        ),
      ],
    );
  }


   Widget _buildCarInfoSection() {
    return _buildSection(
      title: "vehicle Information",
      icon: Icons.contact_mail_outlined,
      children: [
        ImprovedTextField(
          controller: vehiclePlateNumberController,
          label: 'Rgistration plate',
          hint: 'vehicle plate number ',
          icon: Icons.car_crash_outlined,
          keyboardType: TextInputType.emailAddress,
          validator: Validators.notEmpty,
        ),
        const SizedBox(height: 16),
        ImprovedTextField(
          controller: driverNumberController,
          label: 'Driver number',
          hint: '(e.g. 00125)',
          icon: Icons.car_crash_outlined,
          keyboardType: TextInputType.phone,
          validator: Validators.notEmpty,
        ),
        const SizedBox(height: 16),
        ImprovedTextField(
          controller: vehicleTypeController,
          label: 'Vehicle Type',
          hint: 'vehicle type (car, truck, etc.)',
          icon: Icons.car_crash_outlined,
          keyboardType: TextInputType.text,
          validator: Validators.notEmpty,
        ),
         const SizedBox(height: 16),
        buildInfoCard(
          icon: Icons.info_outline,
          title: "Important",
          message:
              "Make sure the vehicle information matches your vehicle registration documents.",
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
                  const Text(
                    'Registering...',
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
                    'Register',
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

