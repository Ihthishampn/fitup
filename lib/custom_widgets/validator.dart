class Validators {

  static String? validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  
  static String? validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a number';
    }
    if (double.tryParse(value) == null) {
      return 'Invalid number';
    }
    return null;
  }

  static String? validateString(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter a valid text';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value)) {
      return 'Only letters allowed';
    }
    return null;
  }

  
  static String? validateImage(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return 'Please select an image';
    }
    return null;
  }

  static String? validateGender(String? gender) {
    if (gender == null || gender.isEmpty) {
      return 'Please select a gender';
    }
    return null;
  }
}
