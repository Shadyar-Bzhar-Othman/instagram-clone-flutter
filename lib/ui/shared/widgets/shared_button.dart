import 'package:flutter/material.dart';
import 'package:instagramclone/utils/colors.dart';

class SharedButton extends StatelessWidget {
  const SharedButton({
    super.key,
    required this.label,
    required this.onPress,
    required this.isLoading,
  });

  final String label;
  final void Function() onPress;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(blueColor),
        padding: MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      child: isLoading
          ? Center(
              child: Container(
                width: 16,
                height: 16,
                child: const CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            )
          : Text(label),
    );
  }
}
