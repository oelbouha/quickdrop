import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/shipment/listing_card_details_screen.dart';
import 'package:quickdrop_app/features/profile/profile_screen.dart';
import 'package:quickdrop_app/core/widgets/app_header.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool _isLoading = true;
  String? userPhotoUrl;

  @override
  void initState() {
    super.initState();

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
          AppUtils.showError(context, 'Error fetching shipments: $e');
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
    return Scaffold(
        backgroundColor: AppColors.background,
        body: SafeArea(
            child: Skeletonizer(
                enabled: _isLoading,
                child: Padding(
                    padding: const EdgeInsets.only(
                      left: AppTheme.homeScreenPadding,
                      right: AppTheme.homeScreenPadding,
                    ),
                    child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                          _buildAppBar(),
                          const SizedBox(height: 20),
                          const Text("Ship Anywhere, Anytime",
                              style: TextStyle(
                                  color: AppColors.shipmentText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                              textAlign: TextAlign.center),
                              const Text("Connect with travelers going your way or send packages with trusted community members",
                              style: TextStyle(
                                  color: AppColors.shipmentText,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600),
                              textAlign: TextAlign.center),
                          const SizedBox(height: 10),
                          Row(children: [
                            Expanded(
                                child: searchTextField(
                                    hintText: "Search ",
                                    controller: TextEditingController(),
                                    iconPath: "assets/icon/magnifer.svg")),
                            const SizedBox(width: 10),
                            Container(
                              decoration: BoxDecoration(
                                color: AppColors.blue,
                                borderRadius:
                                    BorderRadius.circular(AppTheme.cardRadius),
                                boxShadow: [
                                  BoxShadow(
                                    color: Color.fromARGB(255, 0, 0, 0)
                                        .withOpacity(0.1), // Shadow color
                                    spreadRadius:
                                        0.2, // How much the shadow spreads
                                    blurRadius: 2, // Soften the shadow
                                    offset: const Offset(
                                        0, 1), // Move shadow downwards
                                  )
                                ],
                              ),
                              child: IconButton(
                                onPressed: () {
                                  _showRequestSheet();
                                },
                                icon: const CustomIcon(
                                  iconPath: "assets/icon/filter.svg",
                                  size: 30,
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                          ]),
                          const SizedBox(height: 10),
                          // const SizedBox(height: 10),
                          // _buildTogleButtons(),
                          const SizedBox(height: 15),
                          Row(
                            children: [
                              const Text("Recent Listings",
                                  style: TextStyle(
                                      color: AppColors.shipmentText,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600)),
                              const Spacer(),
                              TextButton(
                                onPressed: () {
                                  context.push("/");
                                },
                                child: const Text("Filter",
                                    style: TextStyle(
                                        color: AppColors.blue,
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          // const SizedBox(height: 10),
                          Consumer3<ShipmentProvider, TripProvider,
                                  UserProvider>(
                              builder: (context, shipmentProvider, tripProvider,
                                  userProvider, child) {
                            return IndexedStack(
                              index: selectedIndex,
                              children: [
                                _buildShipmentListings(
                                    shipmentProvider.activeShipments),
                                _buildTripListings(tripProvider.activeTrips),
                              ],
                            );
                          })
                        ]))))));
  }

  Widget _buildAppBar() {
    return (Row(mainAxisSize: MainAxisSize.min, children: [
      UserProfileCard(
        header: "Outman",
        photoUrl: userPhotoUrl!,
        avatarSize: 26,
        subHeader: "Welcome",
        headerFontSize: 14,
        onPressed: () => print("user profile  Clicked"),
      ),
      const Spacer(),
      Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          GestureDetector(
            onTap: () => context.push("/help"),
            child: const CustomIcon(
              iconPath: "assets/icon/help.svg",
              size: 24,
              color: AppColors.dark,
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => context.push("/notification"),
            child: const CustomIcon(
              iconPath: "assets/icon/notification.svg",
              size: 24,
              color: AppColors.dark,
            ),
          ),
        ],
      )
    ]));
  }

  Widget _buildRequesBody() {
    return Text(
      "Request a shipment or trip",
      style: TextStyle(
        color: AppColors.shipmentText,
        fontSize: 18,
        fontWeight: FontWeight.w600,
      ),
    );
  }

void _showRequestSheet() {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.cardBackground,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    barrierColor: Colors.black.withOpacity(0.5),
    builder: (BuildContext context) {
      final mediaQuery = MediaQuery.of(context);
      return Padding(
        padding: EdgeInsets.only(
          bottom: mediaQuery.viewInsets.bottom,
        ),
        child: SizedBox(
          width: mediaQuery.size.width, // Full width
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.6,
            maxChildSize: 0.9,
            minChildSize: 0.4,
            builder: (context, scrollController) {
              return SingleChildScrollView(
                controller: scrollController,
                child: _buildRequesBody(),
              );
            },
          ),
        ),
      );
    },
  );
}


  Widget toggleButton({
    required String text,
    required bool isSelected,
    required String iconPath,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: TextButton.icon(
        onPressed: onPressed,
        icon: CustomIcon(
          iconPath: iconPath,
          size: 20,
          color: isSelected ? AppColors.white : AppColors.blue,
        ),
        style: TextButton.styleFrom(
          backgroundColor:
              isSelected ? AppColors.blue : AppColors.cardBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppTheme.buttonRadius),
          ),
        ),
        label: Text(
          text,
          style: TextStyle(
            color: isSelected ? AppColors.white : AppColors.blue,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildTogleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        toggleButton(
          text: "Shipments",
          isSelected: selectedIndex == 0,
          iconPath: "assets/icon/package.svg",
          onPressed: () {
            setState(() {
              selectedIndex = 0;
            });
          },
        ),
        const SizedBox(width: 10),
        toggleButton(
          text: "Trips",
          iconPath: "assets/icon/car.svg",
          isSelected: selectedIndex == 1,
          onPressed: () {
            setState(() {
              selectedIndex = 1;
            });
          },
        ),
      ],
    );
  }

  Widget _buildTripListings(List<Trip> activeTrips) {
    return Consumer2<TripProvider, UserProvider>(
      builder: (context, tripProvider, userProvider, child) {
        return Container(
          color: AppColors.background,
          child: activeTrips.isEmpty
              ? Center(child: Message(context, 'No active Trips'))
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
                        TripCard(trip: trip, userData: userData),
                        const SizedBox(height: AppTheme.gapBetweenCards),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }

  Widget _buildShipmentListings(List<Shipment> activeShipments) {
    return Consumer2<ShipmentProvider, UserProvider>(
      builder: (context, shipmentProvider, userProvider, child) {
        return Container(
          color: AppColors.background,
          child: activeShipments.isEmpty
              ? Center(child: Message(context, 'No active shipments'))
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
                                '/shipment-details?shipmentId=${shipment.id}&userId=${shipment.userId}');
                          },
                        ),
                        const SizedBox(height: AppTheme.gapBetweenCards),
                      ],
                    );
                  },
                ),
        );
      },
    );
  }
}

