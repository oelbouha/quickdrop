import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

class LoginButton extends StatelessWidget {
  final String hintText;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final double radius;
  final Color textColor;

  const LoginButton({
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
      onTap: onPressed,
      child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
           gradient: const LinearGradient(
          colors: [AppColors.blueStart, AppColors.purpleStart],
        ),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Center(
            child: isLoading?
                const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.white,
                  ),
              ) 
            :
              Text(
                hintText,
                style:  TextStyle(
                    color: textColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
          )),
    );
  }
}
