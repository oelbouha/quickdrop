import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:cached_network_image/cached_network_image.dart';



Widget buildProfileImage({
  required UserData? user,
  VoidCallback? onTap,
  double size = 90,
}) {
  return GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(50),
      child: Container(
        width: size,
        height: size,
        child: Image.network(
          user?.photoUrl ?? AppTheme.defaultProfileImage,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;

            return Container(
              decoration: BoxDecoration(
                color: AppColors.blueStart.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.blue,
                  strokeWidth: 2,
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Container(
              decoration: BoxDecoration(
                color: AppColors.blueStart.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(50),
              ),
              child: Icon(
                Icons.person,
                color: AppColors.blueStart,
                size: size * 0.6,
              ),
            );
          },
        ),
      ),
    ),
  );
}