import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:instagramclone/core/models/post_models.dart';
import 'package:instagramclone/utils/helpers.dart';
import 'package:uuid/uuid.dart';

class AddPostService {
  AddPostService({required FirebaseFirestore firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore;

  final FirebaseFirestore _firebaseFirestore;

  Future<List<Post>> getPosts() async {
    List<Post> posts = [];
    String result = '';
    try {
      QuerySnapshot postsSnapshot =
          await _firebaseFirestore.collection('posts').get();

      posts = postsSnapshot.docs
          .map((post) => Post.fromJson(post.data() as Map<String, dynamic>))
          .toList();

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return posts;
  }

  Future<String> addPost(String userId, String username, String profileURL,
      Uint8List? image, String description) async {
    String result = '';
    try {
      String postId = const Uuid().v1();

      String imageURL = await uploadFileToFirebaseStorage('posts', image, true);

      Post post = Post(
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

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String> deletePost(String postId) async {
    String result = '';
    try {
      await _firebaseFirestore.collection('posts').doc(postId).delete();

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }

  Future<String> likePost(String postId, String userId, List likes) async {
    String result = '';
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

      result = 'Success';
    } catch (ex) {
      result = ex.toString();
    }

    return result;
  }
}
