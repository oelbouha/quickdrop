import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/app_header.dart';

import 'package:go_router/go_router.dart';


class TripScreen extends StatefulWidget {
 
  const TripScreen({Key? key}) : super(key: key);

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> with SingleTickerProviderStateMixin{
  int selectedIndex = 0;
  String? userPhotoUrl;
  bool _isLoading = true;
  late TabController _tabController;

  void removeTrip(String id) async {
    showDialog(
        context: context,
        builder: (context) => ConfirmationDialog(
            message: "Are you sure you want to delete trip",
            hintText: "Confirm",
            onPressed: () async {
              try {
                await Provider.of<TripProvider>(context, listen: false).deleteTrip(id);
                await Provider.of<DeliveryRequestProvider>(context, listen: false)
                      .deleteRequestsByTripId(id);
                  AppUtils.showSuccess(context, 'Trip deleted succusfully!');
              } catch (e) {
                if (mounted) AppUtils.showError(context, 'Failed to delete Trip: $e');
              } finally {
                if (mounted) Navigator.pop(context);
              }
      }
    ));
  
  }

  @override
  void initState() {
    super.initState();
     _tabController = TabController(length: 3, vsync: this);
    userPhotoUrl = Provider.of<UserProvider>(context, listen: false).user?.photoUrl;
    if (userPhotoUrl == null || userPhotoUrl!.isEmpty) {
      userPhotoUrl = "assets/images/profile.png"; // Default image
    }

  


    // Fetch trips when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async{
      try {
          final tripProvider = Provider.of<TripProvider>(context, listen: false);
          tripProvider.fetchTrips();

          final userIds = tripProvider.trips
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

     @override
    void dispose() {
      _tabController.dispose();
      super.dispose();
    }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar:CustomAppBar(
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
              color: AppColors.blue,
            ))
          : Consumer<TripProvider>(builder: (context, provider, child) {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                return const Center(
                    child: Text('Please log in to view shipments'));
              }

              final activeTrips = provider.trips
                  .where((s) => s.userId == user.uid && s.status == DeliveryStatus.active)
                  .toList();
              final ongoingTrips = provider.trips
                  .where((s) => s.userId == user.uid && s.status == DeliveryStatus.ongoing)
                  .toList();
              final completedTrips = provider.trips
                  .where((s) => s.userId == user.uid && s.status == DeliveryStatus.completed)
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
        onTap: () => {context.push("/add-trip")},
        hintText: "Add trip",
        iconPath: "assets/icon/add.svg",
      ),
    );
  }

  Widget _buildActiveTrips(List<Trip> activeTrips) {
    return Container(
      margin: const EdgeInsets.only(left: AppTheme.cardPadding, right: AppTheme.cardPadding),
      color: AppColors.background,
      child: activeTrips.isEmpty
          ? Center(child: Message(context, 'No active trips'))
          : ListView.builder(
              itemCount: activeTrips.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
                    if (index == 0) const SizedBox(height: AppTheme.gapBetweenCards),
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
         margin: const EdgeInsets.only(left: AppTheme.cardPadding, right: AppTheme.cardPadding),
        color: AppColors.background,
        child: ongoingTrips.isEmpty
            ? Center(child: Message(context, 'No ongoing trips'))
            : ListView.builder(
                itemCount: ongoingTrips.length,
                itemBuilder: (context, index) {
                  final trip = ongoingTrips[index];
                 if (trip.matchedDeliveryUserId == null) {
                    return const SizedBox
                        .shrink(); 
                  }
                  final userData = Provider.of<UserProvider>(context, listen: false)
                      .getUserById(trip.matchedDeliveryUserId!);
                  if (userData == null) {
                    return const SizedBox
                        .shrink(); // Skip this item if userData is null
                  }
                  return Column(
                    children: [
                       if (index == 0) const SizedBox(height: AppTheme.gapBetweenCards),
                      OngoingItemCard(
                          item: ongoingTrips[index], user: userData.toMap()),
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
         margin: const EdgeInsets.only(left: AppTheme.cardPadding, right: AppTheme.cardPadding),
        color: AppColors.background,
        child: completedTrips.isEmpty
            ? Center(child: Message(context, 'No completed trips'))
            : ListView.builder(
                itemCount: completedTrips.length,
                itemBuilder: (context, index) {
                  final trip = completedTrips[index];
                  
                  if (trip.matchedDeliveryUserId == null) {
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
                     if (index == 0) const SizedBox(height: AppTheme.gapBetweenCards),
                      CompletedItemCard(
                          item: completedTrips[index],
                          user: userData.toMap(),
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
