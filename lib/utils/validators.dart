class AppValidators {
  static String? validateEmail(String value) {
    if (!value.trim().isNotEmpty || !value.contains('@')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  static String? validatePassword(String value) {
    if (!value.trim().isNotEmpty || value.trim().length < 8) {
      return 'Please enter a valid password more than 8 letter';
    }
    return null;
  }

  static String? validateUsername(String value) {
    if (!value.trim().isNotEmpty || value.trim().length < 6) {
      return 'Please enter a valid username more than 6 letter';
    }
    return null;
  }

  static String? validateBio(String value) {
    if (!value.trim().isNotEmpty ||
        value.trim().length < 2 && value.trim().length > 180) {
      return 'Please enter a valid bio more than 1 letter and less than 180 letter';
    }
    return null;
  }
}
