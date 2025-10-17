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
    required this.iconPath ,
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

    return Dialog(
      backgroundColor: Colors.white,
      elevation: 0,
      child: Container(
        width: 440,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: effectiveIconColor.withOpacity(0.15),
                    ),
                    child: iconData != null
                        ? Icon(
                            iconData,
                            color: effectiveIconColor,
                            size: 32,
                          )
                        : CustomIcon(
                            iconPath: iconPath,
                            color: effectiveIconColor,
                            size: 32,
                          ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    header,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    message,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.dark,
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Container(
              height: 1,
              color: const Color(0x1FFFFFFF),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: effectiveButtonColor,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        buttonHintText,
                        style: const TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () => Navigator.of(context).pop(false),
                      style: TextButton.styleFrom(
                        backgroundColor: const Color(0xFF23272A),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      child: Text(
                        t.cancel_button_text,
                        style: const TextStyle(
                          color: Color(0xFFB9BBBE),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
    required String header ,
    required String buttonText ,
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

 

  

}