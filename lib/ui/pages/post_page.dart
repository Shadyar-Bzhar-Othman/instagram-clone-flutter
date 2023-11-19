import 'package:flutter/material.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/ui/shared/widgets/feed_post_list.dart';
import 'package:instagramclone/ui/shared/widgets/post_list.dart';
import 'package:instagramclone/utils/colors.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key, this.user});

  final UserModel? user;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: const Text('Posts'),
      ),
      body: widget.user == null
          ? const FeedPostList()
          : PostList(user: widget.user!),
    );
  }
}
