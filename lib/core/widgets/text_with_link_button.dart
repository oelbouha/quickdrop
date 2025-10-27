
import 'package:quickdrop_app/core/widgets/gesture_detector.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

Widget TextWithLinkButton({
  required String text,
  required String textLink,
  required String navigatTo,
  required BuildContext context,
  linkTextColor = AppColors.blue,
  double fontSize = 14,
  bool push = false
}) {
return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        text,
        style:  TextStyle(
            color: AppColors.shipmentText, fontSize: fontSize, fontWeight: FontWeight.w500, fontFamily: 'MonaSans'),
      ),
      GestureDetectorWidget(
        onPressed: () => {
            if (push) context.push(navigatTo)
            else context.go(navigatTo)
          },
        hintText: textLink,
        color: linkTextColor,
      )
    ],
  );
}