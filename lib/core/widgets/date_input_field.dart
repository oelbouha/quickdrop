import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class DateTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color backgroundColor;
  final VoidCallback onTap;

final String? Function(String?)? validator; // For form validation
  final void Function(String)? onChanged; // Optional callback for text changes


  const DateTextField({
    super.key,
    required this.controller,
    required this.backgroundColor,
    required this.hintText,
    required this.onTap,
    this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      onChanged: onChanged,
      onTap: onTap,
      style: const TextStyle(color: AppColors.lessImportant, fontSize: 13),
      decoration: InputDecoration(
        border: const OutlineInputBorder(
          borderSide: BorderSide(color: AppColors.blue),
        ),
        fillColor: backgroundColor,
        filled: true,
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: Colors.grey, width: AppTheme.textFieldBorderWidth),
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
              color: AppColors.error, width: AppTheme.textFieldBorderWidth),
          borderRadius: BorderRadius.circular(AppTheme.cardRadius),
        ),
        suffixIcon: IconButton(
          icon: const CustomIcon(
            iconPath: "assets/icon/calendar.svg",
            color: Colors.grey
          ),
          onPressed: onTap,
        ),
          errorStyle: const TextStyle(height: 0, fontSize: 0),
      ),
    );
  }
}
