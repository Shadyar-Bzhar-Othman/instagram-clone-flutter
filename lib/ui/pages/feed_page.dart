import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/core/controllers/story_controller.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/story_service.dart';
import 'package:instagramclone/ui/pages/story_page.dart';
import 'package:instagramclone/ui/shared/dialogs/dialogs.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/post_card.dart';
import 'package:instagramclone/ui/shared/widgets/story_circle.dart';
import 'package:instagramclone/utils/colors.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  final StoryController _storyController = StoryController(
    storyService: StoryService(firebaseFirestore: FirebaseFirestore.instance),
  );

  late UserModel user;
  bool _isLoading = false;
  Uint8List? _selectedImage;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    final currentUserValue = ref.read(userProvider);

    currentUserValue.when(
      data: (currentUser) {
        user = currentUser;
        _isLoading = false;
      },
      error: (error, stackTrace) {},
      loading: () {
        _isLoading == true;
      },
    );
  }

  Future<void> selectImage() async {
    final selectedImage = await showImagePickerDialog(context);

    if (selectedImage != null) {
      setState(() {
        _selectedImage = selectedImage;
      });
    }
  }

  void addStory() async {
    await selectImage();
    if (_selectedImage != null) {
      final result = await _storyController.addStory(
          user.userId, user.username, user.profileImageURL, _selectedImage);

      if (result != 'Success') {
        showSnackbar(context, result);
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: SvgPicture.asset(
          'assets/images/ic_instagram.svg',
          color: Colors.white,
          height: 28,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat_rounded)),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Container(
                  height: 110,
                  padding: const EdgeInsets.all(6),
                  child: FutureBuilder(
                      future:
                          _storyController.getUserWithActiveStory(user.userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        final List<UserModel> data = snapshot.data!;

                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return StoryCircle(
                              isMine: index == 0 ? true : false,
                              user: data[index],
                              isActive: index == 0 ? false : true,
                              onPress: index == 0
                                  ? addStory
                                  : () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => StoryPage(
                                            user: data[index],
                                          ),
                                        ),
                                      );
                                    },
                            );
                          },
                        );
                      }),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .orderBy('datePublished', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final QuerySnapshot snapshotData = snapshot.data!;

                      return ListView.builder(
                        itemCount: snapshotData.docs.length,
                        itemBuilder: (context, index) {
                          return PostCard(
                            post: PostModel.fromJson(
                              snapshotData.docs[index],
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
