import 'package:quickdrop_app/core/utils/imports.dart';
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
  String? userPhotoUrl;
  UserData? user;

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  final typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    typeController.text = "Shipment"; // Default type
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
    userPhotoUrl =
        Provider.of<UserProvider>(context, listen: false).user?.photoUrl;
    if (userPhotoUrl == null || userPhotoUrl!.isEmpty) {
      userPhotoUrl = AppTheme.defaultProfileImage;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final shipmentProvider =
            Provider.of<ShipmentProvider>(context, listen: false);
        final tripProvider = Provider.of<TripProvider>(context, listen: false);

        await shipmentProvider.fetchShipments();
        await tripProvider.fetchTrips();

        final userIds =
            shipmentProvider.shipments.map((r) => r.userId).toSet().toList();
        final tripUserIds =
            tripProvider.trips.map((r) => r.userId).toSet().toList();
        await Provider.of<UserProvider>(context, listen: false)
            .fetchUsersData(userIds);
        await Provider.of<UserProvider>(context, listen: false)
            .fetchUsersData(tripUserIds);
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
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            color: AppColors.background,
          ),
          child: SafeArea(
            child: _isLoading
                ? const HomePageSkeleton()
                : Column(
                    children: [
                      // App Bar
                      Container(
                        // color: Colors.white.withOpacity(0.8),
                         padding: const EdgeInsets.all(16.0),
                        child:  _buildAppBar(),
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
                              _buildValuePropsRow(),
                              // const SizedBox(height: 32),
                              // _buildOurServices(),
                              const SizedBox(height: 24),
                              _buildListingsHeader(),
                              const SizedBox(height: 16),
                              Consumer3<ShipmentProvider, TripProvider,
                                      UserProvider>(
                                  builder: (context, shipmentProvider,
                                      tripProvider, userProvider, child) {
                                return IndexedStack(
                                  index: selectedIndex,
                                  children: [
                                    _buildShipmentListings(
                                        shipmentProvider.activeShipments),
                                    _buildTripListings(
                                        tripProvider.activeTrips),
                                  ],
                                );
                              }),
                              const SizedBox(
                                  height: 100), // Extra space for FAB
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Column(
      children: [
        // Hero Title
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
            colors: [AppColors.blueStart, AppColors.purpleStart],
          ).createShader(bounds),
          child: const Text(
            "Ship Anywhere, Anytime",
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 16),
        // Subtitle
        const Text(
          "Connect with travelers going your way or send packages with trusted community members",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        // Search Section
        _buildSearchSection(),
      ],
    );
  }

  Widget _buildSearchSection() {
    return GestureDetector(
      onTap: () => context.push("/search"),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: AppColors.borderGray200,
            width: 2,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIcon(
              iconPath: "assets/icon/magnifer.svg",
              color: AppColors.textMuted,
              size: 24,
            ),
            SizedBox(width: 12),
            Text(
              "Search packages & trips...",
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValuePropsRow() {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundBlur,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomIcon(
                  iconPath: "assets/icon/verified.svg",
                  color: AppColors.blue600,
                  size: 32,
                ),
                SizedBox(height: 12),
                Text(
                  "Safe & Secure",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "Verified travelers only",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.cardBackgroundBlur,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.cardBorder),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomIcon(
                  iconPath: "assets/icon/users.svg",
                  color: AppColors.purple600,
                  size: 32,
                ),
                SizedBox(height: 12),
                Text(
                  "Growing Network",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 4),
                Text(
                  "Join early adopters",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOurServiceCard(String title, String description, String iconPath,
      List<Color> gradientColors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(left: 12, right: 12, top: 20, bottom: 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: gradientColors[0].withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: CustomIcon(
              iconPath: iconPath,
              size: 32,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOurServices() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Our Services",
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildOurServiceCard(
          "Send Packages",
          "Connect with travelers heading to your destination",
          "assets/icon/package.svg",
          [AppColors.blueStart, AppColors.blueEnd],
        ),
        const SizedBox(height: 16),
        _buildOurServiceCard(
          "Offer Rides",
          "Make money by carrying packages on your trips",
          "assets/icon/car.svg",
          [AppColors.purpleStart, AppColors.purpleEnd],
        ),
      ],
    );
  }

  Widget _buildListingsHeader() {
    return Row(
      children: [
        Text(
          "Recent ${selectedIndex == 0 ? 'Shipments' : 'Trips'}",
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        _showPopUpMenu(),
      ],
    );
  }

  Widget _showPopUpMenu() {
    return Theme(
        data: Theme.of(context).copyWith(
          popupMenuTheme: PopupMenuThemeData(
            color: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: PopupMenuButton<int>(
          onSelected: (value) {
            setState(() {
              selectedIndex = value;
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            const PopupMenuItem<int>(
              value: 0,
              child: Row(
                children: [
                  CustomIcon(
                    iconPath: "assets/icon/package.svg",
                    size: 20,
                    color: AppColors.blue600,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Shipments',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            const PopupMenuItem<int>(
              value: 1,
              child: Row(
                children: [
                  CustomIcon(
                    iconPath: "assets/icon/car.svg",
                    size: 20,
                    color: AppColors.blue600,
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Trips',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.hoverBlue50,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.tune,
                  color: AppColors.blue600,
                  size: 16,
                ),
                SizedBox(width: 4),
                Text(
                  "Filter",
                  style: TextStyle(
                    color: AppColors.blue600,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Widget _buildAppBar() {
    return Row(
      children: [
        UserProfileWithRating(
          user: user,
          header: 'Welcome, ${user?.firstName ?? 'Guest'}',
          avatarSize: 42,
          headerFontSize: 14,
          onPressed: () => context.push("/profile"),
        ),
        const Spacer(),
        Row(
          children: [
            _buildHeaderIcon(
              icon: "assets/icon/help.svg",
              onTap: () => context.push("/help"),
            ),
            const SizedBox(width: 8),
            _buildHeaderIcon(
              icon: "assets/icon/notification.svg",
              onTap: () => context.push("/notification"),
              hasNotification: true,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderIcon({
    required String icon,
    required VoidCallback onTap,
    bool hasNotification = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          // color: AppColors.white.withValues(alpha: 0.4),
          // borderRadius: BorderRadius.circular(30),
          // border: Border.all(
          //   color: AppColors.borderGray200,
          //   width: 1,
          //   strokeAlign: BorderSide.strokeAlignInside,
          // ),

        ),
        child: Stack(
          children: [
            CustomIcon(
              iconPath: icon,
              color: AppColors.textSecondary,
              size: 24,
            ),
            if (hasNotification)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.red500,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterDestination() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          TextFieldWithHeader(
              controller: fromController,
              hintText: "Departure city",
              headerText: "From",
              validator: Validators.notEmpty,
              iconPath: "assets/icon/map-point.svg"),
          const SizedBox(height: 16),
          TextFieldWithHeader(
              controller: toController,
              hintText: "Destination city",
              headerText: "To",
              validator: Validators.notEmpty,
              iconPath: "assets/icon/map-point.svg"),
          const SizedBox(height: 24),
          Row(
            mainAxisSize: MainAxisSize.max, // Use max to fill available width
            children: [
              Expanded(
                child: TextFieldWithHeader(
                  controller: weightController,
                  hintText: "1.0",
                  headerText: "Max Weight (kg)",
                  keyboardType: TextInputType.number,
                  validator: Validators.notEmpty,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFieldWithHeader(
                  controller: priceController,
                  hintText: "1.0",
                  headerText: "Max price (dh)",
                  keyboardType: TextInputType.number,
                  validator: Validators.notEmpty,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            "Select Type",
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TypeSelectorWidget(
            onTypeSelected: (type) {
              typeController.text = type;
            },
            initialSelection: "Shipment",
            types: const ["Shipment", "Trip"],
            selectedColor: AppColors.blue600,
            unselectedColor: AppColors.textSecondary,
          )
        ]);
  }

  void _clearSearchFilter() {
    fromController.text = "";
    toController.text = "";
    weightController.text = "";
    priceController.text = "";
    typeController.text = "Shipment";
  }

  void _applySearchFilter() {
  if (fromController.text.isEmpty &&
        toController.text.isEmpty &&
        weightController.text.isEmpty &&
        priceController.text.isEmpty &&
        typeController.text.isEmpty) {
      AppUtils.showDialog(
          context, 'Please fill at least one field', AppColors.error);
      return;
    }

    SearchFilters filters = SearchFilters(
        from: fromController.text,
        to: toController.text,
        price: priceController.text,
        weight: weightController.text,
        type: typeController.text.isEmpty
            ? "Shipment"
            : typeController.text 
        );
        
    // context.push('/search?${Uri(queryParameters: filters.toQueryParameters()).query}');
  }

  Widget _buildNavigationButtons() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
      ),
      child: SafeArea(
        child: Row(
          children: [
            // Back button

            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: _clearSearchFilter,
                icon: const Icon(Icons.clear_all, size: 18),
                label: const Text('Clear filters'),
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

            // Next/Submit button
            Expanded(
              flex: 3,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                child: ElevatedButton.icon(
                  onPressed: _applySearchFilter,
                  icon: const Icon(Icons.check, size: 18),
                  label: const Text(
                    'Apply filtters',
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

  Widget _buildRequesBody() {
    return Column(children: [
      Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(children: [
            _buildFilterDestination(),
          ])),
      // const SizedBox(height: 24),
      _buildNavigationButtons(),
    ]);
  }

  void _showRequestSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: Column(
                  children: [
                    // Handle bar
                    Container(
                      margin: const EdgeInsets.only(top: 12),
                      width: 48,
                      height: 4,
                      decoration: BoxDecoration(
                        color: AppColors.borderGray200,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    _buildRequesBody(),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTripListings(List<Trip> activeTrips) {
    return Consumer2<TripProvider, UserProvider>(
      builder: (context, tripProvider, userProvider, child) {
        return activeTrips.isEmpty
            ? _buildEmptyState(
                icon: Icons.directions_car,
                title: "No active trips",
                subtitle: "Start earning by offering trip capacity!",
                buttonText: "Post Trip",
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: activeTrips.length,
                itemBuilder: (context, index) {
                  final trip = activeTrips[index];
                  final userData = userProvider.getUserById(trip.userId);
                  if (userData == null) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      ShipmentCard(
                        shipment: trip,
                        userData: userData,
                        onPressed: () {
                          context.push(
                              '/trip-details?tripId=${trip.id}&userId=${trip.userId}&viewOnly=false');
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              );
      },
    );
  }

  Widget _buildShipmentListings(List<Shipment> activeShipments) {
    return Consumer2<ShipmentProvider, UserProvider>(
      builder: (context, shipmentProvider, userProvider, child) {
        return activeShipments.isEmpty
            ? _buildEmptyState(
                icon: Icons.inventory_2,
                title: "No active shipments",
                subtitle: "Be the first to post a shipment request!",
                buttonText: "Post Shipment",
              )
            : ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: activeShipments.length,
                itemBuilder: (context, index) {
                  final shipment = activeShipments[index];
                  final userData = userProvider.getUserById(shipment.userId);
                  if (userData == null) {
                    return const SizedBox.shrink();
                  }
                  return Column(
                    children: [
                      ShipmentCard(
                        shipment: shipment,
                        userData: userData,
                        onPressed: () {
                          context.push(
                              '/shipment-details?shipmentId=${shipment.id}&userId=${shipment.userId}&viewOnly=false');
                        },
                      ),
                      const SizedBox(height: 16),
                    ],
                  );
                },
              );
      },
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
  }) {
    return Container(
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
           Container(
             padding: EdgeInsets.all(16),
             decoration: BoxDecoration(
              color: AppColors.blue700.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(60),
            ),
          child: Icon(
            icon,
            size: 64,
            color: AppColors.blue700.withValues(alpha: 0.6),
          ),),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          // Container(
          //   decoration: BoxDecoration(
          //     gradient: const LinearGradient(
          //       colors: [AppColors.blueStart, AppColors.purpleStart],
          //     ),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: ElevatedButton(
          //     onPressed: () => _showRequestSheet(),
          //     style: ElevatedButton.styleFrom(
          //       backgroundColor: Colors.transparent,
          //       shadowColor: Colors.transparent,
          //       padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          //       shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(12),
          //       ),
          //     ),
          //     child: Text(
          //       buttonText,
          //       style: const TextStyle(
          //         color: Colors.white,
          //         fontSize: 16,
          //         fontWeight: FontWeight.w600,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
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
