String? nameValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a name';
  }
  if (!RegExp(r'^[a-zA-Z1-9\s]{3,25}$').hasMatch(value)) {
    return 'Name must be 3 to 25 alphabetical characters';
  }
  return null;
}

String? descriptionValidator(String? value) {
  if (value != null && (value.isEmpty || value.length > 255)) {
    return 'Description must be between 1 and 255 characters';
  }
  return null;
}

String? priceValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a price';
  }
  final double? price = double.tryParse(value);
  if (price == null || price < 0 || price > 10000) {
    return 'Price must be between 0 and 10000';
  }
  if (!RegExp(r'^(\d+(\.\d{1,2})?)$').hasMatch(value)) {
    return 'Price must have a maximum of 2 decimal places';
  }
  return null;
}

String? durationMonthsValidator(String? value) {
  if (value == null || value.isEmpty) {
    return 'Please enter a duration in months';
  }
  final int? durationMonths = int.tryParse(value);
  if (durationMonths == null || durationMonths < 1 || durationMonths > 120) {
    return 'Duration must be between 1 and 120 months';
  }
  return null;
}
