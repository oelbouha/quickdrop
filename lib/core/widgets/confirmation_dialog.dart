import 'package:quickdrop_app/core/utils/imports.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final String buttonHintText;
  final String header;
  final String iconPath;
  final Color? iconColor;
  final Color? buttonColor;
  final IconData? iconData; // Alternative to iconPath for Material icons

  const ConfirmationDialog({
    super.key,
    required this.message,
    this.iconPath = "assets/icon/trash-bin.svg",
    this.header = 'Delete Shipment',
    this.buttonHintText = "Delete",
    this.iconColor,
    this.buttonColor,
    this.iconData,
  });

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final effectiveIconColor = iconColor ?? AppColors.error;
    final effectiveButtonColor = buttonColor ?? AppColors.error;

    return AlertDialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.cardRadius),
      ),
      contentPadding: const EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: 10,
      ),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: effectiveIconColor.withOpacity(0.1),
            ),
            child: iconData != null
                ? Icon(
                    iconData,
                    color: effectiveIconColor,
                    size: 24,
                  )
                : CustomIcon(
                    iconPath: iconPath,
                    color: effectiveIconColor,
                    size: 24,
                  ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              header,
              style: const TextStyle(
                fontSize: 18,
                color: AppColors.headingText,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: const TextStyle(
          fontSize: 14,
          color: AppColors.shipmentText,
          height: 1.4,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.cardButtonRadius),
            ),
          ),
          child: Text(
            t.cancel_button_text,
            style: TextStyle(
              color: Colors.grey[600],
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(width: 8),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(true),
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            elevation: 0,
            backgroundColor: effectiveButtonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppTheme.cardButtonRadius),
            ),
          ),
          child: Text(
            buttonHintText,
            style: const TextStyle(
              color: AppColors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ],
    );
  }

  // Static method for easier usage
  static Future<bool> show({
    required BuildContext context,
    required String message,
    String header = 'Confirm Action',
    String buttonHintText = 'Confirm',
    String iconPath = "assets/icon/trash-bin.svg",
    IconData? iconData,
    Color? iconColor,
    Color? buttonColor,
  }) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext context) {
        return ConfirmationDialog(
          message: message,
          header: header,
          buttonHintText: buttonHintText,
          iconPath: iconPath,
          iconData: iconData,
          iconColor: iconColor,
          buttonColor: buttonColor,
        );
      },
    ) ?? false;
  }
}

// Extension for common dialog types
extension ConfirmationDialogTypes on ConfirmationDialog {
  // Delete confirmation
  static Future<bool> showDeleteConfirmation({
    required BuildContext context,
    required String message,
    String header = 'Delete Item',
    String buttonText = 'Delete',
  }) {
    return ConfirmationDialog.show(
      context: context,
      message: message,
      header: header,
      buttonHintText: buttonText,
      iconData: Icons.delete_outline,
      iconColor: AppColors.error,
      buttonColor: AppColors.error,
    );
  }

  // Save confirmation
  static Future<bool> showSaveConfirmation({
    required BuildContext context,
    required String message,
    required  String header ,
    required String buttonText ,
  }) {
    return ConfirmationDialog.show(
      context: context,
      message: message,
      header: header,
      buttonHintText: buttonText,
      iconData: Icons.save_outlined,
      iconColor: AppColors.blue600,
      buttonColor: AppColors.blue600,
    );
  }

  // Warning confirmation
  static Future<bool> showWarningConfirmation({
    required BuildContext context,
    required String message,
    String header = 'Warning',
    String buttonText = 'Continue',
  }) {
    return ConfirmationDialog.show(
      context: context,
      message: message,
      header: header,
      buttonHintText: buttonText,
      iconData: Icons.warning_outlined,
      iconColor: Colors.orange,
      buttonColor: Colors.orange,
    );
  }

  // Logout confirmation
  static Future<bool> showLogoutConfirmation({
    required BuildContext context,
    String message = 'Are you sure you want to logout?',
    String header = 'Logout',
    String buttonText = 'Logout',
  }) {
    return ConfirmationDialog.show(
      context: context,
      message: message,
      header: header,
      buttonHintText: buttonText,
      iconData: Icons.logout,
      iconColor: AppColors.error,
      buttonColor: AppColors.error,
    );
  }
}