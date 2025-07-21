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
  UserData? user;

  final fromController = TextEditingController();
  final toController = TextEditingController();
  final weightController = TextEditingController();
  final priceController = TextEditingController();
  final typeController = TextEditingController();

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








  Widget _buildTripListings(List<Trip> activeTrips) {
    return Consumer2<TripProvider, UserProvider>(
      builder: (context, tripProvider, userProvider, child) {
        return activeTrips.isEmpty
            ? buildEmptyState(
                Icons.directions_car,
                "No active trips",
                 "Start earning by offering trip capacity!",
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
            ? buildEmptyState(
                Icons.inventory_2,
                "No active shipments",
                "Be the first to post a shipment request!",
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
