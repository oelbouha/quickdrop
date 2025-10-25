import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/location_textfield.dart';

class AddTripScreen extends StatefulWidget {
  final Trip? existingTrip;
  final bool isEditMode;

  AddTripScreen({Key? key, this.existingTrip, this.isEditMode = false});

  @override
  State<AddTripScreen> createState() => _AddTripScreenState();
}

class _AddTripScreenState extends State<AddTripScreen>
    with TickerProviderStateMixin {
    
    final fromController = TextEditingController();
    final toController = TextEditingController();
    final dateController = TextEditingController();
    final weightController = TextEditingController();
    final priceController = TextEditingController();
    List<TextEditingController> middleStopControllers = [];


    final transportTypeController = TextEditingController();

    bool _isListButtonLoading = false;
    final _formKey = GlobalKey<FormState>();

  late AnimationController _fadeController;
  late AnimationController _slideController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  int _currentStep = 0;
  final _pageController = PageController();

  // final List<String> stepTitles = [
  //   'Package Details',
  //   'Delivery Locations',
  //   // 'Package Dimensions',
  //   'Timing & Image',
    
  // ];

   List<String> getSteps(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return [
      t.tip_1_step, t.tip_2_step, t.tip_3_step
    ];
  }

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

  void _updateTrip() async {

    Trip trip = Trip(
          id: widget.existingTrip!.id,
          from: fromController.text,
          to: toController.text,
          weight: weightController.text,
          date: dateController.text,
          userId: widget.existingTrip!.userId,
          price: priceController.text,
          transportType: transportTypeController.text,
          );
    //  print("existing shipment id: ${widget.existingShipment!.id}");
    await Provider.of<TripProvider>(context, listen: false)
        .updateTrip(widget.existingTrip!.id!, trip);
  }

  void _listTrip() async {
    if (_isListButtonLoading) return;
    final loc = AppLocalizations.of(context)!;

    setState(() {
      _isListButtonLoading = true;
    });
    if (_formKey.currentState!.validate()) {
      // final userProvider = Provider.of<UserProvider>(context);
      // final user = userProvider.user;

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        AppUtils.showDialog(
            context, loc.login_required, AppColors.error);
        return;
      }

      Trip trip = Trip(
          from: fromController.text,
          to: toController.text,
          weight: weightController.text,
          date: dateController.text,
          userId: user.uid,
          price: priceController.text,
          transportType: transportTypeController.text,
          middleStops: middleStopControllers.map((controller) => controller.text).where((text) => text.isNotEmpty).toList(),
          );

      try {
        if (widget.isEditMode) {
          _updateTrip();
          await showSuccessAnimation(context,
                  title: widget.isEditMode ? loc.trip_update_success_title : loc.trip_list_success_title,
                  message:  widget.isEditMode ? loc.trip_update_success_message : loc.trip_list_success_message,
                );
        } else {
          await Provider.of<TripProvider>(context, listen: false).addTrip(trip);
          if (mounted) {
            Provider.of<StatisticsProvider>(context, listen: false)
                .incrementField(user.uid, "pendingTrips");
             await showSuccessAnimation(context,
                  title: widget.isEditMode ? loc.trip_update_success_title : loc.trip_list_success_title,
                  message:  widget.isEditMode ? loc.trip_update_success_message : loc.trip_list_success_message,
                );
          }
        }
      } catch (e) {
        if (mounted) {
          AppUtils.showDialog(
              context, loc.trip_list_failed, AppColors.error);
        }
      } finally {
        setState(() {
          _isListButtonLoading = false;
        });
      }
    } else {
      AppUtils.showDialog(context, loc.fields_empty, AppColors.error);
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
    if (widget.isEditMode && widget.existingTrip != null) {
      fromController.text = widget.existingTrip?.from ?? '';
      toController.text = widget.existingTrip?.to ?? '';
      weightController.text = widget.existingTrip?.weight ??   '';
      dateController.text = widget.existingTrip?.date ?? '';
      priceController.text = widget.existingTrip?.price ?? '';
      transportTypeController.text = widget.existingTrip?.transportType ?? 'Car';
    } else {
      weightController.text = "1";
      // fromController.text = "cassa";
      // toController.text = "martil";
      transportTypeController.text = "Car";
    }
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
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title:  Text(
          widget.isEditMode ? loc.update_trip : loc.create_trip,
          style: const TextStyle(
            color: AppColors.headingText,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(
          color: Colors.black, 
        ),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body:  Form(
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
                              _buildTripDetails(),
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

  Widget _buildTripDetails() {
    final loc = AppLocalizations.of(context)!;
    return _buildStepContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.inventory_2_outlined,
            title: loc.trip_details,
            color: AppColors.blue700,
            backgroundColor: AppColors.blue700.withOpacity(0.1),
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: priceController,
            hintText: "0.00",
            label: loc.delivery_price,
            validator: Validators.isNumber,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          AppTextField(
            controller: weightController,
            hintText: "0.00",
            label: loc.available_weight,
            validator: Validators.isNumber,
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 20),
          StatusCard(
            icon: Icons.info_outline,
            title: loc.pricing_tip_title,
            message:  loc.pricing_tip_message,    
                    color: Colors.blue,
          ),
        ],
      ),
    );
  }


  bool _validateCurrentStep() {
    final loc = AppLocalizations.of(context)!;
    switch (_currentStep) {
      case 0: // Locations
        if (fromController.text.isEmpty) {
          AppUtils.showDialog(context, loc.pickup_required, AppColors.error);
          return false;
        }
        if (toController.text.isEmpty) {
          AppUtils.showDialog(context,loc.delivery_required, AppColors.error);
          return false;
        }
        return true;
      case 1: // Package Details
        if (priceController.text.isEmpty) {
          AppUtils.showDialog(context,loc.price_required, AppColors.error);
          return false;
        }
        if (Validators.isNumber(priceController.text) != null) {
          AppUtils.showDialog(context,loc.price_number, AppColors.error);
          return false;
        }
        return true;
      case 2: // Dimensions
        if (weightController.text.isEmpty) {
          AppUtils.showDialog(context,loc.weight_required, AppColors.error);
          return false;
        }
        if (Validators.isNumber(weightController.text) != null) {
          AppUtils.showDialog(context,loc.weight_number, AppColors.error);
          return false;
        }
        return true;
      case 3: // Timing
        if (dateController.text.isEmpty) {
          AppUtils.showDialog(context,loc.pickup_date_required, AppColors.error);
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
    final loc = AppLocalizations.of(context)!;
    final stepTitles = getSteps(context);

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
                  label:  Text(loc.back),
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
                      : (_currentStep == stepTitles.length - 1
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
                          _currentStep == stepTitles.length - 1
                              ? Icons.check
                              : Icons.arrow_forward,
                          size: 18,
                        ),
                  label: Text(
                    _isListButtonLoading
                        ? loc.processing
                        : (_currentStep == stepTitles.length - 1
                            ?  widget.isEditMode ? loc.update_trip : loc.create_trip
                            : loc.cntinue),
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
    final stepTitles = getSteps(context);
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
                children: List.generate(stepTitles.length, (index) {
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
                        if (index < stepTitles.length - 1)
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
            ],
          ),
        ));
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

  Widget _buildPackageDestination() {
    final loc = AppLocalizations.of(context)!;
    return _buildStepContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.location_on_outlined,
            title: loc.trip_locations,
            color: const Color(0xFF10B981),
            backgroundColor: const Color(0xFFD1FAE5),
          ),
          const SizedBox(height: 24),
          LocationTextField(
              controller: fromController,
              hintText: loc.pickup_location,
              headerText: loc.from_hint,
              iconColor: Theme.of(context).colorScheme.primary,
            ),
          const SizedBox(height: 16),

            // MIDDLE STOPS (dynamically added)
    ...List.generate(middleStopControllers.length, (index) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: LocationTextField(
          controller: middleStopControllers[index],
          hintText: loc.middle_stop_hint, 
          headerText: "${loc.stop} ${index + 1}", 
          iconColor: Theme.of(context).colorScheme.secondary,
        ),
      );
    }),

  TextButton.icon(
  onPressed: () {
    setState(() {
      middleStopControllers.add(TextEditingController());
    });
  },
  icon: const Icon(Icons.add_location_alt_outlined, color: Colors.green),
  label: Text(
    loc.add_stop,
    style: const TextStyle(color: Colors.green),
  ),
),
const SizedBox(height: 8),
Container(
  decoration: BoxDecoration(
    color: const Color(0xFFE0F2F1),
    borderRadius: BorderRadius.circular(8),
  ),
  padding: const EdgeInsets.all(8),
  child: Row(
    children: [
      const Icon(Icons.info_outline, size: 18, color: Colors.teal),
      const SizedBox(width: 8),
      Expanded(
        child: Text(
          loc.add_stop_hint,
          style: const TextStyle(fontSize: 13, color: Colors.teal),
        ),
      ),
    ],
  ),
),



    const SizedBox(height: 16),

         
          LocationTextField(
              controller: toController,
              hintText: loc.delivery_location,
              headerText: loc.to_hint,
              iconColor: Theme.of(context).colorScheme.primary,
            ),
          const SizedBox(height: 20),
          StatusCard(
            icon: Icons.location_on,
            title: loc.location_tip_title,
            message:loc.location_tip_message,
            color: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildTimingDetails() {
    final loc = AppLocalizations.of(context)!;
    return _buildStepContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: Icons.schedule_outlined,
            title: loc.timing,
            color: const Color(0xFFF59E0B),
            backgroundColor: const Color(0xFFFEF3C7),
          ),
          const SizedBox(height: 20),
          RequiredFieldLabel(text: loc.pickup_date),
          const SizedBox(height: 8),
          DateTextField(
            controller: dateController,
            backgroundColor: AppColors.cardBackground,
            onTap: () => _selectDate(context),
            hintText: loc.select_pickup_date,
            validator: Validators.notEmpty,
          ),
          const SizedBox(height: 20),
          
          RequiredFieldLabel(text: loc.transport_type),
          TypeSelectorWidget(
            onTypeSelected: (type) {
              transportTypeController.text = type;
            },
            initialSelection: loc.car,
            types:  [loc.car, loc.truck, loc.motorcycle, loc.van, loc.scooter],
            selectedColor: AppColors.blue600,
            unselectedColor: AppColors.textSecondary,
          ),
          const SizedBox(height: 20),
          StatusCard(
            icon: Icons.schedule,
            title: loc.timing_tip_title,
            message: loc.timing_tip_message,
            color: Colors.orange,
          ),
        ],
      ),
    );
  }
}
