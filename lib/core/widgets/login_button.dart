import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

class LoginButton extends StatelessWidget {
  final String hintText;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final double radius;

  const LoginButton({
    super.key,
    required this.hintText,
    required this.onPressed,
    required this.isLoading,
    this.radius = 30,
    this.backgroundColor = AppColors.blue,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: backgroundColor,
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
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
          )),
    );
  }
}
