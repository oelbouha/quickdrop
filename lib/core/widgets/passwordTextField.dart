import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';


class PasswordTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final Color backgroundColor ;
  bool showPrefix ;

  PasswordTextfield({
    super.key,
    required this.controller,
    this.backgroundColor = AppColors.background,
    this.validator,
    this.onChanged,
    this.showPrefix = true,
  });

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  bool _obscureText = true;

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      style: const TextStyle(color: AppColors.shipmentText),
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          color: AppColors.textFieldHintText,
        ),
        hintText: "Password",
        filled: true,
        prefixIcon:  widget.showPrefix == true ? const Padding(
          padding:  EdgeInsets.all(12),
          child: CustomIcon(
            iconPath: "assets/icon/lock.svg",
            size: 20,
            color: AppColors.lessImportant,
          ),
        ) : null,
        suffixIcon: IconButton(
          onPressed: _toggleVisibility,
          icon: CustomIcon(
            iconPath: _obscureText
                ? "assets/icon/eye-closed-svgrepo-com.svg"
                : "assets/icon/eye.svg",
            size: 20,
            color: AppColors.shipmentText,
          ),
        ),
        fillColor: widget.backgroundColor,
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
