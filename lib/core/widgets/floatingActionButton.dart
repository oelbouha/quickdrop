import 'package:quickdrop_app/core/utils/imports.dart';

class FloatButton extends StatelessWidget {
  final String iconPath;
  final String hintText;
  final Color backgroundColor;
  final VoidCallback onTap;

  const FloatButton({
    super.key,
    this.iconPath = "assets/icon/add.svg",
    required this.hintText,
    this.backgroundColor = AppColors.blue,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      width: 60, 
      child: FloatingActionButton.extended(
        onPressed: onTap,
        backgroundColor: backgroundColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        extendedIconLabelSpacing: 10,
        extendedPadding: const EdgeInsets.all(12),
        // icon: CustomIcon(
        //   iconPath: iconPath, 
        //   size: 28 , 
        //   color: AppColors.white,
        // ),
        label:  CustomIcon(
          iconPath: iconPath, 
          size: 30 , 
          color: Colors.white,
        ),
      ),
    );
  }
}
