class EmailValidator {
  static String? validate(String? value) {
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

    // Optional: light strength rule (at least one letter + one number)
    if (!RegExp(r'^(?=.*[A-Za-z])(?=.*\d).+$').hasMatch(value)) {
      return 'Password must contain at least one letter and one number';
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
    return null;
  }
}

class AddressValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Address is required';
    }
    if (value.trim().isNotEmpty) {
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

class GSTValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'GST is required';
    }
    final cleanedValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    if (cleanedValue.isEmpty) {
      return 'GST must be a number';
    }
    final gst = double.tryParse(cleanedValue);
    if (gst == null) {
      return 'GST must be a valid number';
    }
    if (gst < 0) {
      return 'GST must be between 0 and 100';
    }

    return null;
  }
}

class TaxValidator {
  static String? validate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Tax number is required';
    }
    if (value.trim().length < 3) {
      return 'Tax number must be at least 3 characters';
    }
    if (value.trim().length > 20) {
      return 'Tax number must not exceed 20 characters';
    }

    return null;
  }
}
