import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/utils/helpers.dart';
import 'package:uuid/uuid.dart';

class PostService {
  PostService({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  Future<List<PostModel>> getAllPost() async {
    List<PostModel> posts = [];

    try {
      final querySnapshot = await _firebaseFirestore
          .collection('posts')
          .orderBy('datePublished', descending: true)
          .get();

      posts = querySnapshot.docs
          .map((user) => PostModel.fromJson(user.data()))
          .toList();
    } catch (ex) {
      posts = [];
      rethrow;
    }

    return posts;
  }

  Future<List<PostModel>> getUserPost(String userId) async {
    List<PostModel> posts = [];

    try {
      final querySnapshot = await _firebaseFirestore
          .collection('posts')
          .where('userId', isEqualTo: userId)
          .orderBy('datePublished', descending: true)
          .get();

      posts = querySnapshot.docs
          .map((user) => PostModel.fromJson(user.data()))
          .toList();
    } catch (ex) {
      posts = [];
      rethrow;
    }

    return posts;
  }

  Future<List<PostModel>> addPost(String userId, String username,
      String profileURL, Uint8List? image, String description) async {
    List<PostModel> posts = [];

    try {
      String postId = const Uuid().v1();

      String imageURL = await uploadFileToFirebaseStorage('posts', image, true);

      PostModel post = PostModel(
        userId: userId,
        username: username,
        profileURL: profileURL,
        postId: postId,
        imageURL: imageURL,
        description: description,
        datePublished: DateTime.now(),
        likes: [],
      );

      await _firebaseFirestore
          .collection('posts')
          .doc(postId)
          .set(post.toJson());

      posts = await getAllPost();
    } catch (ex) {
      posts = [];
      rethrow;
    }

    return posts;
  }

  Future<List<PostModel>> deletePost(String postId) async {
    List<PostModel> posts = [];

    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();

      posts = await getAllPost();
    } catch (ex) {
      posts = [];
      rethrow;
    }

    return posts;
  }

  Future<List<PostModel>> likePost(
      String postId, String userId, List likes) async {
    List<PostModel> posts = [];

    try {
      if (likes.contains(userId)) {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayRemove([userId]),
        });
      } else {
        await _firebaseFirestore.collection('posts').doc(postId).update({
          'likes': FieldValue.arrayUnion([userId]),
        });
      }

      posts = await getAllPost();
    } catch (ex) {
      posts = [];
      rethrow;
    }

    return posts;
  }
}
