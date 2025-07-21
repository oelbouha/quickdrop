



import 'package:quickdrop_app/core/utils/imports.dart';

Widget loadingAnimation({
  double size = 60,
}) {
  return (
  Center(
      child: LoadingAnimationWidget.twistingDots(
        leftDotColor: AppColors.blue700,
        rightDotColor: AppColors.dark,
        size: size,
      ),
  ));
}
