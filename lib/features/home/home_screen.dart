import 'package:quickdrop_app/core/utils/imports.dart';

import 'package:quickdrop_app/core/widgets/custom_tab_bar.dart';
import 'package:quickdrop_app/features/shipment/listing_card_details_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await Provider.of<ShipmentProvider>(context, listen: false)
          .fetchShipments();
        await Provider.of<TripProvider>(context, listen: false)
          .fetchTrips();
      } catch (e) {
        if (mounted) AppUtils.showError(context, 'Error fetching shipments: $e');
      }
      finally {
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
        appBar: AppBar(
            backgroundColor: AppColors.barColor,
            title: _buildHomePageHeader(),
            bottom: CustomTabBar(
              selectedIndex: selectedIndex,
              tabs: const ['Packages', 'Trips'],
              icons: const ['package.svg', 'map-point.svg'],
              onTabSelected: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
            )),
        body: Skeletonizer(
            enabled: _isLoading,
            child: Padding(
                padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
                child: Column(children: [
                  const SizedBox(height: 15),
                  SearchForm(),
                  const SizedBox(height: 15),
                  Expanded(child: Consumer2<ShipmentProvider, TripProvider>(
                      builder:
                          (context, shipmentProvider, tripProvider, child) {
                    return IndexedStack(
                      index: selectedIndex,
                      children: [
                        _buildShipmentListings(
                            shipmentProvider.activeShipments),
                        _buildTripListings(tripProvider.activeTrips),
                      ],
                    );
                  }))
                ]))));
  }

  Widget _buildHomePageHeader() {
    return Row(
      mainAxisSize: MainAxisSize.max, // Takes full width
      children: [
        const Expanded(
          // App Name
          child: Text(
            "QuickDrop",
            style: TextStyle(
              color: AppColors.headingText,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
            // textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: const CustomIcon(
              iconPath: "assets/icon/notification.svg",
              size: 24,
              color: AppColors.white),
          onPressed: () {
            // Navigate to notifications page or show a dialog
            print("Notifications clicked!");
          },
        )
      ],
    );
  }

  Widget _buildTripListings(List<Trip> activeTrips) {
    return Consumer<TripProvider>(
      builder: (context, tripProvider, child) {
        return Container(
          color: AppColors.background,
          child: activeTrips.isEmpty
              ? Center(child: Message(context, 'No active Trips'))
              : ListView.builder(
                  itemCount: activeTrips.length,
                  itemBuilder: (context, index) {
                    final trip = activeTrips[index];
                    final userData = tripProvider.getUserData(trip.userId);
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
    return Consumer<ShipmentProvider>(
      builder: (context, shipmentProvider, child) {
        return Container(
          color: AppColors.background,
          child: activeShipments.isEmpty
              ? Center(child: Message(context, 'No active shipments'))
              : ListView.builder(
                  itemCount: activeShipments.length,
                  itemBuilder: (context, index) {
                    final shipment = activeShipments[index];
                    final userData =
                        shipmentProvider.getUserData(shipment.userId);
                    return Column(
                      children: [
                        ShipmentCard(
                          shipment: shipment,
                          userData: userData,
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ListingCardDetails(
                                        shipment: shipment, user: userData)));
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
          color: AppColors.lessImportant,
          fontSize: 12,
          fontWeight: FontWeight.normal),
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
        prefixIcon: const Padding(
          padding: EdgeInsets.all(10),
          child: SizedBox(
            width: 20,
            height: 20,
            child: CustomIcon(
              iconPath: "assets/icon/map-point.svg",
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