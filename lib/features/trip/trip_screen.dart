import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/core/widgets/app_header.dart';


class TripScreen extends StatefulWidget {
  const TripScreen({Key? key}) : super(key: key);

  @override
  State<TripScreen> createState() => _TripScreenState();
}

class _TripScreenState extends State<TripScreen> {
  int selectedIndex = 0;
  bool _isLoading = true;

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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.barColor,
        // centerTitle: true,
        toolbarHeight: 80,
        titleSpacing: 0,
       title:  buildHomePageHeader(
            context,
            'Shipments',
            true,
          ),
        bottom: CustomTabBar(
          tabs: const ['Active', 'Ongoing', 'Completed'],
          selectedIndex: selectedIndex,
          onTabSelected: (index) {
            setState(() {
              selectedIndex = index;
            });
          },
        ),
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

            return Padding(
              padding: const EdgeInsets.only(
                left: AppTheme.homeScreenPadding,
                right: AppTheme.homeScreenPadding,
              ),
              child: IndexedStack(
                index: selectedIndex,
                children: [
                  Column(
                    children: [
                      const SizedBox(height: 16), // <-- This is your top space!
                      Expanded(child: _buildActiveTrips(activeTrips)),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Expanded(child: _buildOngoingTrips(ongoingTrips)),
                    ],
                  ),
                  Column(
                    children: [
                      const SizedBox(height: 16),
                      Expanded(child: _buildOPastTrips(completedTrips)),
                    ],
                  ),
                ],
              ),
            );
            }),
      floatingActionButton: FloatButton(
        onTap: () => {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddTripScreen()))
        },
        hintText: "New trip",
        iconPath: "assets/icon/map-point.svg",
      ),
    );
  }

  Widget _buildActiveTrips(List<Trip> activeTrips) {
    return Container(
      color: AppColors.background,
      child: activeTrips.isEmpty
          ? Center(child: Message(context, 'No active trips'))
          : ListView.builder(
              itemCount: activeTrips.length,
              itemBuilder: (context, index) {
                return Column(
                  children: [
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
