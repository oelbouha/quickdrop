import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:quickdrop_app/core/utils/appUtils.dart';


class Destination extends StatelessWidget {
  final String from;
  final String to;
  final double fontSize;
  final Color color;
  final double iconSize;

  const Destination({
    super.key,
    required this.from,
    required this.to,
    this.fontSize = 12,
    this.iconSize = 12,
    this.color = AppColors.headingText,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFromDestination(),
        const SizedBox(
          width: 5,
        ),
         CustomIcon(
            iconPath: "assets/icon/arrow-right.svg",
            size: iconSize,
            color: AppColors.lessImportant),
        // Spacer(),
         const SizedBox(
          width: 5,
        ),
        _buildToDestination(),
        
      ],
    );
  }

  Widget _buildFromDestination() {
    return Row(
      children: [
           CustomIcon(
            iconPath: "assets/icon/map-point.svg",
            size: iconSize,
            color: AppColors.blue),
        const SizedBox(width: 5,),
        Text(
            truncateText(from),
            style: TextStyle(
                color: AppColors.headingText,
                fontSize: fontSize,
                fontWeight: FontWeight.bold
                )
          ),
      ],
    );
  }


  Widget _buildToDestination() {
    return Row(
      children: [
          CustomIcon(
            iconPath: "assets/icon/map-point.svg",
            size: iconSize,
            color: AppColors.error),
        const SizedBox(
          width: 5,
        ),
        Text(truncateText(to),
            style: TextStyle(
                color: AppColors.headingText,
                fontSize: fontSize,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

}
