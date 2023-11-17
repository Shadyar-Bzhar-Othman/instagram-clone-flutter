import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/core/services/user_service.dart';
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
  late final UserController _userController;

  late UserModel currentUser;

  int _currentIndex = 0;
  Widget content = const FeedPage();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _userController = UserController(
      ref: ref,
      userService: UserService(
        firebaseAuth: FirebaseAuth.instance,
        firebaseFirestore: FirebaseFirestore.instance,
      ),
    );
    getCurrentUser();
  }

  void getCurrentUser() async {
    print(1);
    setState(() {
      _isLoading = true;
    });
    print(3);
    await _userController.getCurrentUserDetail();
    print(44);
    final currentUserData = ref.read(currentUserProvider);
    print(444);
    print(currentUserData!);
    currentUser = currentUserData!;
    print(4);
    setState(() {
      _isLoading = false;
    });
    print(5);
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
    print(2);
    return _isLoading
        ? Container()
        : Scaffold(
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
                        _isLoading
                            ? 'https://cdn.pixabay.com/photo/2015/10/05/22/37/blank-profile-picture-973460_960_720.png'
                            : currentUser.profileImageURL,
                      ),
                      radius: 12,
                    ),
                    label: 'Profile',
                  ),
                ],
              ),
            ),
          );
  }
}
