import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:quickdrop_app/l10n/app_localizations.dart';
import 'package:quickdrop_app/theme/colors.dart';
import 'package:quickdrop_app/theme/AppTheme.dart';
import 'package:quickdrop_app/core/widgets/custom_svg.dart';
import 'package:dotted_border/dotted_border.dart';

class ImagePreviewPicker extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final Color backgroundColor;
  final bool isLoading;
  final bool isError;
  final String? imagePath;
  final String? imageUrl;
  final VoidCallback onPressed;

   ImagePreviewPicker({
    super.key,
    required this.controller,
    this.imagePath,
    this.imageUrl,
    this.isLoading = false,
    this.isError = false,
    required this.hintText,
    required this.backgroundColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
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
                  : imagePath != null || imageUrl != null ? 
                      ClipRRect(
                          // borderRadius: BorderRadius.circular(21),
                        child: 
                         imagePath != null ? Image.file(
                            File(imagePath!), // path to local file
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: 150,
                          ) 
                          : CachedNetworkImage(
                              imageUrl: imageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Image.asset(
                                  "assets/images/box.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                              fadeInDuration: const Duration(milliseconds: 200),
                              fadeOutDuration: const Duration(milliseconds: 200),
                            )
                        )
                  
                  :  Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const CustomIcon(
                            iconPath: "assets/icon/camera-add.svg",
                            size: 30,
                            color: AppColors.lessImportant,
                          ),
                          Text(t.upload_photo,
                              style:const TextStyle(
                                  fontSize: 20, color: AppColors.lessImportant)),
                          Text(
                            t.photo_format_hint,
                            style:  const TextStyle(
                            fontSize: 12, color: AppColors.lessImportant),
                      ),
                    ])
                    )
                  )
                );
  }
}
