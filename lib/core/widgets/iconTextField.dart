import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class IconTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final String iconPath;
  final TextInputType keyboardType; 
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;


  const IconTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.iconPath,
    required this.obsecureText,
    this.keyboardType = TextInputType.text,
     this.validator,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obsecureText,
      validator: validator,
      onChanged: onChanged,
      
      style: const TextStyle(color: AppColors.shipmentText),
      decoration: InputDecoration(
          hintStyle: const TextStyle(
            color: AppColors.textFieldHintText,
          ),
          hintText: hintText,
          filled: true,
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12), 
            child: CustomIcon(iconPath: iconPath, size: 20, color: AppColors.lessImportant,)),
            
          fillColor: AppColors.cardBackground,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(
              color: Colors.grey,
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
    );
  }
}
