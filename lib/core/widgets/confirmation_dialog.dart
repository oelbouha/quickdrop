import 'package:quickdrop_app/core/utils/imports.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final String buttonHintText;
  final String header;
  final VoidCallback onPressed;
  final String iconPath;

  const ConfirmationDialog({
    super.key,
    required this.message,
    this.iconPath = "assets/icon/trash-bin.svg",
    this.header = 'Delete Shipment',
    this.buttonHintText = "Delete",
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppTheme.cardRadius)),
      child: Padding(
        padding: const EdgeInsets.only(
          top: 10,
          left: 20,
          right: 20,
          bottom: 10,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.deleteBackground,
                ),
                child:  CustomIcon(
                  iconPath: iconPath,
                  color: AppColors.error,
                )),
            const SizedBox(height: 10),
            Text(
              header,
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.headingText,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              message,
              style:
                  const TextStyle(fontSize: 14, color: AppColors.shipmentText),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.cardButtonRadius),
                        side: const BorderSide(
                          color: AppColors.shipmentText,
                          width: 1,
                        ),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel',
                        style: TextStyle(
                            color: AppColors.shipmentText,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      elevation: 0,
                      backgroundColor: AppColors.error,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(AppTheme.cardButtonRadius),
                      ),
                    ),
                    onPressed: onPressed,
                    child: Text(buttonHintText,
                        style: const TextStyle(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
