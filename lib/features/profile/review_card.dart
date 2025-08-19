import 'package:quickdrop_app/features/models/review_model.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

import 'package:flutter_rating_bar/flutter_rating_bar.dart';


import 'package:intl/intl.dart';


String formatDate(String rawDate) {
  DateTime dateTime = DateFormat("dd/MM/yyyy").parse(rawDate);
  String formatted = DateFormat("dd MMM yyyy").format(dateTime); 
  return formatted;
}

class ReviewCard extends StatelessWidget {
  final UserData user;
  final ReviewModel review;

  const ReviewCard({
    required this.user,
    required this.review,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: AppColors.background,
        child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              _buildBody(),
              const SizedBox(
                height: AppTheme.cardPadding,
              ),
              Text(
                review.message,
                style: const TextStyle(
                    color: AppColors.headingText, fontWeight: FontWeight.w600),
              ),
            ])));
  }

  Widget _buildBody() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserProfileCard(
              header: user.displayName ?? "Unknown user",
              onPressed: () => print("user profile  Clicked"),
              subHeader: formatDate(review.date),
              photoUrl: user.photoUrl ?? AppTheme.defaultProfileImage,
              headerFontSize: 14,
              subHeaderFontSize: 10,
              avatarSize: 34,
            ),
           RatingBarIndicator(
              rating: review.rating, 
              itemBuilder: (context, _) => const CustomIcon(
                iconPath: "assets/icon/star.svg",
                color: AppColors.rateBackground,
              ),
              itemCount: 5,
              itemSize: 14.0,
              direction: Axis.horizontal,
            ),
          ],
        ),
      ],
    );
  }
}
