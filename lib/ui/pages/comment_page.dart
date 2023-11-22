import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/comment_controller.dart';
import 'package:instagramclone/core/models/comment_model.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/comment_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/core/services/comment_service.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/comment_card.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:instagramclone/utils/helpers.dart';

class CommentPage extends ConsumerStatefulWidget {
  const CommentPage({super.key, required this.post});

  final PostModel post;

  @override
  ConsumerState<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends ConsumerState<CommentPage> {
  late UserModel user;
  final TextEditingController _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final currentUserData = ref.read(currentUserProvider);
    user = currentUserData!;
  }

  Future<void> _loadComments() async {
    await ref.read(commentProvider.notifier).getPostComment(widget.post.postId);
  }

  Widget _buildCommentsList(List<CommentModel> comments) {
    return Expanded(
      child: comments.isEmpty
          ? const Text('No comments added yet')
          : ListView.builder(
              itemCount: comments.length,
              itemBuilder: (context, index) {
                final comment = comments[index];
                return _buildCommentItem(comment);
              },
            ),
    );
  }

  Widget _buildCommentItem(CommentModel comment) {
    return user.userId == comment.userId
        ? CommentCard(post: widget.post, comment: comment)
        : Dismissible(
            onDismissed: (direction) {
              _deleteComment(comment);
            },
            background: Container(
              color: Colors.red,
              child: const Icon(
                Icons.delete,
              ),
            ),
            key: ValueKey<CommentModel>(comment),
            child: CommentCard(post: widget.post, comment: comment),
          );
  }

  void _deleteComment(CommentModel comment) async {
    final result = await ref
        .read(commentProvider.notifier)
        .deleteComment(widget.post.postId, comment.commentId);

    if (result != null) {
      showSnackbar(context, result);
    }
  }

  void _addComment() async {
    final String text = _commentTextController.text;

    final result = await ref.read(commentProvider.notifier).addComment(
          user.userId,
          user.username,
          user.profileImageURL,
          widget.post.postId,
          text,
        );

    if (result != null) {
      showSnackbar(context, result);
    }

    _commentTextController.clear();
  }

  @override
  void dispose() {
    super.dispose();
    _commentTextController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: _loadComments(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return AppHelpers.buildLoadingIndicator();
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              }

              final List<CommentModel> comments = ref.watch(commentProvider);

              return _buildCommentsList(comments);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: AppColors.primaryColor,
                  backgroundImage: NetworkImage(user.profileImageURL),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: TextField(
                    controller: _commentTextController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Add a comment for ${widget.post.username}',
                      suffix: TextButton(
                        onPressed: _addComment,
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            color: AppColors.blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
