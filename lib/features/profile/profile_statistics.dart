import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:quickdrop_app/features/models/statictics_model.dart';
import 'package:quickdrop_app/features/profile/review_card.dart';
import 'package:quickdrop_app/features/models/review_model.dart';
import 'package:quickdrop_app/core/widgets/profile_image.dart';

import 'package:intl/intl.dart';




class ProfileStatisticsLoader extends StatefulWidget {
  final String userId;

  const ProfileStatisticsLoader({
    super.key,
    required this.userId,
  });

  @override
  State<ProfileStatisticsLoader> createState() => _ProfileStatisticsLoaderState();
}


class _ProfileStatisticsLoaderState extends State<ProfileStatisticsLoader> {


Future<(UserData, StatisticsModel)> fetchData() async {
  try {
      final user = await Provider.of<UserProvider>(context, listen: false).fetchUserData(widget.userId);
      final stats = await Provider.of<StatisticsProvider>(context, listen: false)
            .getStatictics(user.uid);
      await Provider.of<ReviewProvider>(context, listen: false)
              .fetchReviews(user.uid);
          final userIds = Provider.of<ReviewProvider>(context, listen: false)
              .reviews
              .map((r) => r.senderId)
              .toSet()
              .toList();
          await Provider.of<UserProvider>(context, listen: false)
              .fetchUsersData(userIds);
      if (stats == null) {
        return Future.error("${AppLocalizations.of(context)!.profile_statistics_not_found} ${user.displayName}");
    }
    return (user, stats);
  } catch (e) {
    return Future.error("${AppLocalizations.of(context)!.profile_error_message}$e");
  }
}




@override
Widget build(BuildContext context) {
  return FutureBuilder<(UserData, StatisticsModel)>(
    future: fetchData(),
    builder: (context, snapshot) {
      if (snapshot.connectionState != ConnectionState.done) {
        return   Scaffold(
           appBar: AppBar(
          backgroundColor: AppColors.appBarBackground,
          title: Text(
            AppLocalizations.of(context)!.profile_title,
            style: const TextStyle(color: AppColors.appBarText, fontWeight: FontWeight.w600),
            
          ),
          centerTitle: true,
        ),
          backgroundColor: AppColors.background,
          body:  loadingAnimation()
        );
      }

      if (snapshot.hasError) {
        return ErrorPage(errorMessage: snapshot.error.toString());
      }

      final (userData, stats) = snapshot.data!;

      return ProfileStatistics(
        user: userData,
        stats: stats,
      );
    },
  );
}
}


class ProfileStatistics extends StatefulWidget {
  final UserData user;
   final StatisticsModel? stats;
  const ProfileStatistics({
    Key? key,
    required this.user,
    required this.stats,
  }) : super(key: key);


  @override
  State<ProfileStatistics> createState() => ProfileStatisticsState();
}

