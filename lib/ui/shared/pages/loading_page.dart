import 'package:flutter/material.dart';
import 'package:instagramclone/utils/helpers.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AppHelpers.buildLoadingIndicator(),
    );
  }
}
