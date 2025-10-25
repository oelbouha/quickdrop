
import 'package:quickdrop_app/core/widgets/gestureDetector.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

import 'package:intl_phone_field/intl_phone_field.dart';

Widget PhoneNumberInput({
  required TextEditingController controller,
}) {
return  IntlPhoneField(
      decoration:  InputDecoration(
        hintText: '0 00 00 00 00',
        hintStyle: const TextStyle(
          color: AppColors.textFieldHintText,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.textFeildRadius),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.textFeildRadius),
          borderSide: const BorderSide(color: AppColors.error, width: 1.0),
        ),
        focusedBorder:  OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.textFeildRadius),
          borderSide:  const BorderSide(color: AppColors.blue, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppTheme.textFeildRadius),
          borderSide:  const BorderSide(color: AppColors.lessImportant, width: 1.0),
        ),
      ),
      initialCountryCode: 'MA',
      onChanged: (phone) {
        controller.text = phone.completeNumber;
      },
    );
}