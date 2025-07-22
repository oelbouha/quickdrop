import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/widgets/loading.dart';
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
                 SizedBox(
                  width: 28,
                  height: 28,
                  child: loadingAnimation(size: 30)
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
          height: 52,
          margin: const EdgeInsets.symmetric(vertical: 20),
          child: ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: isLoading ? Colors.grey : AppColors.primary,
              elevation: 0,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          child: Center(
            child: isLoading?
                SizedBox(
                width: 24,
                height: 24,
                child: loadingAnimation(size: 30)
              )
            : Text(
                hintText,
                style:  TextStyle(
                    color: textColor, fontWeight: FontWeight.bold, fontSize: 16
                    ),
              ),
          ))
    );
  }
}
