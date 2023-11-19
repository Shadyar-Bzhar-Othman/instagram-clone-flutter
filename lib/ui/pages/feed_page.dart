import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/story_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/core/providers/user_story_provider.dart';
import 'package:instagramclone/ui/pages/story_page.dart';
import 'package:instagramclone/ui/shared/dialogs/dialogs.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/feed_post_list.dart';
import 'package:instagramclone/ui/shared/widgets/story_circle.dart';
import 'package:instagramclone/utils/colors.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  late UserModel user;
  Uint8List? _selectedImage;
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    final currentUserData = ref.read(currentUserProvider);
    user = currentUserData!;
  }

  Future<void> selectImage() async {
    final selectedImage = await showImagePickerDialog(context);

    setState(() {
      _selectedImage = selectedImage;
    });
  }

  void addStory() async {
    await selectImage();
    if (_selectedImage != null) {
      final result = await ref.read(storyProvider.notifier).addStory(
          user.userId, user.username, user.profileImageURL, _selectedImage);

      if (result != null) {
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
                    future: ref
                        .read(userStoryProvider.notifier)
                        .getUserWithActiveStory(user.userId),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      final List<UserModel> data = ref.watch(userStoryProvider);

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
                    },
                  ),
                ),
                const Expanded(
                  child: FeedPostList(),
                ),
              ],
            ),
    );
  }
}
