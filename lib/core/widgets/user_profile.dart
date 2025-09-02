import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/core/utils/appUtils.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class UserProfileCard extends StatelessWidget {
  final String header;
  final String photoUrl;
  final VoidCallback onPressed;
  final String subHeader;
  final double headerFontSize;
  final double subHeaderFontSize;
  final double avatarSize;
  final Color subHeaderColor;
  final Color headerColor;
  final Color borderColor;

  const UserProfileCard({
    super.key,
    required this.header,
    required this.onPressed,
    required this.photoUrl,
    this.subHeader = "",
    required this.headerFontSize,
    this.subHeaderFontSize = 12,
    required this.avatarSize,
    this.borderColor = AppColors.blue,
    this.subHeaderColor = AppColors.lessImportant,
    this.headerColor = AppColors.headingText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
      GestureDetector (
         onTap: onPressed,
          child: buildUserProfileImage(
            photoUrl,
            borderColor,
            avatarSize
          ) ,
          ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           buildUserProfileHeader(
             header,
             headerColor,
             headerFontSize
           ),

            if (subHeader != "") buildUserProfileSubHeader(
              subHeader,
              subHeaderColor,
              subHeaderFontSize
            ),
          ],
        ),
      ],
    );
  }
}

Widget buildUserProfileSubHeader(String subHeader, Color color, double fontSize) {
  return Text(
      subHeader.length > 30
          ? "${subHeader.substring(0, 30)}..."
          : subHeader,
      style: TextStyle(
          color: color, fontSize: fontSize, fontWeight: FontWeight.bold
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    );
}

Widget buildUserProfileHeader(String header, Color color, double fontSize) {
  return  Text(
        header.length > 30 ? 
          "${header.substring(0, 30)}..." :
          header,
        style: TextStyle(
            fontSize: fontSize,
            fontWeight: FontWeight.bold,
            color: color
        ),
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
      );
}

Widget buildUserProfileImage(String photoUrl, Color borderColor, double avatarSize) {
  return Stack(
      children: [
        Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: borderColor.withOpacity(0.8),
              width: 0,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(21),
            child: CachedNetworkImage(
            imageUrl:  photoUrl,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
                decoration: BoxDecoration(
                  color: AppColors.blueStart.withValues(alpha: 0.1),
                ),
                child: const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.blue700, strokeWidth: 2))),
            errorWidget: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.blueStart.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.blueStart,
                      size: avatarSize * 0.6,
                    ),
                  );
                },
          )
          ),
        ),
      ],
  );
}


class UserProfileWithRating extends StatelessWidget {
  final UserData? user;
  final VoidCallback onPressed;
  final double headerFontSize;
  final double subHeaderFontSize;
  final double avatarSize;
  final Color subHeaderColor;
  final Color headerColor;
  final Color borderColor;
   final String header;

  const UserProfileWithRating({
    Key? key,
    required this.user,
    required this.header,
    required this.onPressed,
    required this.headerFontSize,
    this.subHeaderFontSize = 12,
    required this.avatarSize,
    this.borderColor = AppColors.blue,
    this.subHeaderColor = AppColors.lessImportant,
    this.headerColor = AppColors.headingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<double>(
      future: Provider.of<ReviewProvider>(context, listen: false).getUserAverageRating(user!.uid),
      builder: (context, snapshot) {
        String ratingText;
        if (snapshot.connectionState == ConnectionState.waiting) {
          ratingText = "Loading...";
        } else if (snapshot.hasError) {
          ratingText = "⭐ No rating";
        } else {
          double rating = snapshot.data ?? 0.0;
          ratingText = rating > 0 
              ? "⭐ ${rating.toStringAsFixed(1)} rating"
              : "⭐ No rating yet";
        }

      return  Row(
          children: [
          GestureDetector (
            onTap: onPressed,
              child: buildUserProfileImage(
                user?.photoUrl ?? AppTheme.defaultProfileImage,
                borderColor,
                avatarSize
              ) ,
              ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              buildUserProfileHeader(
                header,
                headerColor,
                headerFontSize
              ),
              buildUserProfileSubHeader(
                  ratingText,
                  subHeaderColor,
                  subHeaderFontSize
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

