import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class TextFieldWithHeader extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String headerText;
  final bool obsecureText;
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
    required this.headerText,
    this.obsecureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.maxLines = 1,
    this.isRequired = true,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              headerText,
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
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.lessImportant),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  maxLines: maxLines,
                  controller: controller,
                  obscureText: obsecureText,
                  validator: validator,
                  onChanged: onChanged,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.shipmentText,
                  ),
                  decoration: InputDecoration(
                    hintText: hintText,
                    hintStyle: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.normal,
                    ),
                    prefixIcon: _buildPrefixIcon(),
                    suffixText: suffixText,
                    suffixStyle: TextStyle(
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
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