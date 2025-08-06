 import 'package:quickdrop_app/core/utils/imports.dart';



Widget buildHeaderIcon({
    required String icon,
    required VoidCallback onTap,
    bool hasNotification = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          // color: AppColors.white.withValues(alpha: 0.4),
          // borderRadius: BorderRadius.circular(30),
          // border: Border.all(
          //   color: AppColors.borderGray200,
          //   width: 1,
          //   strokeAlign: BorderSide.strokeAlignInside,
          // ),

        ),
        child: Stack(
          children: [
            CustomIcon(
              iconPath: icon,
              color: AppColors.textSecondary,
              size: 24,
            ),
            if (hasNotification)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.red500,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }