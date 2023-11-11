import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/post_controller.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/core/services/post_service.dart';
import 'package:instagramclone/ui/pages/comment_page.dart';
import 'package:instagramclone/ui/shared/dialogs/snackbars.dart';
import 'package:instagramclone/ui/shared/widgets/like_animation.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:intl/intl.dart';

class PostCard extends ConsumerStatefulWidget {
  const PostCard({super.key, required this.post});

  final PostModel post;

  @override
  ConsumerState<PostCard> createState() => _PostCardState();
}

class _PostCardState extends ConsumerState<PostCard> {
  final PostController _postController = PostController(
    postService: PostService(firebaseFirestore: FirebaseFirestore.instance),
  );

  late UserModel user;
  bool isLikeAnimating = false;

  @override
  void initState() {
    super.initState();
    final currentUserValue = ref.read(userProvider);

    currentUserValue.whenData((currentUser) {
      user = currentUser;
    });
  }

  void likePost() async {
    final result = await _postController.likePost(
        widget.post.postId, user.userId, widget.post.likes);

    if (result != 'Success') {
      showSnackbar(context, result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    backgroundImage: NetworkImage(widget.post.profileURL),
                    radius: 14,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(widget.post.username),
                ],
              ),
              widget.post.userId == user.userId
                  ? IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_horiz),
                    )
                  : Container(),
            ],
          ),
        ),
        widget.post.userId == user.userId
            ? Container()
            : const SizedBox(
                height: 6,
              ),
        Stack(
          alignment: Alignment.center,
          children: [
            GestureDetector(
              onDoubleTap: () {
                setState(() {
                  likePost();
                  isLikeAnimating = true;
                });
              },
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  widget.post.imageURL,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AnimatedOpacity(
              opacity: isLikeAnimating ? 1 : 0,
              duration: const Duration(milliseconds: 200),
              child: LikeAnimation(
                isAnimating: isLikeAnimating,
                duration: const Duration(
                  milliseconds: 400,
                ),
                onEnd: () {
                  setState(() {
                    isLikeAnimating = false;
                  });
                },
                child: const Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: 100,
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                LikeAnimation(
                  isAnimating: widget.post.likes.contains(user.userId),
                  smallLike: true,
                  child: IconButton(
                    onPressed: () {
                      likePost();
                    },
                    icon: widget.post.likes.contains(user.userId)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(Icons.favorite_border),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentPage(post: widget.post),
                      ),
                    );
                  },
                  icon: const Icon(Icons.comment),
                ),
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.post.likes.length != 0
                  ? Text(
                      '${widget.post.likes.length} likes',
                    )
                  : Container(),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Text(widget.post.username),
                  RichText(
                    text: TextSpan(
                      text: '  ${widget.post.description}',
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 6,
              ),
              GestureDetector(
                onTap: () {},
                child: Text('View all 22 comments'),
              ),
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Text(
                  DateFormat.yMMMd().format(widget.post.datePublished.toDate()),
                  style: const TextStyle(
                    color: secondaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
