import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/widgets/loading_skeleton.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

/// Main login/signup button
class PrimaryButton extends StatelessWidget {
  final String hintText;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final double radius;
  final Color textColor;

  const PrimaryButton({
    super.key,
    required this.hintText,
    required this.onPressed,
    required this.isLoading,
    this.radius = AppTheme.textFeildRadius,
    this.backgroundColor = AppColors.blue,
    this.textColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPressed,
      child: Container(
        height: 56, 
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: isLoading ? Colors.grey : backgroundColor,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: Center(
          child: isLoading
              ? SizedBox(
                  width: 24,
                  height: 24,
                  child: loadingAnimation(size: 30),
                )
              : Text(
                  hintText,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontSize: 16, 
                        fontWeight: FontWeight.w600, 
                        color: textColor,
                      ),
                ),
        ),
      ),
    );
  }
}

/// General-purpose button
class Button extends StatelessWidget {
  final String hintText;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final double radius;
  final Color textColor;

  const Button({
    super.key,
    required this.hintText,
    required this.onPressed,
    required this.isLoading,
    this.radius = AppTheme.textFeildRadius,
    this.backgroundColor = AppColors.blue700,
    this.textColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48, 
      margin: const EdgeInsets.symmetric(vertical: 12),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading ? Colors.grey : backgroundColor,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: loadingAnimation(size: 30),
              )
            : Text(
                hintText,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontSize: 14, 
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
              ),
      ),
    );
  }
}
