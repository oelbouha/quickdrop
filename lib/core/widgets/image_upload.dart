import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:dotted_border/dotted_border.dart';

class ImageUpload extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color backgroundColor;
  final VoidCallback onPressed;

  const ImageUpload({
    super.key,
    required this.controller,
    required this.hintText,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPressed,
        child: DottedBorder(
            color: AppColors.lessImportant,
            borderType: BorderType.RRect,
            dashPattern: [4, 6],
            child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppTheme.cardPadding),
                decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CustomIcon(
                        iconPath: "assets/icon/camera-add.svg",
                        size: 30,
                        color: AppColors.lessImportant,
                      ),
                      Text("upload photo ",
                          style: TextStyle(
                              fontSize: 20, color: AppColors.lessImportant)),
                      Text(
                        "JPG, PNG up to 5 MB",
                        style: TextStyle(
                            fontSize: 12, color: AppColors.lessImportant),
                      ),
                    ]))));
  }
}
