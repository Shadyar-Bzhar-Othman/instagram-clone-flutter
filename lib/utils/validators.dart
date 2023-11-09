String? validateUsername(String value) {
  if (!value.trim().isNotEmpty || value.trim().length < 6) {
    return 'Please enter a valid username more than 6 letter';
  }
  return null;
}

String? validateEmail(String value) {
  if (!value.trim().isNotEmpty || !value.contains('@')) {
    return 'Please enter a valid email address';
  }
  return null;
}

String? validatePassword(String value) {
  if (!value.trim().isNotEmpty || value.trim().length < 8) {
    return 'Please enter a valid password more than 8 letter';
  }
  return null;
}
