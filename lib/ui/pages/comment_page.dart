import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/comment_controller.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/comment_model.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/providers/comment_provider.dart';
import 'package:instagramclone/core/providers/user_provider.dart';
import 'package:instagramclone/core/services/comment_service.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/comment_card.dart';
import 'package:instagramclone/utils/colors.dart';

class CommentPage extends ConsumerStatefulWidget {
  const CommentPage({super.key, required this.post});

  final PostModel post;

  @override
  ConsumerState<CommentPage> createState() => _CommentPageState();
}

class _CommentPageState extends ConsumerState<CommentPage> {
  final CommentController _commentController = CommentController(
    commentService:
        CommentService(firebaseFirestore: FirebaseFirestore.instance),
  );

  late UserModel user;
  final TextEditingController _commentTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final currentUserData = ref.read(currentUserProvider);
    user = currentUserData!;
  }

  void addComment() async {
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

  void deleteComment(CommentModel comment) async {
    final result = await ref
        .read(commentProvider.notifier)
        .deleteComment(widget.post.postId, comment.commentId);

    if (result != null) {
      showSnackbar(context, result);
    }
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
        backgroundColor: backgroundColor,
        title: const Text('Comments'),
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
              future: ref
                  .read(commentProvider.notifier)
                  .getPostComment(widget.post.postId),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                final List<CommentModel> comments = ref.watch(commentProvider);

                if (comments.isEmpty) {
                  return const Center(
                    child: Text('There\'s no comment for this post...'),
                  );
                }

                return ListView.builder(
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    final comment = comments[index];
                    return user.userId == comment.userId
                        ? Dismissible(
                            onDismissed: (direction) {
                              deleteComment(comment);
                            },
                            background: Container(
                              color: Colors.red,
                              child: const Icon(
                                Icons.delete,
                              ),
                            ),
                            key: ValueKey<CommentModel>(comment),
                            child: CommentCard(
                              post: widget.post,
                              comment: comment,
                            ),
                          )
                        : CommentCard(
                            post: widget.post,
                            comment: comment,
                          );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 16,
                  backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
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
                        onPressed: addComment,
                        child: const Text(
                          'Post',
                          style: TextStyle(
                            color: blueColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
