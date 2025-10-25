import 'package:quickdrop_app/core/utils/imports.dart';
import 'package:cached_network_image/cached_network_image.dart';



Widget ProfileAvatar({
  required UserData? user,
  VoidCallback? onTap,
  double size = 50,
}) {
  return GestureDetector(
    onTap: onTap,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(500),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
            color: AppColors.blueStart.withValues(alpha: 0.1),
            // borderRadius: BorderRadius.circular(500),

              shape: BoxShape.circle,
              border: Border.all(color: AppColors.blue, width: 2),
          ),
        child: user!.photoUrl != null ? CachedNetworkImage(
              imageUrl: user.photoUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: AppColors.blueStart.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.blue700, strokeWidth: 2))),
              errorWidget: (context, error, stackTrace) {
                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.blueStart.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.blueStart,
                      size: size * 0.6,
                    ),
                  );
                },
            ) : Container(
                    decoration: BoxDecoration(
                      color: AppColors.blueStart.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Icon(
                      Icons.person,
                      color: AppColors.blueStart,
                      size: size * 0.6,
                    ),
                  )
      ),
    ),
  );
}

