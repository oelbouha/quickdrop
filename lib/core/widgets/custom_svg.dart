import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomIcon extends StatelessWidget {
  final String iconPath;
  final double size;
  final Color color;

  const CustomIcon({
    super.key,
    required this.iconPath,
    this.size = 24,
    this.color = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    if (iconPath.endsWith('.svg')) {
      return SvgPicture.asset(
        iconPath,
        width: size,
        height: size,
        color: color,
      );
    } else {
      return Image.asset(
        iconPath,
        width: size,
        height: size,
        color: color,
      );
    }
  }
}