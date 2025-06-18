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
    userPhotoUrl =
        Provider.of<UserProvider>(context, listen: false).user?.photoUrl ??
            AppTheme.defaultProfileImage;
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
        if (mounted)
          AppUtils.showDialog(
              context, "Failed to fetch Shipments", AppColors.error);
      } finally {
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
     final confirmed = await ConfirmationDialogTypes.showDeleteConfirmation(
      context: context,
      message: 'This action cannot be undone. Are you sure?',
    );

      if (!confirmed) return ;
      try {
          await Provider.of<ShipmentProvider>(context, listen: false)
              .deleteShipment(id);
          await Provider.of<DeliveryRequestProvider>(context, listen: false)
              .deleteRequestsByShipmentId(id);
          AppUtils.showDialog(
              context, 'Shipment deleted succusfully', AppColors.succes);
          Provider.of<StatisticsProvider>(context, listen: false)
              .decrementField(user!.uid, "pendingShipments");
        } catch (e) {
          if (mounted)
            AppUtils.showDialog(
                context, 'Failed to delete shipment: $e', AppColors.error);
        } 
      
   
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }


  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
    required String buttonText,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(48),
      child: Column(
        children: [
          Icon(
            icon,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
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
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.blueStart, AppColors.purpleStart],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ElevatedButton(
              onPressed: () => {context.push("/add-shipment")},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                shadowColor: Colors.transparent,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                buttonText,
                style: const TextStyle(
                  color: Colors.white,
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
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.blue700,
              ),
            )
          : Consumer<ShipmentProvider>(builder: (context, provider, child) {
              final user =
                  Provider.of<UserProvider>(context, listen: false).user;
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
            ? Center(child: _buildEmptyState(
                icon: Icons.inventory_2,
                title: "No active shipments",
                subtitle: "Be the first to post a shipment request!",
                buttonText: "Post Shipment",
              ))
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
            ? Center(child: _buildEmptyState(
                icon: Icons.inventory_2,
                title: "No Ongoing shipments",
                subtitle: "Be the first to post a shipment request!",
                buttonText: "Post Shipment",
              ))
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
                          item: ongoingShipments[index], user: userData),
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
            ? Center(child: _buildEmptyState(
                icon: Icons.inventory_2,
                title: "No Completed shipments",
                subtitle: "Be the first to post a shipment request!",
                buttonText: "Post Shipment",
              ))
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
                          user: userData,
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
