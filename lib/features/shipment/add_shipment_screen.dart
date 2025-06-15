import 'dart:io'; // Import File class

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/dropDownTextField.dart';

class AddShipmentScreen extends StatefulWidget {
  const AddShipmentScreen({Key? key}) : super(key: key);

  @override
  State<AddShipmentScreen> createState() => _AddShipmentScreenState();
}

class _AddShipmentScreenState extends State<AddShipmentScreen>
    with TickerProviderStateMixin {
  File? _selectedImage;
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final weightController = TextEditingController();
  final descriptionController = TextEditingController();
  final dateController = TextEditingController();
  final lengthController = TextEditingController();
  final widthController = TextEditingController();
  final heightController = TextEditingController();
  final packageNameController = TextEditingController();
  final packageQuantityController = TextEditingController();
  final typeController = TextEditingController();
  final priceController = TextEditingController();

  bool _isListButtonLoading = false;
  final _formKey = GlobalKey<FormState>();
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
    _setupAnimations();
  }

  void _initializeDefaults() {
    packageQuantityController.text = "1";
    weightController.text = "1";
  }

  void _setupAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeIn,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutQuart,
    ));

    // Start animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _showErrorWithAnimation(String message) {
    AppUtils.showDialog(context, message, AppColors.error);
    HapticFeedback.heavyImpact();
  }

  void _listShipment() async {
    // Add haptic feedback
    HapticFeedback.mediumImpact();

    if (_isListButtonLoading) return;
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isListButtonLoading = true;
      });
      // final userProvider = Provider.of<UserProvider>(context);
      // final user = userProvider.user;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        AppUtils.showDialog(context, 'Please log in to list a shipment', AppColors.error);
        return;
      }

      // if (_selectedImage == null) {
      //   AppUtils.showDialog(context, "Please select a package image", AppColors.error);
      //   setState(() {
      //     _isListButtonLoading = false;
      //   });
      //   return;
      // }
      // print("uploading file ${_selectedImage}");
      // String? photoUrl =
      //     await Provider.of<ShipmentProvider>(context, listen: false)
      //         .uploadImageToFirebase(_selectedImage!);

      // if (photoUrl == null) {
      //   AppUtils.showDialog(context, "failed to upload image", AppColors.error);
      //   setState(() {
      //     _isListButtonLoading = false;
      //   });
      //   return;
      // }

      Shipment shipment = Shipment(
        price: priceController.text,
        type: typeController.text,
        from: fromController.text,
        to: toController.text,
        weight: weightController.text,
        description: descriptionController.text,
        date: dateController.text,
        length: lengthController.text,
        width: widthController.text,
        height: heightController.text,
        packageName: packageNameController.text,
        packageQuantity: packageQuantityController.text,
        imageUrl: null,
        userId: user.uid,
      );
      try {
        await Provider.of<ShipmentProvider>(context, listen: false)
            .addShipment(shipment);
        if (mounted) {
          Provider.of<StatisticsProvider>(context, listen: false)
              .incrementField(user.uid, "pendingShipments");
          await _showSuccessAnimation();
          // Navigator.pop(context);
          // AppUtils.showSuccess(context, 'Shipment listed Successfully!');
        }
      } catch (e) {
        if (mounted) {
          _showErrorWithAnimation('Failed to list shipment: $e');
        }
      } finally {
        if (mounted) {
          setState(() {
            _isListButtonLoading = false;
          });
        }
      }
    } else {
      _showErrorWithAnimation('Please fill in all required fields');
      HapticFeedback.heavyImpact();
    }
  }

  Future<void> _showSuccessAnimation() async {
    HapticFeedback.lightImpact();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) {
            Navigator.of(dialogContext).pop(); // close dialog
            Navigator.of(context).pop(); // close screen
          }
        });
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.success.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.check_circle,
                        color: AppColors.success,
                        size: 64 * value,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              const Text(
                'Package Listed Successfully!',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'Your shipment has been added and is now visible to couriers.',
                style: TextStyle(fontSize: 14, color: AppColors.textMuted),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // color: Colors.white.withOpacity(0.9),
                borderRadius: BorderRadius.circular(12),
                // boxShadow: [
                //   BoxShadow(
                //     color: Colors.black.withOpacity(0.1),
                //     blurRadius: 8,
                //     offset: const Offset(0, 2),
                //   ),
                // ],
              ),
              child: const Icon(Icons.arrow_back, color: Color(0xFF1F2937)),
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
                decoration: const BoxDecoration(
                    // gradient: LinearGradient(
                    //   begin: Alignment.topLeft,
                    //   end: Alignment.bottomRight,
                    //   colors: [
                    //     Color(0xFFEFF6FF),
                    //     Color(0xFFFFFFFF),
                    //     Color(0xFFFAF5FF),
                    //   ],
                    // ),
                    ),
                padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeader(),
                      const SizedBox(
                        height: 32,
                      ),
                      _buildPackageDestination(),
                      const SizedBox(
                        height: 24,
                      ),
                      _buildTimingDetails(),
                      const SizedBox(
                        height: 24,
                      ),
                      _buildPackageDetails(),
                      const SizedBox(
                        height: 24,
                      ),
                      // _buildImage(),
                      // const SizedBox(
                      //   height: 24,
                      // ),
                      _buildPackageDemensions(),
                      const SizedBox(
                        height: 32,
                      ),
                      LoginButton(
                          hintText: "List Package",
                          onPressed: _listShipment,
                          isLoading: _isListButtonLoading),
                      const SizedBox(
                        height: 25,
                      ),
                    ],
                  ),
                ))));
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Add Your Shipment',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Complete the form below to create a new delivery request',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
          // textAlign: TextAlign.start,
        ),
      ],
    );
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickerFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickerFile != null) {
      setState(() {
        _selectedImage = File(pickerFile.path);
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _buildPackageDetails() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildIconcard(
                backgroundColor: AppColors.contactBackground,
                color: AppColors.blue700,
                icon: "assets/icon/package.svg",
                title: "Package details"),
            const SizedBox(
              height: 10,
            ),
            TextFieldWithHeader(
              controller: packageNameController,
              headerText: "Packge Name",
              hintText: "e.g, phone case, book, etc",
              obsecureText: false,
              keyboardType: TextInputType.text,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWithHeader(
              controller: descriptionController,
              hintText: "Describe your package content...",
              headerText: "Package description",
              maxLines: 3,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWithHeader(
              controller: priceController,
              hintText: "0.00",
              headerText: "Price",
              validator: Validators.notEmpty,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 10,
            ),
            TextWithRequiredIcon(text: "Package type"),
            DropdownTextField(
              validator: Validators.notEmpty,
              controller: typeController,
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ));
  }

  Widget _buildPackageDemensions() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildIconcard(
                backgroundColor: const Color(0xFFEDE9FE),
                color: const Color(0xFF8B5CF6),
                icon: "assets/icon/package.svg",
                title: "Package Dimensions"),
            const SizedBox(
              height: 10,
            ),
            TextFieldWithHeader(
              controller: weightController,
              hintText: "1.0",
              headerText: "Weight (kg)",
              keyboardType: TextInputType.number,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWithHeader(
              controller: packageQuantityController,
              hintText: "1",
              headerText: "Quantity",
              keyboardType: TextInputType.number,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "Demensions (cm)-optional",
              style: TextStyle(
                  color: AppColors.headingText,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            const SizedBox(
              height: 4,
            ),
            Row(
              children: [
                Expanded(
                  child: TextFieldWithHeader(
                    controller: lengthController,
                    hintText: "0",
                    headerText: "Length ",
                    keyboardType: TextInputType.number,
                    isRequired: false,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFieldWithHeader(
                    controller: widthController,
                    hintText: "0",
                    headerText: "Width",
                    isRequired: false,
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextFieldWithHeader(
                    controller: heightController,
                    hintText: "0",
                    headerText: "Height",
                    isRequired: false,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 15,
            ),
          ],
        ));
  }

  Widget _buildPackageDestination() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildIconcard(
                backgroundColor: const Color(0xFFD1FAE5),
                color: const Color(0xFF10B981),
                icon: "assets/icon/map-point.svg",
                title: "Delivery Locations"),
            const SizedBox(
              height: 10,
            ),
            TextFieldWithHeader(
              controller: fromController,
              hintText: "Enter pickup location ",
              headerText: "Pickup Location",
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWithHeader(
              controller: toController,
              hintText: "Enter delivery location",
              headerText: "Delivery Location",
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 16,
            ),
            TipWidget(message: 'Include landmarks, building numbers, and contact information for smoother pickup and delivery.',),
                 
          ],
        ));
  }

  Widget _buildTimingDetails() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildIconcard(
                backgroundColor: const Color(0xFFFEF3C7),
                color: const Color(0xFFF59E0B),
                icon: "assets/icon/camera-add.svg",
                title: "Package Image & Timing"),
            const SizedBox(
              height: 16,
            ),
            TextWithRequiredIcon(text: "Package image"),
            ImageUpload(
              onPressed: _pickImage,
              backgroundColor: AppColors.cardBackground,
              controller: dateController,
              hintText: "",
            ),
            const SizedBox(
              height: 20,
            ),
            TextWithRequiredIcon(text: "Preferred Pickup Time"),
            DateTextField(
              controller: dateController,
              backgroundColor: AppColors.cardBackground,
              onTap: () => _selectDate(context),
              hintText: dateController.text,
              validator: Validators.notEmpty,
            ),
            const SizedBox(
              height: 16,
            ),
            Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFEF3C7), Color(0xFFFEF9C3)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFCD34D)),
                ),
                child: Column(
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.schedule,
                            color: Color(0xFFF59E0B), size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Timing Note',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ll contact you to confirm the exact pickup time within your preferred date.',
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.orange[800],
                      ),
                    ),
                  ],
                )),
          ],
        ));
  }

  Widget _buildImage() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/camera-add.svg",
                  size: 20,
                  color: AppColors.blue,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Upload Image",
                  style: TextStyle(
                      color: AppColors.headingText,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            TextWithRequiredIcon(text: "Package image"),
            ImageUpload(
              onPressed: _pickImage,
              backgroundColor: AppColors.cardBackground,
              controller: dateController,
              hintText: "",
            )
          ],
        ));
  }
}

Widget buildIconcard(
    {required icon, required backgroundColor, required color, required title}) {
  return Row(children: [
    Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: backgroundColor, borderRadius: BorderRadius.circular(8)),
      child: CustomIcon(
        iconPath: icon,
        size: 20,
        color: color,
      ),
    ),
    const SizedBox(
      width: 8,
    ),
    Text(
      title,
      style: TextStyle(
          color: AppColors.headingText,
          fontWeight: FontWeight.bold,
          fontSize: 20),
    ),
  ]);
}
