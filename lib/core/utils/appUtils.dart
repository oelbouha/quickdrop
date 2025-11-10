import 'package:quickdrop_app/core/utils/imports.dart';

class AppUtils {

  static void showDialog(
      BuildContext context, String message, Color? backgroundColor ) {
    // Clear any existing SnackBar
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            // Error icon
            if (backgroundColor == AppColors.succes)
              Icon(
                Icons.check_circle,
                color: backgroundColor,
                size: 24,
              ),
            if (backgroundColor == AppColors.error)
              Icon(
                Icons.error,
                color: backgroundColor,
                size: 24,
              ),
            const SizedBox(width: 12),
            // Message
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                softWrap: true,
              ),
            ),
            IconButton(
              icon: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
              },
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        backgroundColor: AppColors.dark.withValues(alpha: 0.9),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 16),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        duration: const Duration(seconds: 5),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1,
      ),
    );
  }
}

String getChatId(String user1, String user2) {
  return user1.compareTo(user2) <= 0
      ? '${user1}_$user2'
      : '${user2}_$user1';
}



String truncateText(String text, {int maxLength = 15}) {
  return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
}




