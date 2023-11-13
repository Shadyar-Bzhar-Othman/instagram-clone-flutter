import 'package:flutter/material.dart';
import 'package:instagramclone/utils/colors.dart';

class StoryPercentIndecator extends StatelessWidget {
  const StoryPercentIndecator({super.key, required this.percent});

  final double percent;

  @override
  Widget build(BuildContext context) {
    return LinearProgressIndicator(
      color: primaryColor,
      backgroundColor: secondaryColor,
      minHeight: 5,
      borderRadius: BorderRadius.circular(3),
      value: percent,
    );
  }
}
