import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/core/utils/appUtils.dart';

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

  const UserProfileCard({
    super.key,
    required this.header,
    required this.onPressed,
    required this.photoUrl,
    this.subHeader = "",
    required this.headerFontSize,
     this.subHeaderFontSize = 12,
    required this.avatarSize,
    this.subHeaderColor = AppColors.lessImportant,
    this.headerColor = AppColors.headingText,
  });

  @override
  Widget build(BuildContext context) {
    ImageProvider imageProvider;
    if (photoUrl.startsWith('http')) {
      imageProvider = NetworkImage(photoUrl);
    } else {
      imageProvider = AssetImage(photoUrl);
    }
    
    return Row(
      children: [
Container(
  width: avatarSize * 2,
  height: avatarSize * 2,
  decoration: BoxDecoration(
    shape: BoxShape.circle,
    image: DecorationImage(
      image: imageProvider,
      fit: BoxFit.cover, // Ensures the image fully covers the circle
    ),
  ),
),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header.length > 30 ? 
                "${header.substring(0, 30)}..." :
                header,
              style: TextStyle(
                  fontSize: headerFontSize,
                  fontWeight: FontWeight.bold,
                  color: headerColor
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),

            if (subHeader != "") Text(
              subHeader.length > 30
                  ? "${subHeader.substring(0, 30)}..."
                  : subHeader,
              style: TextStyle(
                  color: subHeaderColor, fontSize: subHeaderFontSize, fontWeight: FontWeight.bold
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ],
    );
  }
}
