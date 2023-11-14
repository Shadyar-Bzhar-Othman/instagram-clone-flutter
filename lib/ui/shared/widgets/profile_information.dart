import 'package:flutter/material.dart';

class ProfileInformation extends StatelessWidget {
  const ProfileInformation({
    super.key,
    required this.number,
    required this.title,
  });

  final String number;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          number,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(
          title,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
