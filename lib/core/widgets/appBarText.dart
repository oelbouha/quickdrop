
import 'package:quickdrop_app/core/utils/imports.dart';

Widget AppBarText(
    {
      required String text,
      color = AppColors.white,
      double fontSize = 20,
    }) {
  return  Text(
    text,
    style: TextStyle(color: color, fontSize: fontSize, fontWeight: FontWeight.w500, fontFamily: 'MonaSans'),
  );
}
