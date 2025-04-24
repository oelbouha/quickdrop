import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color backgroundColor;
  final int? maxLines;
  final bool obscureText;
  final String? Function(String?)? validator; // For form validation
  final void Function(String)? onChanged; // Optional callback for text changes

  const CustomTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.backgroundColor,
    this.maxLines = 1,
    this.obscureText = false,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: maxLines == 1 ? 50 : 100,
      child: TextFormField(
        controller: controller,
      
        style: const TextStyle(color: AppColors.lessImportant, fontSize: 13),
        maxLines: maxLines,
        obscureText: obscureText,
        keyboardType: maxLines == 1 ? TextInputType.text : TextInputType.multiline,
        validator: validator,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          fillColor: backgroundColor,
          filled: true,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
              width: AppTheme.textFieldBorderWidth,
            ),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.blue,
              width: AppTheme.textFieldBorderWidth,
            ),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.error,
              width: AppTheme.textFieldBorderWidth,
            ),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
           focusedErrorBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.error,
              width: AppTheme.textFieldBorderWidth,
            ),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
            errorStyle: const TextStyle(height: 0, fontSize: 0),
         
        ),
      ),
    );
  }
}