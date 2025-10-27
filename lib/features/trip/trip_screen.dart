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
  UserData? user;
  bool _isLoading = true;
  late TabController _tabController;

  // final ScrollController _scrollController = ScrollController();
  bool _isExpanded = true;

  void removeTrip(String id) async {
    final t = AppLocalizations.of(context)!;
    final confirmed = await ConfirmationDialog.show(
      context: context,
      message: t.action_cannot_be_undone,
      header: t.delete_trip_title,
      buttonHintText: t.delete,
      iconPath: "assets/icon/trash-bin.svg",
    );
    if (!confirmed) return;

    try {
      await Provider.of<TripProvider>(context, listen: false).deleteTrip(id);
      await Provider.of<DeliveryRequestProvider>(context, listen: false)
          .deleteRequestsByTripId(id);
      AppUtils.showDialog(context, t.trip_deleted, AppColors.succes);
      Provider.of<StatisticsProvider>(context, listen: false)
          .decrementField(user!.uid, "pendingTrips");
    } catch (e) {
      if (mounted) {
        AppUtils.showDialog(context, t.trip_deleted_failed, AppColors.error);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(_handleScroll);
    _tabController = TabController(length: 3, vsync: this);

    // Fetch trips when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final t = AppLocalizations.of(context)!;  
      try {
        user = Provider.of<UserProvider>(context, listen: false).user;
        final tripProvider = Provider.of<TripProvider>(context, listen: false);
        await tripProvider.fetchTripsBuUserId(user!.uid);

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
        if (mounted) {
          AppUtils.showDialog(context, t.error_fetch_trips(e), AppColors.error);
        }
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

  //  void _handleScroll() {
  //   if (_scrollController.position.userScrollDirection == ScrollDirection.reverse && _isExpanded) {
  //     setState(() => _isExpanded = false);
  //   } else if (_scrollController.position.userScrollDirection == ScrollDirection.forward && !_isExpanded) {
  //     setState(() => _isExpanded = true);
  //   }
  // }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: MainAppBar(
        tabController: _tabController,
        tabs: [
          t.active,
          t.ongoing,
          t.completed,
        ],
        title: t.trips,
      ),
      body: _isLoading
          ? loadingAnimation()
          : Consumer<TripProvider>(builder: (context, provider, child) {
              final user = FirebaseAuth.instance.currentUser;
              if (user == null) {
                return Center(
                    child: Text(AppLocalizations.of(context)!.login_required));
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
        onTap: () => {
           Provider.of<UserProvider>(context, listen: false).canDriverMakeActions()
              ? context.push("/add-trip")
              : AppUtils.showDialog(
                  context,
                  AppLocalizations.of(context)!
                      .driver_cannot_create_trip_message,
                  AppColors.error)
          },
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
    return SizedBox.expand(
        child: Center(
            child: Padding(
      padding: EdgeInsets.all(48),
      child: Column(
        mainAxisSize: MainAxisSize.min,
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
            ),
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
            // child: ElevatedButton(
            //   onPressed: () => {context.push("/add-trip")},
            //   style: ElevatedButton.styleFrom(
            //     backgroundColor: Colors.transparent,
            //     shadowColor: Colors.transparent,
            //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(12),
            //     ),
            //   ),
            //   child: Text(
            //     buttonText,
            //     style: const TextStyle(
            //       color: Colors.white,
            //       fontSize: 16,
            //       fontWeight: FontWeight.w600,
            //     ),
            //   ),
            // ),
          ),
        ],
      ),
    )));
  }

  Widget _buildActiveTrips(List<Trip> activeTrips) {
    final t = AppLocalizations.of(context)!;
    return Container(
      margin: const EdgeInsets.only(
          left: AppTheme.cardPadding, right: AppTheme.cardPadding),
      color: AppColors.background,
      child: activeTrips.isEmpty
          ? Center(
              child: _buildEmptyState(
              icon: Icons.directions_car,
              title: t.no_active_trips,
              subtitle: t.no_active_trips_subtitle,
              buttonText: "Post Trip",
            ))
          : ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: activeTrips.length,
              itemBuilder: (context, index) {
                final trip = activeTrips[index];
                return Column(
                  children: [
                    if (index == 0)
                      const SizedBox(height: AppTheme.gapBetweenCards),
                    ActiveItemCard(
                      onEditPressed: () => {
                        context.push('/add-trip?tripId=${trip.id}&isEdit=true')
                      },
                      onViewPressed: () => {
                        context.push(
                            '/trip-details?tripId=${trip.id}&userId=${trip.userId}&viewOnly=true')
                      },
                      item: trip,
                      onPressed: () => {removeTrip(trip.id!)},
                    ),
                    const SizedBox(height: AppTheme.gapBetweenCards),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildOngoingTrips(List<Trip> ongoingTrips) {
    final t = AppLocalizations.of(context)!;
    return Consumer<TripProvider>(builder: (context, tripProvider, child) {
      return Container(
        margin: const EdgeInsets.only(
            left: AppTheme.cardPadding, right: AppTheme.cardPadding),
        color: AppColors.background,
        child: ongoingTrips.isEmpty
            ? Center(
                child: _buildEmptyState(
                icon: Icons.directions_car,
                title: t.no_ongoing_trips,
                subtitle: t.no_ongoing_trips_subtitle,
                buttonText: "Post Trip",
              ))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
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
                          onViewPressed: () => {
                                context.push(
                                    '/trip-details?tripId=${trip.id}&userId=${trip.userId}&viewOnly=true')
                              },
                          item: ongoingTrips[index],
                          user: userData),
                      const SizedBox(height: AppTheme.gapBetweenCards),
                    ],
                  );
                },
              ),
      );
    });
  }

  Widget _buildOPastTrips(List<Trip> completedTrips) {
    final t = AppLocalizations.of(context)!;
    return Consumer<TripProvider>(builder: (context, tripProvider, child) {
      return Container(
        margin: const EdgeInsets.only(
            left: AppTheme.cardPadding, right: AppTheme.cardPadding),
        color: AppColors.background,
        child: completedTrips.isEmpty
            ? Center(
                child: _buildEmptyState(
                icon: Icons.directions_car,
                title: t.no_completed_trips,
                subtitle: t.no_completed_trips_subtitle,
                buttonText: "Post Trip",
              ))
            : ListView.builder(
                physics: const BouncingScrollPhysics(),
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
                          onViewPressed: () => {
                                context.push(
                                    '/trip-details?tripId=${trip.id}&userId=${trip.userId}&viewOnly=true')
                              },
                          item: trip,
                          user: userData,
                          onReviewPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return ReviewUserDialog(
                                  recieverUser: userData,
                                );
                              },
                            );
                          },
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
