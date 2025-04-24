// In lib/utils/validators.dart
class Validators {
  static String? notEmpty(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  // Add more validators as needed
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email cannot be empty';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Enter a valid email';
    }
    return null;
  }
  
  static String? name(String? value) {
     if (value == null || value.trim().isEmpty) {
        return 'This field cannot be empty';
      }
      // Optional: Add email format validation
      if (value.length < 4) {
        return 'Name must be more than 4 character';
      }
      return null;
  }
}