import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

class AuthButton extends StatelessWidget {
  final String hintText;
  final VoidCallback onPressed;
  final String? imagePath; // Optional image
  final bool isLoading;
  final double radius;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;


  const AuthButton({
    super.key,
    required this.hintText,
    required this.onPressed,
    this.imagePath,
    this.radius = AppTheme.textFeildRadius,
    this.backgroundColor = AppColors.cardBackground,
    this.textColor = AppColors.shipmentText,
    this.borderColor = AppColors.lessImportant,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading? null : onPressed,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:  backgroundColor, 
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(width: 1, color: isLoading? AppColors.shipmentText: borderColor),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 28,
                height: 28,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  color: AppColors.blue,
                ),
              )
            else ...[
              if (imagePath != null)
                SizedBox(
                  width: 28,
                  child: Image.asset(imagePath!, fit: BoxFit.contain),
                ),
              const SizedBox(width: 8),
              Text(
                hintText,
                style:
                     TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
