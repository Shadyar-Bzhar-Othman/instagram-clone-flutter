import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/comment_controller.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/comment_model.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/comment_service.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/like_animation.dart';
import 'package:instagramclone/utils/colors.dart';

class CommentCard extends ConsumerStatefulWidget {
  const CommentCard({super.key, required this.post, required this.comment});

  final PostModel post;
  final CommentModel comment;

  @override
  ConsumerState<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends ConsumerState<CommentCard> {
  final CommentController _commentController = CommentController(
    commentService:
        CommentService(firebaseFirestore: FirebaseFirestore.instance),
  );

  late UserModel user;

  @override
  void initState() {
    super.initState();
    final currentUserValue = ref.read(userProvider);

    currentUserValue.whenData((currentUser) {
      user = currentUser;
    });
  }

  void likeComment() async {
    final result = await _commentController.likeComment(
      widget.post.postId,
      widget.comment.commentId,
      user.userId,
      widget.comment.likes,
    );

    if (result != 'Success') {
      showSnackbar(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(widget.comment.profileURL),
            radius: 15,
          ),
          const SizedBox(
            width: 10,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.comment.username,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  widget.comment.text,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      '${widget.comment.likes.length} likes',
                      style:
                          const TextStyle(color: secondaryColor, fontSize: 13),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    const Text(
                      'Reply',
                      style: TextStyle(color: secondaryColor, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          LikeAnimation(
            isAnimating: widget.comment.likes.contains(user.userId),
            smallLike: true,
            child: IconButton(
              onPressed: () {
                likeComment();
              },
              icon: widget.comment.likes.contains(user.userId)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                      size: 16,
                    )
                  : const Icon(
                      Icons.favorite_border,
                      size: 16,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
