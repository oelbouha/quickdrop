import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class TextFieldWithHeader extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String headerText;
  final bool obsecureText;
  final bool displayHeader;
  final bool isRequired;
  final String? iconPath;
  final IconData? prefixIcon;
  final String? suffixText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  int maxLines;

  TextFieldWithHeader({
    super.key,
    required this.controller,
    required this.hintText,
    this.iconPath,
    this.prefixIcon,
    this.suffixText,
     this.headerText = "",
    this.obsecureText = false,
    this.displayHeader = true,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.isRequired = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
     final BorderSide borderSide = BorderSide(
      color: Colors.grey,
      width: AppTheme.textFieldBorderWidth,
    );

     final BorderSide focusedBorderSide = BorderSide(
      color:  AppColors.blue,
      width: AppTheme.textFieldBorderWidth,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (displayHeader)
            Text(
              headerText,
              style: const TextStyle(
                color: AppColors.headingText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
          ],
        ),
        if (displayHeader) const SizedBox(height: 8),
        TextFormField(
          
                  maxLines: maxLines,
                  controller: controller,
                  obscureText: obsecureText,
                  validator: validator,
                  onChanged: onChanged,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.shipmentText,
                  ),
                  decoration: InputDecoration(

    // contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.normal,
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderSide: borderSide,
                    borderRadius: BorderRadius.circular(AppTheme.textFeildRadius),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: focusedBorderSide,
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
                    prefixIcon: _buildPrefixIcon(),        
                  ),
                    
                  
                ),
      ],
    );
  }

  Widget? _buildPrefixIcon() {
    if (prefixIcon != null) {
      return Icon(
        prefixIcon,
        color: AppColors.lessImportant,
        size: 20,
      );
    } else if (iconPath != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: CustomIcon(
          iconPath: iconPath!,
          size: 20,
          color: AppColors.lessImportant,
        ),
      );
    }
    return null;
  }
}