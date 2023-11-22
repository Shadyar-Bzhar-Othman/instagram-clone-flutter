import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/providers/post_provider.dart';
import 'package:instagramclone/ui/shared/widgets/post_card.dart';
import 'package:instagramclone/utils/helpers.dart';

class FeedPostList extends ConsumerStatefulWidget {
  const FeedPostList({
    super.key,
  });

  @override
  ConsumerState<FeedPostList> createState() => _FeedPostListState();
}

class _FeedPostListState extends ConsumerState<FeedPostList> {
  late Future userPostsFuture;

  @override
  void initState() {
    super.initState();
    userPostsFuture = ref.read(postProvider.notifier).getAllPost();
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

        final List<PostModel> posts = ref.watch(postProvider) ?? [];

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
