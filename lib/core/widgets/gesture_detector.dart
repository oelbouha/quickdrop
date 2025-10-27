import 'package:flutter/material.dart';

class GestureDetectorWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String hintText;
  final Color color;
  final double fontSize;

  const GestureDetectorWidget({
    super.key,
    required this.onPressed,
    required this.hintText,
    this.color = Colors.blue,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Text(
        hintText,
        style: TextStyle(
          color: color,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
          fontFamily: 'MonaSans',
          decoration: TextDecoration.underline,
          decorationStyle: TextDecorationStyle.solid,
          letterSpacing: 0.5,
          decorationColor: color,
        ),
      ),
    );
  }
}
