import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';

class UserProfileCard extends StatelessWidget {
  final String header;
  final String photoUrl;
  final VoidCallback onPressed;
  final String subHeader;
  final double headerFontSize;
  final double subHeaderFontSize;
  final double avatarSize;

  const UserProfileCard({
    Key? key,
    required this.header,
    required this.onPressed,
    required this.photoUrl,
    this.subHeader = "",
    required this.headerFontSize,
    required this.subHeaderFontSize,
    required this.avatarSize,
  }) : super(key: key);

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
        CircleAvatar(
          radius: avatarSize,
          backgroundImage: imageProvider,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              header,
              style: TextStyle(
                  fontSize: headerFontSize,
                  fontWeight: FontWeight.bold,
                  color: AppColors.headingText),
            ),
            if (subHeader != "") Text(
              subHeader,
              style: TextStyle(
                  color: AppColors.lessImportant, fontSize: subHeaderFontSize),
            ),
          ],
        ),
      ],
    );
  }
}
