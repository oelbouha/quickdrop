import 'package:quickdrop_app/core/utils/imports.dart';

class FloatButton extends StatelessWidget {
  final String iconPath;
  final String hintText;
  final Color backgroundColor;
  final VoidCallback onTap;
  final bool expanded;

  const FloatButton({
    super.key,
    this.iconPath = "assets/icon/add.svg",
    required this.hintText,
    this.backgroundColor = AppColors.blue,
    required this.onTap,
     required this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        // width: 50,
        // height: 50,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.blue700,
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.blueStart.withOpacity(0.4),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: const Icon(Icons.add, color: Colors.white, size: 28)
      ),
    );
  }
}
