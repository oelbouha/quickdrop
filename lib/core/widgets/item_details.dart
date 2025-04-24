import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class ItemDetail extends StatelessWidget {
  final String title;
  final String value;
  final String iconPath;
  final double fontSize;
  final double iconSize;
  final Color textColor;
  final Color iconColor;

  const ItemDetail({
    super.key,
    required this.title,
    required this.iconPath,
    required this.value,
    this.fontSize = 9,
    this.iconSize = 10,
    this.textColor = AppColors.lessImportant,
    this.iconColor = AppColors.lessImportant,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CustomIcon(
          iconPath: iconPath,
          color: iconColor,
          size: iconSize,
        ),
        const SizedBox(
          width: 5,
        ),
        Text(title,
            style: TextStyle(color: AppColors.headingText, fontSize: fontSize)),
        Text(' $value',
            style: TextStyle(color: AppColors.headingText, fontSize: fontSize, fontWeight: FontWeight.bold)),
      
      ],
    );
  }
}