class ProfileStatisticsState extends State<ProfileStatistics> {


String  calculateTime(String rawDate) {
  DateTime pastDate = DateFormat("dd/MM/yyyy").parse(rawDate);

  Duration diff = DateTime.now().difference(pastDate);

  String timeAgo = formatTimeAgo(diff);

  return timeAgo;
}

String formatTimeAgo(Duration diff) {
  final loc = AppLocalizations.of(context)!;
  
  if (diff.inDays > 365) {
    int years = (diff.inDays / 365).floor();
    return "$years ${years > 1 ? loc.profile_year_plural : loc.profile_year_singular} ${loc.profile_ago}";
  } else if (diff.inDays > 30) {
    int months = (diff.inDays / 30).floor();
    return "$months ${months > 1 ? loc.profile_month_plural : loc.profile_month_singular} ${loc.profile_ago}";
  } else if (diff.inDays > 0) {
    return "${diff.inDays} ${diff.inDays > 1 ? loc.profile_day_plural : loc.profile_day_singular} ${loc.profile_ago}";
  } else if (diff.inHours > 0) {
    return "${diff.inHours} ${diff.inHours > 1 ? loc.profile_hour_plural : loc.profile_hour_singular} ${loc.profile_ago}";
  } else if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes > 1 ? loc.profile_minute_plural : loc.profile_minute_singular} ${loc.profile_ago}";
  } else {
    return loc.profile_just_now;
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.appBarBackground,
          title: Text(
            AppLocalizations.of(context)!.profile_title,
            style: const TextStyle(color: AppColors.appBarText, fontWeight: FontWeight.w600),
            
          ),
          centerTitle: true,
        ),
        body:  SingleChildScrollView(
            padding: const EdgeInsets.all(AppTheme.homeScreenPadding),
            physics: const BouncingScrollPhysics(),
            child: Column(children: [
              _buildUserStats(),
              const SizedBox(height: AppTheme.cardPadding),
              _buildContent()
          ])));
  }

  Widget _buildContent() {
    return Column(
      children: [
        _buildStatisticsSection(),
        const SizedBox(height: 32),
        _buildReviewsSection(),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: textColor,
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: textColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShipmentsStats() {
    return Consumer<StatisticsProvider>(
      builder: (context, statsProvider, child) {
        return _buildStatsRow([
          _buildStatCard(
            title: AppLocalizations.of(context)!.profile_pending,
            value: widget.stats?.pendingShipments.toString() ?? "0",
            backgroundColor: AppColors.contactBackground,
            textColor: AppColors.blue,
            icon: Icons.pending_actions,
          ),
          _buildStatCard(
            title: AppLocalizations.of(context)!.profile_ongoing,
            value: widget.stats?.ongoingShipments.toString() ?? "0",
            backgroundColor: AppColors.ongoingstatusBackground,
            textColor: AppColors.ongoingStatusText,
            icon: Icons.local_shipping,
          ),
          _buildStatCard(
            title: AppLocalizations.of(context)!.profile_completed,
            value: widget.stats?.completedShipments.toString() ?? "0",
            backgroundColor: AppColors.completedstatusBackground,
            textColor: AppColors.completedStatusText,
            icon: Icons.check_circle,
          ),
        ]);
      },
    );
  }

  Widget _buildStatisticsSection() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader(
            icon: "assets/icon/package.svg",
            title: AppLocalizations.of(context)!.profile_shipments_overview,
          ),
          const SizedBox(height: 16),
          _buildShipmentsStats(),
          const SizedBox(height: 32),
          _buildSectionHeader(
            icon: "assets/icon/car.svg",
            title: AppLocalizations.of(context)!.profile_trips_overview,
          ),
          const SizedBox(height: 16),
          _buildTripsStats(),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String icon, required String title}) {
    return Row(
      children: [
        CustomIcon(
          iconPath: icon,
          size: 24,
          color: AppColors.blue,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.headingText,
          ),
        ),
      ],
    );
  }

  Widget _buildTripsStats() {
    return Consumer<StatisticsProvider>(
      builder: (context, statsProvider, child) {
        return _buildStatsRow([
          _buildStatCard(
            title: AppLocalizations.of(context)!.profile_pending,
            value: widget.stats?.pendingTrips.toString() ?? "0",
            backgroundColor: AppColors.contactBackground,
            textColor: AppColors.blue,
            icon: Icons.pending_actions,
          ),
          _buildStatCard(
            title: AppLocalizations.of(context)!.profile_ongoing,
            value: widget.stats?.ongoingTrips.toString() ?? "0",
            backgroundColor: AppColors.ongoingstatusBackground,
            textColor: AppColors.ongoingStatusText,
            icon: Icons.directions_car,
          ),
          _buildStatCard(
            title: AppLocalizations.of(context)!.profile_completed,
            value: widget.stats?.completedTrips.toString() ?? "0",
            backgroundColor: AppColors.completedstatusBackground,
            textColor: AppColors.completedStatusText,
            icon: Icons.check_circle,
          ),
        ]);
      },
    );
  }

  Widget _buildStatsRow(List<Widget> cards) {
    return Row(
      children: cards.map((card) => Expanded(child: card)).toList(),
    );
  }

  Widget _buildReviewsSection() {
    return Consumer<ReviewProvider>(
      builder: (context, reviewProvider, child) {
        final reviews = reviewProvider.reviews;
        return Container(
            width: double.infinity,
            child: Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CustomIcon(
                        iconPath: "assets/icon/star.svg",
                        size: 24,
                        color: AppColors.blue,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        AppLocalizations.of(context)!.profile_reviews,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.headingText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.blue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          reviews.length.toString(),
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildReviewsList(reviews),
                ],
              ),
            ));
      },
    );
  }

  Widget _buildReviewsList(List<ReviewModel> reviews) {
    if (reviews.isEmpty) {
      return _buildEmptyReviews();
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: reviews.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final review = reviews[index];
        final userData = Provider.of<UserProvider>(context, listen: false)
            .getUserById(review.senderId);

        return Container(
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ReviewCard(user: userData!, review: review),
        );
      },
    );
  }

  Widget _buildEmptyReviews() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.borderGray200,
          width: 1,
        ),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.star_border,
            size: 48,
            color: AppColors.textLight,
          ),
           const SizedBox(height: 16),
           Text(
            AppLocalizations.of(context)!.profile_no_reviews_yet,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.headingText,
            ),
          ),
        ],
      ),
    );
  }

Widget _buildUserStats() {
  return Container(
    padding: const EdgeInsets.only(
      top: 32,
      left: 16,
      right: 16,
      bottom: 32
    ),
    width: double.infinity,
    decoration: BoxDecoration(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.05),
          blurRadius: 10,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: FittedBox(
      fit: BoxFit.scaleDown,
      child: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                buildProfileImage(user: widget.user, size: 120),
                const SizedBox(height: 12),
                Text(
                  widget.user.displayName ?? AppLocalizations.of(context)!.profile_guest_user,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                 Text(
                  widget.user.status.toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.dark,

                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            const SizedBox(width: 32),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.profile_joined,
                  style: const TextStyle(
                    fontSize: 18,
                    color: AppColors.dark,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  calculateTime(widget.user.createdAt!),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.dark,
                  ),
                ),
                
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

}