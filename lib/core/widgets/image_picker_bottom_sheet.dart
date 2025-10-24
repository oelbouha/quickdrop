import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:quickdrop_app/core/utils/imports.dart';

class ImagePickerHelper {
  
  
  static Future<File?> pickImage({required BuildContext context}) async {
    final t = AppLocalizations.of(context)!;
    final ImagePicker picker = ImagePicker();

    final ImageSource? source = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const CustomIcon(iconPath: "assets/icon/gallery.svg"),
                title: Text(t.choose_from_gallery),
                onTap: () => Navigator.pop(context, ImageSource.gallery),
              ),
              ListTile(
                leading: const CustomIcon(iconPath: "assets/icon/camera.svg"),
                title: Text(t.take_a_picture),
                onTap: () => Navigator.pop(context, ImageSource.camera),
              ),
            ],
          ),
        );
      },
    );

    // If user canceled
    if (source == null) return null;

    final XFile? pickedFile = await picker.pickImage(source: source);
    if (pickedFile == null) return null;

    return File(pickedFile.path);
  }
}
