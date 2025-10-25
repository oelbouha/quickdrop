import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickdrop_app/theme/colors.dart';

Future<void> showSuccessAnimation(BuildContext context, {String? title, String? message}) async {
  HapticFeedback.lightImpact();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      Future.delayed(const Duration(seconds: 3), () {
        if (Navigator.of(dialogContext).canPop()) {
          Navigator.of(dialogContext).pop();
        }
        if (Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: const Duration(milliseconds: 600),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.success.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      color: AppColors.success,
                      size: 64 * value,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Text(
              title ?? 'Success!',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message ?? 'The operation completed successfully.',
              style: const TextStyle(fontSize: 14, color: AppColors.textMuted),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    },
  );
}
