import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/core/models/user_model.dart';
import 'package:instagramclone/ui/shared/widgets/post_card.dart';
import 'package:instagramclone/ui/shared/widgets/story_circle.dart';
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
      body: Column(
        children: [
          Container(
            height: 110,
            padding: const EdgeInsets.all(6),
            child: Expanded(
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 40,
                itemBuilder: (context, index) {
                  return StoryCircle(
                    isMine: index == 0 ? true : false,
                    user: UserModel(
                      userId: '1',
                      username: 'Shadyar',
                      profileImageURL:
                          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSdxqCRBVi8V3xiVudx-MoDjmGZ0mj-L2WqjV985Zktex1AfQ761TAf47OLnjDRb-L7NMg&usqp=CAU',
                      email: '',
                      bio: '',
                      follower: [],
                      following: [],
                    ),
                    isActive: true,
                    onPress: () {},
                  );
                },
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder(
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
                      post: PostModel.fromJson(
                        snapshotData.docs[index],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
