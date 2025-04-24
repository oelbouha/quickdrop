import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:flutter/services.dart';


class NumberField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color backgroundColor;

final String? Function(String?)? validator; // For form validation
  final void Function(String)? onChanged; // Optional callback for text changes

  const NumberField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.backgroundColor,
    this.validator,
    this.onChanged
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: TextFormField(
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        controller: controller,
        validator: validator,
        onChanged: onChanged,
        style: const TextStyle(color: AppColors.lessImportant, fontSize: 13),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: AppColors.blue),
          ),
          hintText: hintText,
          fillColor: backgroundColor,
          filled: true,
          enabledBorder
              : OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey, width: 1.0),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.blue, width: 1.0),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
          errorBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: AppColors.error, width: 1.0),
            borderRadius: BorderRadius.circular(AppTheme.cardRadius),
          ),
            errorStyle: const TextStyle(height: 0, fontSize: 0),
        ),
    ));
  }
}
