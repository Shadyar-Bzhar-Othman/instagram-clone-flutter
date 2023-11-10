import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  final String userId;
  final String username;
  final String profileURL;
  final String postId;
  final String imageURL;
  final String description;
  final datePublished;
  final List likes;

  Post({
    required this.userId,
    required this.username,
    required this.profileURL,
    required this.postId,
    required this.imageURL,
    required this.description,
    required this.datePublished,
    required this.likes,
  });

  factory Post.fromJson(DocumentSnapshot documentSnapshot) {
    final snapshotData = documentSnapshot.data() as Map<String, dynamic>;

    return Post(
      userId: snapshotData['userId'],
      username: snapshotData['username'],
      profileURL: snapshotData['profileURL'],
      postId: snapshotData['postId'],
      imageURL: snapshotData['imageURL'],
      description: snapshotData['description'],
      datePublished: snapshotData['datePublished'],
      likes: snapshotData['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'profileURL': profileURL,
      'postId': postId,
      'imageURL': imageURL,
      'description': description,
      'datePublished': datePublished,
      'likes': likes,
    };
  }
}
