import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class TextFieldWithHeader extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final bool isRequired;
  final String iconPath;
  final TextInputType keyboardType; 
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;


  const TextFieldWithHeader({
    super.key,
    required this.controller,
    required this.hintText,
    this.iconPath = "d  ",
     this.obsecureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isRequired = true,
    this.onChanged,
  });

  @override
  
  @override
Widget build(BuildContext context) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            hintText,
            style: const TextStyle(
              color: AppColors.headingText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (isRequired)
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
      const SizedBox(height: 2),
      TextFormField(
        controller: controller,
        obscureText: obsecureText,
        validator: validator,
        onChanged: onChanged,
        keyboardType: keyboardType,
        style: const TextStyle(color: AppColors.shipmentText),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
            color: AppColors.lessImportant,
          ),
          filled: true,
          fillColor: AppColors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: AppColors.lessImportant,
              width: AppTheme.textFieldBorderWidth,
            ),
            borderRadius: BorderRadius.circular(AppTheme.textFeildRadius),
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
        ),
      ),
    ],
  );
}

}
