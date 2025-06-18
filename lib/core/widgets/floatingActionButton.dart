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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.blueStart, AppColors.purpleStart],
          ),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.blueStart.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: AnimatedSize(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.add, color: Colors.white, size: 28),
              if (expanded) ...[
                const SizedBox(width: 8),
                Text(
                  hintText,
                  style: const  TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
