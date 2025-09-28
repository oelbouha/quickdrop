import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

class AuthButton extends StatelessWidget {
  final String hintText;
  final VoidCallback onPressed;
  final String? imagePath; // Optional image/logo
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
    this.radius = 8.0, // Material 3 default
    this.backgroundColor = AppColors.cardBackground,
    this.textColor = AppColors.shipmentText,
    this.borderColor = AppColors.lessImportant,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 52, 
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(radius),
          border: Border.all(
            width: 1,
            color: isLoading ? AppColors.shipmentText : borderColor,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isLoading)
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: AppColors.blue,
                ),
              )
            else ...[
              if (imagePath != null)
                SizedBox(
                  width: 24, 
                  height: 24,
                  child: Image.asset(imagePath!, fit: BoxFit.contain),
                ),
              if (imagePath != null) const SizedBox(width: 8),
              Text(
                hintText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w500, 
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
