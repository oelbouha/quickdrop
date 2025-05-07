import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';

class StatisticCard extends StatelessWidget {
  final String hintText;
  final String number ;
  final Color hintTextColor;
  final Color backgroundColor;
  // final VoidCallback onTap;

  const StatisticCard({
    required this.number,
    required this.hintText,
    this.hintTextColor = AppColors.headingText,
    this.backgroundColor = AppColors.cardBackground,
    // required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 1,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: backgroundColor,
        child:  Padding(
          padding: const EdgeInsets.all(8),
          child: Column(children: [
              Text(hintText, style: TextStyle(color: hintTextColor, fontWeight: FontWeight.w600),),
              Text(number, style: const TextStyle(color: AppColors.headingText, fontWeight: FontWeight.w600),)
            ])
        )
    );
  }
 
}
