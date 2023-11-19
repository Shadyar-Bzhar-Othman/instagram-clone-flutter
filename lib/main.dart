import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/firebase_options.dart';
import 'package:instagramclone/ui/pages/home_page.dart';
import 'package:instagramclone/ui/pages/login_page.dart';
import 'package:instagramclone/ui/shared/pages/loading_page.dart';
import 'package:instagramclone/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: InstagramClone()));
}

class InstagramClone extends ConsumerWidget {
  const InstagramClone({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Instagram Clone',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: backgroundColor,
      ),
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingPage();
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Failed to load the app'),
            );
          }

          // FirebaseAuth.instance.signOut();
          if (snapshot.hasData) {
            return const HomePage();
          }

          return const LoginPage();
        },
      ),
    );
  }
}
