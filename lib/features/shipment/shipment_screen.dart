import 'package:quickdrop_app/core/utils/imports.dart';

import 'package:go_router/go_router.dart';
import 'package:quickdrop_app/core/widgets/app_header.dart';

class ShipmentScreen extends StatefulWidget {
  const ShipmentScreen({Key? key}) : super(key: key);

  @override
  State<ShipmentScreen> createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<ShipmentScreen> with SingleTickerProviderStateMixin{
  int selectedIndex = 0;
  bool _isLoading = true;
  String? userPhotoUrl;
  late TabController _tabController;


  @override
  void initState() {
    super.initState();
    // Fetch shipments when the screen loads
    _tabController = TabController(length: 3, vsync: this);
    userPhotoUrl = Provider.of<UserProvider>(context, listen: false).user?.photoUrl;
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      try {
        final shipmentProvider =  Provider.of<ShipmentProvider>(context, listen: false);
        shipmentProvider.fetchShipments();
        final userIds = shipmentProvider.shipments
              .where((r) => r.matchedDeliveryUserId != null)
              .map((r) => r.matchedDeliveryUserId!)
              .toSet()
              .toList();
          if (userIds.isNotEmpty) {
             await Provider.of<UserProvider>(context, listen: false)
              .fetchUsersData(userIds);
          }

        Future.delayed(Duration(milliseconds: 500), () {
          setState(() {
            _isLoading = false;
          });
        });
      } catch (e) {
        if (mounted) AppUtils.showError(context, "Failed to fetch Shipments");
      }
    });
  }

  void removeShipment(String id) async {
      //  print("Removing shipment with id: $id");
       showDialog(
            context: context,
            builder: (context) => ConfirmationDialog(
              message: "Are you sure you want to delete shipment",
              hintText: "Confirm",
              onPressed: () async {
                 try {
                    await Provider.of<ShipmentProvider>(context, listen: false)
                        .deleteShipment(id);
                    await Provider.of<DeliveryRequestProvider>(context, listen: false)
                        .deleteRequestsByShipmentId(id);
                   AppUtils.showSuccess(context, 'Shipment deleted succusfully:');
                  } catch (e) {
                    if (mounted) AppUtils.showError(context, 'Failed to delete shipment: $e');
                  } finally {
                    Navigator.pop(context);
                  } 
              },
            ),
          );
   
  }

    @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.barColor,
        // centerTitle: true,
        // toolbarHeight: 40,
       title:  const Text(
          "Shipments", 
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
       actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: AppColors.white),
            tooltip: 'notification',
            onPressed: () {context.push("/notification");},
          ),
          GestureDetector(
            onTap: () {context.push("/profile");},
  
            child:  CircleAvatar(
              radius: 18,
              backgroundColor: AppColors.blue,
              backgroundImage: userPhotoUrl!.startsWith("http")
                  ? NetworkImage(userPhotoUrl!)
                  : AssetImage(userPhotoUrl!) as ImageProvider,
            ),
          ),
          const SizedBox(width: 10,),
      ],

        bottom: customTabBar(
          tabs: const ['Active', 'Ongoing', 'Completed'],
          tabController: _tabController
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: AppColors.blue,
            ))
          : Consumer<ShipmentProvider>(builder: (context, provider, child) {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                return const Center(
                    child: Text('Please log in to view shipments'));
              }

              final activeShipments = provider.shipments
                  .where((s) => s.userId == user.uid && s.status == DeliveryStatus.active)
                  .toList();
              final ongoingShipments = provider.shipments
                  .where((s) => s.userId == user.uid && s.status == DeliveryStatus.ongoing)
                  .toList();
              final pastShipments = provider.shipments
                  .where((s) => s.userId == user.uid && s.status == DeliveryStatus.completed)
                  .toList();

              return Padding(
                 padding: const EdgeInsets.only(
                    left: AppTheme.homeScreenPadding,
                    right: AppTheme.homeScreenPadding,
                    top: AppTheme.homeScreenPadding,
                    ),
                child: TabBarView(
                    controller: _tabController,
                  children: [
                    _buildActiveShipment(activeShipments),
                    _buildOngoingShipment(ongoingShipments),
                    _buildOPastShipment(pastShipments),
                  ],
              ));
            }),
      floatingActionButton: FloatButton(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddShipmentScreen()));
        },
        hintText: "Add package",
        iconPath: "assets/icon/add.svg",
      ),
    );
  }

  Widget _buildActiveShipment(List<Shipment> activeShipments) {
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
                  return Column(
                    children: [
                      ActiveItemCard(
                          item: shipment,
                          onPressed: () {
                            removeShipment(activeShipments[index].id!);
                          }),
                      const SizedBox(height: AppTheme.gapBetweenCards),
                    ],
                  );
                },
              ),
      );
    });
  }

  Widget _buildOngoingShipment(List<Shipment> ongoingShipments) {
    return Consumer<ShipmentProvider>(
        builder: (context, shipmentProvider, child) {
      return Container(
        color: AppColors.background,
        child: ongoingShipments.isEmpty
            ? Center(child: Message(context, 'No ongoing shipments'))
            : ListView.builder(
                itemCount: ongoingShipments.length,
                itemBuilder: (context, index) {
                  final shipment = ongoingShipments[index];
                  if (shipment.matchedDeliveryUserId == null) {
                    return const SizedBox
                        .shrink(); // Skip this item if userData is null
                  }
                  final userData = Provider.of<UserProvider>(context, listen: false)
                      .getUserById(shipment.matchedDeliveryUserId!);
                  if (userData == null) {
                    return const SizedBox
                        .shrink(); // Skip this item if userData is null
                  }
                  return Column(
                    children: [
                      OngoingItemCard(
                          item: ongoingShipments[index], user: userData.toMap()),
                      const SizedBox(height: AppTheme.gapBetweenCards),
                    ],
                  );
                },
              ),
      );
    });
  }

  Widget _buildOPastShipment(List<Shipment> pastShipments) {
    return Consumer<ShipmentProvider>(
        builder: (context, shipmentProvider, child) {
      return Container(
        color: AppColors.background,
        child: pastShipments.isEmpty
            ? Center(child: Message(context, 'No completed shipments'))
            : ListView.builder(
                itemCount: pastShipments.length,
                itemBuilder: (context, index) {
                  final trip = pastShipments[index];
                  if (trip.matchedDeliveryUserId == null) {
                    print("matchedDeliveryUserId is null");
                    return const SizedBox
                        .shrink(); // Skip this item if userData is null
                  }
                  final userData = Provider.of<UserProvider>(context, listen: false)
                      .getUserById(trip.matchedDeliveryUserId!);
                  if (userData == null) {
                    return const SizedBox
                        .shrink(); // Skip this item if userData is null
                  }
                  return Column(
                    children: [
                      CompletedItemCard(
                          item: pastShipments[index], 
                          user: userData.toMap(),
                          onPressed: () {
                            removeShipment(pastShipments[index].id!);
                          }
                        ),
                      const SizedBox(height: AppTheme.gapBetweenCards),
                    ],
                  );
                },
              ),
      );
    });
  }
}
