import 'package:quickdrop_app/core/utils/imports.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final String hintText;
  final VoidCallback onPressed;

  const ConfirmationDialog({
    super.key,
    required this.message,
    required this.hintText,
    required this.onPressed,
    });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.cardBackground,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, top: 16, right: 8),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // const Icon(Icons.check_circle, color: AppColors.succes, size: 50),
            // const SizedBox(height: 10),
            Text(
              message,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Spacer(),
                TextButton(
                  onPressed: onPressed,
                  child: Text(hintText,
                      style: const TextStyle(
                          color: AppColors.blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 18)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
