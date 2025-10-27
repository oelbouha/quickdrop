import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';


class LoginTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obsecureText;
  final String iconPath;
  final Color backgroundColor;
  final TextInputType keyboardType;
  final double radius;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;

  const LoginTextField({
    super.key,
    required this.controller,
    required this.hintText,

    this.radius = AppTheme.textFeildRadius,
    required this.iconPath,
    required this.obsecureText,
    this.backgroundColor = AppColors.background,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
  });

  @override
  State<LoginTextField> createState() => LoginTextFieldState();
}

class LoginTextFieldState extends State<LoginTextField> {
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
      obscureText: widget.obsecureText,
      validator: widget.validator,
      onChanged: widget.onChanged,
      keyboardType: widget.keyboardType,
      style:    TextStyle(color: hasText ? AppColors.shipmentText: AppColors.shipmentText),
      decoration: InputDecoration(
        hintStyle: const TextStyle(
          color: AppColors.textFieldHintText,
        ),
        hintText: widget.hintText,
        filled: false,
        fillColor: widget.backgroundColor,
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12),
          child: CustomIcon(
            iconPath: widget.iconPath,
            size: 20,
            color: hasText? AppColors.blue700 : AppColors.lessImportant,
          ),
        ),
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
