import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
// import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:quickdrop_app/core/widgets/button.dart';
import 'package:quickdrop_app/core/widgets/destination.dart';
import 'package:quickdrop_app/core/widgets/item_details.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class TripCard extends StatefulWidget {
  final Trip trip;
  final Map<String, dynamic> userData;
  const TripCard({super.key, required this.trip, required this.userData});

  @override
  TripCardState createState() => TripCardState();
}

class TripCardState extends State<TripCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: const EdgeInsets.all(10),
      height: AppTheme.imageHeight,
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 0.2,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: _buildListingDetails(),
    );
  }

  Widget _buildUserRating() {
    return const Row(children: [
      Icon(
        Icons.person,
        color: AppColors.lessImportant,
        size: 6,
      ),
      Text("4.5 ", style: TextStyle(color: AppColors.headingText, fontSize: 8)),
      Icon(
        Icons.star,
        color: AppColors.lessImportant,
        size: 6,
      ),
      Text(" 126 trips",
          style: TextStyle(color: AppColors.headingText, fontSize: 8)),
    ]);
  }

  Widget _buildUserProfile() {
    return  Row(
      children: [
        CircleAvatar(
          radius: 14,
          backgroundImage: NetworkImage(widget.userData['photoUrl']) as ImageProvider,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.userData['displayName'],
              style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headingText),
            ),
            // _buildUserRating(),
          ],
        ),
      ],
    );
  }

  Widget _buildPrice() {
    return  Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const Text("From ",
            style: TextStyle(color: AppColors.lessImportant, fontSize: 12)),
        Text('${widget.trip.price}dh',
            style: const TextStyle(
                color: AppColors.blue,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildListingDetails() {
    return Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildUserProfile(),
                const SizedBox(height: AppTheme.cardGap),
                Destination(
                    from: truncateText(widget.trip.from),
                    to: truncateText(widget.trip.to)),
                const SizedBox(height: AppTheme.cardGap),
                ItemDetail(
                  iconPath: "assets/icon/calendar.svg",
                  title: "Delivery by: ",
                  value: '${widget.trip.date}',
                ),
                const SizedBox(height: AppTheme.cardGap),
                ItemDetail(
                  iconPath: "assets/icon/weight.svg",
                  title: "Available weight  ",
                  value: widget.trip.weight + " kg",
                ),
                Spacer(),
                _buildPrice(),
              ],
            ));
  }

  Widget _sendRequestButton() {
    return CustomButton(
      text: 'Request',
      onPressed: () {
        // Your contact logic here
      },
      textColor: Colors.white,
      height: 34,
      backgroundColor: AppColors.blue,
      borderRadius: AppTheme.requestButtonRaduis,
      horizontalPadding: 6,
      fontsize: 12,
    );
  }
}
