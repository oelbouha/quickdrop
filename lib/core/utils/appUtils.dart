
import 'package:quickdrop_app/core/utils/imports.dart';

class AppUtils {
  static void showLoading(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const Center(
              child: CircularProgressIndicator(
            strokeWidth: 2,
            color: Colors.blue,
          ));
        });
  }

 static void showError(BuildContext context, String message) {
    // Clear any existing SnackBar
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            // Error icon
            const Icon(
              Icons.error_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            // Message
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating, // Allows custom positioning
        margin: const EdgeInsets.only(
          top: 60,
          left: 16,
          right: 16,
          bottom: 16
        ), // Position at top with margins
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        duration: const Duration(seconds: 3), // Auto-dismiss after 3 seconds
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1, // Adds shadow
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Dismiss when close button is pressed
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          textColor: Colors.white,
        ),
      ),
    );
  }

static void showSuccess(BuildContext context, String message) {
    // Clear any existing SnackBar
    ScaffoldMessenger.of(context).removeCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            // Success icon
            const Icon(
              Icons.check_circle_outline,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            // Message
            Expanded(
              child: Text(
                message,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.cardBackground,
        behavior: SnackBarBehavior.floating, // Allows custom positioning
        margin: const EdgeInsets.only(
          top: 60,
          left: 16,
          right: 16,
          bottom: 16
        ), // Position at top with margins
        // padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 12),
        duration: const Duration(seconds: 3), // Auto-dismiss after 3 seconds
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 1, // Adds shadow
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Dismiss when close button is pressed
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
          textColor: Colors.white,
        ),
      ),
    );
  }

}




Widget Message(BuildContext context, String message) {
  return Text(message, style: TextStyle(color: AppColors.white),);
}

String truncateText(String text, {int maxLength = 10}) {
  return text.length > maxLength ? '${text.substring(0, maxLength)}...' : text;
}

Widget buildIconWithText({
  required String iconPath,
  required String text,
  double iconSize = 10,
  double textSize = 9,
  Color iconColor = AppColors.lessImportant,
  Color textColor = AppColors.headingText,
}) {
  return Row(
    children: [
      CustomIcon(
        iconPath: "assets/icon/" + iconPath,
        size: iconSize,
        color: iconColor,
      ),
      Text(
        ' $text',
        style: TextStyle(
          color: textColor,
          fontSize: textSize,
        ),
      ),
    ],
  );
}

