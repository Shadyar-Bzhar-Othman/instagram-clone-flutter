import 'package:flutter/material.dart';
import 'package:instagramclone/core/models/comment_model.dart';
import 'package:instagramclone/utils/colors.dart';

class CommentCard extends StatelessWidget {
  const CommentCard({super.key, required this.comment});

  final CommentModel comment;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: double.infinity,
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.white,
            backgroundImage: NetworkImage(comment.profileURL),
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
                  comment.username,
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(
                  height: 4,
                ),
                Text(
                  comment.text,
                  maxLines: 5,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text(
                      '${comment.likes.length} likes',
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
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.favorite_border,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
