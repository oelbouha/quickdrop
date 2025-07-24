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
  final double radius;

  PasswordTextfield({
    super.key,
    required this.controller,
    this.backgroundColor = AppColors.background,
    this.validator,
    this.onChanged,
    this.showPrefix = true,
    this.radius = AppTheme.textFeildRadius,
  });

  @override
  State<PasswordTextfield> createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  bool _obscureText = true;
 bool hasText = false;

  @override
  void initState() {
    super.initState();
    hasText = widget.controller.text.isNotEmpty;
    widget.controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    if (mounted) {
      setState(() {
        hasText = widget.controller.text.isNotEmpty;
      });
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _toggleVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
     final BorderSide borderSide = BorderSide(
      color: hasText ? AppColors.blue700 : Colors.grey,
      width: AppTheme.textFieldBorderWidth,
    );

    final BorderSide focusedBorderSide = BorderSide(
      color: hasText ? AppColors.blue700 : AppColors.blue,
      width: AppTheme.textFieldBorderWidth,
    );
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
        filled: false,
        prefixIcon:  widget.showPrefix == true ?  Padding(
          padding:  EdgeInsets.all(12),
          child: CustomIcon(
            iconPath: "assets/icon/lock.svg",
            size: 20,
            color: hasText ? AppColors.blue700: AppColors.lessImportant,
          ),
        ) : null,
        suffixIcon: IconButton(
          onPressed: _toggleVisibility,
          icon: CustomIcon(
            iconPath: _obscureText
                ? "assets/icon/eye-closed-svgrepo-com.svg"
                : "assets/icon/eye.svg",
            size: 20,
            color:  AppColors.shipmentText,
          ),
        ),
        fillColor: widget.backgroundColor,
        enabledBorder: OutlineInputBorder(
          borderSide: borderSide,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: focusedBorderSide,
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppTheme.textFieldBorderWidth,
          ),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppTheme.textFieldBorderWidth,
          ),
          borderRadius: BorderRadius.circular(widget.radius),
        ),
      ),
    );
  }
}
