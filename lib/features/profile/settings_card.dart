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
    this.iconColor = AppColors.headingText,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:  Container(
        padding: const EdgeInsets.only(
          top: AppTheme.homeScreenPadding,
          bottom: AppTheme.homeScreenPadding,
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
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
      ],
)

    ));
  }

  Widget _buildText() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        CustomIcon(
          iconPath: iconPath,
          size: 22,
          color: hintTextColor,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          hintText,
          style: TextStyle(
            color: hintTextColor,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          textAlign: TextAlign.left,
        ),
      ],
    );
  }
}
