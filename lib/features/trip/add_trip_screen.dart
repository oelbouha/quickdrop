import 'package:quickdrop_app/core/utils/imports.dart';

class AddTripScreen extends StatefulWidget {
  const AddTripScreen({Key? key}) : super(key: key);

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen>   with TickerProviderStateMixin {
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final weightController = TextEditingController();
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
    // 'Package Dimensions',
    'Timing & Image',
  ];

  final List<IconData> _stepIcons = [
    Icons.inventory_2_outlined,
    Icons.location_on_outlined,
    // Icons.straighten_outlined,
    Icons.schedule_outlined,
  ];


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

  void _listTrip() async {
    if (_isListButtonLoading) return;
    setState(() {
      _isListButtonLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      // final userProvider = Provider.of<UserProvider>(context);
      // final user = userProvider.user;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        AppUtils.showDialog(
            context, 'Please log in to list a shipment', AppColors.error);
        return;
      }

      Trip trip = Trip(
          from: fromController.text,
          to: toController.text,
          weight: weightController.text,
          date: dateController.text,
          userId: user.uid,
          price: priceController.text);
      try {
        await Provider.of<TripProvider>(context, listen: false).addTrip(trip);
        if (mounted) {
          Navigator.pop(context);
          AppUtils.showDialog(
              context, 'Trip listed Successfully!', AppColors.succes);
          Provider.of<StatisticsProvider>(context, listen: false)
              .incrementField(user.uid, "pendingTrips");
        }
      } catch (e) {
        if (mounted)
          AppUtils.showDialog(
              context, 'Failed to list Trip ${e}', AppColors.error);
      } finally {
        setState(() {
          _isListButtonLoading = false;
        });
      }
    } else {
      AppUtils.showDialog(context, 'some fields are empty', AppColors.error);
    }
    setState(() {
      _isListButtonLoading = false;
    });
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

void _initializeDefaults() {
    weightController.text = "1";
    fromController.text = "cassa";
    toController.text = "martil";
  }

  @override
  void initState() {
    super.initState();
    _initializeDefaults();
    _setupAnimations();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pageController.dispose();
    fromController.dispose();
    toController.dispose();
    weightController.dispose();
    dateController.dispose();
    priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.appBarBackground,
          title: const Text(
            "Add your trip",
            style: TextStyle(color: AppColors.white),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
              child: Form(
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
                          _buildPackageDestails(),
                          // _buildPackageDimensions(),
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
              )
            ),
        ));
  }


  void _showErrorWithAnimation(String message) {
    AppUtils.showDialog(context, message, AppColors.error);
    HapticFeedback.heavyImpact();
  }



  bool _validateCurrentStep() {
    switch (_currentStep) {
      case 1: // Package Details
       
        
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
                          ? _listTrip
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

  Widget _buildPackageDestails() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.lessImportant,
                width: AppTheme.textFieldBorderWidth),
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/map-point.svg",
                  size: 20,
                  color: AppColors.blue,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Trip Details",
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
            TextFieldWithHeader(
              controller: priceController,
              hintText: "Available weight",
              headerText: "Available Weight",
              validator: Validators.notEmpty,
              keyboardType: TextInputType.number,
            ),
            const SizedBox(
              height: 10,
            ),
            TextFieldWithHeader(
              controller: priceController,
              hintText: "Price",
              headerText: "Price",
              validator: Validators.notEmpty,
              keyboardType: TextInputType.number,
            ),
          ],
        ));
  }

  Widget _buildPackageDestination() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.lessImportant,
                width: AppTheme.textFieldBorderWidth),
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/map-point.svg",
                  size: 20,
                  color: AppColors.blue,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Pickup & Delivery Details",
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
          ],
        ));
  }

  Widget _buildTimingDetails() {
    return Container(
        padding: const EdgeInsets.all(AppTheme.addShipmentPadding),
        decoration: BoxDecoration(
            border: Border.all(
                color: AppColors.lessImportant,
                width: AppTheme.textFieldBorderWidth),
            color: AppColors.cardBackground,
            borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
        child: Column(
          // mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                CustomIcon(
                  iconPath: "assets/icon/time.svg",
                  size: 20,
                  color: AppColors.blue,
                ),
                SizedBox(
                  width: 8,
                ),
                Text(
                  "Timing",
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
            TextWithRequiredIcon(text: "Preferred Pickup Time"),
            DateTextField(
              controller: dateController,
              backgroundColor: AppColors.cardBackground,
              onTap: () => _selectDate(context),
              hintText: dateController.text,
              validator: Validators.notEmpty,
            ),
          ],
        ));
  }
}