Widget searchTextField({
  required String hintText,
  required TextEditingController controller,
  String iconPath = "",
  Color iconColor = AppColors.blue,
}) {
  return (TextFormField(
      style: const TextStyle(
          color: AppColors.input, fontSize: 12, fontWeight: FontWeight.w500),
      controller: controller,
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.input,
            width: AppTheme.textFieldBorderWidth,
          ),
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.blue,
            width: AppTheme.textFieldBorderWidth,
          ),
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CustomIcon(
              iconPath: iconPath,
              size: 20,
              color: AppColors.blue,
            ),
          ),
        ),
        hintText: hintText,

        // Set color & style
        filled: true, // Enables background color
        fillColor: AppColors.input,
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(AppTheme.inputRadius), // Rounded borders
          borderSide: BorderSide.none, // Removes default border
        ),
      )));
}

class SearchForm extends StatefulWidget {
  @override
  _searchFormState createState() => _searchFormState();
}

class _searchFormState extends State<SearchForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fromDistination = TextEditingController();
  final TextEditingController _toDistination = TextEditingController();

  void _submitForm() {}
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          boxShadow: [
            BoxShadow(
              color:
                  Color.fromARGB(255, 0, 0, 0).withOpacity(0.1), // Shadow color
              spreadRadius: 0.2, // How much the shadow spreads
              blurRadius: 2, // Soften the shadow
              offset: Offset(0, 1), // Move shadow downwards
            )
          ],
        ),
        padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
        child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                  child: searchTextField(
                      hintText: "Pickup location",
                      controller: _fromDistination),
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  child: searchTextField(
                      hintText: "Dropoff location", controller: _toDistination),
                ),
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  icon: const CustomIcon(
                      iconPath: "assets/icon/magnifer.svg",
                      size: 22,
                      color: AppColors.white),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size.fromHeight(AppTheme.searchButtonHeight),
                    backgroundColor: AppColors.blue,
                    foregroundColor: AppColors.white,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(AppTheme.buttonRadius),
                      ),
                    ),
                  ),
                  onPressed: _submitForm,
                  label: const Text(
                    "Search",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ],
            )));
  }
}



 // Widget _buildAAllListings(
  //     List<Shipment> activeShipments, List<Trip> activeTrips) {
  //   final allItems = [...activeShipments, ...activeTrips];
  //   return Container(
  //     color: AppColors.background,
  //     padding: const EdgeInsets.only(
  //       left: AppTheme.homeScreenPadding,
  //       right: AppTheme.homeScreenPadding
  //     ),
  //     child: allItems.isEmpty
  //         ? const Center(child: Text('No active listings'))
  //         : ListView.builder(
  //             itemCount: allItems.length,
  //             itemBuilder: (context, index) {
  //               final item = allItems[index];
  //               return Column(
  //                 children: [
  //                   item is Shipment
  //                       ? ShipmentCard(shipment: item)
  //                       : TripCard(
  //                           trip: item as Trip,
  //                         ),
  //                   const SizedBox(height: AppTheme.gapBetweenCards),
  //                 ],
  //               );
  //             },
  //           ),
  //   );
  // }