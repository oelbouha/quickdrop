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
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.circle,
            size: 12,
            color: AppColors.blue,
          ),
          const SizedBox(width: 10),
          Text(
            truncateText(from),
            style: TextStyle(
              color: AppColors.headingText,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        width: 2,
        height: 20,
        decoration: BoxDecoration(
          color: Color(0xFFd1d5db),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.circle,
            size: 12,
            color: AppColors.succes,
          ),
          const SizedBox(width: 10),
          Text(
            truncateText(to),
            style: TextStyle(
              color: AppColors.headingText,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ],
  );
}


  Widget _buildFromDestination() {
    return Row(
      children: [
           const Icon(
                  Icons.circle,
                  size: 12,
                  color: AppColors.blue,
                ),
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
         const Icon(
                  Icons.circle,
                  size: 12,
                  color: AppColors.succes,
                ),
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
