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
      height: 50, 
      child: FloatingActionButton.extended(
        onPressed: onTap,
        backgroundColor: backgroundColor,
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        extendedIconLabelSpacing: 10,
        extendedPadding: const EdgeInsets.all(12),
        icon: CustomIcon(
          iconPath: iconPath, 
          size: 28 , 
          color: AppColors.white,
        ),
        label: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Text(
            hintText,
            style: const TextStyle(
              color: AppColors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
          
        ),
      ),
    );
  }
}
