String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email is required';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Enter a valid email address';
  }
  return null;
}

String? validatePhone(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }
  if (value.length != 10) {
    return 'Phone number must be 10 digits';
  }
  return null;
}

String? validatePincode(String? value) {
  if (value == null || value.isEmpty) {
    return 'Pincode is required';
  }
  if (value.length != 6) {
    return 'Pincode must be 6 digits';
  }
  return null;
}
