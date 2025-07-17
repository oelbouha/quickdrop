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
        decoration: BoxDecoration(
            color: AppColors.blueStart.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(50),
          ),
        child: user!.photoUrl != null ? CachedNetworkImage(
              imageUrl: user.photoUrl!,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                  decoration: BoxDecoration(
                    color: AppColors.blueStart.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: const Center(
                      child: CircularProgressIndicator(
                          color: AppColors.blue700, strokeWidth: 2))),
              errorWidget: (context, error, stackTrace) {
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
            ) : Image.asset(
              "assets/images/profile.png",
            )
      ),
    ),
  );
}

