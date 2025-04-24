import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class CustomHeader extends StatelessWidget {
  final String hintText;
  final VoidCallback onPressed;

  const CustomHeader({
    super.key,
    required this.hintText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        IconButton(
          icon: const CustomIcon(
              iconPath: "assets/icon/alt-arrow-left.svg",
              size: 24,
              color: Color.fromARGB(255, 161, 68, 68)),
          onPressed: onPressed
        ),
        const SizedBox(width: 10,),
        Expanded(
          child: Text(
            hintText,
            style: const TextStyle(
              color: AppColors.headingText,
              fontSize: 18,
            ),
            // textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
