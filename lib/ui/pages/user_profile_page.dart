import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/user_service.dart';
import 'package:instagramclone/ui/pages/story_page.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/post_card.dart';
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
  final UserController _userController = UserController(
    UserService(
      firebaseAuth: FirebaseAuth.instance,
      firebaseFirestore: FirebaseFirestore.instance,
    ),
  );

  late UserModel currentUser;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final currentUserValue = ref.read(userProvider);

    currentUserValue.when(
      data: (cUser) {
        setState(() {
          currentUser = cUser;
          _isLoading = false;
        });
      },
      error: (error, stackTrace) {},
      loading: () {
        setState(() {
          _isLoading = true;
        });
      },
    );
  }

  void followUser() async {
    final result = await _userController.followUser(
        currentUser.userId, widget.user.userId, currentUser.following);

    if (result != 'Success') {
      showSnackbar(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isSameUser = widget.user.userId == currentUser.userId;

    return _isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
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
                                number: widget.user.follower.length.toString(),
                                title: 'Followers',
                              ),
                              ProfileInformation(
                                number: widget.user.following.length.toString(),
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
                                    onPress: () {},
                                    isLoading: false,
                                    color: secondaryColor,
                                  ),
                                )
                              : Container(
                                  child: SharedButton(
                                    // Problem with updating data and maybe it does not unfollow coz it did not get new current updated user 'I think'
                                    label: currentUser.following
                                            .contains(widget.user.userId)
                                        ? 'Unollow'
                                        : 'Follow',
                                    onPress: () {
                                      setState(() {
                                        followUser();
                                      });
                                    },
                                    isLoading: false,
                                    color: currentUser.following
                                            .contains(widget.user.userId)
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
                    future: FirebaseFirestore.instance
                        .collection('posts')
                        .where('userId', isEqualTo: widget.user.userId)
                        .get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final List<PostModel> data = snapshot.data!.docs
                          .map((post) => PostModel.fromMap(
                              post.data() as Map<String, dynamic>))
                          .toList();

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
