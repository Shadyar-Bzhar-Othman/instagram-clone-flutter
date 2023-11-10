import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/ui/shared/widgets/post_card.dart';
import 'package:instagramclone/utils/colors.dart';

class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: SvgPicture.asset(
          'assets/images/ic_instagram.svg',
          color: Colors.white,
          height: 28,
        ),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.chat_rounded)),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: ListView.builder(
        itemCount: 4,
        itemBuilder: (context, index) {
          return PostCard(
              post: Post(
            userId: '1',
            username: 'Shadyar Bzhar Othman',
            profileURL: '',
            postId: '1',
            imageURL: 'https://wallpaperaccess.com/full/9095169.jpg',
            description: 'Hello World',
            datePublished: '2023-10-30',
            likes: [],
          ));
        },
      ),
    );
  }
}
