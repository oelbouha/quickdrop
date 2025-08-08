



import 'package:quickdrop_app/core/utils/imports.dart';

Widget loadingAnimation({
  double size = 60,
  Color color = AppColors.blue700,
}) {
  return (
  Center(
      child: LoadingAnimationWidget.staggeredDotsWave(
        color: color,
        size: size,
      ),
  ));
}
