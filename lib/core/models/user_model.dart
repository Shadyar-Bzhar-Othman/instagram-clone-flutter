import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String userId;
  final String username;
  final String profileImageURL;
  final String email;
  final String bio;
  final List follower;
  final List following;
  final List savedPost;

  UserModel({
    required this.userId,
    required this.username,
    required this.profileImageURL,
    required this.email,
    required this.bio,
    required this.follower,
    required this.following,
    required this.savedPost,
  });

  factory UserModel.fromJson(Map<String, dynamic> snapshotData) {
    return UserModel(
      userId: snapshotData['userId'],
      username: snapshotData['username'],
      profileImageURL: snapshotData['profileImageURL'],
      email: snapshotData['email'],
      bio: snapshotData['bio'],
      follower: snapshotData['follower'],
      following: snapshotData['following'],
      savedPost: snapshotData['savedPost'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'username': username,
      'profileImageURL': profileImageURL,
      'email': email,
      'bio': bio,
      'follower': follower,
      'following': following,
      'savedPost': savedPost,
    };
  }
}
