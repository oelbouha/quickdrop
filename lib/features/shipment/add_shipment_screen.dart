import 'dart:io'; // Import File class
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/dropDownTextField.dart';

export 'package:quickdrop_app/core/widgets/tipWidget.dart';

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

  int _currentStep = 0;
  final _pageController = PageController();

  final List<String> _stepTitles = [
    'Package Details',
    'Delivery Locations',
    'Package Dimensions',
    'Timing & Image',
  ];

  final List<IconData> _stepIcons = [
    Icons.inventory_2_outlined,
    Icons.location_on_outlined,
    Icons.straighten_outlined,
    Icons.schedule_outlined,
  ];

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
    _setupAnimations();
  }

  void _initializeDefaults() {
    packageQuantityController.text = "1";
    weightController.text = "1";
    typeController.text = "water";
    fromController.text = "cassa";
    toController.text = "martil";
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
    _pageController.dispose();
    // Dispose all controllers
    fromController.dispose();
    toController.dispose();
    weightController.dispose();
    descriptionController.dispose();
    dateController.dispose();
    lengthController.dispose();
    widthController.dispose();
    heightController.dispose();
    packageNameController.dispose();
    packageQuantityController.dispose();
    typeController.dispose();
    priceController.dispose();
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

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        AppUtils.showDialog(
            context, 'Please log in to list a shipment', AppColors.error);
        setState(() {
          _isListButtonLoading = false;
        });
        return;
      }

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
            Navigator.of(dialogContext).pop();
            Navigator.of(context).pop();
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
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Create Shipment',
          style: TextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
            color: Colors.black, // Set the arrow back color to black
          ),
          systemOverlayStyle:
              SystemUiOverlayStyle.dark,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProgressBar(),

            Expanded(
              child: AnimatedBuilder(
                animation: _slideAnimation,
                builder: (context, child) {
                  return Transform.translate(
                    offset: _slideAnimation.value,
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          _buildPackageDestination(),
                          _buildPackageDetails(),
                          _buildPackageDimensions(),
                          _buildTimingDetails(),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Enhanced Navigation Buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
        // alignment: ali,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(color: AppColors.background
            // gradient: LinearGradient(
            //   begin: Alignment.topLeft,
            //   end: Alignment.bottomRight,
            //   colors: [
            //     AppColors.blue700,
            //     Colors.purple,
            //   ],
            // ),
            ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Step indicators with connecting lines
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_stepTitles.length, (index) {
                  final isActive = _currentStep >= index;
                  final isCurrent = _currentStep == index;

                  return Flexible(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Step circle
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: isCurrent ? 36 : 28,
                          height: isCurrent ? 36 : 28,
                          decoration: BoxDecoration(
                            color:
                                isActive ? AppColors.blue700 : Colors.grey[300],
                            shape: BoxShape.circle,
                            boxShadow: isCurrent
                                ? [
                                    BoxShadow(
                                      color: AppColors.blue700.withOpacity(0.3),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Center(
                            child: isActive && _currentStep > index
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 16)
                                : Icon(
                                    _stepIcons[index],
                                    color: isActive
                                        ? Colors.white
                                        : Colors.grey[600],
                                    size: isCurrent ? 18 : 16,
                                  ),
                          ),
                        ),
                        // Connecting line (except for last item)
                        if (index < _stepTitles.length - 1)
                          Flexible(
                            child: Container(
                              height: 2,
                              margin: const EdgeInsets.symmetric(horizontal: 8),
                              decoration: BoxDecoration(
                                color: _currentStep > index
                                    ? AppColors.blue700
                                    : Colors.grey[300],
                                borderRadius: BorderRadius.circular(1),
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
              ),

              // const SizedBox(height: 12),

              // // Current step title
              // AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 300),
              //   child: Text(
              //     _stepTitles[_currentStep],
              //     key: ValueKey(_currentStep),
              //     style: TextStyle(
              //       fontSize: 16,
              //       fontWeight: FontWeight.w600,
              //       color: AppColors.headingText,
              //     ),
              //   ),
              // ),

              // const SizedBox(height: 8),

              // Progress bar
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(4),
              //   child: LinearProgressIndicator(
              //     value: (_currentStep + 1) / _stepTitles.length,
              //     backgroundColor: Colors.grey[200],
              //     valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue700),
              //     minHeight: 6,
              //   ),
              // ),
            ],
          ),
        ));
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button
            if (_currentStep > 0) ...[
              Expanded(
                flex: 2,
                child: OutlinedButton.icon(
                  onPressed: _goToPreviousStep,
                  icon: const Icon(Icons.arrow_back, size: 18),
                  label: const Text('Back'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    side: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              const SizedBox(width: 12),
            ],

            // Next/Submit button
            Expanded(
              flex: 3,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton.icon(
                  onPressed: _isListButtonLoading
                      ? null
                      : (_currentStep == _stepTitles.length - 1
                          ? _listShipment
                          : _goToNextStep),
                  icon: _isListButtonLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : Icon(
                          _currentStep == _stepTitles.length - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                          size: 18,
                        ),
                  label: Text(
                    _isListButtonLoading
                        ? 'Processing...'
                        : (_currentStep == _stepTitles.length - 1
                            ? 'Create Shipment'
                            : 'Continue'),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 1: // Package Details
        if (packageNameController.text.isEmpty) {
          _showErrorWithAnimation('Package name is required');
          return false;
        }
        if (descriptionController.text.isEmpty) {
          _showErrorWithAnimation('Description is required');
          return false;
        }
        if (typeController.text.isEmpty) {
          _showErrorWithAnimation('Package type is required');
          return false;
        }
        if (priceController.text.isEmpty) {
          _showErrorWithAnimation('Price is required');
          return false;
        }
        return true;
      case 0: // Locations
        if (fromController.text.isEmpty) {
          _showErrorWithAnimation('Pickup location is required');
          return false;
        }
        if (toController.text.isEmpty) {
          _showErrorWithAnimation('Delivery location is required');
          return false;
        }
        return true;
      case 2: // Dimensions
        if (weightController.text.isEmpty) {
          _showErrorWithAnimation('Weight is required');
          return false;
        }
        if (packageQuantityController.text.isEmpty) {
          _showErrorWithAnimation('Quantity is required');
          return false;
        }
        return true;
      case 3: // Timing
        if (dateController.text.isEmpty) {
          _showErrorWithAnimation('Pickup date is required');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  void _goToNextStep() {
    if (_validateCurrentStep()) {
      HapticFeedback.lightImpact();
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _goToPreviousStep() {
    HapticFeedback.lightImpact();
    _pageController.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep--);
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
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.blue700,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  Widget _buildStepContainer({required Widget child}) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Container(
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
        child: child,
      ),
    );
  }

  Widget _buildPackageDetails() {
    return _buildStepContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.inventory_2_outlined,
            title: "Package Details",
            color: AppColors.blue700,
            backgroundColor: AppColors.blue700.withOpacity(0.1),
          ),
          const SizedBox(height: 24),

          TextFieldWithHeader(
            controller: packageNameController,
            headerText: "Package Name",
            hintText: "e.g., Phone case, Book, Documents",
            obsecureText: false,
            keyboardType: TextInputType.text,
            validator: Validators.notEmpty,
          ),
          const SizedBox(height: 16),

          TextFieldWithHeader(
            controller: descriptionController,
            hintText: "Describe your package content in detail...",
            headerText: "Package Description",
            maxLines: 3,
            validator: Validators.notEmpty,
           
          ),
          const SizedBox(height: 16),
          TextFieldWithHeader(
            controller: priceController,
            hintText: "0.00",
            headerText: "Delivery Price (MAD)",
            validator: Validators.notEmpty,
            keyboardType: TextInputType.number,
          ),
          // Row(
          //   children: [
          //     Expanded(
          //       child: TextFieldWithHeader(
          //         controller: priceController,
          //         hintText: "0.00",
          //         headerText: "Delivery Price (MAD)",
          //         validator: Validators.notEmpty,
          //         keyboardType: TextInputType.number,
          //       ),
          //     ),
          //     const SizedBox(width: 12),
          //     Expanded(
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           TextWithRequiredIcon(text: "Package Type"),
          //           const SizedBox(height: 4),
          //           DropdownTextField(
          //             validator: Validators.notEmpty,
          //             controller: typeController,
          //           ),
          //         ],
          //       ),
          //     ),
          //   ],
          // ),

          const SizedBox(height: 20),
          buildInfoCard(
            icon: Icons.info_outline,
            title: "Pricing Tip",
            message:
                "Set a competitive price based on distance, package size, and urgency.",
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildPackageDimensions() {
    return _buildStepContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.straighten_outlined,
            title: "Package Dimensions",
            color: const Color(0xFF8B5CF6),
            backgroundColor: const Color(0xFFEDE9FE),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: TextFieldWithHeader(
                  controller: weightController,
                  hintText: "1.0",
                  headerText: "Weight (kg)",
                  keyboardType: TextInputType.number,
                  validator: Validators.notEmpty,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFieldWithHeader(
                  controller: packageQuantityController,
                  hintText: "1",
                  headerText: "Quantity",
                  keyboardType: TextInputType.number,
                  validator: Validators.notEmpty,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            "Dimensions (cm) - Optional",
            style: TextStyle(
              color: AppColors.headingText,
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFieldWithHeader(
                  controller: lengthController,
                  hintText: "0",
                  headerText: "Length",
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
          const SizedBox(height: 20),
          buildInfoCard(
            icon: Icons.scale_outlined,
            title: "Accurate measurements help couriers prepare",
            message:
                "Providing dimensions helps couriers choose appropriate transport.",
            color: Colors.purple,
          ),
        ],
      ),
    );
  }

  Widget _buildPackageDestination() {
    return _buildStepContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.location_on_outlined,
            title: "Delivery Locations",
            color: const Color(0xFF10B981),
            backgroundColor: const Color(0xFFD1FAE5),
          ),
          const SizedBox(height: 24),
          TextFieldWithHeader(
            controller: fromController,
            hintText: "From",
            headerText: "Pickup Location",
            validator: Validators.notEmpty,
             iconPath : "assets/icon/map-point.svg"
          ),
          const SizedBox(height: 16),
          TextFieldWithHeader(
            controller: toController,
            hintText: "To",
            headerText: "Delivery Location",
            validator: Validators.notEmpty,
             iconPath : "assets/icon/map-point.svg"
          ),
          const SizedBox(height: 20),
          buildInfoCard(
            icon: Icons.location_on,
            title: "Location Details Matter",
            message:
                "Include landmarks, building numbers, and floor details for smoother pickup and delivery.",
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildTimingDetails() {
    return _buildStepContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.schedule_outlined,
            title: "Timing & Image",
            color: const Color(0xFFF59E0B),
            backgroundColor: const Color(0xFFFEF3C7),
          ),
          const SizedBox(height: 24),
          TextWithRequiredIcon(text: "Package Image"),
          const SizedBox(height: 8),
          ImageUpload(
            onPressed: _pickImage,
            backgroundColor: AppColors.cardBackground,
            controller: dateController,
            hintText: "",
          ),
          const SizedBox(height: 20),
          TextWithRequiredIcon(text: "Preferred Pickup Date"),
          const SizedBox(height: 8),
          DateTextField(
            controller: dateController,
            backgroundColor: AppColors.cardBackground,
            onTap: () => _selectDate(context),
            hintText: "Select pickup date",
            validator: Validators.notEmpty,
          ),
          const SizedBox(height: 20),
          buildInfoCard(
            icon: Icons.schedule,
            title: "Flexible Timing",
            message:
                "We'll contact you to confirm the exact pickup time within your preferred date.",
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required Color color,
    required Color backgroundColor,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            size: 20,
            color: color,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
