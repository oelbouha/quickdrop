// In lib/utils/validators.dart
import 'package:flutter/material.dart';
import 'package:quickdrop_app/core/utils/imports.dart';

class Validators {
  static String? Function(String?) notEmpty(BuildContext context) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.trim().isEmpty) {
        return t.field_cannot_be_empty;
      }
      return null;
    };
  }

  static String? Function(String?) isNumber(BuildContext context) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.trim().isEmpty) {
        return t.field_cannot_be_empty;
      }
      if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
        return t.enter_valid_number;
      }
      return null;
    };
  }

  static String? Function(String?) phone(BuildContext context) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.trim().isEmpty) {
        return t.phone_cannot_be_empty;
      }
      if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
        return t.enter_valid_phone;
      }
      return null;
    };
  }

  static String? Function(String?) email(BuildContext context) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.trim().isEmpty) {
        return t.email_cannot_be_empty;
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        return t.enter_valid_email;
      }
      return null;
    };
  }

  static String? Function(String?) isEmail(BuildContext context) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.trim().isEmpty) {
        return null;
      }
      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
        return t.enter_valid_email;
      }
      return null;
    };
  }

  static String? Function(String?) name(BuildContext context) {
    return (String? value) {
      final t = AppLocalizations.of(context)!;
      if (value == null || value.trim().isEmpty) {
        return t.field_cannot_be_empty;
      }
      if (value.length < 4) {
        return t.name_min_length;
      }
      return null;
    };
  }
}

