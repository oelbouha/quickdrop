


import 'package:quickdrop_app/core/utils/imports.dart';

Widget buildProfileImage({
  required UserData? user,
  VoidCallback? onTap,
  double size = 90,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(50),
        child: Image.network(
          user?.photoUrl ?? AppTheme.defaultProfileImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.blueStart.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(35),
              ),
              child: Icon(
                Icons.person,
                color: AppColors.blueStart,
                size: 52,
              ),
            );
          },
        ),
      ),
    ),
  );
}

