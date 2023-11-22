import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/auth_provider.dart';
import 'package:instagramclone/core/providers/post_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/ui/pages/post_page.dart';
import 'package:instagramclone/ui/pages/saved_post_page.dart';
import 'package:instagramclone/ui/pages/story_page.dart';
import 'package:instagramclone/ui/pages/update_profile_page.dart';
import 'package:instagramclone/ui/shared/dialogs/custom_dialog.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/profile_information.dart';
import 'package:instagramclone/ui/shared/widgets/shared_button.dart';
import 'package:instagramclone/ui/shared/widgets/story_circle.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/consts.dart';
import 'package:instagramclone/utils/helpers.dart';

class UserProfilePage extends ConsumerStatefulWidget {
  const UserProfilePage({super.key, required this.user});

  final UserModel user;

  @override
  ConsumerState<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends ConsumerState<UserProfilePage> {
  late UserModel user;
  late UserModel currentUser;
  bool _isFollowing = false;
  int postNumber = 0;
  int follower = 0;
  int following = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    final currentUserData = ref.read(currentUserProvider);
    currentUser = currentUserData!;

    await ref
        .read(specificUserProvider.notifier)
        .getUserDetailById(widget.user.userId);

    final userData = ref.read(specificUserProvider);
    user = userData!;

    await ref.read(postProvider.notifier).getUserPost(user.userId);

    setState(() {
      _isLoading = false;
    });
  }

  void _followUnfollowUser() async {
    final String? result = await ref
        .read(specificUserProvider.notifier)
        .followUser(user.userId, currentUser.userId, user.follower);

    if (result != null) {
      showSnackbar(context, result);
    }
  }

  void signOut() async {
    final String? result = await ref.read(authProvider.notifier).signOut();

    if (result != null) {
      showSnackbar(context, result);
    }
  }

  Widget _buildProfileInformation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ProfileInformation(number: postNumber.toString(), title: 'Posts'),
        ProfileInformation(number: follower.toString(), title: 'Followers'),
        ProfileInformation(number: following.toString(), title: 'Following'),
      ],
    );
  }

  Widget _buildProfileActionButton() {
    return user.userId == currentUser.userId
        ? Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 60),
            child: SharedButton(
              label: 'Edit Profile',
              onPress: () {
                customDialog(
                  context,
                  'User Settings',
                  [
                    {
                      'icon': Icons.update_rounded,
                      'label': 'Update Profile',
                      'function': () {
                        Future.delayed(
                          const Duration(microseconds: 250),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UpdateProfilePage(
                                  user: user,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    },
                    {
                      'icon': Icons.bookmark,
                      'label': 'Saved Posts',
                      'function': () {
                        Future.delayed(
                          const Duration(microseconds: 250),
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SavedPostPage(
                                  user: user,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    },
                    {
                      'icon': Icons.logout_rounded,
                      'label': 'Signout',
                      'function': () {
                        signOut();
                      },
                    },
                  ],
                );
              },
              isLoading: false,
              color: AppColors.secondaryColor,
            ),
          )
        : Container(
            child: SharedButton(
              label: _isFollowing ? 'Unfollow' : 'Follow',
              onPress: _followUnfollowUser,
              isLoading: false,
              color:
                  _isFollowing ? AppColors.secondaryColor : AppColors.blueColor,
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return AppHelpers.buildLoadingIndicator();
    }

    final userData = ref.watch(specificUserProvider);
    user = userData!;

    _isFollowing = user.follower.contains(currentUser.userId);
    follower = user.follower.length;
    following = user.following.length;
    postNumber = ref.read(postProvider).length;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(user.username),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StoryCircle(
                isMine: false,
                user: user,
                isActive: true,
                onPress: () {
                  // Navigating if the user has story
                  // Navigator.push(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => StoryPage(
                  //       user: widget.user,
                  //     ),
                  //   ),
                  // );
                },
              ),
              Expanded(
                child: Column(
                  children: [
                    _buildProfileInformation(),
                    const SizedBox(height: 15),
                    _buildProfileActionButton(),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: ref.read(postProvider.notifier).getUserPost(user.userId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return AppHelpers.buildLoadingIndicator();
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                final List<PostModel> data = ref.watch(postProvider);

                return GridView.builder(
                  padding: const EdgeInsets.only(top: 5),
                  itemCount: data.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PostPage.forUser(widget.user),
                          ),
                        );
                      },
                      child: Image.network(
                        data[index].imageURL,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
