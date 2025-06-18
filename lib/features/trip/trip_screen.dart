import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/listing_skeleton.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/rendering.dart';

class TripScreen extends StatefulWidget {
  const TripScreen({Key? key}) : super(key: key);

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen>
    with SingleTickerProviderStateMixin {
  int selectedIndex = 0;
  String? userPhotoUrl;
  UserData? user;
  bool _isLoading = true;
  late TabController _tabController;

  final ScrollController _scrollController = ScrollController();
  bool _isExpanded = true;

  void removeTrip(String id) async {
    final confirmed = await ConfirmationDialog.show(
        context: context,
        message: 'Are you sure you want to delete this shipment?',
        header: 'Delete Shipment',
        buttonHintText: 'Delete',
        iconData: Icons.delete_outline,
      );
      if (!confirmed) return ; 

      try {
        await Provider.of<TripProvider>(context, listen: false)
            .deleteTrip(id);
        await Provider.of<DeliveryRequestProvider>(context, listen: false)
            .deleteRequestsByTripId(id);
        AppUtils.showDialog(
            context, 'Trip deleted succusfully!', AppColors.succes);
        Provider.of<StatisticsProvider>(context, listen: false)
            .decrementField(user!.uid, "pendingTrips");
      } catch (e) {
        if (mounted) {
          AppUtils.showDialog(
              context, 'Failed to delete Trip: $e', AppColors.error);
        }
      } 
      
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
    _tabController = TabController(length: 3, vsync: this);
    userPhotoUrl =
        Provider.of<UserProvider>(context, listen: false).user?.photoUrl;
    if (userPhotoUrl == null || userPhotoUrl!.isEmpty) {
      userPhotoUrl = "assets/images/profile.png"; // Default image
    }

    // Fetch trips when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        user = Provider.of<UserProvider>(context, listen: false).user;
        final tripProvider = Provider.of<TripProvider>(context, listen: false);
        tripProvider.fetchTripsBuUserId(user!.uid);

        final userIds = tripProvider.trips
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

   void _handleScroll() {
    if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _isExpanded) {
      setState(() => _isExpanded = false);
    } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward && !_isExpanded) {
      setState(() => _isExpanded = true);
    }
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
        title: "Trips",
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: AppColors.blue700,
              ),
            )
          : Consumer<TripProvider>(builder: (context, provider, child) {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                return const Center(
                    child: Text('Please log in to view shipments'));
              }

              final activeTrips = provider.trips
                  .where((s) =>
                      s.userId == user.uid && s.status == DeliveryStatus.active)
                  .toList();
              final ongoingTrips = provider.trips
                  .where((s) =>
                      s.userId == user.uid &&
                      s.status == DeliveryStatus.ongoing)
                  .toList();
              final completedTrips = provider.trips
                  .where((s) =>
                      s.userId == user.uid &&
                      s.status == DeliveryStatus.completed)
                  .toList();

              // print("trips");
              // print(activeTrips.length);

              return TabBarView(
                controller: _tabController,
                
                children: [
                  _buildActiveTrips(activeTrips),
                  _buildOngoingTrips(ongoingTrips),
                  _buildOPastTrips(completedTrips)
                ],
              );
            }),
      floatingActionButton: FloatButton(
        expanded: _isExpanded,
        onTap: () => {context.push("/add-trip")},
        hintText: "Add trip",
        iconPath: "assets/icon/add.svg",
      ),
    );
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
              onPressed: () => {context.push("/add-trip")},
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

  Widget _buildActiveTrips(List<Trip> activeTrips) {
    return Container(
      margin: const EdgeInsets.only(
          left: AppTheme.cardPadding, right: AppTheme.cardPadding),
      color: AppColors.background,
      child: activeTrips.isEmpty
          ? Center(child: _buildEmptyState(
               icon: Icons.directions_car,
                title: "No active trips",
                subtitle: "Start earning by offering trip capacity!",
                buttonText: "Post Trip",
              ))
          : ListView.builder(
             controller: _scrollController,
              itemCount: activeTrips.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index == 0)
                      const SizedBox(height: AppTheme.gapBetweenCards),
                    ActiveItemCard(
                      item: activeTrips[index],
                      onPressed: () => {removeTrip(activeTrips[index].id!)},
                    ),
                    const SizedBox(height: AppTheme.gapBetweenCards),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildOngoingTrips(List<Trip> ongoingTrips) {
    return Consumer<TripProvider>(builder: (context, tripProvider, child) {
      return Container(
        margin: const EdgeInsets.only(
            left: AppTheme.cardPadding, right: AppTheme.cardPadding),
        color: AppColors.background,
        child: ongoingTrips.isEmpty
            ? Center(child: _buildEmptyState(
               icon: Icons.directions_car,
                title: "No ovgoing trips",
                subtitle: "Start earning by offering trip capacity!",
                buttonText: "Post Trip",
              ))
            : ListView.builder(
               controller: _scrollController,
                itemCount: ongoingTrips.length,
                itemBuilder: (context, index) {
                  final trip = ongoingTrips[index];
                  if (trip.matchedDeliveryUserId == null) {
                    return const SizedBox.shrink();
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
                      OngoingItemCard(
                          item: ongoingTrips[index], user: userData),
                      const SizedBox(height: AppTheme.gapBetweenCards),
                    ],
                  );
                },
              ),
      );
    });
  }

  Widget _buildOPastTrips(List<Trip> completedTrips) {
    return Consumer<TripProvider>(builder: (context, tripProvider, child) {
      return Container(
        margin: const EdgeInsets.only(
            left: AppTheme.cardPadding, right: AppTheme.cardPadding),
        color: AppColors.background,
        child: completedTrips.isEmpty
            ? Center(child: _buildEmptyState(
               icon: Icons.directions_car,
                title: "No completed trips",
                subtitle: "Start earning by offering trip capacity!",
                buttonText: "Post Trip",
              ))
            : ListView.builder(
               controller: _scrollController,
                itemCount: completedTrips.length,
                itemBuilder: (context, index) {
                  final trip = completedTrips[index];

                  if (trip.matchedDeliveryUserId == null) {
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
                          item: completedTrips[index],
                          user: userData,
                          onPressed: () {
                            removeTrip(completedTrips[index].id!);
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
