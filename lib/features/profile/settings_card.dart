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
  final bool isLoading;

  const SettingsCard({
    required this.iconPath,
    required this.hintText,
    this.hintTextColor = AppColors.headingText,
    this.backgroundColor = Colors.transparent,
    this.iconColor = AppColors.lightGray,
    required this.onTap,
    this.isLoading = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor == AppColors.lightGray 
                      ? AppColors.blueStart.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                  child: CustomIcon(
                    iconPath: iconPath,
                    size: 20,
                    color: iconColor == AppColors.lightGray 
                        ? AppColors.blueStart 
                        : iconColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  hintText,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: hintTextColor,
                  ),
                ),
              ),
              if (isLoading)
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      hintTextColor.withOpacity(0.6),
                    ),
                  ),
                )
              else
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: hintTextColor.withOpacity(0.6),
                ),
            ],
          ),
        ),
      ),
    );
  }
 
}
