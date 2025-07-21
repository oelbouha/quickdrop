import 'dart:io';

import 'package:flutter/material.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:dotted_border/dotted_border.dart';

class ImageUpload extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color backgroundColor;
  final bool isLoading;
  final bool isError;
  final String? imagePath;
  final VoidCallback onPressed;

  const ImageUpload({
    super.key,
    required this.controller,
    this.imagePath,
    this.isLoading = false,
    this.isError = false,
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
                height: 150,
                padding:  EdgeInsets.all(imagePath == null ? AppTheme.cardPadding: 0),
                decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
                child: isLoading ? 
                    const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ) 
                  : imagePath != null ? ClipRRect(
                          // borderRadius: BorderRadius.circular(21),
                        child: Image.file(
                            File(imagePath!), // path to local file
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                          )
                        )
                  
                  : const Column(
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
