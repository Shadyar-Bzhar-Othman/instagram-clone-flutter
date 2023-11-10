import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/ui/pages/add_post_page.dart';
import 'package:instagramclone/ui/pages/feed_page.dart';
import 'package:instagramclone/utils/colors.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  Widget content = const FeedPage();

  void changeScreen(int index) {
    setState(() {
      _currentIndex = index;

      if (_currentIndex == 0) {
        content = const FeedPage();
      } else if (_currentIndex == 1) {
        content = const FeedPage();
      } else if (_currentIndex == 2) {
        content = const AddPostPage();
      } else if (_currentIndex == 3) {
        content = const FeedPage();
      } else if (_currentIndex == 4) {
        FirebaseAuth.instance.signOut();
        content = const FeedPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: content,
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(canvasColor: backgroundColor),
        child: BottomNavigationBar(
          backgroundColor: backgroundColor,
          selectedItemColor: primaryColor,
          unselectedItemColor: secondaryColor,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          onTap: changeScreen,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_filled),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_circle),
              label: 'Add Post',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
