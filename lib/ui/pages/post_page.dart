import 'package:flutter/material.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/ui/shared/widgets/feed_post_list.dart';
import 'package:instagramclone/ui/shared/widgets/post_list.dart';
import 'package:instagramclone/utils/colors.dart';

class PostPage extends StatefulWidget {
  const PostPage.feed({super.key})
      : user = null,
        isSavedPost = null;

  const PostPage.forUser(UserModel user, {super.key, bool isSavedPost = false})
      : user = user,
        isSavedPost = isSavedPost;

  final UserModel? user;
  final bool? isSavedPost;

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  Widget _buildPostList() {
    if (widget.user == null) {
      return const FeedPostList();
    } else {
      return PostList(
        user: widget.user!,
        isSavedPost: widget.isSavedPost ?? false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: Text(widget.user != null && widget.isSavedPost == true
            ? 'Saved Posts'
            : 'Posts'),
      ),
      body: _buildPostList(),
    );
  }
}
