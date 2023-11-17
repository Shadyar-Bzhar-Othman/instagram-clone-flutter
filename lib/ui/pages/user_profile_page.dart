import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/post_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/core/services/user_service.dart';
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
  late final UserController _userController;

  late UserModel currentUser;
  bool _isFollowing = false;
  int postNumber = 0;
  int follower = 0;
  int following = 0;

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

    final currentUserData = ref.read(currentUserProvider);
    currentUser = currentUserData!;

    _isFollowing = widget.user.follower.contains(currentUser.userId);
    follower = widget.user.follower.length;
    following = widget.user.following.length;
  }

  void followUser() async {
    final String? result = await _userController.followUser(
        currentUser.userId, widget.user.userId, currentUser.following);

    if (result != null) {
      showSnackbar(context, result);
    }

    if (_isFollowing) {
      _isFollowing = false;
      follower--;
    } else {
      _isFollowing = true;
      follower++;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    bool isSameUser = widget.user.userId == currentUser.userId;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text(
          widget.user.username,
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StoryCircle(
                isMine: false,
                user: widget.user,
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
                          number: '0',
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
                            padding: const EdgeInsets.symmetric(horizontal: 60),
                            child: SharedButton(
                              label: 'Edit Profile',
                              onPress: () {},
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
                              color: _isFollowing ? secondaryColor : blueColor,
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
                  .getUserPost(widget.user.userId),
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
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    mainAxisSpacing: 5,
                    crossAxisSpacing: 5,
                    childAspectRatio: 1,
                  ),
                  itemBuilder: (context, index) {
                    return Image.network(
                      data[index].imageURL,
                      fit: BoxFit.cover,
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
