
import 'package:quickdrop_app/core/widgets/gestureDetector.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

Widget TextWithLink({
  required String text,
  required String textLink,
  required String navigatTo,
  required BuildContext context,
  linkTextColor = AppColors.shipmentText,
  double fontSize = 14
}) {
  return    Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  text,
                  style:  TextStyle(
                      color: AppColors.shipmentText, fontSize: fontSize),
                ),
                GestureDetectorWidget(
                  onPressed: () => GoRouter.of(context).go(navigatTo),
                  hintText: textLink,
                )
              ],
            );
}