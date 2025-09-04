class EmailValidator {
  static String? validate(String? value){
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Enter a valid email';
              }
              if (value.length > 254) {
                return 'Email must be less than 254 characters'; 
              }
              return null;            
  }
}
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
class NameValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Name is required";
    }
    if (value.trim().length < 3) {
      return "Name must be at least 3 characters";
    }
    if (value.trim().length > 50) {
                    return 'Customer name must not exceed 50 characters'; 
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return "Name must contain only letters";
    }
    return null;
  }
}
class PhoneValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    String cleanPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    if (cleanPhone.length != 10) {
      return 'Phone number must be exactly 10 digits';
    }
    if (!RegExp(r'^[6-9][0-9]{9}$').hasMatch(cleanPhone)) {
      return 'Please enter a valid Indian phone number (starting with 6-9)';
    }
    if (cleanPhone.startsWith('0')) {
      return 'Phone number should not start with 0';
    }
    return null;
  }
}
class GSTINValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'GSTIN is required';
    }
    if (value.trim().isNotEmpty) {
      if (!RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}Z[0-9A-Z]{1}$')
          .hasMatch(value.trim().toUpperCase())) {
        return 'Please enter a valid GSTIN format (e.g., 22AAAAA0000A1Z5)';
      }
    }
    return null;
  }
}
class AddressValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if ( value.trim().isNotEmpty) {
      if (value.trim().length < 5) {
        return 'Address must be at least 5 characters';
      }
      if (value.length > 1000) {
        return 'Address must not exceed 200 characters';
      }
    }
    return null;
  }
}
