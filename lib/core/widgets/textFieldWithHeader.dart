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
  final Color iconColor;
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
    this.iconColor = AppColors.lessImportant,
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
      color: Colors.grey.shade200,
      width: AppTheme.textFieldBorderWidth,
    );

     final BorderSide focusedBorderSide = BorderSide(
      color:  AppColors.blue,
      width: 2,
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
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.normal,
                    ),
                    enabledBorder: OutlineInputBorder(
                    borderSide: borderSide,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: focusedBorderSide,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: AppTheme.textFieldBorderWidth,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: AppColors.error,
                      width: AppTheme.textFieldBorderWidth,
                    ),
                    borderRadius: BorderRadius.circular(12),
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
        color: iconColor,
        size: 20,
      );
    } else if (iconPath != null) {
      return Padding(
        padding: const EdgeInsets.all(12),
        child: CustomIcon(
          iconPath: iconPath!,
          size: 20,
          color:iconColor,
        ),
      );
    }
    return null;
  }
}