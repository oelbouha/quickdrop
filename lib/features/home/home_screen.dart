import 'package:cached_network_image/cached_network_image.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/build_header_icon.dart';
import 'package:quickdrop_app/core/widgets/home_page_skeleton.dart';
import 'package:quickdrop_app/features/home/search_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool _isLoading = true;
  UserData? user;
  String selectedFilter = "Trip";
  int? expandedFaqIndex;

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  final typeController = TextEditingController();
  final dateController = TextEditingController();

  final List<String> filterOptions = [
    "All",
    "Documents",
    "Electronics",
    "Apparel",
    "Other"
  ];

  final List<String> serviceTypes = [
    "Trip",
    "Shipment",
  ];

  final List<Map<String, String>> faqs = [
    {
      "question": "How does QuickDrop ensure package safety?",
      "answer": "All couriers are verified through ID checks and background screening. Every package is insured, tracked in real-time, and handled with care by trusted travelers."
    },
    {
      "question": "What can I ship with QuickDrop?",
      "answer": "You can ship documents, electronics, clothing, gifts, and most personal items. Prohibited items include hazardous materials, illegal substances, and fragile items without proper packaging."
    },
    {
      "question": "How much can I save compared to traditional shipping?",
      "answer": "Users typically save 50-70% compared to major carriers like FedEx or UPS, especially for international shipments. Prices vary based on size, weight, and destination."
    },
    {
      "question": "How do I become a courier?",
      "answer": "Simply sign up, verify your identity, and start accepting delivery requests on routes you're already traveling. You set your own prices and schedule."
    },
    {
      "question": "What if something goes wrong with my shipment?",
      "answer": "We provide 24/7 customer support and full insurance coverage. If there's any issue, our team will resolve it quickly and ensure you're compensated."
    }
  ];

  @override
  void initState() {
    super.initState();
    typeController.text = "Shipment";
    user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
      // If user is null, redirect to login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          context.go("/login");
        }
      });
      return;
    }
    dateController.text = _getCurrentDate();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        // final shipmentProvider =
        //     Provider.of<ShipmentProvider>(context, listen: false);
        // final tripProvider = Provider.of<TripProvider>(context, listen: false);

        // await shipmentProvider.fetchShipments();
        // await tripProvider.fetchTrips();

        // final userIds = shipmentProvider.shipments.map((r) => r.userId).toSet().toList();
        // final tripUserIds =
        //     tripProvider.trips.map((r) => r.userId).toSet().toList();

        // await Provider.of<UserProvider>(context, listen: false)
        //     .fetchUsersData(userIds);
        // await Provider.of<UserProvider>(context, listen: false)
        //     .fetchUsersData(tripUserIds);
      } catch (e) {
        if (mounted) {
          AppUtils.showDialog(
              context, 'Error fetching shipments: $e', AppColors.error);
        }
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
     return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent, //  background transparent
        statusBarIconBrightness: Brightness.dark, // dark icons (black)
        statusBarBrightness: Brightness.light,   // iOS
      ),
      child: Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF8FAFC),
        ),
        child: SafeArea(
          child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        // color: AppColors.blue,
                      ),
                      child: _buildAppBar(),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 24),
                            _buildHeroSection(),
                            const SizedBox(height: 32),
                            _buildOurServices(),
                            const SizedBox(height: 32),
                            _buildFAQSection(),
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    ));
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        const Text(
          "Ship anywhere, anytime",
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F2937),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        const Text(
          "Connect with trusted travelers and ship your packages for up to 70% less than traditional carriers.",
          style: TextStyle(
            color: Color(0xFF6B7280),
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        _buildSearchSection(),
      ],
    );
  }


  void perfumeSearch() async {
     SearchFilters filters = SearchFilters(
      from: fromController.text.isEmpty ? null : fromController.text,
      to: toController.text.isEmpty ? null : toController.text,
      price: priceController.text.isEmpty ? null : priceController.text,
      weight: weightController.text.isEmpty ? null : weightController.text,
      type: selectedFilter
    );

    context.push(
    '/search',
    extra: filters,
  );
  }
  Widget _buildSearchSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 16,
        children: [
          // Origin field
          TextFieldWithHeader(
              controller: fromController,
              displayHeader: false,
              hintText: "From",
              headerText: "To",
              isRequired: false,
              validator: Validators.notEmpty,
              iconPath: "assets/icon/map-point.svg"
            ),
          // Destination field
          TextFieldWithHeader(
              controller: toController,
              displayHeader: false,
               isRequired: false,
              hintText: "To",
              headerText: "To",
              validator: Validators.notEmpty,
              iconPath: "assets/icon/map-point.svg"
            ),
          // Filter chips
          _buildServiceTypes(),
          // Date field
          DateTextField(
            controller: dateController,
            backgroundColor: AppColors.cardBackground,
            onTap: () => _selectDate(context),
            hintText: "Select pickup date",
            validator: Validators.notEmpty,
          ),

          // Search button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => perfumeSearch(),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2563EB),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              child: const Text(
                "Find Couriers",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchField({
    required TextEditingController controller,
    required String hintText,
    required String icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),

        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontSize: 16,
          ),
          prefixIcon: CustomIcon(
            iconPath: "assets/icon/car.svg",
            color: const Color(0xFF9CA3AF),
            size: 20,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
        ),
        style: const TextStyle(
          fontSize: 16,
          color: Color(0xFF1F2937),
        ),
      ),
    );
  }

  Widget _buildServiceTypes() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: serviceTypes.map((filter) {
          final isSelected = selectedFilter == filter;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF6B7280),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  selectedFilter = filter;
                });
              },
              backgroundColor: const Color(0xFFF3F4F6),
              selectedColor: const Color(0xFF2563EB),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide.none,
              ),
              showCheckmark: false,
            ),
          );
        }).toList(),
      ),
    );
  }

  String _getCurrentDate() {
    final date = DateTime.now();
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
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

  Widget _buildOurServiceCard(String title, String description, String iconPath,
      String backgroundImageUrl) {
    return Container(
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Background Image
            Positioned.fill(
              child: Image.asset(
                backgroundImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.blue600, AppColors.blue700],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Blue overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      AppColors.dark.withValues(alpha: 0.3),
                      AppColors.dark.withValues(alpha: 0.3),
                    ],
                  ),
                ),
              ),
            ),
            // Content
            Positioned.fill(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Icon and title
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: CustomIcon(
                            iconPath: iconPath,
                            size: 20,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Description
                    Expanded(
                      child: Text(
                        description,
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          height: 1.5,
                        ),
                      ),
                    ),
                    // Features
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildFeatureTag("Instant quotes"),
                        _buildFeatureTag("Real-time tracking"),
                        _buildFeatureTag("Insurance included"),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildOurServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // const Text(
        //   "How it works",
        //   style: TextStyle(
        //     color: AppColors.textPrimary,
        //     fontSize: 24,
        //     fontWeight: FontWeight.bold,
        //   ),
        // ),
        // const SizedBox(height: 20),
        _buildOurServiceCard(
          "Send Packages",
          "Connect with verified travelers heading to your destination. Save up to 70% on shipping costs with our trusted courier network.",
          "assets/icon/package.svg",
          "assets/images/back1.png",
        ),
        const SizedBox(height: 20),
        _buildOurServiceCard(
          "Become a Courier",
          "Turn your trips into earnings. Carry packages and make money on routes you're already taking. Set your own prices and schedule.",
          "assets/icon/car.svg",
          "assets/images/back2.png",
        ),
      ],
    );
  }

  Widget _buildFAQSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Frequently Asked Questions",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: faqs.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final faq = faqs[index];
            final isExpanded = expandedFaqIndex == index;
            
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFFE5E7EB),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      setState(() {
                        expandedFaqIndex = isExpanded ? null : index;
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              faq["question"]!,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                          ),
                          Icon(
                            isExpanded
                                ? Icons.keyboard_arrow_up
                                : Icons.keyboard_arrow_down,
                            color: const Color(0xFF6B7280),
                            size: 24,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (isExpanded)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(
                        faq["answer"]!,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xFF6B7280),
                          height: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
 
 
 
 Widget _buildAppBar() {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.push("/profile"),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.blue, width: 2),
            ),
            child: ClipRRect(
             borderRadius: BorderRadius.circular(21),
            child: CachedNetworkImage(
            imageUrl:  user!.photoUrl!,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  color: AppColors.blueStart.withValues(alpha: 0.1),
                ),
                child: const Center(
                    child: CircularProgressIndicator(color: AppColors.blue700, strokeWidth: 2))),
            errorWidget: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.blueStart.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: const Icon(
                      Icons.person,
                      color: AppColors.blueStart,
                      size: 24,
                    ),
                  );
                },
          )
            ),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            buildHeaderIcon(
              icon: "assets/icon/help.svg",
              onTap: () => context.push("/help"),
              color: AppColors.textSecondary
            ),
            const SizedBox(width: 16),
            const NotificationIcon(),
          ],
        ),
        // const Spacer(),
        
      ],
    );
  }


  Widget _buildShipmentCard(Shipment shipment, UserData userData) {
    return ShipmentCard(
      shipment: shipment,
      userData: userData,
      onPressed: () {
        context.push(
            '/shipment-details?shipmentId=${shipment.id}&userId=${shipment.userId}&viewOnly=false');
      },
    );
  }

  Widget _buildTripcard(Trip trip, UserData userData) {
    return ShipmentCard(
      shipment: trip,
      userData: userData,
      onPressed: () {
        context.push(
            '/trip-details?tripId=${trip.id}&userId=${trip.userId}&viewOnly=false');
      },
    );
  }
}

Widget searchTextField({
  required String hintText,
  required TextEditingController controller,
  String iconPath = "",
  Color iconColor = AppColors.blue600,
}) {
  return TextFormField(
    style: const TextStyle(
      color: AppColors.textPrimary,
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    controller: controller,
    decoration: InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.borderGray200,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: AppColors.blue600,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12),
        child: CustomIcon(
          iconPath: iconPath,
          size: 20,
          color: AppColors.blue600,
        ),
      ),
      hintText: hintText,
      hintStyle: const TextStyle(
        color: AppColors.textMuted,
        fontSize: 16,
      ),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}