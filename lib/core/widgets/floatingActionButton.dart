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
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.blue700,
          // gradient: const LinearGradient(
          //   colors: [AppColors.blueStart, AppColors.purpleStart],
          // ),
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
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 200),
                  scale: expanded ? 1.0 : 0.9,
                  child: const Icon(Icons.add, color: Colors.white, size: 28),
                ),
                AnimatedContainer(
                  duration: const Duration(microseconds: 350),
                  curve: Curves.easeInOutCubic,
                  width: expanded? null : 0,
                  child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 250),
                  opacity: expanded ? 1.0 : 0.0,
                  child: expanded
                      ? Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Text(
                            hintText,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),

                ),
              // if (expanded) ...[
              //   const SizedBox(width: 8),
              //   Text(
              //     hintText,
              //     style: const  TextStyle(
              //       color: Colors.white,
              //       fontSize: 16,
              //       fontWeight: FontWeight.w500,
              //     ),
              //   ),
              // ],
            ],
          ),
        ),
      ),
    );
  }
}
