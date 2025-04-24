import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

class LoginButton extends StatelessWidget {
  final String hintText;
  final VoidCallback onPressed;
  final bool isLoading;

  const LoginButton({
    super.key,
    required this.hintText,
    required this.onPressed,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.blue,
            borderRadius: BorderRadius.circular(AppTheme.textFeildRadius),
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
