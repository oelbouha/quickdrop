
import 'package:quickdrop_app/core/utils/imports.dart';

Widget TextWithRequiredIcon({
  required String text
}) {
  return Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              color: AppColors.headingText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
            const Text(
              ' *',
              style: TextStyle(
                color: Colors.red,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      );
}