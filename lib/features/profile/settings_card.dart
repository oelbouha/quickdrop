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
    return SizedBox(
        width: double.infinity, // Full width
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(AppTheme.cardPadding),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.cardRadius),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  spreadRadius: 0.2,
                  blurRadius: 2,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildText(),
                CustomIcon(iconPath: "assets/icon/alt-arrow-right.svg", size: 20, color: iconColor),
              ],
            ),
          ),
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
