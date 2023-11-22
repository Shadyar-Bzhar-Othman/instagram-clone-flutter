import 'package:flutter/material.dart';

class AppStyles {
  static InputDecoration customFormTextFieldStyle(
      BuildContext context, String hintText) {
    final inputBorder = OutlineInputBorder(
      borderSide: Divider.createBorderSide(context),
    );

    return InputDecoration(
      contentPadding: const EdgeInsets.all(16),
      filled: true,
      fillColor: const Color(0xff121212),
      hintText: hintText,
      border: inputBorder,
      enabledBorder: inputBorder,
      disabledBorder: inputBorder,
      focusedBorder: inputBorder,
    );
  }
}
