import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  final String userId;
  final String username;
  final String profileURL;
  final String commentId;
  final String text;
  final datePublished;
  final List likes;

  CommentModel({
    required this.userId,
    required this.username,
    required this.profileURL,
    required this.commentId,
    required this.text,
    required this.datePublished,
    required this.likes,
  });

  factory CommentModel.fromJson(Map<String, dynamic> snapshotData) {
    return CommentModel(
      userId: snapshotData['userId'],
      username: snapshotData['username'],
      profileURL: snapshotData['profileURL'],
      commentId: snapshotData['commentId'],
      text: snapshotData['text'],
      datePublished: snapshotData['datePublished'],
      likes: snapshotData['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'profileURL': profileURL,
      'commentId': commentId,
      'text': text,
      'datePublished': datePublished,
      'likes': likes,
    };
  }
}
