import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/post_provider.dart';
import 'package:instagramclone/ui/pages/post_page.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/consts.dart';
import 'package:instagramclone/utils/helpers.dart';

class SavedPostPage extends ConsumerStatefulWidget {
  const SavedPostPage({super.key, required this.user});

  final UserModel user;

  @override
  ConsumerState<SavedPostPage> createState() => _SavedPostPageState();
}

class _SavedPostPageState extends ConsumerState<SavedPostPage> {
  late Future userSavedPost;

  @override
  void initState() {
    super.initState();

    userSavedPost =
        ref.read(postProvider.notifier).getUserSavedPost(widget.user.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Saved Posts'),
      ),
      body: FutureBuilder(
        future: userSavedPost,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return AppHelpers.buildLoadingIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          List<PostModel> posts = ref.read(postProvider) ?? [];

          if (posts.isEmpty) {
            return const Center(
              child: Text('There\'s no saved post yet'),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.only(top: 5),
            itemCount: posts.length,
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
                      builder: (context) => PostPage.forUser(
                        widget.user,
                        isSavedPost: true,
                      ),
                    ),
                  );
                },
                child: Image.network(
                  posts[index].imageURL,
                  fit: BoxFit.cover,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
