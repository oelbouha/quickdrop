import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';

class GestureDetectorWidget extends StatelessWidget {
  final String hintText;
  final VoidCallback onPressed;

  const GestureDetectorWidget({
    super.key,
    required this.hintText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        hintText,
        style: const TextStyle(
          color: AppColors.shipmentText,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
