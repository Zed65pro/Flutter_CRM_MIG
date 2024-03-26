String? phoneNumberValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a phone number';
  }
  if (!RegExp(r'^[0-9]{9}$').hasMatch(value)) {
    return 'Phone number must be 9 numerals';
  }
  return null;
}

String? addressValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please select an address';
  }
  return null;
}

String? firstNameValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a first name';
  }
  if (!RegExp(r'^[a-zA-Z]{3,25}$').hasMatch(value)) {
    return 'First name must be 3 to 25 alphabetical characters';
  }
  return null;
}

String? lastNameValidator(value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a last name';
  }
  if (!RegExp(r'^[a-zA-Z]{3,25}$').hasMatch(value)) {
    return 'Last name must be 3 to 25 alphabetical characters';
  }
  return null;
}
