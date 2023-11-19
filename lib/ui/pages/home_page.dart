import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/ui/pages/add_post_page.dart';
import 'package:instagramclone/ui/pages/feed_page.dart';
import 'package:instagramclone/ui/pages/search_page.dart';
import 'package:instagramclone/ui/pages/user_profile_page.dart';
import 'package:instagramclone/utils/colors.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late UserModel currentUser;

  int _currentIndex = 0;
  Widget content = const FeedPage();

  @override
  void initState() {
    super.initState();
  }

  void changePage(int index) {
    setState(() {
      _currentIndex = index;

      if (_currentIndex == 0) {
        content = const FeedPage();
      } else if (_currentIndex == 1) {
        content = const SearchPage();
      } else if (_currentIndex == 2) {
        content = AddPostPage(
          changePage: changePage,
        );
      } else if (_currentIndex == 3) {
        content = const FeedPage();
      } else if (_currentIndex == 4) {
        content = UserProfilePage(
          user: currentUser,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: ref.read(currentUserProvider.notifier).getCurrentUserDetail(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final currentUserData = ref.read(currentUserProvider);

          currentUser = currentUserData!;
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
                onTap: changePage,
                items: [
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.home_filled),
                    label: 'Home',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'Search',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.add_circle),
                    label: 'Add Post',
                  ),
                  const BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: 'Notification',
                  ),
                  BottomNavigationBarItem(
                    icon: CircleAvatar(
                      backgroundColor: Colors.white,
                      backgroundImage: NetworkImage(
                        currentUser.profileImageURL,
                      ),
                      radius: 12,
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          );
        });
  }
}
