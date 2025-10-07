import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

  
  
  Widget BuildPrimaryButton({
    required VoidCallback onPressed,
    required String label,
    required Color color,
    required String icon,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ 
            CustomIcon(
              iconPath: icon,
              size: 20,
              color: Colors.white,
          ),
          const SizedBox(width: 8),
            Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),

          ])
        ),
      ),
    );
  }

class SecondaryButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color iconColor;

  const SecondaryButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = const Color(0xFFF3F4F6),
    this.iconColor = const Color(0xFF6B7280),
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isLoading ? null : onPressed,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(12),
          ),
          child: isLoading
              ?  SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: iconColor,
                  ),
                )
              : CustomIcon(
                  iconPath: icon,
                  size: 16,
                  color: iconColor,
                ),
        ),
      ),
    );
  }
}

