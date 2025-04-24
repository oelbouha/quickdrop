import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final IconData? icon;
  final double height;
  final double borderRadius;
  final double fontsize;
  final double horizontalPadding;
  final double borderWidth;
  final Color borderColor;
  final double  elevation;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = AppColors.blue, // Indigo color
    this.textColor = Colors.white,
    this.icon,
    this.height = 48.0,
    this.borderRadius = 4.0,
    this.fontsize = 14,
    this.horizontalPadding = 12,
    this.borderColor = AppColors.blue,
    this.borderWidth = 0,
    this.elevation = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ElevatedButton(
        
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: textColor,
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          // side: BorderSide(color: borderColor, width: borderWidth),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 24),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: TextStyle(
                fontSize: fontsize,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
