import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class SettingsCard extends StatelessWidget {
  final String hintText;
  final Color hintTextColor;
  final Color backgroundColor;
  final Color iconColor;
  final String iconPath;
  final VoidCallback onTap;

  const SettingsCard({
    required this.iconPath,
    required this.hintText,
    this.hintTextColor = AppColors.headingText,
    this.backgroundColor = AppColors.cardBackground,
    this.iconColor = AppColors.lightGray,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:  Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        padding: const EdgeInsets.only(
          top: AppTheme.homeScreenPadding,
          bottom: AppTheme.homeScreenPadding,
          left: 8,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CustomIcon(
              iconPath: iconPath,
              size: 22,
              color: iconColor,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              hintText,
              style:  TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: hintTextColor),
            ),
      ],
)

    ));
  }

 
}
