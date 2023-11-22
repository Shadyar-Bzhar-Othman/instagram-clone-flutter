import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/story_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/core/providers/user_story_provider.dart';
import 'package:instagramclone/ui/pages/story_page.dart';
import 'package:instagramclone/ui/shared/dialogs/image_picker_dialog.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/feed_post_list.dart';
import 'package:instagramclone/ui/shared/widgets/story_circle.dart';
import 'package:instagramclone/utils/assets.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/helpers.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  late UserModel user;
  Uint8List? _selectedImage;

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

  Widget customStoryList() {
    return FutureBuilder(
      future: ref
          .read(userStoryProvider.notifier)
          .getUserWithActiveStory(user.userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppHelpers.buildLoadingIndicator();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        final List<UserModel> data = ref.watch(userStoryProvider);

        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return StoryCircle(
              isMine: index == 0,
              user: data[index],
              isActive: index != 0,
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: SvgPicture.asset(
          AppAssets.instagramLogo,
          color: AppColors.primaryColor,
          height: 28,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const FaIcon(
              FontAwesomeIcons.facebookMessenger,
              size: 22,
            ),
          ),
          const SizedBox(
            width: 1,
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 110,
            padding: const EdgeInsets.all(6),
            child: customStoryList(),
          ),
          const Expanded(
            child: FeedPostList(),
          ),
        ],
      ),
    );
  }
}
