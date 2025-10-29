import 'package:cached_network_image/cached_network_image.dart';
import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/notification_icon.dart';
import 'package:quickdrop_app/core/widgets/location_textfield.dart';
import 'package:quickdrop_app/features/home/search_page.dart';
import 'package:quickdrop_app/core/widgets/profile_avatar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  UserData? user;
  String? selectedFilter;
  int? expandedFaqIndex;

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  final typeController = TextEditingController();
  final dateController = TextEditingController();

  List<String> getServiceTypes(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return [
      t.trips,
      t.shipments,
    ];
  }



  List<Map<String, String>> getFaqs(BuildContext context) {
    final t = AppLocalizations.of(context)!;

    return [
      {"question": t.faq_q1, "answer": t.faq_a1},
      {"question": t.faq_q2, "answer": t.faq_a2},
      {"question": t.faq_q3, "answer": t.faq_a3},
      {"question": t.faq_q4, "answer": t.faq_a4},
      {"question": t.faq_q5, "answer": t.faq_a5},
    ];
  }



  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    selectedFilter = AppLocalizations.of(context)!.trips;
  }



  @override
  void initState() {
    super.initState();

    typeController.text = "Shipment";

    user = Provider.of<UserProvider>(context, listen: false).user;
    if (user == null) {
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
        final user = Provider.of<UserProvider>(context, listen: false).user;
          final subscriptionEndAt = user?.subscriptionEndsAt;
        final now = DateTime.now();
        if (subscriptionEndAt != null) {
          final endDate = DateTime.parse(subscriptionEndAt);
          if (now.isAfter(endDate)) {
            Provider.of<UserProvider>(context, listen: false).updateSubscriptionStatus("expired");
          }
        }
      } catch(e) {
        print("Error checking subscription status: $e");
      }
    //   try {
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


      // } catch (e) {
      //   if (mounted) {
      //     AppUtils.showDialog(context, 'Error fetching shipments: $e', AppColors.error);
      //   }
      // }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark.copyWith(
          statusBarColor: Colors.transparent, //  background transparent
          statusBarIconBrightness: Brightness.dark, // dark icons (black)
          statusBarBrightness: Brightness.light, // iOS
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: const BoxDecoration(
                        // color: AppColors.blue,
                        ),
                    child: _buildAppBar(),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16),
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
    final t = AppLocalizations.of(context)!;
    return Column(
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
            children: [
              TextSpan(
                text: "${t.home_title_part1}\n",
                style: const TextStyle(color: Color(0xFF1F2937)),
              ),
              TextSpan(
                text: t.home_title_part2,
                style: TextStyle(
                  foreground: Paint()
                    ..shader = LinearGradient(
                      colors: [
                        Theme.of(context).colorScheme.primary,
                        Theme.of(context).colorScheme.primary,
                      ],
                    ).createShader(
                      Rect.fromLTWH(0.0, 0.0, 200.0, 70.0),
                    ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          t.intro_description,
          style: const TextStyle(
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

    final serviceTypes = getServiceTypes(context);

    SearchFilters filters = SearchFilters(
        from: fromController.text.isEmpty ? null : fromController.text,
        to: toController.text.isEmpty ? null : toController.text,
        price: priceController.text.isEmpty ? null : priceController.text,
        weight: weightController.text.isEmpty ? null : weightController.text,
        type:  serviceTypes[0] ==  selectedFilter ? "Trip" : "Shipment",
        date: dateController.text.isEmpty ? null : dateController.text
      );

    context.push(
      '/search',
      extra: filters,
    );
  }

  Widget _buildSearchSection() {
    final t = AppLocalizations.of(context)!;
    bool isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
              blurRadius: 20,
              offset: Offset(0, 10),
            ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Column(
                children: [

                  LocationTextField(
                    controller: fromController,
                    hintText: t.pickup_location,
                    headerText: t.from_hint,
                    iconColor: Theme.of(context).colorScheme.primary,
                    displayHeader: false,
                    isRequired: false,
                  ),
                 
                  const SizedBox(height: 24), 

                  // Destination field
                  LocationTextField(
                    controller: toController,
                    hintText: t.drop_off_location,
                    headerText: t.to_hint,
                    iconColor: Theme.of(context).colorScheme.primary,
                    displayHeader: false,
                    isRequired: false,
                  ),
                  
                ],
              ),

              // Swap button
              Positioned(
                right: isArabic ? null : 12,
                top: 50,
                left: isArabic ? 12 : null,
                child: GestureDetector(
                  onTap: () {
                    final temp = fromController.text;
                    fromController.text = toController.text;
                    toController.text = temp;
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.tertiary,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const CustomIcon(
                      iconPath: "assets/icon/switch-vertical.svg",
                      size: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Filter chips
          _buildServiceTypes(),
          const SizedBox(height: 16),

          // Date field
          DateTextField(
            controller: dateController,
            backgroundColor: AppColors.cardBackground,
            onTap: () => _selectDate(context),
            hintText: t.select_pickup_date,
            validator: Validators.notEmpty, 
          ),

          const SizedBox(height: 20),

          // Search button
          IconTextButton(
            iconPath: "assets/icon/search.svg",
            hint: t.search,
            isLoading: false,
            onPressed: () => perfumeSearch(),
            backgroundColor: Theme.of(context).colorScheme.primary,
            loadingText: t.saving,
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
    final serviceTypes = getServiceTypes(context);
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
                  color: isSelected
                      ? Colors.white
                      : Theme.of(context).colorScheme.secondary,
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
              selectedColor: Theme.of(context).colorScheme.primary,
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
            colorScheme: const ColorScheme.light(
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
    final t = AppLocalizations.of(context)!;
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
                        _buildFeatureTag(t.feature_tag_1),
                        _buildFeatureTag(t.feature_tag_2),
                        _buildFeatureTag(t.feature_tag_3),
                        _buildFeatureTag(t.feature_tag_4),
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
    final t = AppLocalizations.of(context)!;
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
          t.service_send_title,
          t.service_send_description,
          "assets/icon/package.svg",
          "assets/images/back1.png",
        ),
        const SizedBox(height: 20),
        _buildOurServiceCard(
          t.service_courier_title,
          t.service_courier_description,
          "assets/icon/car.svg",
          "assets/images/back2.png",
        ),
      ],
    );
  }

  Widget _buildFAQSection() {
    final t = AppLocalizations.of(context)!;
    final faqs = getFaqs(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          t.faq_title,
          style: const TextStyle(
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
          onTap: () {
            context.push('/profile');
          },
          child: ProfileAvatar(user: user, size: 48),
        ),
        const Spacer(),
        Row(
          children: [
            buildHeaderIcon(
                icon: "assets/icon/help.svg",
                onTap: () => context.push("/help"),
                color: AppColors.textSecondary),
            const SizedBox(width: 16),
            const NotificationIcon(),
          ],
        ),
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
