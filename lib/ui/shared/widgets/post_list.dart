import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/post_provider.dart';
import 'package:instagramclone/ui/shared/widgets/post_card.dart';
import 'package:instagramclone/utils/helpers.dart';

class PostList extends ConsumerStatefulWidget {
  const PostList({super.key, required this.user, required this.isSavedPost});

  final UserModel user;
  final bool isSavedPost;

  @override
  ConsumerState<PostList> createState() => _PostListState();
}

class _PostListState extends ConsumerState<PostList> {
  late Future userPostsFuture;

  @override
  void initState() {
    super.initState();
    if (widget.isSavedPost) {
      userPostsFuture =
          ref.read(postProvider.notifier).getUserSavedPost(widget.user.userId);
    } else {
      userPostsFuture =
          ref.read(postProvider.notifier).getUserPost(widget.user.userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: userPostsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return AppHelpers.buildLoadingIndicator();
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        List<PostModel> posts = [];

        if (widget.isSavedPost) {
          posts = ref.read(postProvider) ?? [];
        } else {
          posts = ref.watch(postProvider) ?? [];
        }

        if (posts.isEmpty) {
          return const Center(
            child: Text('There\'s no post...'),
          );
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            return PostCard(
              post: posts[index],
            );
          },
        );
      },
    );
  }
}
