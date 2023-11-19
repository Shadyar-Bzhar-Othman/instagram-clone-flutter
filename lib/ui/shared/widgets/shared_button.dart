import 'package:flutter/material.dart';
import 'package:instagramclone/utils/colors.dart';

class SharedButton extends StatelessWidget {
  SharedButton({
    super.key,
    required this.label,
    required this.onPress,
    required this.isLoading,
    this.color = blueColor,
  });

  final String label;
  final void Function() onPress;
  final bool isLoading;
  Color color = blueColor;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      style: ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(color),
        padding: const MaterialStatePropertyAll(
          EdgeInsets.symmetric(vertical: 14),
        ),
      ),
      child: isLoading
          ? const Center(
              child: SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: primaryColor,
                ),
              ),
            )
          : Text(label),
    );
  }
}
