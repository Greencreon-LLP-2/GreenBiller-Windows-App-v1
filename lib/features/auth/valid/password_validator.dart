class PasswordValidator {
  static String? validate(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (value.length > 30) {
      return 'Password must be below 30 characters';
    }
    if (value.contains(' ')) {
      return 'Password cannot contain spaces';
    }
    
    if (!RegExp(r'(?=.*[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'(?=.*\d)').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'(?=.*[@$!%*?&])').hasMatch(value)) {
      return 'Password must contain at least one special symbol (@\$!%*?&)';
    }
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,30}$');
    
    if (!regex.hasMatch(value)) {
      return 'Password must have uppercase, number, and special symbol (@\$!%*?&)';
    }
    return null;
  }
}
