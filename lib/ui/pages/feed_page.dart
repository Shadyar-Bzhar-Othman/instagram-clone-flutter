import 'package:cloud_firestore/cloud_firestore.dart';
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
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final QuerySnapshot snapshotData = snapshot.data!;

          return ListView.builder(
            itemCount: snapshotData.docs.length,
            itemBuilder: (context, index) {
              return PostCard(
                post: Post.fromJson(
                  snapshotData.docs[index],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
