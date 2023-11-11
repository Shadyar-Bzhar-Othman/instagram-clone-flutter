import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:instagramclone/core/controllers/user_controller.dart';
import 'package:instagramclone/core/models/comment_model.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/ui/shared/widgets/comment_card.dart';
import 'package:instagramclone/utils/colors.dart';

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
    final currentUserValue = ref.read(userProvider);

    currentUserValue.whenData((currentUser) => user = currentUser);
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
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('posts')
                  .doc(widget.post.postId)
                  .collection('comments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData) {
                  return const Center(
                    child: Text('There\'s no comment for this post...'),
                  );
                }

                final QuerySnapshot snapshotData = snapshot.data!;

                return ListView.builder(
                  // itemCount: snapshotData.docs.length,
                  itemCount: 10,
                  itemBuilder: (context, index) {
                    return CommentCard(
                      // comment: CommentModel.fromJson(
                      //   snapshotData.docs[index],
                      comment: CommentModel(
                        userId: '1',
                        username: 'Shadyar Bzhar Othman',
                        profileURL:
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGxkV3U56UXcCBKREVzK7LDU6Bd22Q2iIgKg&usqp=CAU',
                        commentId: '3',
                        text:
                            'Heyyyyyyyyy I\'m from kurdistan mann yooooooooooooo',
                        datePublished: '2-2-2023',
                        likes: [1, 3, 4, 23, 1],
                      ),
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
                        onPressed: () {},
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
