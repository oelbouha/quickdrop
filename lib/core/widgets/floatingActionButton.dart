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
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.blueStart, AppColors.purpleStart],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.blueStart.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: const Icon(
          Icons.add,
          color: Colors.white,
          size: 28,
        ),
      ),
    );
  }
}
