import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/auth_provider.dart';
import 'package:instagramclone/core/providers/post_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/ui/pages/post_page.dart';
import 'package:instagramclone/ui/pages/saved_post_page.dart';
import 'package:instagramclone/ui/pages/update_profile_page.dart';
import 'package:instagramclone/ui/shared/dialogs/custom_dialog.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/profile_information.dart';
import 'package:instagramclone/ui/shared/widgets/shared_button.dart';
import 'package:instagramclone/ui/shared/widgets/story_circle.dart';
import 'package:instagramclone/utils/colors.dart';

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

  void getData() async {
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

  void followUser() async {
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

  @override
  Widget build(BuildContext context) {
    bool isSameUser = false;

    if (!_isLoading) {
      final userData = ref.watch(specificUserProvider);
      user = userData!;

      _isFollowing = user.follower.contains(currentUser.userId);
      follower = user.follower.length;
      following = user.following.length;
      postNumber = ref.read(postProvider).length;

      isSameUser = user.userId == currentUser.userId;
    }

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: backgroundColor,
              title: Text(
                user.username,
              ),
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
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              // Implementing when I create service and controller for it
                              ProfileInformation(
                                number: postNumber.toString(),
                                title: 'Posts',
                              ),
                              ProfileInformation(
                                number: follower.toString(),
                                title: 'Followers',
                              ),
                              ProfileInformation(
                                number: following.toString(),
                                title: 'Following',
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          isSameUser
                              ? Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 60),
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
                                              // Navigator.pop(context);
                                              Future.delayed(
                                                const Duration(
                                                    microseconds: 250),
                                                () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          UpdateProfilePage(
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
                                            'label': 'Saved Post',
                                            'function': () {
                                              Future.delayed(
                                                const Duration(
                                                    microseconds: 250),
                                                () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          SavedPostPage(
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
                                    color: secondaryColor,
                                  ),
                                )
                              : Container(
                                  child: SharedButton(
                                    // Problem with updating data and maybe it does not unfollow coz it did not get new current updated user 'I think'
                                    label: _isFollowing ? 'Unollow' : 'Follow',
                                    onPress: () {
                                      followUser();
                                    },
                                    isLoading: false,
                                    color: _isFollowing
                                        ? secondaryColor
                                        : blueColor,
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: FutureBuilder(
                    future: ref
                        .read(postProvider.notifier)
                        .getUserPost(user.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final List<PostModel> data = ref.watch(postProvider);

                      return GridView.builder(
                        padding: const EdgeInsets.only(top: 5),
                        itemCount: data.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
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
                                  builder: (context) =>
                                      PostPage(user: widget.user),
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
