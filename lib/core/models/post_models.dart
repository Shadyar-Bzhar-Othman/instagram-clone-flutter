import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final String userId;
  final String username;
  final String profileURL;
  final String postId;
  final String imageURL;
  final String description;
  final datePublished;
  final List likes;

  PostModel({
    required this.userId,
    required this.username,
    required this.profileURL,
    required this.postId,
    required this.imageURL,
    required this.description,
    required this.datePublished,
    required this.likes,
  });

  factory PostModel.fromJson(DocumentSnapshot documentSnapshot) {
    final snapshotData = documentSnapshot.data() as Map<String, dynamic>;

    return PostModel(
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

  factory PostModel.fromQueryDocumentSnapshot(QueryDocumentSnapshot snapshot) {
    final snapshotData = snapshot.data() as Map<String, dynamic>;

    return PostModel(
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

  factory PostModel.fromMap(Map<String, dynamic> snapshot) {
    final snapshotData = snapshot;

    return PostModel(
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
