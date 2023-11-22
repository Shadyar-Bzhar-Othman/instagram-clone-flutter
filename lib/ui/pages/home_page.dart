import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/ui/pages/add_post_page.dart';
import 'package:instagramclone/ui/pages/feed_page.dart';
import 'package:instagramclone/ui/pages/search_page.dart';
import 'package:instagramclone/ui/pages/user_profile_page.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/helpers.dart';

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

  List<BottomNavigationBarItem> customBottomNavigationBarItems() {
    return [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_filled),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.search),
        label: 'Search',
      ),
      const BottomNavigationBarItem(
        icon: FaIcon(
          FontAwesomeIcons.squarePlus,
          size: 22,
        ),
        label: 'Add Post',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.favorite),
        label: 'Notification',
      ),
      BottomNavigationBarItem(
        icon: CircleAvatar(
          backgroundColor: AppColors.primaryColor,
          backgroundImage: NetworkImage(
            currentUser.profileImageURL,
          ),
          radius: 12,
        ),
        label: 'Profile',
      ),
    ];
  }

  Widget customBottomNavigationBar() {
    return Theme(
      data: Theme.of(context).copyWith(canvasColor: AppColors.backgroundColor),
      child: BottomNavigationBar(
        backgroundColor: AppColors.backgroundColor,
        selectedItemColor: AppColors.primaryColor,
        unselectedItemColor: AppColors.secondaryColor,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: _currentIndex,
        onTap: changePage,
        items: customBottomNavigationBarItems(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: ref.read(currentUserProvider.notifier).getCurrentUserDetail(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppHelpers.buildLoadingIndicator();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final currentUserData = ref.read(currentUserProvider);

        currentUser = currentUserData!;
        return Scaffold(
          body: content,
          bottomNavigationBar: Theme(
            data: Theme.of(context)
                .copyWith(canvasColor: AppColors.backgroundColor),
            child: customBottomNavigationBar(),
          ),
        );
      },
    );
  }
}
