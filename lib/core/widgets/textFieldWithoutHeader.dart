import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class TextFieldWithoutHeader extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String? iconPath;
  final bool obsecureText;
  final bool isRequired;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const TextFieldWithoutHeader({
    super.key,
    required this.controller,
    this.iconPath = null,
    required this.hintText,
    this.obsecureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.isRequired = true,
    this.onChanged,
  });


  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
           
         prefixIcon: iconPath != null ? Padding(
                padding:  EdgeInsets.all(12),
                child: CustomIcon(
                  iconPath: iconPath!,
                  size: 20,
                  color: AppColors.textSecondary,
               
            ),
              ) : null,
        fillColor: AppColors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.textSecondary,
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
