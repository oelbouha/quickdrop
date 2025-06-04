import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/listing_skeleton.dart';

class ShipmentScreen extends StatefulWidget {
  const ShipmentScreen({Key? key}) : super(key: key);

  @override
  State<ShipmentScreen> createState() => _ShipmentScreenState();
}

class _ShipmentScreenState extends State<ShipmentScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  bool _isLoading = true;
  UserData? user;
  String? userPhotoUrl;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 3, vsync: this);
    userPhotoUrl = Provider.of<UserProvider>(context, listen: false).user?.photoUrl ?? AppTheme.defaultProfileImage;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        user = Provider.of<UserProvider>(context, listen: false).user;
        final shipmentProvider =
            Provider.of<ShipmentProvider>(context, listen: false);
        shipmentProvider.fetchShipmentsByUserId(user!.uid);
        final userIds = shipmentProvider.shipments
            .where((r) => r.matchedDeliveryUserId != null)
            .map((r) => r.matchedDeliveryUserId!)
            .toSet()
            .toList();
        if (userIds.isNotEmpty) {
          await Provider.of<UserProvider>(context, listen: false)
              .fetchUsersData(userIds);
        }

      
      } catch (e) {
        if (mounted) AppUtils.showError(context, "Failed to fetch Shipments");
      }
      finally {
        // Ensure the loading state is updated even if an error occurs
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    });
  }

  void removeShipment(String id) async {
    //  print("Removing shipment with id: $id");
    showDialog(
      context: context,
      builder: (context) => ConfirmationDialog(
        message: AppTheme.deleteShipmentText,
        iconPath: "assets/icon/trash-bin.svg",
        onPressed: () async {
          try {
            await Provider.of<ShipmentProvider>(context, listen: false)
                .deleteShipment(id);
            await Provider.of<DeliveryRequestProvider>(context, listen: false)
                .deleteRequestsByShipmentId(id);
            AppUtils.showSuccess(context, 'Shipment deleted succusfully');
            Provider.of<StatisticsProvider>(context, listen: false)
                .decrementField(user!.uid, "pendingShipments");
          } catch (e) {
            if (mounted)
              AppUtils.showError(context, 'Failed to delete shipment: $e');
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
      appBar: CustomAppBar(
        userPhotoUrl: userPhotoUrl!,
        tabController: _tabController,
        tabs: const [
          "Active",
          "Ongoing",
          "Completed",
        ],
        title: "Shipments",
      ),
      body: _isLoading
          ? const ListingSkeleton()
          : Consumer<ShipmentProvider>(builder: (context, provider, child) {
              final user = Provider.of<UserProvider>(context, listen: false).user;
              if (user == null) {
                return const Center(
                    child: Text('Please log in to view shipments'));
              }

              final activeShipments = provider.shipments
                  .where((s) =>
                      s.userId == user.uid && s.status == DeliveryStatus.active)
                  .toList();
              final ongoingShipments = provider.shipments
                  .where((s) =>
                      s.userId == user.uid &&
                      s.status == DeliveryStatus.ongoing)
                  .toList();
              final pastShipments = provider.shipments
                  .where((s) =>
                      s.userId == user.uid &&
                      s.status == DeliveryStatus.completed)
                  .toList();

              return TabBarView(
                controller: _tabController,
                children: [
                  _buildActiveShipment(activeShipments),
                  _buildOngoingShipment(ongoingShipments),
                  _buildOPastShipment(pastShipments),
                ],
              );
            }),
      floatingActionButton: FloatButton(
        onTap: () {
          context.push("/add-shipment");
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
        margin: const EdgeInsets.only(
            left: AppTheme.cardPadding, right: AppTheme.cardPadding),
        color: AppColors.background,
        child: activeShipments.isEmpty
            ? Center(child: Message(context, 'No active shipments'))
            : ListView.builder(
                itemCount: activeShipments.length,
                itemBuilder: (context, index) {
                  final shipment = activeShipments[index];
                  return Column(
                    children: [
                      if (index == 0)
                        const SizedBox(height: AppTheme.gapBetweenCards),
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
        margin: const EdgeInsets.only(
            left: AppTheme.cardPadding, right: AppTheme.cardPadding),
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
                  final userData =
                      Provider.of<UserProvider>(context, listen: false)
                          .getUserById(shipment.matchedDeliveryUserId!);
                  if (userData == null) {
                    return const SizedBox
                        .shrink(); // Skip this item if userData is null
                  }
                  return Column(
                    children: [
                      if (index == 0)
                        const SizedBox(height: AppTheme.gapBetweenCards),
                      OngoingItemCard(
                          item: ongoingShipments[index],
                          user: userData.toMap()),
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
        margin: const EdgeInsets.only(
            left: AppTheme.cardPadding, right: AppTheme.cardPadding),
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
                  final userData =
                      Provider.of<UserProvider>(context, listen: false)
                          .getUserById(trip.matchedDeliveryUserId!);
                  if (userData == null) {
                    return const SizedBox
                        .shrink(); // Skip this item if userData is null
                  }
                  return Column(
                    children: [
                      if (index == 0)
                        const SizedBox(height: AppTheme.gapBetweenCards),
                      CompletedItemCard(
                          item: pastShipments[index],
                          user: userData.toMap(),
                          onPressed: () {
                            removeShipment(pastShipments[index].id!);
                          }),
                      const SizedBox(height: AppTheme.gapBetweenCards),
                    ],
                  );
                },
              ),
      );
    });
  }
}
