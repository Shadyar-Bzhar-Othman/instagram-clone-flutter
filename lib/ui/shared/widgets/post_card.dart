import 'package:flutter/material.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/utils/colors.dart';
import 'package:intl/intl.dart';

class PostCard extends StatelessWidget {
  const PostCard({super.key, required this.post});

  final Post post;

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
                    backgroundImage: NetworkImage(post.profileURL),
                    radius: 14,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(post.username),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.more_horiz),
              ),
            ],
          ),
        ),
        AspectRatio(
          aspectRatio: 1,
          child: Image.network(
            post.imageURL,
            fit: BoxFit.cover,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.favorite_border),
                ),
                IconButton(
                  onPressed: () {},
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
              post.likes.length != 0
                  ? Text(
                      '${post.likes.length} likes',
                    )
                  : Container(),
              const SizedBox(
                height: 6,
              ),
              Row(
                children: [
                  Text(post.username),
                  RichText(
                    text: TextSpan(
                      text: '  ${post.description}',
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
                  DateFormat.yMMMd().format(post.datePublished.toDate()),
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
