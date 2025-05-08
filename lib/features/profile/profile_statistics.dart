import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/profile/statistic_card.dart';
import 'package:quickdrop_app/features/profile/review_card.dart';
import 'package:quickdrop_app/core/providers/review_provider.dart';
import 'package:quickdrop_app/features/models/review_model.dart';

class ProfileStatistics extends StatefulWidget {
  const ProfileStatistics({Key? key}) : super(key: key);

  @override
  State<ProfileStatistics> createState() => ProfileStatisticsState();
}

class ProfileStatisticsState extends State<ProfileStatistics> {
  bool _isLoading = true;
  late int pendingShipments;
  late int ongoingShipments;
  late int completedShipments;
  // List<NotificationModel> notifications = [];

  @override
  void initState() {
    super.initState();

    // Fetch trips when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final user = Provider.of<UserProvider>(context, listen: false).user;

        Provider.of<StatisticsProvider>(context, listen: false)
            .fetchStatictics(user!.uid);

        Provider.of<ReviewProvider>(context, listen: false)
            .fetchReviews(user!.uid);
        final userIds = Provider.of<ReviewProvider>(context, listen: false)
            .reviews
            .map((r) => r.senderId)
            .toSet()
            .toList();
        await Provider.of<UserProvider>(context, listen: false)
            .fetchUsersData(userIds);

        setState(() {
          _isLoading = false;
        });
      } catch (e) {
        if (mounted) {
          AppUtils.showError(context, "Failed to fetch Shipments analytics");
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final reviews = Provider.of<ReviewProvider>(context, listen: false).reviews;
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text(
            'Profile Statistics',
            style: TextStyle(color: AppColors.white),
          ),
          backgroundColor: AppColors.barColor,
          centerTitle: true,
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                color: AppColors.blue,
              ))
            : SingleChildScrollView(
                child: Column(children: [
                // const SizedBox(height: AppTheme.cardPadding),
                _buildUserStatus(),
                const SizedBox(height: AppTheme.cardPadding),
                Container(
                    margin: const EdgeInsets.only(
                        left: AppTheme.homeScreenPadding,
                        right: AppTheme.homeScreenPadding),
                    child: Column(children: [
                      const Row(children: [
                        CustomIcon(
                          iconPath: "assets/icon/package.svg",
                          size: 22,
                          color: AppColors.blue,
                        ),
                        SizedBox(width: 10),
                        Text("Shipments Statistics",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.headingText)),
                      ]),
                      const SizedBox(height: 10),
                      _buildShipmentsStats(),
                      const SizedBox(height: 25),
                      const Row(children: [
                        CustomIcon(
                          iconPath: "assets/icon/car.svg",
                          size: 22,
                          color: AppColors.blue,
                        ),
                        SizedBox(width: 10),
                        Text("Trips Statistics",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.headingText)),
                      ]),
                      _buildTripsStats(),
                      const SizedBox(
                        height: 20,
                      ),
                      _buildReviews(reviews),
                    ]))
              ])));
  }

  Widget _buildTripsStats() {
    return Consumer<StatisticsProvider>(
      builder: (context, statsProvider, child) {
        return (Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: StatisticCard(
                hintText: "Pending",
                backgroundColor: AppColors.contactBackground,
                hintTextColor: AppColors.blue,
                number: statsProvider.stats != null
                    ? statsProvider.stats!.pendingTrips.toString()
                    : "0",
              )),
              Expanded(
                  child: StatisticCard(
                hintText: "Ongoing",
                backgroundColor: AppColors.ongoingstatusBackground,
                hintTextColor: AppColors.ongoingStatusText,
                number: statsProvider.stats != null
                    ? statsProvider.stats!.ongoingTrips.toString()
                    : "0",
              )),
              Expanded(
                  child: StatisticCard(
                hintText: "Comleted",
                backgroundColor: AppColors.completedstatusBackground,
                hintTextColor: AppColors.completedStatusText,
                number: statsProvider.stats != null
                    ? statsProvider.stats!.completedTrips.toString()
                    : "0",
              )),
            ]));
      },
    );
  }

  Widget _buildShipmentsStats() {
    return Consumer<StatisticsProvider>(
      builder: (context, statsProvider, child) {
        return (Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                  child: StatisticCard(
                hintText: "Pending",
                backgroundColor: AppColors.contactBackground,
                hintTextColor: AppColors.blue,
                number: statsProvider.stats != null
                    ? statsProvider.stats!.pendingShipments.toString()
                    : "0",
              )),
              Expanded(
                  child: StatisticCard(
                hintText: "Ongoing",
                backgroundColor: AppColors.ongoingstatusBackground,
                hintTextColor: AppColors.ongoingStatusText,
                number: statsProvider.stats != null
                    ? statsProvider.stats!.ongoingShipments.toString()
                    : "0",
              )),
              Expanded(
                  child: StatisticCard(
                hintText: "Comleted",
                backgroundColor: AppColors.completedstatusBackground,
                hintTextColor: AppColors.completedStatusText,
                number: statsProvider.stats != null
                    ? statsProvider.stats!.completedShipments.toString()
                    : "0",
              )),
            ]));
      },
    );
  }

  Widget _buildReviews(List<ReviewModel> reviews) {
    return Consumer2<ReviewProvider, StatisticsProvider>(
        builder: (context, reviewProvider, statsProvider, child) {
      print("reviews length ::${reviewProvider.reviews.length}");
      return Column(children: [
        Row(children: [
          const CustomIcon(
            iconPath: "assets/icon/star.svg",
            size: 22,
            color: AppColors.blue,
          ),
          const SizedBox(width: 10),
          const Text("Reviews",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingText)),
          const SizedBox(width: 10),
          Text(
              '(${reviewProvider.reviews.length.toString()})',
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.headingText)),
        ]),
        Container(
          // margin: const EdgeInsets.only(
          //     left: AppTheme.cardPadding, right: AppTheme.cardPadding),
          color: AppColors.background,
          child: reviewProvider.reviews.isEmpty
              ? Center(child: Message(context, 'No Reviews'))
              : ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: reviewProvider.reviews.length,
                  itemBuilder: (context, index) {
                    final review = reviewProvider.reviews[index];
                    final userData =
                        Provider.of<UserProvider>(context, listen: false)
                            .getUserById(review.senderId);
                    return Column(
                      children: [
                        if (index == 0)
                          const SizedBox(height: AppTheme.gapBetweenCards),
                        ReviewCard(user: userData!, review: review),
                        const SizedBox(height: AppTheme.gapBetweenCards),
                      ],
                    );
                  },
                ),
        )
      ]);
    });
  }

  Widget _buildUserStatus() {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.user;
    return Container(
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: AppTheme.cardPadding,
          right: AppTheme.cardPadding,
          top: AppTheme.cardPadding,
          bottom: AppTheme.cardPadding,
        ),
        decoration: const BoxDecoration(color: AppColors.blue),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          CircleAvatar(
            radius: 50,
            backgroundImage: user != null && user.photoUrl != null
                ? NetworkImage(user.photoUrl!)
                : AssetImage('assets/images/profile.png') as ImageProvider,
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                user != null ? (user.displayName ?? 'Guest') : 'Guest',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.white),
              ),
              const Text(
                "Member since 2025",
                style: TextStyle(fontSize: 14, color: AppColors.lessImportant),
              ),
            ],
          ),
        ]));
  }
}
